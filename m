Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85974331278
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 16:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhCHPp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 10:45:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:42302 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230051AbhCHPp0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 10:45:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 92D10AE05;
        Mon,  8 Mar 2021 15:45:24 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id AFD17DA81B; Mon,  8 Mar 2021 16:43:26 +0100 (CET)
Date:   Mon, 8 Mar 2021 16:43:26 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.11 03/12] btrfs: subpage: fix the false data
 csum mismatch error
Message-ID: <20210308154326.GB7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210307135746.967418-1-sashal@kernel.org>
 <20210307135746.967418-3-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210307135746.967418-3-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 07, 2021 at 08:57:37AM -0500, Sasha Levin wrote:
> From: Qu Wenruo <wqu@suse.com>
> 
> [ Upstream commit c28ea613fafad910d08f67efe76ae552b1434e44 ]
> 
> [BUG]
> When running fstresss, we can hit strange data csum mismatch where the
> on-disk data is in fact correct (passes scrub).
> 
> With some extra debug info added, we have the following traces:
> 
>   0482us: btrfs_do_readpage: root=5 ino=284 offset=393216, submit force=0 pgoff=0 iosize=8192
>   0494us: btrfs_do_readpage: root=5 ino=284 offset=401408, submit force=0 pgoff=8192 iosize=4096
>   0498us: btrfs_submit_data_bio: root=5 ino=284 bio first bvec=393216 len=8192
>   0591us: btrfs_do_readpage: root=5 ino=284 offset=405504, submit force=0 pgoff=12288 iosize=36864
>   0594us: btrfs_submit_data_bio: root=5 ino=284 bio first bvec=401408 len=4096
>   0863us: btrfs_submit_data_bio: root=5 ino=284 bio first bvec=405504 len=36864
>   0933us: btrfs_verify_data_csum: root=5 ino=284 offset=393216 len=8192
>   0967us: btrfs_do_readpage: root=5 ino=284 offset=442368, skip beyond isize pgoff=49152 iosize=16384
>   1047us: btrfs_verify_data_csum: root=5 ino=284 offset=401408 len=4096
>   1163us: btrfs_verify_data_csum: root=5 ino=284 offset=405504 len=36864
>   1290us: check_data_csum: !!! root=5 ino=284 offset=438272 pg_off=45056 !!!
>   7387us: end_bio_extent_readpage: root=5 ino=284 before pending_read_bios=0
> 
> [CAUSE]
> Normally we expect all submitted bio reads to only touch the range we
> specified, and under subpage context, it means we should only touch the
> range specified in each bvec.
> 
> But in data read path, inside end_bio_extent_readpage(), we have page
> zeroing which only takes regular page size into consideration.
> 
> This means for subpage if we have an inode whose content looks like below:
> 
>   0       16K     32K     48K     64K
>   |///////|       |///////|       |
> 
>   |//| = data needs to be read from disk
>   |  | = hole
> 
> And i_size is 64K initially.
> 
> Then the following race can happen:
> 
> 		T1		|		T2
> --------------------------------+--------------------------------
> btrfs_do_readpage()		|
> |- isize = 64K;			|
> |  At this time, the isize is 	|
> |  64K				|
> |				|
> |- submit_extent_page()		|
> |  submit previous assembled bio|
> |  assemble bio for [0, 16K)	|
> |				|
> |- submit_extent_page()		|
>    submit read bio for [0, 16K) |
>    assemble read bio for	|
>    [32K, 48K)			|
>  				|
> 				| btrfs_setsize()
> 				| |- i_size_write(, 16K);
> 				|    Now i_size is only 16K
> end_io() for [0K, 16K)		|
> |- end_bio_extent_readpage()	|
>    |- btrfs_verify_data_csum()  |
>    |  No csum error		|
>    |- i_size = 16K;		|
>    |- zero_user_segment(16K,	|
>       PAGE_SIZE);		|
>       !!! We zeroed range	|
>       !!! [32K, 48K)		|
> 				| end_io for [32K, 48K)
> 				| |- end_bio_extent_readpage()
> 				|    |- btrfs_verify_data_csum()
> 				|       ! CSUM MISMATCH !
> 				|       ! As the range is zeroed now !
> 
> [FIX]
> To fix the problem, make end_bio_extent_readpage() to only zero the
> range of bvec.
> 
> The bug only affects subpage read-write support, as for full read-only
> mount we can't change i_size thus won't hit the race condition.

Please drop this patch from autosel because of the above, this is in a
feature that's in progress and does not affect regular filesystems.
