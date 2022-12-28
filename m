Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B912657AEB
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbiL1PQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:16:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbiL1PQS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:16:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6FA228
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:16:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F11A614BA
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:16:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEAB0C433D2;
        Wed, 28 Dec 2022 15:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240577;
        bh=+X9WtXhLdC5G5eMLxL3ALLA5OJbtipaJ7scp4JEFKgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0OR09Qk86Y9QQH9Z3fntB7cYCp+0wLfBWTob+2+lBo4nSZQWW7TdlJJhUlBs3wOfG
         BF/zMtHm+fHuMHl3mYpwo4miw67M29Gr+jF5xPPWqwm855oy+YV0t6tq6rk5Q2mlRi
         3C476K4P8JAtNhqTOxZIqbnJwg3VbBSEKNeUdlFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 369/731] f2fs: Fix the race condition of resize flag between resizefs
Date:   Wed, 28 Dec 2022 15:37:56 +0100
Message-Id: <20221228144307.258237527@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index e75a276f5b9c..4cbaa6ab083f 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -2051,8 +2051,6 @@ int f2fs_resize_fs(struct f2fs_sb_info *sbi, __u64 block_count)
 	if (err)
 		return err;
 
-	set_sbi_flag(sbi, SBI_IS_RESIZEFS);
-
 	freeze_super(sbi->sb);
 	down_write(&sbi->gc_lock);
 	down_write(&sbi->cp_global_sem);
@@ -2068,6 +2066,7 @@ int f2fs_resize_fs(struct f2fs_sb_info *sbi, __u64 block_count)
 	if (err)
 		goto out_err;
 
+	set_sbi_flag(sbi, SBI_IS_RESIZEFS);
 	err = free_segment_range(sbi, secs, false);
 	if (err)
 		goto recover_out;
@@ -2091,6 +2090,7 @@ int f2fs_resize_fs(struct f2fs_sb_info *sbi, __u64 block_count)
 		f2fs_commit_super(sbi, false);
 	}
 recover_out:
+	clear_sbi_flag(sbi, SBI_IS_RESIZEFS);
 	if (err) {
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 		f2fs_err(sbi, "resize_fs failed, should run fsck to repair!");
@@ -2103,6 +2103,5 @@ int f2fs_resize_fs(struct f2fs_sb_info *sbi, __u64 block_count)
 	up_write(&sbi->cp_global_sem);
 	up_write(&sbi->gc_lock);
 	thaw_super(sbi->sb);
-	clear_sbi_flag(sbi, SBI_IS_RESIZEFS);
 	return err;
 }
-- 
2.35.1



