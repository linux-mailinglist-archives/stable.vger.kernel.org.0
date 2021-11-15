Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B645450CD6
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237661AbhKORod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:44:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:57868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237334AbhKORly (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:41:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA58B632F3;
        Mon, 15 Nov 2021 17:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997247;
        bh=zr9+qOmVC9QCtsJNBaf1BMCOPihvwMxhYinK66G6ccw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ljTpV5KZ1HfHQC1nGXTVYT/995gYABWKGPTq25qc7tWmHxCqDC3P38IQ72iCxzMh
         eVEndK8E6W4k6wR7UUrWFMYlbu1E3+1nUUAtfbmsjKL8T3YyvZFoN1RpFpz++k+71u
         j28GsyereMzwX+ByESbd2gjgFGJxMZ6qahry5dZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        yangerkun <yangerkun@huawei.com>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 045/575] ext4: refresh the ext4_ext_path struct after dropping i_data_sem.
Date:   Mon, 15 Nov 2021 17:56:10 +0100
Message-Id: <20211115165345.197972482@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>

commit 1811bc401aa58c7bdb0df3205aa6613b49d32127 upstream.

After we drop i_data sem, we need to reload the ext4_ext_path
structure since the extent tree can change once i_data_sem is
released.

This addresses the BUG:

[52117.465187] ------------[ cut here ]------------
[52117.465686] kernel BUG at fs/ext4/extents.c:1756!
...
[52117.478306] Call Trace:
[52117.478565]  ext4_ext_shift_extents+0x3ee/0x710
[52117.479020]  ext4_fallocate+0x139c/0x1b40
[52117.479405]  ? __do_sys_newfstat+0x6b/0x80
[52117.479805]  vfs_fallocate+0x151/0x4b0
[52117.480177]  ksys_fallocate+0x4a/0xa0
[52117.480533]  __x64_sys_fallocate+0x22/0x30
[52117.480930]  do_syscall_64+0x35/0x80
[52117.481277]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[52117.481769] RIP: 0033:0x7fa062f855ca

Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20210903062748.4118886-4-yangerkun@huawei.com
Signed-off-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5005,8 +5005,11 @@ ext4_ext_shift_path_extents(struct ext4_
 			restart_credits = ext4_writepage_trans_blocks(inode);
 			err = ext4_datasem_ensure_credits(handle, inode, credits,
 					restart_credits, 0);
-			if (err)
+			if (err) {
+				if (err > 0)
+					err = -EAGAIN;
 				goto out;
+			}
 
 			err = ext4_ext_get_access(handle, inode, path + depth);
 			if (err)
@@ -5080,6 +5083,7 @@ ext4_ext_shift_extents(struct inode *ino
 	int ret = 0, depth;
 	struct ext4_extent *extent;
 	ext4_lblk_t stop, *iterator, ex_start, ex_end;
+	ext4_lblk_t tmp = EXT_MAX_BLOCKS;
 
 	/* Let path point to the last extent */
 	path = ext4_find_extent(inode, EXT_MAX_BLOCKS - 1, NULL,
@@ -5133,11 +5137,15 @@ ext4_ext_shift_extents(struct inode *ino
 	 * till we reach stop. In case of right shift, iterator points to stop
 	 * and it is decreased till we reach start.
 	 */
+again:
 	if (SHIFT == SHIFT_LEFT)
 		iterator = &start;
 	else
 		iterator = &stop;
 
+	if (tmp != EXT_MAX_BLOCKS)
+		*iterator = tmp;
+
 	/*
 	 * Its safe to start updating extents.  Start and stop are unsigned, so
 	 * in case of right shift if extent with 0 block is reached, iterator
@@ -5166,6 +5174,7 @@ ext4_ext_shift_extents(struct inode *ino
 			}
 		}
 
+		tmp = *iterator;
 		if (SHIFT == SHIFT_LEFT) {
 			extent = EXT_LAST_EXTENT(path[depth].p_hdr);
 			*iterator = le32_to_cpu(extent->ee_block) +
@@ -5184,6 +5193,9 @@ ext4_ext_shift_extents(struct inode *ino
 		}
 		ret = ext4_ext_shift_path_extents(path, shift, inode,
 				handle, SHIFT);
+		/* iterator can be NULL which means we should break */
+		if (ret == -EAGAIN)
+			goto again;
 		if (ret)
 			break;
 	}


