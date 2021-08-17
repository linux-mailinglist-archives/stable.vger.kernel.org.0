Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFAD3EE14C
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 02:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236060AbhHQAiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 20:38:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236079AbhHQAgh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 20:36:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EED3F6103A;
        Tue, 17 Aug 2021 00:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629160565;
        bh=kIexKIdcMTVkOlUwD4Q2wR1/p8oEvDAmKeJCf5AcyZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BXMH0uAS9YlgasvPJdtkH49Z5NgoJxutYtrSrt0VmAXkiJzXvkHir8605FeQzlPWg
         P8HbQ/LPsF8sAHqOBZhgwXb7qDrYZZplCSzdOtTA7knY7yYUehrrAHosub9y0rOkEd
         Y1sWUs5J+rUKsPhM9FbEqIjMKCke67tzqkahq6dIeedKdYa0r+Ss5mS8tpYG9wdUgz
         6z05wN+hiO4n/VKULw2cGqnnt9i103sNWPIWxcn2psfqOuql9UsRuibQfLL3D6A8J+
         O3ABIohpKnAUhZziFoF6sUgvh+IAGURJcJhGhzdhe+c+wTDdzNVI89vQBL5r9Ke2aL
         I0siDGXJUkxjw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Sasha Levin <sashal@kernel.org>, linux-unionfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 8/9] ovl: fix uninitialized pointer read in ovl_lookup_real_one()
Date:   Mon, 16 Aug 2021 20:35:53 -0400
Message-Id: <20210817003554.83213-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817003554.83213-1-sashal@kernel.org>
References: <20210817003554.83213-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 580c610429b3994e8db24418927747cf28443cde ]

One error path can result in release_dentry_name_snapshot() being called
before "name" was initialized by take_dentry_name_snapshot().

Fix by moving the release_dentry_name_snapshot() to immediately after the
only use.

Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/export.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index ed35be3fafc6..f469982dcb36 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -390,6 +390,7 @@ static struct dentry *ovl_lookup_real_one(struct dentry *connected,
 	 */
 	take_dentry_name_snapshot(&name, real);
 	this = lookup_one_len(name.name.name, connected, name.name.len);
+	release_dentry_name_snapshot(&name);
 	err = PTR_ERR(this);
 	if (IS_ERR(this)) {
 		goto fail;
@@ -404,7 +405,6 @@ static struct dentry *ovl_lookup_real_one(struct dentry *connected,
 	}
 
 out:
-	release_dentry_name_snapshot(&name);
 	dput(parent);
 	inode_unlock(dir);
 	return this;
-- 
2.30.2

