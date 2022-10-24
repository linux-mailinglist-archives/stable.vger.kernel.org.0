Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F0B60B8C0
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbiJXTxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233719AbiJXTwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:52:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A09D386A2;
        Mon, 24 Oct 2022 11:17:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8156B817C2;
        Mon, 24 Oct 2022 12:36:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1F6C433D6;
        Mon, 24 Oct 2022 12:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614994;
        bh=fCrdWHM8LnRaqMfC4KAxu5QD6ur8u7uDL8AqdQGAJ9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PgVTv8hBRmKi6TKQsj701VcV3I7z73elPZCB4ZIUe7UiZiZ2Py8YFdj3bplaTvoqY
         VBEOJbhyDuNZsWP5Qh2C9pzYHzkyEUIfFjmO7U9SxJ5vhXs+qiaYPgLgdqoSxQalSO
         76FRYT/H3ZFpVIm5ANwHvDBbbWKEsp6K1f8CZu6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.15 082/530] f2fs: flush pending checkpoints when freezing super
Date:   Mon, 24 Oct 2022 13:27:06 +0200
Message-Id: <20221024113048.729715245@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
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

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit c7b58576370147833999fd4cc874d0f918bdf9ca upstream.

This avoids -EINVAL when trying to freeze f2fs.

Cc: stable@vger.kernel.org
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/checkpoint.c |   24 ++++++++++++++++++------
 fs/f2fs/f2fs.h       |    1 +
 fs/f2fs/super.c      |    5 ++---
 3 files changed, 21 insertions(+), 9 deletions(-)

--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -1892,15 +1892,27 @@ int f2fs_start_ckpt_thread(struct f2fs_s
 void f2fs_stop_ckpt_thread(struct f2fs_sb_info *sbi)
 {
 	struct ckpt_req_control *cprc = &sbi->cprc_info;
+	struct task_struct *ckpt_task;
 
-	if (cprc->f2fs_issue_ckpt) {
-		struct task_struct *ckpt_task = cprc->f2fs_issue_ckpt;
+	if (!cprc->f2fs_issue_ckpt)
+		return;
 
-		cprc->f2fs_issue_ckpt = NULL;
-		kthread_stop(ckpt_task);
+	ckpt_task = cprc->f2fs_issue_ckpt;
+	cprc->f2fs_issue_ckpt = NULL;
+	kthread_stop(ckpt_task);
 
-		flush_remained_ckpt_reqs(sbi, NULL);
-	}
+	f2fs_flush_ckpt_thread(sbi);
+}
+
+void f2fs_flush_ckpt_thread(struct f2fs_sb_info *sbi)
+{
+	struct ckpt_req_control *cprc = &sbi->cprc_info;
+
+	flush_remained_ckpt_reqs(sbi, NULL);
+
+	/* Let's wait for the previous dispatched checkpoint. */
+	while (atomic_read(&cprc->queued_ckpt))
+		io_schedule_timeout(DEFAULT_IO_TIMEOUT);
 }
 
 void f2fs_init_ckpt_req_control(struct f2fs_sb_info *sbi)
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3540,6 +3540,7 @@ unsigned int f2fs_usable_blks_in_seg(str
  * checkpoint.c
  */
 void f2fs_stop_checkpoint(struct f2fs_sb_info *sbi, bool end_io);
+void f2fs_flush_ckpt_thread(struct f2fs_sb_info *sbi);
 struct page *f2fs_grab_meta_page(struct f2fs_sb_info *sbi, pgoff_t index);
 struct page *f2fs_get_meta_page(struct f2fs_sb_info *sbi, pgoff_t index);
 struct page *f2fs_get_meta_page_retry(struct f2fs_sb_info *sbi, pgoff_t index);
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1661,9 +1661,8 @@ static int f2fs_freeze(struct super_bloc
 	if (is_sbi_flag_set(F2FS_SB(sb), SBI_IS_DIRTY))
 		return -EINVAL;
 
-	/* ensure no checkpoint required */
-	if (!llist_empty(&F2FS_SB(sb)->cprc_info.issue_list))
-		return -EINVAL;
+	/* Let's flush checkpoints and stop the thread. */
+	f2fs_flush_ckpt_thread(F2FS_SB(sb));
 
 	/* to avoid deadlock on f2fs_evict_inode->SB_FREEZE_FS */
 	set_sbi_flag(F2FS_SB(sb), SBI_IS_FREEZING);


