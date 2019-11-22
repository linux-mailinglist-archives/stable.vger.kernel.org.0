Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48D6F1078EE
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 20:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfKVTtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 14:49:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:48120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727148AbfKVTtG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 14:49:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8AFE2084B;
        Fri, 22 Nov 2019 19:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574452146;
        bh=S/L1hLiHFY0yuqr31DMWzA3QYET4k3af1LqJ31C86GI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=066cGurtsQOdz/edQU3SY/ZXSQsjb3+tUgHyiGUj9q+gQoQnmOt2xrnL6dzh9vfQ6
         9jcbmCnv2Dpo0ftHygL5hTxK93qW79+azdC7gSmUa0htMchQD5RvarBXeOfuvbjRIM
         hYTDz/onGwB7V7w6JgoRAsbtoXM5PghHYt0fUFW0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Sasha Levin <sashal@kernel.org>,
        linux-audit@redhat.com
Subject: [PATCH AUTOSEL 4.19 06/25] audit_get_nd(): don't unlock parent too early
Date:   Fri, 22 Nov 2019 14:48:39 -0500
Message-Id: <20191122194859.24508-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122194859.24508-1-sashal@kernel.org>
References: <20191122194859.24508-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 69924b89687a2923e88cc42144aea27868913d0e ]

if the child has been negative and just went positive
under us, we want coherent d_is_positive() and ->d_inode.
Don't unlock the parent until we'd done that work...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/audit_watch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index 787c7afdf8294..4f7262eba73d8 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -366,12 +366,12 @@ static int audit_get_nd(struct audit_watch *watch, struct path *parent)
 	struct dentry *d = kern_path_locked(watch->path, parent);
 	if (IS_ERR(d))
 		return PTR_ERR(d);
-	inode_unlock(d_backing_inode(parent->dentry));
 	if (d_is_positive(d)) {
 		/* update watch filter fields */
 		watch->dev = d->d_sb->s_dev;
 		watch->ino = d_backing_inode(d)->i_ino;
 	}
+	inode_unlock(d_backing_inode(parent->dentry));
 	dput(d);
 	return 0;
 }
-- 
2.20.1

