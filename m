Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9209D603C63
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbiJSIqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbiJSIpA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:45:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE1415828;
        Wed, 19 Oct 2022 01:43:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 170826181D;
        Wed, 19 Oct 2022 08:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274DAC433D6;
        Wed, 19 Oct 2022 08:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168998;
        bh=ocT89eyYuIuOto2JTfMrtff4SJkzbMfHnpgn7rdRkk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NlBXEw9ZkpGJRg+V8MMDXTqDsyHd77ZyIP+M2TqBw4VvnnpRVf97UAwqDjZGls/m3
         tlsxFVt4T/FNSmx5fvucHR5SrizAI241lKzg8azayj+FMoOJWhSFtko4X0BenypPCi
         dzdWNmMW6MuSvhY+WG6JuxBS001tJFKvfyU6OrMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.0 125/862] f2fs: flush pending checkpoints when freezing super
Date:   Wed, 19 Oct 2022 10:23:32 +0200
Message-Id: <20221019083255.475244105@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -3707,6 +3707,7 @@ static inline bool f2fs_need_rand_seg(st
  * checkpoint.c
  */
 void f2fs_stop_checkpoint(struct f2fs_sb_info *sbi, bool end_io);
+void f2fs_flush_ckpt_thread(struct f2fs_sb_info *sbi);
 struct page *f2fs_grab_meta_page(struct f2fs_sb_info *sbi, pgoff_t index);
 struct page *f2fs_get_meta_page(struct f2fs_sb_info *sbi, pgoff_t index);
 struct page *f2fs_get_meta_page_retry(struct f2fs_sb_info *sbi, pgoff_t index);
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1666,9 +1666,8 @@ static int f2fs_freeze(struct super_bloc
 	if (is_sbi_flag_set(F2FS_SB(sb), SBI_IS_DIRTY))
 		return -EINVAL;
 
-	/* ensure no checkpoint required */
-	if (!llist_empty(&F2FS_SB(sb)->cprc_info.issue_list))
-		return -EINVAL;
+	/* Let's flush checkpoints and stop the thread. */
+	f2fs_flush_ckpt_thread(F2FS_SB(sb));
 
 	/* to avoid deadlock on f2fs_evict_inode->SB_FREEZE_FS */
 	set_sbi_flag(F2FS_SB(sb), SBI_IS_FREEZING);


