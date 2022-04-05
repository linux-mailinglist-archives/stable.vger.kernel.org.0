Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 705344F27C9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbiDEIJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233723AbiDEH51 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:57:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763F0506CC;
        Tue,  5 Apr 2022 00:51:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A71861728;
        Tue,  5 Apr 2022 07:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE2AC34111;
        Tue,  5 Apr 2022 07:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145083;
        bh=k107eXAopS3cg/qO3bNvEgkCP2VIeERH0+D1JEhJDRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xnsH4tVNNbdzSIB4YsVs8X/RVUQ+FxqknEF4RwiKAb+F8td5uB0Q61DjBGhVEj6k7
         x3nSgGGMxW0FyMVXBOGc8Vy6BKs7b6qjjK+PHvVmY7lqbRRbsO+DAeiYOu7G7WY7bH
         XddtL30wOLRsOqFr/G55FooUqnm/8JDN5669Yf/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        Ye Bin <yebin10@huawei.com>, Eric Sandeen <sandeen@redhat.com>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0278/1126] ext4: fix remount with abort option
Date:   Tue,  5 Apr 2022 09:17:05 +0200
Message-Id: <20220405070415.770327618@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Lukas Czerner <lczerner@redhat.com>

[ Upstream commit e3952fcce1aad934f1322843b564ff86256444b2 ]

After commit 6e47a3cc68fc ("ext4: get rid of super block and sbi from
handle_mount_ops()") the 'abort' options stopped working. This is
because we're using ctx_set_mount_flags() helper that's expecting an
argument with the appropriate bit set, but instead got
EXT4_MF_FS_ABORTED which is a bit position. ext4_set_mount_flag() is
using set_bit() while ctx_set_mount_flags() was using bitwise OR.

Create a separate helper ctx_set_mount_flag() to handle setting the
mount_flags correctly.

While we're at it clean up the EXT4_SET_CTX macros so that we're only
creating helpers that we actually use to avoid warnings.

Fixes: 6e47a3cc68fc ("ext4: get rid of super block and sbi from handle_mount_ops()")
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Cc: Ye Bin <yebin10@huawei.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Tested-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Link: https://lore.kernel.org/r/20220201131345.77591-1-lczerner@redhat.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index cd0547fabd79..bed29f96ccc7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2045,8 +2045,8 @@ struct ext4_fs_context {
 	unsigned int	mask_s_mount_opt;
 	unsigned int	vals_s_mount_opt2;
 	unsigned int	mask_s_mount_opt2;
-	unsigned int	vals_s_mount_flags;
-	unsigned int	mask_s_mount_flags;
+	unsigned long	vals_s_mount_flags;
+	unsigned long	mask_s_mount_flags;
 	unsigned int	opt_flags;	/* MOPT flags */
 	unsigned int	spec;
 	u32		s_max_batch_time;
@@ -2149,23 +2149,36 @@ static inline void ctx_set_##name(struct ext4_fs_context *ctx,		\
 {									\
 	ctx->mask_s_##name |= flag;					\
 	ctx->vals_s_##name |= flag;					\
-}									\
+}
+
+#define EXT4_CLEAR_CTX(name)						\
 static inline void ctx_clear_##name(struct ext4_fs_context *ctx,	\
 				    unsigned long flag)			\
 {									\
 	ctx->mask_s_##name |= flag;					\
 	ctx->vals_s_##name &= ~flag;					\
-}									\
+}
+
+#define EXT4_TEST_CTX(name)						\
 static inline unsigned long						\
 ctx_test_##name(struct ext4_fs_context *ctx, unsigned long flag)	\
 {									\
 	return (ctx->vals_s_##name & flag);				\
-}									\
+}
 
-EXT4_SET_CTX(flags);
+EXT4_SET_CTX(flags); /* set only */
 EXT4_SET_CTX(mount_opt);
+EXT4_CLEAR_CTX(mount_opt);
+EXT4_TEST_CTX(mount_opt);
 EXT4_SET_CTX(mount_opt2);
-EXT4_SET_CTX(mount_flags);
+EXT4_CLEAR_CTX(mount_opt2);
+EXT4_TEST_CTX(mount_opt2);
+
+static inline void ctx_set_mount_flag(struct ext4_fs_context *ctx, int bit)
+{
+	set_bit(bit, &ctx->mask_s_mount_flags);
+	set_bit(bit, &ctx->vals_s_mount_flags);
+}
 
 static int ext4_parse_param(struct fs_context *fc, struct fs_parameter *param)
 {
@@ -2235,7 +2248,7 @@ static int ext4_parse_param(struct fs_context *fc, struct fs_parameter *param)
 			 param->key);
 		return 0;
 	case Opt_abort:
-		ctx_set_mount_flags(ctx, EXT4_MF_FS_ABORTED);
+		ctx_set_mount_flag(ctx, EXT4_MF_FS_ABORTED);
 		return 0;
 	case Opt_i_version:
 		ext4_msg(NULL, KERN_WARNING, deprecated_msg, param->key, "5.20");
-- 
2.34.1



