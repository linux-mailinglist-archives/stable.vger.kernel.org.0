Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7DC3FDAC1
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343960AbhIAMew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:34:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244994AbhIAMdh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:33:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CB51610F7;
        Wed,  1 Sep 2021 12:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499524;
        bh=PzJh8m5YlA4RKogp/AH540axtYUK9XSISkigre4dzaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G8nNrA/uKSG26VTe+sBvqIaNx2Imt1bTN/xi0AjKoUwPxE9E2mMm7DXesbZu/G/JA
         5T8vy3MD31GqkgzNCMzNtxK7woGDlluffns9I/ChRgyzWbCd9QGRndeuIhYWFcXgLY
         0xDoC13skDzRmnrQB2SdeBZF19wM/Qvenmjv3CdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 05/48] ovl: fix uninitialized pointer read in ovl_lookup_real_one()
Date:   Wed,  1 Sep 2021 14:27:55 +0200
Message-Id: <20210901122253.570920785@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122253.388326997@linuxfoundation.org>
References: <20210901122253.388326997@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



