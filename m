Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B220E74B5
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 16:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbfJ1PPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 11:15:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390639AbfJ1PPb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Oct 2019 11:15:31 -0400
Received: from localhost (unknown [91.217.168.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D637520830;
        Mon, 28 Oct 2019 15:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572275730;
        bh=5zkD/vp3Gc9wDtzgScCzXQ8nvjSH0sfq5NS766Q8rAE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LXYfWc5iZWFdFBwPFxA0RP8ujNVg9N/z1yP0NSvoL1OVBGdp8MWc86AGkZ5bhmF8L
         oXiKMv9GLKG3TdSTvWWV1//Q5eTshKzumZohEX2tBe1+UUS462TO1cAmWSbF/3JJD1
         49uesXO0mwj1rn6l6KyKFeZiIFJUa961SUllySa0=
Date:   Mon, 28 Oct 2019 11:15:27 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     wqu@suse.com, dsterba@suse.com, fdmanana@suse.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: qgroup: Always free PREALLOC META
 reserve in" failed to apply to 5.3-stable tree
Message-ID: <20191028151527.GB1554@sasha-vm>
References: <1572191283164109@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1572191283164109@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 27, 2019 at 04:48:03PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.3-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 8702ba9396bf7bbae2ab93c94acd4bd37cfa4f09 Mon Sep 17 00:00:00 2001
>From: Qu Wenruo <wqu@suse.com>
>Date: Mon, 14 Oct 2019 14:34:51 +0800
>Subject: [PATCH] btrfs: qgroup: Always free PREALLOC META reserve in
> btrfs_delalloc_release_extents()
>
>[Background]
>Btrfs qgroup uses two types of reserved space for METADATA space,
>PERTRANS and PREALLOC.
>
>PERTRANS is metadata space reserved for each transaction started by
>btrfs_start_transaction().
>While PREALLOC is for delalloc, where we reserve space before joining a
>transaction, and finally it will be converted to PERTRANS after the
>writeback is done.
>
>[Inconsistency]
>However there is inconsistency in how we handle PREALLOC metadata space.
>
>The most obvious one is:
>In btrfs_buffered_write():
>	btrfs_delalloc_release_extents(BTRFS_I(inode), reserve_bytes, true);
>
>We always free qgroup PREALLOC meta space.
>
>While in btrfs_truncate_block():
>	btrfs_delalloc_release_extents(BTRFS_I(inode), blocksize, (ret != 0));
>
>We only free qgroup PREALLOC meta space when something went wrong.
>
>[The Correct Behavior]
>The correct behavior should be the one in btrfs_buffered_write(), we
>should always free PREALLOC metadata space.
>
>The reason is, the btrfs_delalloc_* mechanism works by:
>- Reserve metadata first, even it's not necessary
>  In btrfs_delalloc_reserve_metadata()
>
>- Free the unused metadata space
>  Normally in:
>  btrfs_delalloc_release_extents()
>  |- btrfs_inode_rsv_release()
>     Here we do calculation on whether we should release or not.
>
>E.g. for 64K buffered write, the metadata rsv works like:
>
>/* The first page */
>reserve_meta:	num_bytes=calc_inode_reservations()
>free_meta:	num_bytes=0
>total:		num_bytes=calc_inode_reservations()
>/* The first page caused one outstanding extent, thus needs metadata
>   rsv */
>
>/* The 2nd page */
>reserve_meta:	num_bytes=calc_inode_reservations()
>free_meta:	num_bytes=calc_inode_reservations()
>total:		not changed
>/* The 2nd page doesn't cause new outstanding extent, needs no new meta
>   rsv, so we free what we have reserved */
>
>/* The 3rd~16th pages */
>reserve_meta:	num_bytes=calc_inode_reservations()
>free_meta:	num_bytes=calc_inode_reservations()
>total:		not changed (still space for one outstanding extent)
>
>This means, if btrfs_delalloc_release_extents() determines to free some
>space, then those space should be freed NOW.
>So for qgroup, we should call btrfs_qgroup_free_meta_prealloc() other
>than btrfs_qgroup_convert_reserved_meta().
>
>The good news is:
>- The callers are not that hot
>  The hottest caller is in btrfs_buffered_write(), which is already
>  fixed by commit 336a8bb8e36a ("btrfs: Fix wrong
>  btrfs_delalloc_release_extents parameter"). Thus it's not that
>  easy to cause false EDQUOT.
>
>- The trans commit in advance for qgroup would hide the bug
>  Since commit f5fef4593653 ("btrfs: qgroup: Make qgroup async transaction
>  commit more aggressive"), when btrfs qgroup metadata free space is slow,
>  it will try to commit transaction and free the wrongly converted
>  PERTRANS space, so it's not that easy to hit such bug.
>
>[FIX]
>So to fix the problem, remove the @qgroup_free parameter for
>btrfs_delalloc_release_extents(), and always pass true to
>btrfs_inode_rsv_release().
>
>Reported-by: Filipe Manana <fdmanana@suse.com>
>Fixes: 43b18595d660 ("btrfs: qgroup: Use separate meta reservation type for delalloc")
>CC: stable@vger.kernel.org # 4.19+
>Reviewed-by: Filipe Manana <fdmanana@suse.com>
>Signed-off-by: Qu Wenruo <wqu@suse.com>
>Signed-off-by: David Sterba <dsterba@suse.com>

The conflict was due to not having 29d47d00e0ae6 ("Btrfs: fix inode
cache block reserve leak on failure to allocate data space") on 5.3 so I
took it as well as it's a fix.

On 4.19, in addition to 29d47d00e0ae6m, I also took 17e762bd8e32d ("dm
snapshot: rework COW throttling to fix deadlock") as it's tagged for
stable but needed trivial massaging to backport to 4.19, and worked
around the code movement introduced by 867363429d706 ("btrfs: migrate
the delalloc space stuff to it's own home").

-- 
Thanks,
Sasha
