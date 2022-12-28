Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8CA658033
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbiL1QPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:15:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233185AbiL1QPK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:15:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDD21B79F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:12:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 280DE61577
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360C6C433EF;
        Wed, 28 Dec 2022 16:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243954;
        bh=9ByHS5rdBQSK/3m+Pz9D9FtxqECs/qtdtiFHnVbC/ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U8dFLRSev6DibasfbWiu2FYOCgd8c+gmNqABuS2JRfpr91Fdz3m0E5WE77aLsKdJS
         6TizKS0iGz3/eeSwQGVflEXUB1GOPhiUflMf9o+FAdT9DAvNyuy2bKH+WCBcOyw/3x
         PN7s9kXASm0U5xzLdeIgzw87JK6HAVClkLQBx1mY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0585/1146] f2fs: Fix the race condition of resize flag between resizefs
Date:   Wed, 28 Dec 2022 15:35:24 +0100
Message-Id: <20221228144346.062514599@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 28fc4e9077ce59ab28c89c20dc6be5154473218f ]

Because the set/clear SBI_IS_RESIZEFS flag not between any locks,
In the following case:
  thread1			thread2
   ->ioctl(resizefs)
    ->set RESIZEFS flag		 ->ioctl(resizefs)
    ...                   	  ->set RESIZEFS flag
    ->clear RESIZEFS flag
    				  ->resizefs stream
				    # No RESIZEFS flag in the stream

Also before freeze_super, the resizefs not started, we should not set
the SBI_IS_RESIZEFS flag.

So move the set/clear SBI_IS_RESIZEFS flag between the cp_mutex and
gc_lock.

Fixes: b4b10061ef98 ("f2fs: refactor resize_fs to avoid meta updates in progress")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 4546e01b2ee0..2a9d825b84f7 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -2133,8 +2133,6 @@ int f2fs_resize_fs(struct f2fs_sb_info *sbi, __u64 block_count)
 	if (err)
 		return err;
 
-	set_sbi_flag(sbi, SBI_IS_RESIZEFS);
-
 	freeze_super(sbi->sb);
 	f2fs_down_write(&sbi->gc_lock);
 	f2fs_down_write(&sbi->cp_global_sem);
@@ -2150,6 +2148,7 @@ int f2fs_resize_fs(struct f2fs_sb_info *sbi, __u64 block_count)
 	if (err)
 		goto out_err;
 
+	set_sbi_flag(sbi, SBI_IS_RESIZEFS);
 	err = free_segment_range(sbi, secs, false);
 	if (err)
 		goto recover_out;
@@ -2173,6 +2172,7 @@ int f2fs_resize_fs(struct f2fs_sb_info *sbi, __u64 block_count)
 		f2fs_commit_super(sbi, false);
 	}
 recover_out:
+	clear_sbi_flag(sbi, SBI_IS_RESIZEFS);
 	if (err) {
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 		f2fs_err(sbi, "resize_fs failed, should run fsck to repair!");
@@ -2185,6 +2185,5 @@ int f2fs_resize_fs(struct f2fs_sb_info *sbi, __u64 block_count)
 	f2fs_up_write(&sbi->cp_global_sem);
 	f2fs_up_write(&sbi->gc_lock);
 	thaw_super(sbi->sb);
-	clear_sbi_flag(sbi, SBI_IS_RESIZEFS);
 	return err;
 }
-- 
2.35.1



