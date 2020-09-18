Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD23E26F2A0
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbgIRDA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:00:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbgIRCFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:05:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08419238A0;
        Fri, 18 Sep 2020 02:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394737;
        bh=P1Nxwkmp1ODADvpVBMOspS3S8Fm6UaImrkwa3DwaVEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xdAjwns8md8HN8OSUDMaETtqOk2/eVc9UTnTfSNMUW7/Bi3rtQdXsBP9e5KdLWP5S
         EETQhwAsk8IW/jTBvG/tHhym7UWWDStSlLBWCH/7K/6w5hhqRRXJn7NkmwDzZPRjVC
         DNKPxn0T36b+at1pSN3WtCyNVoaLRa1sc9SDaxpU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>, linux-mtd@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 218/330] ubifs: ubifs_add_orphan: Fix a memory leak bug
Date:   Thu, 17 Sep 2020 21:59:18 -0400
Message-Id: <20200918020110.2063155-218-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 927cc5cec35f01fe4f8af0ba80830a90b0533983 ]

Memory leak occurs when files with extended attributes are added to
orphan list.

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Fixes: 988bec41318f3fa897e2f8 ("ubifs: orphan: Handle xattrs like files")
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/orphan.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/orphan.c b/fs/ubifs/orphan.c
index 7dd740e3692da..283f9eb48410d 100644
--- a/fs/ubifs/orphan.c
+++ b/fs/ubifs/orphan.c
@@ -157,7 +157,7 @@ int ubifs_add_orphan(struct ubifs_info *c, ino_t inum)
 	int err = 0;
 	ino_t xattr_inum;
 	union ubifs_key key;
-	struct ubifs_dent_node *xent;
+	struct ubifs_dent_node *xent, *pxent = NULL;
 	struct fscrypt_name nm = {0};
 	struct ubifs_orphan *xattr_orphan;
 	struct ubifs_orphan *orphan;
@@ -181,11 +181,16 @@ int ubifs_add_orphan(struct ubifs_info *c, ino_t inum)
 		xattr_inum = le64_to_cpu(xent->inum);
 
 		xattr_orphan = orphan_add(c, xattr_inum, orphan);
-		if (IS_ERR(xattr_orphan))
+		if (IS_ERR(xattr_orphan)) {
+			kfree(xent);
 			return PTR_ERR(xattr_orphan);
+		}
 
+		kfree(pxent);
+		pxent = xent;
 		key_read(c, &xent->key, &key);
 	}
+	kfree(pxent);
 
 	return 0;
 }
-- 
2.25.1

