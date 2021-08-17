Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF3E3EE138
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 02:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236258AbhHQAhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 20:37:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236634AbhHQAgq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 20:36:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9A0D60FC3;
        Tue, 17 Aug 2021 00:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629160574;
        bh=PzJh8m5YlA4RKogp/AH540axtYUK9XSISkigre4dzaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G9FLQUe+BMGOd9uAg438pi2xCOUhHwA2T2tm0QR2PCe1MrjB7T973F9EF5sUwcOdr
         PUsjYy7SrS+nxJVsuOyV9nXiWh1T48bq3VygIVUp+akEdlVfqc8WXf3Smc6p9UjiXq
         ZloUWMOG8Kmen+SJ5MpZx0wck5qMsj83grDWLG/HsxNeZGqA/rTfo4MmHkkM+NQLrg
         I2Z4950btMQp8CwwSl5sSR/HK22KOD5afWCN4yjZSWzzawcVJFIs+KYBjQPREs3PxY
         WzX4fr3b5vioWwwelKDiIJm641MLGrUFXkkY/Yv7su+F/ArGDiBTOAQcv8pE5GBFZt
         6WBinIBJ+aZ7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Sasha Levin <sashal@kernel.org>, linux-unionfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 5/5] ovl: fix uninitialized pointer read in ovl_lookup_real_one()
Date:   Mon, 16 Aug 2021 20:36:07 -0400
Message-Id: <20210817003607.83340-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817003607.83340-1-sashal@kernel.org>
References: <20210817003607.83340-1-sashal@kernel.org>
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
index 11dd8177770d..19574ef17470 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -395,6 +395,7 @@ static struct dentry *ovl_lookup_real_one(struct dentry *connected,
 	 */
 	take_dentry_name_snapshot(&name, real);
 	this = lookup_one_len(name.name.name, connected, name.name.len);
+	release_dentry_name_snapshot(&name);
 	err = PTR_ERR(this);
 	if (IS_ERR(this)) {
 		goto fail;
@@ -409,7 +410,6 @@ static struct dentry *ovl_lookup_real_one(struct dentry *connected,
 	}
 
 out:
-	release_dentry_name_snapshot(&name);
 	dput(parent);
 	inode_unlock(dir);
 	return this;
-- 
2.30.2

