Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B5160BA66
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234478AbiJXUgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234415AbiJXUg0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:36:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADAC1358AA;
        Mon, 24 Oct 2022 11:47:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB4B8B81200;
        Mon, 24 Oct 2022 12:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A84C4314D;
        Mon, 24 Oct 2022 12:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613174;
        bh=btpbaJQOeK/Q5qLPhStOkkSHkPIW1bhoa9FE22TUv0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uX2oLhy52ExjHMmChEtcUsAZGtEAYlnCHOUqmVR6JJH7GQZQnvTrs66XNk7wmfgxo
         7ShrfzvUJg90BKXJLMO52wi3XB76/Fbzky/Ai3Q9eP0yIa6BEs/j9nqBgry1pCiOjv
         vIZ/CLABhhDIynAoC1eJ4imcShDk4bRA1BRcLw/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenqing Liu <wenqingliu0120@gmail.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.4 037/255] f2fs: fix to do sanity check on destination blkaddr during recovery
Date:   Mon, 24 Oct 2022 13:29:07 +0200
Message-Id: <20221024113003.670696382@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

commit 0ef4ca04a3f9223ff8bc440041c524b2123e09a3 upstream.

As Wenqing Liu reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=216456

loop5: detected capacity change from 0 to 131072
F2FS-fs (loop5): recover_inode: ino = 6, name = hln, inline = 1
F2FS-fs (loop5): recover_data: ino = 6 (i_size: recover) err = 0
F2FS-fs (loop5): recover_inode: ino = 6, name = hln, inline = 1
F2FS-fs (loop5): recover_data: ino = 6 (i_size: recover) err = 0
F2FS-fs (loop5): recover_inode: ino = 6, name = hln, inline = 1
F2FS-fs (loop5): recover_data: ino = 6 (i_size: recover) err = 0
F2FS-fs (loop5): Bitmap was wrongly set, blk:5634
------------[ cut here ]------------
WARNING: CPU: 3 PID: 1013 at fs/f2fs/segment.c:2198
RIP: 0010:update_sit_entry+0xa55/0x10b0 [f2fs]
Call Trace:
 <TASK>
 f2fs_do_replace_block+0xa98/0x1890 [f2fs]
 f2fs_replace_block+0xeb/0x180 [f2fs]
 recover_data+0x1a69/0x6ae0 [f2fs]
 f2fs_recover_fsync_data+0x120d/0x1fc0 [f2fs]
 f2fs_fill_super+0x4665/0x61e0 [f2fs]
 mount_bdev+0x2cf/0x3b0
 legacy_get_tree+0xed/0x1d0
 vfs_get_tree+0x81/0x2b0
 path_mount+0x47e/0x19d0
 do_mount+0xce/0xf0
 __x64_sys_mount+0x12c/0x1a0
 do_syscall_64+0x38/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

If we enable CONFIG_F2FS_CHECK_FS config, it will trigger a kernel panic
instead of warning.

The root cause is: in fuzzed image, SIT table is inconsistent with inode
mapping table, result in triggering such warning during SIT table update.

This patch introduces a new flag DATA_GENERIC_ENHANCE_UPDATE, w/ this
flag, data block recovery flow can check destination blkaddr's validation
in SIT table, and skip f2fs_replace_block() to avoid inconsistent status.

Cc: stable@vger.kernel.org
Reported-by: Wenqing Liu <wenqingliu0120@gmail.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/checkpoint.c |   10 +++++++++-
 fs/f2fs/f2fs.h       |    4 ++++
 fs/f2fs/recovery.c   |    8 ++++++++
 3 files changed, 21 insertions(+), 1 deletion(-)

--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -137,7 +137,7 @@ static bool __is_bitmap_valid(struct f2f
 	unsigned int segno, offset;
 	bool exist;
 
-	if (type != DATA_GENERIC_ENHANCE && type != DATA_GENERIC_ENHANCE_READ)
+	if (type == DATA_GENERIC)
 		return true;
 
 	segno = GET_SEGNO(sbi, blkaddr);
@@ -145,6 +145,13 @@ static bool __is_bitmap_valid(struct f2f
 	se = get_seg_entry(sbi, segno);
 
 	exist = f2fs_test_bit(offset, se->cur_valid_map);
+	if (exist && type == DATA_GENERIC_ENHANCE_UPDATE) {
+		f2fs_err(sbi, "Inconsistent error blkaddr:%u, sit bitmap:%d",
+			 blkaddr, exist);
+		set_sbi_flag(sbi, SBI_NEED_FSCK);
+		return exist;
+	}
+
 	if (!exist && type == DATA_GENERIC_ENHANCE) {
 		f2fs_err(sbi, "Inconsistent error blkaddr:%u, sit bitmap:%d",
 			 blkaddr, exist);
@@ -182,6 +189,7 @@ bool f2fs_is_valid_blkaddr(struct f2fs_s
 	case DATA_GENERIC:
 	case DATA_GENERIC_ENHANCE:
 	case DATA_GENERIC_ENHANCE_READ:
+	case DATA_GENERIC_ENHANCE_UPDATE:
 		if (unlikely(blkaddr >= MAX_BLKADDR(sbi) ||
 				blkaddr < MAIN_BLKADDR(sbi))) {
 			f2fs_warn(sbi, "access invalid blkaddr:%u",
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -225,6 +225,10 @@ enum {
 					 * condition of read on truncated area
 					 * by extent_cache
 					 */
+	DATA_GENERIC_ENHANCE_UPDATE,	/*
+					 * strong check on range and segment
+					 * bitmap for update case
+					 */
 	META_GENERIC,
 };
 
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -630,6 +630,14 @@ retry_prev:
 				goto err;
 			}
 
+			if (f2fs_is_valid_blkaddr(sbi, dest,
+					DATA_GENERIC_ENHANCE_UPDATE)) {
+				f2fs_err(sbi, "Inconsistent dest blkaddr:%u, ino:%lu, ofs:%u",
+					dest, inode->i_ino, dn.ofs_in_node);
+				err = -EFSCORRUPTED;
+				goto err;
+			}
+
 			/* write dummy data page */
 			f2fs_replace_block(sbi, &dn, src, dest,
 						ni.version, false, false);


