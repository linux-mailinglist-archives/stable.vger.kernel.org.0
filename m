Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155EB1AA07F
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369312AbgDOM2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:28:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409143AbgDOLpM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:45:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 273F120768;
        Wed, 15 Apr 2020 11:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951111;
        bh=ONrlaUTrJlt3oF5jm/4hpTz5zdiFdn6NHQ66OXct7fU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QQ6pDduxel7LrRANEP7kl3Yb4nkUnSzztJ8QZuLSBwKoANbLIEEk+01l962HLsvKb
         FxAPGGjMseMksUYZgWyS/WfP+AqfMGi7I+0co6asPRpd6OQWR/d6kKgzDSTV4Dk7Tl
         hJoo42+WmyNNIR7jLKyz/2XjQDE64VNJ/by2NrbE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sahitya Tummala <stummala@codeaurora.org>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.4 26/84] f2fs: Add a new CP flag to help fsck fix resize SPO issues
Date:   Wed, 15 Apr 2020 07:43:43 -0400
Message-Id: <20200415114442.14166-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114442.14166-1-sashal@kernel.org>
References: <20200415114442.14166-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sahitya Tummala <stummala@codeaurora.org>

[ Upstream commit c84ef3c5e65ccf99a7a91a4d731ebb5d6331a178 ]

Add and set a new CP flag CP_RESIZEFS_FLAG during
online resize FS to help fsck fix the metadata mismatch
that may happen due to SPO during resize, where SB
got updated but CP data couldn't be written yet.

fsck errors -
Info: CKPT version = 6ed7bccb
        Wrong user_block_count(2233856)
[f2fs_do_mount:3365] Checkpoint is polluted

Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c    | 8 ++++++--
 include/linux/f2fs_fs.h | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 410f5c2c6ef17..a28ffecc0f95a 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -1301,10 +1301,14 @@ static void update_ckpt_flags(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 	else
 		__clear_ckpt_flags(ckpt, CP_ORPHAN_PRESENT_FLAG);
 
-	if (is_sbi_flag_set(sbi, SBI_NEED_FSCK) ||
-		is_sbi_flag_set(sbi, SBI_IS_RESIZEFS))
+	if (is_sbi_flag_set(sbi, SBI_NEED_FSCK))
 		__set_ckpt_flags(ckpt, CP_FSCK_FLAG);
 
+	if (is_sbi_flag_set(sbi, SBI_IS_RESIZEFS))
+		__set_ckpt_flags(ckpt, CP_RESIZEFS_FLAG);
+	else
+		__clear_ckpt_flags(ckpt, CP_RESIZEFS_FLAG);
+
 	if (is_sbi_flag_set(sbi, SBI_CP_DISABLED))
 		__set_ckpt_flags(ckpt, CP_DISABLED_FLAG);
 	else
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index 2847389960281..6bb6f718a1023 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -124,6 +124,7 @@ struct f2fs_super_block {
 /*
  * For checkpoint
  */
+#define CP_RESIZEFS_FLAG		0x00004000
 #define CP_DISABLED_QUICK_FLAG		0x00002000
 #define CP_DISABLED_FLAG		0x00001000
 #define CP_QUOTA_NEED_FSCK_FLAG		0x00000800
-- 
2.20.1

