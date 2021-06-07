Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C6A39E6D1
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 20:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhFGSs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 14:48:56 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:37410 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbhFGSs4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 14:48:56 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E02B91FD33;
        Mon,  7 Jun 2021 18:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1623091623;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rr7S9JSXv6IpLAtI9bLnX6PFhXlv2eOqaxvSo85v7uA=;
        b=2/UBzS6qUekAt7UEUpNJAHFpjtRAZCgya5dg2rGSkv8azROShqBsdCThiFY3pTmB4Arh31
        9Qlbz1Eu86lC3HZFXbzsCq2DnK2MRggvObzZIhPYXXdB3/T01BObas1BnmaRccqqUNUzIA
        fl0rYC+V6NfOh7oqPq/yKOiqmq3jfws=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1623091623;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rr7S9JSXv6IpLAtI9bLnX6PFhXlv2eOqaxvSo85v7uA=;
        b=LA6F3GjeMfMvvf0Lf74O8X8WxBwWbvu6Woir3S7t5I4W0txi/lXTOjGLr1++E4PV73+IUJ
        irrwAP5VA6K8SoAA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id D97AEA3B8E;
        Mon,  7 Jun 2021 18:47:03 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C2FAFDB228; Mon,  7 Jun 2021 20:44:20 +0200 (CEST)
Date:   Mon, 7 Jun 2021 20:44:20 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: handle shrink_delalloc pages calculation
 differently
Message-ID: <20210607184420.GK31483@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org
References: <f17b840611935b5f58bfcdbe050a942c33b90a60.1622576697.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17b840611935b5f58bfcdbe050a942c33b90a60.1622576697.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 01, 2021 at 03:45:08PM -0400, Josef Bacik wrote:
> We have been hitting some early ENOSPC issues in production with more
> recent kernels, and I tracked it down to us simply not flushing delalloc
> as aggressively as we should be.  With tracing I was seeing us failing
> all tickets with all of the block rsvs at or around 0, with very little
> pinned space, but still around 120mib of outstanding bytes_may_used.
> Upon further investigation I saw that we were flushing around 14 pages
> per shrink call for delalloc, despite having around 2gib of delalloc
> outstanding.
> 
> Consider the example of a 8 way machine, all cpu's trying to create a
> file in parallel, which at the time of this commit requires 5 items to
> do.  Assuming a 16k leaf size, we have 10mib of total metadata reclaim
> size waiting on reservations.  Now assume we have 128mib of delalloc
> outstanding.  With our current math we would set items to 20, and then
> set to_reclaim to 20 * 256k, or 5mib.
> 
> Assuming that we went through this loop all 3 times, for both
> FLUSH_DELALLOC and FLUSH_DELALLOC_WAIT, and then did the full loop
> twice, we'd only flush 60mib of the 128mib delalloc space.  This could
> leave a fair bit of delalloc reservations still hanging around by the
> time we go to ENOSPC out all the remaining tickets.
> 
> Fix this two ways.  First, change the calculations to be a fraction of
> the total delalloc bytes on the system.  Prior to my change we were
> calculating based on dirty inodes so our math made more sense, now it's
> just completely unrelated to what we're actually doing.
> 
> Second add a FLUSH_DELALLOC_FULL state, that we hold off until we've
> gone through the flush states at least once.  This will empty the system
> of all delalloc so we're sure to be truly out of space when we start
> failing tickets.
> 
> I'm tagging stable 5.10 and forward, because this is where we started
> using the page stuff heavily again.  This affects earlier kernel
> versions as well, but would be a pain to backport to them as the
> flushing mechanisms aren't the same.

For 5.10 it depends on f00c42dd4cc8b856e6 ("btrfs: introduce a
FORCE_COMMIT_TRANS flush operation") and is followed by the premptive
flushing series. Prior to the commit introducing COMMIT_TRANS there are
3 patches that seem lightweight enough for stable backport to 5.10 but
that should be evaluated first.

5.11.x stable is EOL, so 5.12 is ok to pick it but in case there's
interest to backport it to 5.10, more work is needed than just tagging.
