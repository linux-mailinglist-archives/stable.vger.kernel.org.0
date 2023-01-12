Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B25667597
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbjALOXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236621AbjALOWU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:22:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A75BA0
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:13:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8013BB81DCC
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:13:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CDCC433EF;
        Thu, 12 Jan 2023 14:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532819;
        bh=Fcq213SnMnf54uGEEhpZ8HlaTHB+eCQCWjZVM3hau6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xv6UvupYo6xvsiTCqprEjpLIWwJ82jkeG6fag7jasBta0ETtXjmxQZifIIImkNC1Y
         AM4M5+f6TGoV16k+pF0pC5HlckXGe8XFmVIKYK8nb+XSt2puBZxDGLRGePhTjqJGng
         yaORnc5jcNJySjq6VQu2uVeGq5hxGVkxfNRdfaFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 287/783] f2fs: Fix the race condition of resize flag between resizefs
Date:   Thu, 12 Jan 2023 14:50:03 +0100
Message-Id: <20230112135537.689650786@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 3baa62ef6e3a..5ac0b605335f 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -2035,8 +2035,6 @@ int f2fs_resize_fs(struct f2fs_sb_info *sbi, __u64 block_count)
 	if (err)
 		return err;
 
-	set_sbi_flag(sbi, SBI_IS_RESIZEFS);
-
 	freeze_super(sbi->sb);
 	down_write(&sbi->gc_lock);
 	mutex_lock(&sbi->cp_mutex);
@@ -2052,6 +2050,7 @@ int f2fs_resize_fs(struct f2fs_sb_info *sbi, __u64 block_count)
 	if (err)
 		goto out_err;
 
+	set_sbi_flag(sbi, SBI_IS_RESIZEFS);
 	err = free_segment_range(sbi, secs, false);
 	if (err)
 		goto recover_out;
@@ -2075,6 +2074,7 @@ int f2fs_resize_fs(struct f2fs_sb_info *sbi, __u64 block_count)
 		f2fs_commit_super(sbi, false);
 	}
 recover_out:
+	clear_sbi_flag(sbi, SBI_IS_RESIZEFS);
 	if (err) {
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 		f2fs_err(sbi, "resize_fs failed, should run fsck to repair!");
@@ -2087,6 +2087,5 @@ int f2fs_resize_fs(struct f2fs_sb_info *sbi, __u64 block_count)
 	mutex_unlock(&sbi->cp_mutex);
 	up_write(&sbi->gc_lock);
 	thaw_super(sbi->sb);
-	clear_sbi_flag(sbi, SBI_IS_RESIZEFS);
 	return err;
 }
-- 
2.35.1



