Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEC424F39CB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378744AbiDELi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351738AbiDEKKO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:10:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 684B7C4E33;
        Tue,  5 Apr 2022 02:55:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1F24616D7;
        Tue,  5 Apr 2022 09:55:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF99FC385A2;
        Tue,  5 Apr 2022 09:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152553;
        bh=nI7dbDDhx02UpWsfJfAL/zctEyT8a5ocPR6yVKs23Fo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kGYk5uz2k4kLMSdPoAAzGvVYXmfv7B1ft2s1ks1iFr5xWy3GZPb2eohpbQak6x6MZ
         UIYZZTQrOQu9lXWxtozQvY2xQjV3UrIuFqCQGyUX8iJGkskGAwkn+17VRBIQaX5UTh
         7igNCg7WHmuCRWc6Y1kzoZWOG5zK53sYa6IARYDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.15 817/913] ubifs: Fix deadlock in concurrent rename whiteout and inode writeback
Date:   Tue,  5 Apr 2022 09:31:19 +0200
Message-Id: <20220405070404.320584400@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit afd427048047e8efdedab30e8888044e2be5aa9c upstream.

Following hung tasks:
[   77.028764] task:kworker/u8:4    state:D stack:    0 pid:  132
[   77.028820] Call Trace:
[   77.029027]  schedule+0x8c/0x1b0
[   77.029067]  mutex_lock+0x50/0x60
[   77.029074]  ubifs_write_inode+0x68/0x1f0 [ubifs]
[   77.029117]  __writeback_single_inode+0x43c/0x570
[   77.029128]  writeback_sb_inodes+0x259/0x740
[   77.029148]  wb_writeback+0x107/0x4d0
[   77.029163]  wb_workfn+0x162/0x7b0

[   92.390442] task:aa              state:D stack:    0 pid: 1506
[   92.390448] Call Trace:
[   92.390458]  schedule+0x8c/0x1b0
[   92.390461]  wb_wait_for_completion+0x82/0xd0
[   92.390469]  __writeback_inodes_sb_nr+0xb2/0x110
[   92.390472]  writeback_inodes_sb_nr+0x14/0x20
[   92.390476]  ubifs_budget_space+0x705/0xdd0 [ubifs]
[   92.390503]  do_rename.cold+0x7f/0x187 [ubifs]
[   92.390549]  ubifs_rename+0x8b/0x180 [ubifs]
[   92.390571]  vfs_rename+0xdb2/0x1170
[   92.390580]  do_renameat2+0x554/0x770

, are caused by concurrent rename whiteout and inode writeback processes:
	rename_whiteout(Thread 1)	        wb_workfn(Thread2)
ubifs_rename
  do_rename
    lock_4_inodes (Hold ui_mutex)
    ubifs_budget_space
      make_free_space
        shrink_liability
	  __writeback_inodes_sb_nr
	    bdi_split_work_to_wbs (Queue new wb work)
					      wb_do_writeback(wb work)
						__writeback_single_inode
					          ubifs_write_inode
					            LOCK(ui_mutex)
							   ↑
	      wb_wait_for_completion (Wait wb work) <-- deadlock!

Reproducer (Detail program in [Link]):
  1. SYS_renameat2("/mp/dir/file", "/mp/dir/whiteout", RENAME_WHITEOUT)
  2. Consume out of space before kernel(mdelay) doing budget for whiteout

Fix it by doing whiteout space budget before locking ubifs inodes.
BTW, it also fixes wrong goto tag 'out_release' in whiteout budget
error handling path(It should at least recover dir i_size and unlock
4 ubifs inodes).

Fixes: 9e0a1fff8db56ea ("ubifs: Implement RENAME_WHITEOUT")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=214733
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ubifs/dir.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1324,6 +1324,7 @@ static int do_rename(struct inode *old_d
 
 	if (flags & RENAME_WHITEOUT) {
 		union ubifs_dev_desc *dev = NULL;
+		struct ubifs_budget_req wht_req;
 
 		dev = kmalloc(sizeof(union ubifs_dev_desc), GFP_NOFS);
 		if (!dev) {
@@ -1345,6 +1346,20 @@ static int do_rename(struct inode *old_d
 		whiteout_ui->data = dev;
 		whiteout_ui->data_len = ubifs_encode_dev(dev, MKDEV(0, 0));
 		ubifs_assert(c, !whiteout_ui->dirty);
+
+		memset(&wht_req, 0, sizeof(struct ubifs_budget_req));
+		wht_req.dirtied_ino = 1;
+		wht_req.dirtied_ino_d = ALIGN(whiteout_ui->data_len, 8);
+		/*
+		 * To avoid deadlock between space budget (holds ui_mutex and
+		 * waits wb work) and writeback work(waits ui_mutex), do space
+		 * budget before ubifs inodes locked.
+		 */
+		err = ubifs_budget_space(c, &wht_req);
+		if (err) {
+			iput(whiteout);
+			goto out_release;
+		}
 	}
 
 	lock_4_inodes(old_dir, new_dir, new_inode, whiteout);
@@ -1419,16 +1434,6 @@ static int do_rename(struct inode *old_d
 	}
 
 	if (whiteout) {
-		struct ubifs_budget_req wht_req = { .dirtied_ino = 1,
-				.dirtied_ino_d = \
-				ALIGN(ubifs_inode(whiteout)->data_len, 8) };
-
-		err = ubifs_budget_space(c, &wht_req);
-		if (err) {
-			iput(whiteout);
-			goto out_release;
-		}
-
 		inc_nlink(whiteout);
 		mark_inode_dirty(whiteout);
 


