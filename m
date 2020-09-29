Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FCC27C5CE
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729937AbgI2LjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:39:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730454AbgI2LjH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:39:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E4F2208FE;
        Tue, 29 Sep 2020 11:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379547;
        bh=P1Nxwkmp1ODADvpVBMOspS3S8Fm6UaImrkwa3DwaVEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QrDx4kZpChnBwl/9/H0blHcKC4L+xaB+2T61swoqfAqdSgLd7ioZY0f48UiJDgBW9
         9mjG+YfngNLFFNf6n/qMrBdjWqctzY76xk4SFHjPpulvLP9a/GdUiMJEwv4MZLFW+9
         8R2PjCfALvPOHJZ3Z7JTgyqt1PrzgdVvvEjttu1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 212/388] ubifs: ubifs_add_orphan: Fix a memory leak bug
Date:   Tue, 29 Sep 2020 12:59:03 +0200
Message-Id: <20200929110020.732181725@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



