Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9C445E48B
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 03:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357556AbhKZCfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:35:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:47742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357642AbhKZCdV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:33:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DD0461155;
        Fri, 26 Nov 2021 02:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637893809;
        bh=7RSYnjakDGbVSQHSGL9A7juJSunyWzBmGji4TfHiWaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uYqTe0JcxS2hIH0CKu3+M6NDoQy5TntK1EBUaEyW1P5X5iwFVLzA1vbEdqxgCP/5o
         sVBwzccJTj+Wh31sWMxMTwwA3KoxPlJA9WzRCBCxm+BBSqWU67tzI+quflaNl9UJn7
         X/ypiBlMeA0GzclwhMxsR1B2YFycYn4f32XRVLJy5bB0IPz27dV5Tdk5T6RIAkyr3w
         dAN5LTisPxbXHDu2jqCyMtZBIS/9HdkTU8UvoOdI+k8VDiJKzFRbVVL250nwlJkaVe
         dTcViCu/GHzIyvXUp9BpAteM4qa2sSkTrMoBcdqiepB8mbuCThfu/j+p7+XmiI24Jt
         +nhCukbZcu6Kg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Weichao Guo <guoweichao@oppo.com>, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.15 2/7] f2fs: set SBI_NEED_FSCK flag when inconsistent node block found
Date:   Thu, 25 Nov 2021 21:30:01 -0500
Message-Id: <20211126023006.440839-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023006.440839-1-sashal@kernel.org>
References: <20211126023006.440839-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weichao Guo <guoweichao@oppo.com>

[ Upstream commit 6663b138ded1a59e630c9e605e42aa7fde490cdc ]

Inconsistent node block will cause a file fail to open or read,
which could make the user process crashes or stucks. Let's mark
SBI_NEED_FSCK flag to trigger a fix at next fsck time. After
unlinking the corrupted file, the user process could regenerate
a new one and work correctly.

Signed-off-by: Weichao Guo <guoweichao@oppo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index e863136081b47..556fcd8457f3f 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1443,6 +1443,7 @@ static struct page *__get_node_page(struct f2fs_sb_info *sbi, pgoff_t nid,
 			  nid, nid_of_node(page), ino_of_node(page),
 			  ofs_of_node(page), cpver_of_node(page),
 			  next_blkaddr_of_node(page));
+		set_sbi_flag(sbi, SBI_NEED_FSCK);
 		err = -EINVAL;
 out_err:
 		ClearPageUptodate(page);
-- 
2.33.0

