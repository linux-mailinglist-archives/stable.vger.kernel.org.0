Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C28D1078C0
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 20:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfKVTxK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 14:53:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:49640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727510AbfKVTtj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 14:49:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48CBE2077B;
        Fri, 22 Nov 2019 19:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574452178;
        bh=+NyR+5ZkSauhPyZqxIyCrMeEajUoSH5Z90ILzUX3lfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OCqCRPGXF6gxcVxBvmIeCYOr0aARLpzmXboRf5Imkkt3F+52I8NyRChs1f+DtvELW
         VeThAT1gEE1GlYU3oVnkdpSMOlFW6AiD0MvHkyZ/lVzDxTFlhcn/TxHqSrnxkVDlsW
         GVOgQZEvySxn3JuImfcbbqEDvexWJ5CHBy5Pqi1A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Sasha Levin <sashal@kernel.org>,
        linux-audit@redhat.com
Subject: [PATCH AUTOSEL 4.14 06/21] audit_get_nd(): don't unlock parent too early
Date:   Fri, 22 Nov 2019 14:49:16 -0500
Message-Id: <20191122194931.24732-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122194931.24732-1-sashal@kernel.org>
References: <20191122194931.24732-1-sashal@kernel.org>
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
index 4a98f6e314a9b..35f1d706bd5b4 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -365,12 +365,12 @@ static int audit_get_nd(struct audit_watch *watch, struct path *parent)
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

