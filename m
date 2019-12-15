Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D620B11FA86
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 19:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbfLOStv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 13:49:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:57348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726146AbfLOStv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Dec 2019 13:49:51 -0500
Received: from localhost (unknown [73.61.17.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D81A206D7;
        Sun, 15 Dec 2019 18:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576435790;
        bh=9T2NwdRNIET7vkk57AHK+ClKCEPq3JvD8ZNwnL+xBFo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aTEqQocbb61HWYycC7icFMwjPL9SIR92JnbaEL1aJG7Y8j3E+MuDTMK3HGg1VM90r
         sVhiaVC6v6FZbnfC69TwJlG5aVndompKNfcU66RzhCVFReJNC9sZJ2dJWRtT/IyPdG
         gB8fk+m5bRouE9961pxBz+e7pzPw+zVw+jrV6wzY=
Date:   Sun, 15 Dec 2019 13:49:48 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     fdmanana@suse.com, dsterba@suse.com, josef@toxicpanda.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] Btrfs: fix negative subv_writers counter
 and data space leak" failed to apply to 4.9-stable tree
Message-ID: <20191215184948.GP18043@sasha-vm>
References: <1576408223251148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1576408223251148@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 15, 2019 at 12:10:23PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.9-stable tree.
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
>From a0e248bb502d5165b3314ac3819e888fdcdf7d9f Mon Sep 17 00:00:00 2001
>From: Filipe Manana <fdmanana@suse.com>
>Date: Fri, 11 Oct 2019 16:41:20 +0100
>Subject: [PATCH] Btrfs: fix negative subv_writers counter and data space leak
> after buffered write
>
>When doing a buffered write it's possible to leave the subv_writers
>counter of the root, used for synchronization between buffered nocow
>writers and snapshotting. This happens in an exceptional case like the
>following:
>
>1) We fail to allocate data space for the write, since there's not
>   enough available data space nor enough unallocated space for allocating
>   a new data block group;
>
>2) Because of that failure, we try to go to NOCOW mode, which succeeds
>   and therefore we set the local variable 'only_release_metadata' to true
>   and set the root's sub_writers counter to 1 through the call to
>   btrfs_start_write_no_snapshotting() made by check_can_nocow();
>
>3) The call to btrfs_copy_from_user() returns zero, which is very unlikely
>   to happen but not impossible;
>
>4) No pages are copied because btrfs_copy_from_user() returned zero;
>
>5) We call btrfs_end_write_no_snapshotting() which decrements the root's
>   subv_writers counter to 0;
>
>6) We don't set 'only_release_metadata' back to 'false' because we do
>   it only if 'copied', the value returned by btrfs_copy_from_user(), is
>   greater than zero;
>
>7) On the next iteration of the while loop, which processes the same
>   page range, we are now able to allocate data space for the write (we
>   got enough data space released in the meanwhile);
>
>8) After this if we fail at btrfs_delalloc_reserve_metadata(), because
>   now there isn't enough free metadata space, or in some other place
>   further below (prepare_pages(), lock_and_cleanup_extent_if_need(),
>   btrfs_dirty_pages()), we break out of the while loop with
>   'only_release_metadata' having a value of 'true';
>
>9) Because 'only_release_metadata' is 'true' we end up decrementing the
>   root's subv_writers counter to -1 (through a call to
>   btrfs_end_write_no_snapshotting()), and we also end up not releasing the
>   data space previously reserved through btrfs_check_data_free_space().
>   As a consequence the mechanism for synchronizing NOCOW buffered writes
>   with snapshotting gets broken.
>
>Fix this by always setting 'only_release_metadata' to false at the start
>of each iteration.
>
>Fixes: 8257b2dc3c1a ("Btrfs: introduce btrfs_{start, end}_nocow_write() for each subvolume")
>Fixes: 7ee9e4405f26 ("Btrfs: check if we can nocow if we don't have data space")
>CC: stable@vger.kernel.org # 4.4+
>Reviewed-by: Josef Bacik <josef@toxicpanda.com>
>Signed-off-by: Filipe Manana <fdmanana@suse.com>
>Reviewed-by: David Sterba <dsterba@suse.com>
>Signed-off-by: David Sterba <dsterba@suse.com>

Adjusted context for missing da17066c4047 ("btrfs: pull
node/sector/stripe sizes out of root and into fs_info") and queued up
for 4.9 and 4.4.

-- 
Thanks,
Sasha
