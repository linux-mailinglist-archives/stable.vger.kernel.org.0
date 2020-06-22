Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9549D2041D4
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 22:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbgFVUUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 16:20:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728405AbgFVUUc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 16:20:32 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EEBA206D4;
        Mon, 22 Jun 2020 20:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592857231;
        bh=vAEEku65+8tZi8+9cTYRSz9iB5JJxgkXlaXTlost4LE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xR/k5rP+18LwqwL+kRNIoEnQvA5oVVVvpgukjRdKWhlj7+NdkrL3LIwdswTybFjH6
         DBa8sjWL/HLjkNe25W7TZ2cHgUGV1dVpLsXJjrbHHpFGAlV0ipKdoLiGTZTBx4Gzjw
         m5AvV8het0fjiEuVIeBg/ZApZRoCvMa/ScHiZ23A=
Date:   Mon, 22 Jun 2020 16:20:30 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     jefflexu@linux.alibaba.com, enwlinux@gmail.com, tytso@mit.edu,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ext4: fix partial cluster initialization
 when splitting" failed to apply to 4.19-stable tree
Message-ID: <20200622202030.GI1931@sasha-vm>
References: <1592848206219166@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1592848206219166@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 22, 2020 at 07:50:06PM +0200, gregkh@linuxfoundation.org wrote:
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
>From cfb3c85a600c6aa25a2581b3c1c4db3460f14e46 Mon Sep 17 00:00:00 2001
>From: Jeffle Xu <jefflexu@linux.alibaba.com>
>Date: Fri, 22 May 2020 12:18:44 +0800
>Subject: [PATCH] ext4: fix partial cluster initialization when splitting
> extent
>
>Fix the bug when calculating the physical block number of the first
>block in the split extent.
>
>This bug will cause xfstests shared/298 failure on ext4 with bigalloc
>enabled occasionally. Ext4 error messages indicate that previously freed
>blocks are being freed again, and the following fsck will fail due to
>the inconsistency of block bitmap and bg descriptor.
>
>The following is an example case:
>
>1. First, Initialize a ext4 filesystem with cluster size '16K', block size
>'4K', in which case, one cluster contains four blocks.
>
>2. Create one file (e.g., xxx.img) on this ext4 filesystem. Now the extent
>tree of this file is like:
>
>...
>36864:[0]4:220160
>36868:[0]14332:145408
>51200:[0]2:231424
>...
>
>3. Then execute PUNCH_HOLE fallocate on this file. The hole range is
>like:
>
>..
>ext4_ext_remove_space: dev 254,16 ino 12 since 49506 end 49506 depth 1
>ext4_ext_remove_space: dev 254,16 ino 12 since 49544 end 49546 depth 1
>ext4_ext_remove_space: dev 254,16 ino 12 since 49605 end 49607 depth 1
>...
>
>4. Then the extent tree of this file after punching is like
>
>...
>49507:[0]37:158047
>49547:[0]58:158087
>...
>
>5. Detailed procedure of punching hole [49544, 49546]
>
>5.1. The block address space:
>```
>lblk        ~49505  49506   49507~49543     49544~49546    49547~
>	  ---------+------+-------------+----------------+--------
>	    extent | hole |   extent	|	hole	 | extent
>	  ---------+------+-------------+----------------+--------
>pblk       ~158045  158046  158047~158083  158084~158086   158087~
>```
>
>5.2. The detailed layout of cluster 39521:
>```
>		cluster 39521
>	<------------------------------->
>
>		hole		  extent
>	<----------------------><--------
>
>lblk      49544   49545   49546   49547
>	+-------+-------+-------+-------+
>	|	|	|	|	|
>	+-------+-------+-------+-------+
>pblk     158084  1580845  158086  158087
>```
>
>5.3. The ftrace output when punching hole [49544, 49546]:
>- ext4_ext_remove_space (start 49544, end 49546)
>  - ext4_ext_rm_leaf (start 49544, end 49546, last_extent [49507(158047), 40], partial [pclu 39522 lblk 0 state 2])
>    - ext4_remove_blocks (extent [49507(158047), 40], from 49544 to 49546, partial [pclu 39522 lblk 0 state 2]
>      - ext4_free_blocks: (block 158084 count 4)
>        - ext4_mballoc_free (extent 1/6753/1)
>
>5.4. Ext4 error message in dmesg:
>EXT4-fs error (device vdb): mb_free_blocks:1457: group 1, block 158084:freeing already freed block (bit 6753); block bitmap corrupt.
>EXT4-fs error (device vdb): ext4_mb_generate_buddy:747: group 1, block bitmap and bg descriptor inconsistent: 19550 vs 19551 free clusters
>
>In this case, the whole cluster 39521 is freed mistakenly when freeing
>pblock 158084~158086 (i.e., the first three blocks of this cluster),
>although pblock 158087 (the last remaining block of this cluster) has
>not been freed yet.
>
>The root cause of this isuue is that, the pclu of the partial cluster is
>calculated mistakenly in ext4_ext_remove_space(). The correct
>partial_cluster.pclu (i.e., the cluster number of the first block in the
>next extent, that is, lblock 49597 (pblock 158086)) should be 39521 rather
>than 39522.
>
>Fixes: f4226d9ea400 ("ext4: fix partial cluster initialization")
>Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
>Reviewed-by: Eric Whitney <enwlinux@gmail.com>
>Cc: stable@kernel.org # v3.19+
>Link: https://lore.kernel.org/r/1590121124-37096-1-git-send-email-jefflexu@linux.alibaba.com
>Signed-off-by: Theodore Ts'o <tytso@mit.edu>

This was a conflict with the work done in 9fe671496b6c ("ext4: adjust
reserved cluster count when removing extents"). I've fixed it up and
queued the patch for 4.19-4.4.

-- 
Thanks,
Sasha
