Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1E3162AE2
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 17:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgBRQnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 11:43:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:59948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbgBRQnD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 11:43:03 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C82B0208C4;
        Tue, 18 Feb 2020 16:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582044182;
        bh=z2Ed6W7KtzGK9BU3ToR53vdmHhzfNF3Dspc50Zh47SU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FhAaErRZRhjrX+ViHBAg/M995zFpvEQUn9LCOhBMgFbvXOkjPVQTisrDtZRRMnhh9
         kc93hplcodwZ4bovSzyInAeWeG9DI6yu3ariftX+PeuisrjMzqQmydvnrh/QLLDWb0
         2OT71d+NaEL3yfG4KMQ8jLwjcY+GzOCwVfdKsISs=
Date:   Tue, 18 Feb 2020 11:43:00 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     fdmanana@suse.com, dsterba@suse.com, josef@toxicpanda.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] Btrfs: fix race between shrinking
 truncate and fiemap" failed to apply to 4.19-stable tree
Message-ID: <20200218164300.GQ1734@sasha-vm>
References: <158196656712413@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158196656712413@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 17, 2020 at 08:09:27PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
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
>From 28553fa992cb28be6a65566681aac6cafabb4f2d Mon Sep 17 00:00:00 2001
>From: Filipe Manana <fdmanana@suse.com>
>Date: Fri, 7 Feb 2020 12:23:09 +0000
>Subject: [PATCH] Btrfs: fix race between shrinking truncate and fiemap
>
>When there is a fiemap executing in parallel with a shrinking truncate
>we can end up in a situation where we have extent maps for which we no
>longer have corresponding file extent items. This is generally harmless
>and at the moment the only consequences are missing file extent items
>representing holes after we expand the file size again after the
>truncate operation removed the prealloc extent items, and stale
>information for future fiemap calls (reporting extents that no longer
>exist or may have been reallocated to other files for example).
>
>Consider the following example:
>
>1) Our inode has a size of 128KiB, one 128KiB extent at file offset 0
>   and a 1MiB prealloc extent at file offset 128KiB;
>
>2) Task A starts doing a shrinking truncate of our inode to reduce it to
>   a size of 64KiB. Before it searches the subvolume tree for file
>   extent items to delete, it drops all the extent maps in the range
>   from 64KiB to (u64)-1 by calling btrfs_drop_extent_cache();
>
>3) Task B starts doing a fiemap against our inode. When looking up for
>   the inode's extent maps in the range from 128KiB to (u64)-1, it
>   doesn't find any in the inode's extent map tree, since they were
>   removed by task A.  Because it didn't find any in the extent map
>   tree, it scans the inode's subvolume tree for file extent items, and
>   it finds the 1MiB prealloc extent at file offset 128KiB, then it
>   creates an extent map based on that file extent item and adds it to
>   inode's extent map tree (this ends up being done by
>   btrfs_get_extent() <- btrfs_get_extent_fiemap() <-
>   get_extent_skip_holes());
>
>4) Task A then drops the prealloc extent at file offset 128KiB and
>   shrinks the 128KiB extent file offset 0 to a length of 64KiB. The
>   truncation operation finishes and we end up with an extent map
>   representing a 1MiB prealloc extent at file offset 128KiB, despite we
>   don't have any more that extent;
>
>After this the two types of problems we have are:
>
>1) Future calls to fiemap always report that a 1MiB prealloc extent
>   exists at file offset 128KiB. This is stale information, no longer
>   correct;
>
>2) If the size of the file is increased, by a truncate operation that
>   increases the file size or by a write into a file offset > 64KiB for
>   example, we end up not inserting file extent items to represent holes
>   for any range between 128KiB and 128KiB + 1MiB, since the hole
>   expansion function, btrfs_cont_expand() will skip hole insertion for
>   any range for which an extent map exists that represents a prealloc
>   extent. This causes fsck to complain about missing file extent items
>   when not using the NO_HOLES feature.
>
>The second issue could be often triggered by test case generic/561 from
>fstests, which runs fsstress and duperemove in parallel, and duperemove
>does frequent fiemap calls.
>
>Essentially the problems happens because fiemap does not acquire the
>inode's lock while truncate does, and fiemap locks the file range in the
>inode's iotree while truncate does not. So fix the issue by making
>btrfs_truncate_inode_items() lock the file range from the new file size
>to (u64)-1, so that it serializes with fiemap.
>
>CC: stable@vger.kernel.org # 4.4+
>Reviewed-by: Josef Bacik <josef@toxicpanda.com>
>Signed-off-by: Filipe Manana <fdmanana@suse.com>
>Reviewed-by: David Sterba <dsterba@suse.com>
>Signed-off-by: David Sterba <dsterba@suse.com>

Note: since this patch has a fix that just hit upstream, and it needs
backporting to older kernels, I've dropped it from 5.5 and 5.4 for now
and will queue both this and it's fix for the next release.

Backports of both to older kernels (<5.4) would be great to have.

-- 
Thanks,
Sasha
