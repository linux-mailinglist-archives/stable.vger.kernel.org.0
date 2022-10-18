Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7586601EEB
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbiJRAOq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbiJRANq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:13:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7DBE89949;
        Mon, 17 Oct 2022 17:10:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6343B61329;
        Tue, 18 Oct 2022 00:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15856C43143;
        Tue, 18 Oct 2022 00:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051821;
        bh=1ZYxHUyU9NpGZtKaFDyP0j06ZoEkHo2aD97zSqyG0gU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fmojT7R+ukzv97BLMmoabXJoDXShQvOclPgBAnEZZuvQYRGj8yNtncj4tTSWzVj8c
         AFhGrfdzVhbyTZgCb3mFhCz2/65h4tbU2yhDMGBYRoBV9sNrDS3rpLnlgkt6jRFJvJ
         N2nAIiiQtw/LgUmWAzjG0I1mZIrPZcXSLZHA6Ho6xm35SCZjhXLnVgKX21cuV41w3n
         yxsVZ/K6NFMe060qr/PtsM+0k0ZgNXNBRxth/BX78GoH4QKD2TC0BunV0Z6o4nNxy8
         HslKmdg86ksTJh4JZO++heDk59Z2LjNsP8xq2MLGq1027eDZ0uovlSZy6ZUaUuJJcH
         fgOS2K8bH2pNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.15 17/21] f2fs: fix to detect corrupted meta ino
Date:   Mon, 17 Oct 2022 20:09:36 -0400
Message-Id: <20221018000940.2731329-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018000940.2731329-1-sashal@kernel.org>
References: <20221018000940.2731329-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

[ Upstream commit fcc2d8cc96b2f6141bbbe5b1e8953db990794b44 ]

It is possible that ino of dirent or orphan inode is corrupted in a
fuzzed image, occasionally, if corrupted ino is equal to meta ino:
meta_ino, node_ino or compress_ino, caller of f2fs_iget() from below
call paths will get meta inode directly, it's not allowed, let's
add sanity check to detect such cases.

case #1
- recover_dentry
 - __f2fs_find_entry
 - f2fs_iget_retry

case #2
- recover_orphan_inode
 - f2fs_iget_retry

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/inode.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index bd8960f4966b..cc91bcebd2ca 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -480,6 +480,12 @@ static int do_read_inode(struct inode *inode)
 	return 0;
 }
 
+static bool is_meta_ino(struct f2fs_sb_info *sbi, unsigned int ino)
+{
+	return ino == F2FS_NODE_INO(sbi) || ino == F2FS_META_INO(sbi) ||
+		ino == F2FS_COMPRESS_INO(sbi);
+}
+
 struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
@@ -491,16 +497,21 @@ struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
 		return ERR_PTR(-ENOMEM);
 
 	if (!(inode->i_state & I_NEW)) {
+		if (is_meta_ino(sbi, ino)) {
+			f2fs_err(sbi, "inaccessible inode: %lu, run fsck to repair", ino);
+			set_sbi_flag(sbi, SBI_NEED_FSCK);
+			ret = -EFSCORRUPTED;
+			trace_f2fs_iget_exit(inode, ret);
+			iput(inode);
+			return ERR_PTR(ret);
+		}
+
 		trace_f2fs_iget(inode);
 		return inode;
 	}
-	if (ino == F2FS_NODE_INO(sbi) || ino == F2FS_META_INO(sbi))
-		goto make_now;
 
-#ifdef CONFIG_F2FS_FS_COMPRESSION
-	if (ino == F2FS_COMPRESS_INO(sbi))
+	if (is_meta_ino(sbi, ino))
 		goto make_now;
-#endif
 
 	ret = do_read_inode(inode);
 	if (ret)
-- 
2.35.1

