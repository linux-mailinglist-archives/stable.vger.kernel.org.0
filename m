Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB40C3BE6EE
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 13:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhGGLPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 07:15:21 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:56286 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbhGGLPU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Jul 2021 07:15:20 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id D75B92254E;
        Wed,  7 Jul 2021 11:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1625656359;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0yVq/2Tb7uFpNZN3ZYLO5llspoKSR2+oTpAxlRWJ6ww=;
        b=ZPbKPHcMj85WVAUrF5w4w/q4dVRMe8ZCDZ7m/RXgRRaNkSdz1jdu89RhEL5BWNYS0tB9hl
        mytlmOAPnjtE/45sOuEd5zJ7kjvDdeRyhzooZhCO8d+0dFUAAd/nGU2ATpBizwtq/SFVeM
        fzJ/3nNjy9WX5aK+uuK7Npuuh+e1T2g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1625656359;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0yVq/2Tb7uFpNZN3ZYLO5llspoKSR2+oTpAxlRWJ6ww=;
        b=OGpvM9L+4da609ICMu0WLYOsVcliE7uwDz1zgFRJPnPnu8Fi8qhz6iJeuE9uVAv1Dhnr+/
        1IGOTG/1Ybkd0+Dg==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id C73C4A3B99;
        Wed,  7 Jul 2021 11:12:39 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1DEE9DA6FD; Wed,  7 Jul 2021 13:10:06 +0200 (CEST)
Date:   Wed, 7 Jul 2021 13:10:05 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.13 75/85] btrfs: make Private2 lifespan more
 consistent
Message-ID: <20210707111005.GI2610@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20210704230420.1488358-1-sashal@kernel.org>
 <20210704230420.1488358-75-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210704230420.1488358-75-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 04, 2021 at 07:04:10PM -0400, Sasha Levin wrote:
> From: Qu Wenruo <wqu@suse.com>
> 
> [ Upstream commit 87b4d86baae219a9a79f6b0a1434b2a42fd40d09 ]
> 
> Currently we use page Private2 bit to indicate that we have ordered
> extent for the page range.
> 
> But the lifespan of it is not consistent, during regular writeback path,
> there are two locations to clear the same PagePrivate2:
> 
>     T ----- Page marked Dirty
>     |
>     + ----- Page marked Private2, through btrfs_run_dealloc_range()
>     |
>     + ----- Page cleared Private2, through btrfs_writepage_cow_fixup()
>     |       in __extent_writepage_io()
>     |       ^^^ Private2 cleared for the first time
>     |
>     + ----- Page marked Writeback, through btrfs_set_range_writeback()
>     |       in __extent_writepage_io().
>     |
>     + ----- Page cleared Private2, through
>     |       btrfs_writepage_endio_finish_ordered()
>     |       ^^^ Private2 cleared for the second time.
>     |
>     + ----- Page cleared Writeback, through
>             btrfs_writepage_endio_finish_ordered()
> 
> Currently PagePrivate2 is mostly to prevent ordered extent accounting
> being executed for both endio and invalidatepage.
> Thus only the one who cleared page Private2 is responsible for ordered
> extent accounting.
> 
> But the fact is, in btrfs_writepage_endio_finish_ordered(), page
> Private2 is cleared and ordered extent accounting is executed
> unconditionally.
> 
> The race prevention only happens through btrfs_invalidatepage(), where
> we wait for the page writeback first, before checking the Private2 bit.
> 
> This means, Private2 is also protected by Writeback bit, and there is no
> need for btrfs_writepage_cow_fixup() to clear Priavte2.
> 
> This patch will change btrfs_writepage_cow_fixup() to just check
> PagePrivate2, not to clear it.
> The clearing will happen in either btrfs_invalidatepage() or
> btrfs_writepage_endio_finish_ordered().
> 
> This makes the Private2 bit easier to understand, just meaning the page
> has unfinished ordered extent attached to it.
> 
> And this patch is a hard requirement for the incoming refactoring for
> how we finished ordered IO for endio context, as the coming patch will
> check Private2 to determine if we need to do the ordered extent
> accounting.  Thus this patch is definitely needed or we will hang due to
> unfinished ordered extent.
> 
> Reviewed-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Please drop this patch from all autosel stable backports. This is not a
standalone fix and the CC: stable@ is not there intentionally.

All patches that go through my tree are evaluated for stable backports
up to 4.4 so it's unlikely the machinery you're using can find something
I've overlooked.

The patches that autosel picks and do not get a complain^Wreply for me
are below the bar I'd consider it for stable but if after another review
the patch "does no harm", I let it pass because you're obviously
handling the backports. I would not tag it myself to avoid increasing
load of Greg with patches that don't matter much.
