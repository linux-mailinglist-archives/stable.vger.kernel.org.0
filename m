Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580133FDBC5
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344714AbhIAMoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:44:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344437AbhIAMmR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:42:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A0A7611ED;
        Wed,  1 Sep 2021 12:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499860;
        bh=EG8oCqNCpJ9I9kaz9k9fICEPwDby1FZHFnk/nQTYB7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rS2ZOudT9ulJd6/MswLV3dLUmjSlVaiuOLoyKU3TQn6MasrezWiLs+WMAG/kwrQVE
         5OhlAywJkFdfB6EhdMoUV0UJt9mJK7vFxs2y9ve4D+uOvwsZFCAwEYgf5wwFFpVkIn
         2q1HwTT75njjl8ySkm+bMibuJfpcXJlmQ6FqJAMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 012/113] ovl: fix uninitialized pointer read in ovl_lookup_real_one()
Date:   Wed,  1 Sep 2021 14:27:27 +0200
Message-Id: <20210901122302.391449510@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
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



