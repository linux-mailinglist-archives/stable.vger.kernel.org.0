Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176B83EE116
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 02:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235635AbhHQAgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 20:36:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236051AbhHQAgY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 20:36:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBEAE60FC3;
        Tue, 17 Aug 2021 00:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629160552;
        bh=EG8oCqNCpJ9I9kaz9k9fICEPwDby1FZHFnk/nQTYB7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+93b0oiiBM0fR+YzyLZ/gUQO7NS9jgUK98b8w2nuHnhe9GYcWbY66B27/4iAtqoN
         O9kxXTly0Uf7Cs1AMG7w4lKAM8VBcS0xNJ+PpSKMIoaSFNsm+iVFYyNIDyeHefCxsG
         F6Nfi39so0gt/G7lRIR4huzLaoK1kentHP5v/LbMArSPgX5z0p34CJcTZ3X1wcptWh
         5OpavjCAmnPOWkSzgxrkKtMYKy4ZutuBokqhsNMqIT73VTtHcq6I2X2cqrcXgm5E++
         BFWAhpupwYt58lAJlLlUP8WdPbDzR+E5v/5+iUwqToIWqo3oymTjd3Gz1IUGX8SGHL
         ySBeAuT9lppoA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Sasha Levin <sashal@kernel.org>, linux-unionfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 11/12] ovl: fix uninitialized pointer read in ovl_lookup_real_one()
Date:   Mon, 16 Aug 2021 20:35:35 -0400
Message-Id: <20210817003536.83063-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817003536.83063-1-sashal@kernel.org>
References: <20210817003536.83063-1-sashal@kernel.org>
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
index 41ebf52f1bbc..ebde05c9cf62 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -392,6 +392,7 @@ static struct dentry *ovl_lookup_real_one(struct dentry *connected,
 	 */
 	take_dentry_name_snapshot(&name, real);
 	this = lookup_one_len(name.name.name, connected, name.name.len);
+	release_dentry_name_snapshot(&name);
 	err = PTR_ERR(this);
 	if (IS_ERR(this)) {
 		goto fail;
@@ -406,7 +407,6 @@ static struct dentry *ovl_lookup_real_one(struct dentry *connected,
 	}
 
 out:
-	release_dentry_name_snapshot(&name);
 	dput(parent);
 	inode_unlock(dir);
 	return this;
-- 
2.30.2

