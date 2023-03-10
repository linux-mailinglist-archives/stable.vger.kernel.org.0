Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99ADF6B41ED
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbjCJN6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbjCJN5y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:57:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED86C112DDC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:57:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 896F761771
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:57:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95847C433EF;
        Fri, 10 Mar 2023 13:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456664;
        bh=sjTCY6DiJKy+05lhXb0ZWq6h3nG7hU3WJ7x5I0zLqQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WuiVB0kjJ4DrOZxjRE/BHuQuj6d11nP4vuamJQufcAd4In5Vsj7IOuTmik7YtxKuf
         PfYbPkmbX+Hne8zQZjRBAslRbYXaGPHVc2jcIY61DK6vJNTNupa5RZEQOSiI5NJp5y
         VkeU9FxK7j9gMEyzzekcVqBlAjpuNbcWW0NIUSAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yangtao Li <frank.li@vivo.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 050/211] f2fs: fix to set ipu policy
Date:   Fri, 10 Mar 2023 14:37:10 +0100
Message-Id: <20230310133720.259506044@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit c5bf83483382600988d7db5ffe9fcd1936b491fd ]

For LFS mode, it should update outplace and no need inplace update.
When using LFS mode for small-volume devices, IPU will not be used,
and the OPU writing method is actually used, but F2FS_IPU_FORCE can
be read from the ipu_policy node, which is different from the actual
situation. And remount to lfs mode should be disallowed when
f2fs ipu is enabled, let's fix it.

Fixes: 84b89e5d943d ("f2fs: add auto tuning for small devices")
Signed-off-by: Yangtao Li <frank.li@vivo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.h | 10 +++++++++-
 fs/f2fs/super.c   | 15 +++++++++++----
 fs/f2fs/sysfs.c   |  9 +++++++++
 3 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index e77518c49f388..6eb5922a25361 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -670,6 +670,8 @@ static inline int utilization(struct f2fs_sb_info *sbi)
 
 #define SMALL_VOLUME_SEGMENTS	(16 * 512)	/* 16GB */
 
+#define F2FS_IPU_DISABLE	0
+
 enum {
 	F2FS_IPU_FORCE,
 	F2FS_IPU_SSR,
@@ -679,10 +681,16 @@ enum {
 	F2FS_IPU_ASYNC,
 	F2FS_IPU_NOCACHE,
 	F2FS_IPU_HONOR_OPU_WRITE,
+	F2FS_IPU_MAX,
 };
 
+static inline bool IS_F2FS_IPU_DISABLE(struct f2fs_sb_info *sbi)
+{
+	return SM_I(sbi)->ipu_policy == F2FS_IPU_DISABLE;
+}
+
 #define F2FS_IPU_POLICY(name)					\
-static inline int IS_##name(struct f2fs_sb_info *sbi)		\
+static inline bool IS_##name(struct f2fs_sb_info *sbi)		\
 {								\
 	return SM_I(sbi)->ipu_policy & BIT(name);		\
 }
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 87d56a9883e65..53878feb69d33 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1347,12 +1347,12 @@ static int parse_options(struct super_block *sb, char *options, bool is_remount)
 	}
 
 	if (test_opt(sbi, DISABLE_CHECKPOINT) && f2fs_lfs_mode(sbi)) {
-		f2fs_err(sbi, "LFS not compatible with checkpoint=disable");
+		f2fs_err(sbi, "LFS is not compatible with checkpoint=disable");
 		return -EINVAL;
 	}
 
 	if (test_opt(sbi, ATGC) && f2fs_lfs_mode(sbi)) {
-		f2fs_err(sbi, "LFS not compatible with ATGC");
+		f2fs_err(sbi, "LFS is not compatible with ATGC");
 		return -EINVAL;
 	}
 
@@ -2306,6 +2306,12 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
 		}
 	}
 #endif
+	if (f2fs_lfs_mode(sbi) && !IS_F2FS_IPU_DISABLE(sbi)) {
+		err = -EINVAL;
+		f2fs_warn(sbi, "LFS is not compatible with IPU");
+		goto restore_opts;
+	}
+
 	/* disallow enable atgc dynamically */
 	if (no_atgc == !!test_opt(sbi, ATGC)) {
 		err = -EINVAL;
@@ -4089,8 +4095,9 @@ static void f2fs_tuning_parameters(struct f2fs_sb_info *sbi)
 		if (f2fs_block_unit_discard(sbi))
 			SM_I(sbi)->dcc_info->discard_granularity =
 						MIN_DISCARD_GRANULARITY;
-		SM_I(sbi)->ipu_policy = BIT(F2FS_IPU_FORCE) |
-					BIT(F2FS_IPU_HONOR_OPU_WRITE);
+		if (!f2fs_lfs_mode(sbi))
+			SM_I(sbi)->ipu_policy = BIT(F2FS_IPU_FORCE) |
+						BIT(F2FS_IPU_HONOR_OPU_WRITE);
 	}
 
 	sbi->readdir_ra = true;
diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index 83a366f3ee80e..088b816127ecb 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -686,6 +686,15 @@ static ssize_t __sbi_store(struct f2fs_attr *a,
 		return count;
 	}
 
+	if (!strcmp(a->attr.name, "ipu_policy")) {
+		if (t >= BIT(F2FS_IPU_MAX))
+			return -EINVAL;
+		if (t && f2fs_lfs_mode(sbi))
+			return -EINVAL;
+		SM_I(sbi)->ipu_policy = (unsigned int)t;
+		return count;
+	}
+
 	*ui = (unsigned int)t;
 
 	return count;
-- 
2.39.2



