Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026ED423DB7
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 14:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238197AbhJFM31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 08:29:27 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:57858 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238218AbhJFM31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 08:29:27 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id ECA7E1FEB3;
        Wed,  6 Oct 2021 12:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1633523253;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rBb/jATyAIyUsukFqKiqj5YooYa63eGyhDGDiBZ0KT0=;
        b=PNWPNTpl3vNOjeMEnizTrVjc3iddLgJ+YmuYv5HNfG8JrDbb3Rwatg63A/tS7vhlya7auE
        twznGRGVIRT9KpVBQFo7iuPmM9LcTnkt8vyC1Re9orp9oh3kmW+WsFaHaqklHLs+WhevrI
        bjoOsPE4MJx4wvJdTD8wKmwspGYN26c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1633523253;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rBb/jATyAIyUsukFqKiqj5YooYa63eGyhDGDiBZ0KT0=;
        b=BxqD9CheRkDLCXCO4/jpBisQH+N9ViZ4tPXT8fA4OexXnXtnTxdsIRqeiDrab2gFmq/2bI
        zgPm+YRYSN6u9lAA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id E2057A3B8C;
        Wed,  6 Oct 2021 12:27:33 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A8104DA7F3; Wed,  6 Oct 2021 14:27:13 +0200 (CEST)
Date:   Wed, 6 Oct 2021 14:27:13 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: update refs for any root except tree log roots
Message-ID: <20211006122713.GN9286@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, stable@vger.kernel.org
References: <3b6169b5a9b7bda03e14bcc7e10f8dcda5e92374.1633111027.git.josef@toxicpanda.com>
 <2b50d041-55d7-c3b1-0729-577e0af942dd@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b50d041-55d7-c3b1-0729-577e0af942dd@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 02, 2021 at 09:11:19AM +0800, Qu Wenruo wrote:
> But this makes me wonder, can we just leave scrub and balance exclusive?
> There are already quite some limitations, like balance and send.
> 
> Adding balance and scrub to be exclusive to each other shouldn't cause
> too much hassle, and can remove these checks.

This was suggested in the past in the btrfsmaintenance project, but
rather for performance reasons. Some people run scrub and balance and
let it finish when the time comes, so no perf concerns. As scrub is
read-only the strict exclusion is not necessary as with send where it
can lead to bugs.

I'd like to keep it working as it is now, unless we find a stronger
reason to make it exclusive. As eg. zoned now uses relocation on the
background we'd have either scrub failing or bg reclaim not working.
It's a trade off, there will be always some problematic case. Not
allowing to do eg. a quick balance filter while scrub is running could
be pretty annoying.
