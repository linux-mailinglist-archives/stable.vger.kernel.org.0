Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542151AA1C6
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370244AbgDOMrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:47:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408968AbgDOLnK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:43:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC9F2206A2;
        Wed, 15 Apr 2020 11:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950990;
        bh=UxleMb+N/xS2Xz2EYS7sPTQkefnAxZdwm7h31dVQk+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IJFMcPCpRS0yEEng5MKgymN1MptgiDUBd4PRzgZE7dcTvJ/xR20AdnoJikbTgaqhW
         wGtI3qQowo3nEJpMFW8m6+1Y4amHDiCwFIl+ILff7LKUuKA5QiysSR25pM932HFHen
         UC4qO2fcubOmiQxYKZXTEKS9f1u7Lq1imaPNDGNo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sahitya Tummala <stummala@codeaurora.org>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.5 037/106] f2fs: Fix mount failure due to SPO after a successful online resize FS
Date:   Wed, 15 Apr 2020 07:41:17 -0400
Message-Id: <20200415114226.13103-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114226.13103-1-sashal@kernel.org>
References: <20200415114226.13103-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sahitya Tummala <stummala@codeaurora.org>

[ Upstream commit 682756827501dc52593bf490f2d437c65ec9efcb ]

Even though online resize is successfully done, a SPO immediately
after resize, still causes below error in the next mount.

[   11.294650] F2FS-fs (sda8): Wrong user_block_count: 2233856
[   11.300272] F2FS-fs (sda8): Failed to get valid F2FS checkpoint

This is because after FS metadata is updated in update_fs_metadata()
if the SBI_IS_DIRTY is not dirty, then CP will not be done to reflect
the new user_block_count.

Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index d6705ded0141a..47d4c343cec6d 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1577,11 +1577,17 @@ int f2fs_resize_fs(struct f2fs_sb_info *sbi, __u64 block_count)
 		goto out;
 	}
 
+	mutex_lock(&sbi->cp_mutex);
 	update_fs_metadata(sbi, -secs);
 	clear_sbi_flag(sbi, SBI_IS_RESIZEFS);
+	set_sbi_flag(sbi, SBI_IS_DIRTY);
+	mutex_unlock(&sbi->cp_mutex);
+
 	err = f2fs_sync_fs(sbi->sb, 1);
 	if (err) {
+		mutex_lock(&sbi->cp_mutex);
 		update_fs_metadata(sbi, secs);
+		mutex_unlock(&sbi->cp_mutex);
 		update_sb_metadata(sbi, secs);
 		f2fs_commit_super(sbi, false);
 	}
-- 
2.20.1

