Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEBB156BBE
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 18:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbgBIROG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 12:14:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727336AbgBIROG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 12:14:06 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BCC920715;
        Sun,  9 Feb 2020 17:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581268445;
        bh=ItfHx84E8jgPpMaoV/5UZjGqN7VOvf2nkwsrq+6+S7Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gyVkguRSGFJOQEaHKDHRIZ3nX+qj/mTcT2OyN2gIDfouY0DHD5a5HSsL5O9rONKjD
         IEoWH58DhUqJD7Qu4V25GWrX3ouhELNcAEGfaqwE3HDWnhHFX7T2IlQ1oPY7oxrpC6
         RKr5jTG9OtbifZGOeThIoH4BEkaio/vr/lDmXp9I=
Date:   Sun, 9 Feb 2020 12:14:04 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     fdmanana@suse.com, dsterba@suse.com, josef@toxicpanda.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] Btrfs: fix missing hole after hole
 punching and fsync when" failed to apply to 4.14-stable tree
Message-ID: <20200209171404.GE3584@sasha-vm>
References: <158124763023114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158124763023114@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 12:27:10PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.14-stable tree.
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
>From 0e56315ca147b3e60c7bf240233a301d3c7fb508 Mon Sep 17 00:00:00 2001
>From: Filipe Manana <fdmanana@suse.com>
>Date: Tue, 19 Nov 2019 12:07:33 +0000
>Subject: [PATCH] Btrfs: fix missing hole after hole punching and fsync when
> using NO_HOLES
>
>When using the NO_HOLES feature, if we punch a hole into a file and then
>fsync it, there are cases where a subsequent fsync will miss the fact that
>a hole was punched, resulting in the holes not existing after replaying
>the log tree.
>
>Essentially these cases all imply that, tree-log.c:copy_items(), is not
>invoked for the leafs that delimit holes, because nothing changed those
>leafs in the current transaction. And it's precisely copy_items() where
>we currenly detect and log holes, which works as long as the holes are
>between file extent items in the input leaf or between the beginning of
>input leaf and the previous leaf or between the last item in the leaf
>and the next leaf.
>
>First example where we miss a hole:
>
>  *) The extent items of the inode span multiple leafs;
>
>  *) The punched hole covers a range that affects only the extent items of
>     the first leaf;
>
>  *) The fsync operation is done in full mode (BTRFS_INODE_NEEDS_FULL_SYNC
>     is set in the inode's runtime flags).
>
>  That results in the hole not existing after replaying the log tree.
>
>  For example, if the fs/subvolume tree has the following layout for a
>  particular inode:
>
>      Leaf N, generation 10:
>
>      [ ... INODE_ITEM INODE_REF EXTENT_ITEM (0 64K) EXTENT_ITEM (64K 128K) ]
>
>      Leaf N + 1, generation 10:
>
>      [ EXTENT_ITEM (128K 64K) ... ]
>
>  If at transaction 11 we punch a hole coverting the range [0, 128K[, we end
>  up dropping the two extent items from leaf N, but we don't touch the other
>  leaf, so we end up in the following state:
>
>      Leaf N, generation 11:
>
>      [ ... INODE_ITEM INODE_REF ]
>
>      Leaf N + 1, generation 10:
>
>      [ EXTENT_ITEM (128K 64K) ... ]
>
>  A full fsync after punching the hole will only process leaf N because it
>  was modified in the current transaction, but not leaf N + 1, since it
>  was not modified in the current transaction (generation 10 and not 11).
>  As a result the fsync will not log any holes, because it didn't process
>  any leaf with extent items.
>
>Second example where we will miss a hole:
>
>  *) An inode as its items spanning 5 (or more) leafs;
>
>  *) A hole is punched and it covers only the extents items of the 3rd
>     leaf. This resulsts in deleting the entire leaf and not touching any
>     of the other leafs.
>
>  So the only leaf that is modified in the current transaction, when
>  punching the hole, is the first leaf, which contains the inode item.
>  During the full fsync, the only leaf that is passed to copy_items()
>  is that first leaf, and that's not enough for the hole detection
>  code in copy_items() to determine there's a hole between the last
>  file extent item in the 2nd leaf and the first file extent item in
>  the 3rd leaf (which was the 4th leaf before punching the hole).
>
>Fix this by scanning all leafs and punch holes as necessary when doing a
>full fsync (less common than a non-full fsync) when the NO_HOLES feature
>is enabled. The lack of explicit file extent items to mark holes makes it
>necessary to scan existing extents to determine if holes exist.
>
>A test case for fstests follows soon.
>
>Fixes: 16e7549f045d33 ("Btrfs: incompatible format change to remove hole extents")
>CC: stable@vger.kernel.org # 4.4+
>Reviewed-by: Josef Bacik <josef@toxicpanda.com>
>Signed-off-by: Filipe Manana <fdmanana@suse.com>
>Signed-off-by: David Sterba <dsterba@suse.com>

I took these additional patches for 4.14 (one is tagged for stable):

e41ca5897489 ("btrfs: Get rid of the confusing btrfs_file_extent_inline_len")
0ccc3876e4b2 ("Btrfs: fix assertion failure on fsync with NO_HOLES enabled")

4.9 and older need some work I'm not comfortable doing. I did take
0ccc3876e4b2 all the way back to 4.4.

-- 
Thanks,
Sasha
