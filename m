Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3574D3B02BC
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 13:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbhFVLa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 07:30:58 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:49354 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhFVLa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 07:30:57 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 4C5802197E;
        Tue, 22 Jun 2021 11:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1624361321;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QFmYesFVcE6yLCF2PKzMDFp8snSHCtEkxuTLu4pi2ns=;
        b=npEE17wXRrXoUfBYAUsJjTdBrrI/LWKOfxRoPwp8xeKgAFrSSGIRKaw/Fw5qH19rIjs6/k
        s3BqXAZTVYNOp5vli0mDd/USqO+Lkfbzev8+DjinhFoWrT0ueKuHsKfxMOKkLC6QA8QZAz
        F36F1hPhftsWFcnkS/gZbEEkevLqG7Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1624361321;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QFmYesFVcE6yLCF2PKzMDFp8snSHCtEkxuTLu4pi2ns=;
        b=j9P+poND6qz4iTU2Rutw6kylacNilG/xZ6DR5LogoV+M1niCiYhBfB1mbDQLTEnYe9g3Mz
        rY2Te/2Z2UyXjODQ==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 4541FA3B85;
        Tue, 22 Jun 2021 11:28:41 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 94560DA79B; Tue, 22 Jun 2021 13:25:50 +0200 (CEST)
Date:   Tue, 22 Jun 2021 13:25:50 +0200
From:   David Sterba <dsterba@suse.cz>
To:     David Sterba <dsterba@suse.cz>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: handle shrink_delalloc pages calculation
 differently
Message-ID: <20210622112550.GH28158@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org
References: <f17b840611935b5f58bfcdbe050a942c33b90a60.1622576697.git.josef@toxicpanda.com>
 <20210622111604.GG28158@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622111604.GG28158@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 22, 2021 at 01:16:04PM +0200, David Sterba wrote:
> On Tue, Jun 01, 2021 at 03:45:08PM -0400, Josef Bacik wrote:
> > We have been hitting some early ENOSPC issues in production with more
> > recent kernels, and I tracked it down to us simply not flushing delalloc
> > as aggressively as we should be.  With tracing I was seeing us failing
> > all tickets with all of the block rsvs at or around 0, with very little
> > pinned space, but still around 120mib of outstanding bytes_may_used.
> > Upon further investigation I saw that we were flushing around 14 pages
> > per shrink call for delalloc, despite having around 2gib of delalloc
> > outstanding.
> > 
> > Consider the example of a 8 way machine, all cpu's trying to create a
> > file in parallel, which at the time of this commit requires 5 items to
> > do.  Assuming a 16k leaf size, we have 10mib of total metadata reclaim
> > size waiting on reservations.  Now assume we have 128mib of delalloc
> > outstanding.  With our current math we would set items to 20, and then
> > set to_reclaim to 20 * 256k, or 5mib.
> > 
> > Assuming that we went through this loop all 3 times, for both
> > FLUSH_DELALLOC and FLUSH_DELALLOC_WAIT, and then did the full loop
> > twice, we'd only flush 60mib of the 128mib delalloc space.  This could
> > leave a fair bit of delalloc reservations still hanging around by the
> > time we go to ENOSPC out all the remaining tickets.
> > 
> > Fix this two ways.  First, change the calculations to be a fraction of
> > the total delalloc bytes on the system.  Prior to my change we were
> > calculating based on dirty inodes so our math made more sense, now it's
> > just completely unrelated to what we're actually doing.
> > 
> > Second add a FLUSH_DELALLOC_FULL state, that we hold off until we've
> > gone through the flush states at least once.  This will empty the system
> > of all delalloc so we're sure to be truly out of space when we start
> > failing tickets.
> > 
> > I'm tagging stable 5.10 and forward, because this is where we started
> > using the page stuff heavily again.  This affects earlier kernel
> > versions as well, but would be a pain to backport to them as the
> > flushing mechanisms aren't the same.
> > 
> > CC: stable@vger.kernel.org # 5.10
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> 
> As this is going to be resent, I'll remove it from misc-next for now.
> Updated version can go in as a fix after rc1.

Ok so that does not work, the patchset "[PATCH 0/4][v2] btrfs: commit
the transaction unconditionally for ensopc"
https://lore.kernel.org/linux-btrfs/cover.1623421213.git.josef@toxicpanda.com/
touches the defines and can't be trivially resolved.
