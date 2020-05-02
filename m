Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03AD1C2370
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 08:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgEBGAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 May 2020 02:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726468AbgEBGAT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 2 May 2020 02:00:19 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 174842137B;
        Sat,  2 May 2020 06:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588399219;
        bh=2TZcArf1YUgKkcv3Pow2cc7A9wlRsm3LVNfkjMQvDIU=;
        h=From:To:Cc:Subject:Date:From;
        b=bpBNP+z008ubNPNLGe/0RCLG7aa5tXFBEaeDeae+BOeIyPxQXhlYoOExsrpJrAMdj
         8gLIYcsEn7tdNql0i07dnM5qJPf3DjDoG0pxAP/zOhW/Ank0Oaeydi0qZ0eoQXXN5H
         9j7lW3scMPF/mW9KsDJ93WP+zRzOCEAJc6N1j0v8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     Richard Weinberger <richard@nod.at>, linux-mtd@lists.infradead.org
Cc:     linux-crypto@vger.kernel.org, stable@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH] ubifs: fix wrong use of crypto_shash_descsize()
Date:   Fri,  1 May 2020 22:59:45 -0700
Message-Id: <20200502055945.1008194-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

crypto_shash_descsize() returns the size of the shash_desc context
needed to compute the hash, not the size of the hash itself.

crypto_shash_digestsize() would be correct, or alternatively using
c->hash_len and c->hmac_desc_len which already store the correct values.
But actually it's simpler to just use stack arrays, so do that instead.

Fixes: 49525e5eecca ("ubifs: Add helper functions for authentication support")
Fixes: da8ef65f9573 ("ubifs: Authenticate replayed journal")
Cc: <stable@vger.kernel.org> # v4.20+
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ubifs/auth.c   | 17 ++++-------------
 fs/ubifs/replay.c | 13 ++-----------
 2 files changed, 6 insertions(+), 24 deletions(-)

diff --git a/fs/ubifs/auth.c b/fs/ubifs/auth.c
index 8cdbd53d780ca7..f985a3fbbb36a1 100644
--- a/fs/ubifs/auth.c
+++ b/fs/ubifs/auth.c
@@ -79,13 +79,9 @@ int ubifs_prepare_auth_node(struct ubifs_info *c, void *node,
 			     struct shash_desc *inhash)
 {
 	struct ubifs_auth_node *auth = node;
-	u8 *hash;
+	u8 hash[UBIFS_HASH_ARR_SZ];
 	int err;
 
-	hash = kmalloc(crypto_shash_descsize(c->hash_tfm), GFP_NOFS);
-	if (!hash)
-		return -ENOMEM;
-
 	{
 		SHASH_DESC_ON_STACK(hash_desc, c->hash_tfm);
 
@@ -94,21 +90,16 @@ int ubifs_prepare_auth_node(struct ubifs_info *c, void *node,
 
 		err = crypto_shash_final(hash_desc, hash);
 		if (err)
-			goto out;
+			return err;
 	}
 
 	err = ubifs_hash_calc_hmac(c, hash, auth->hmac);
 	if (err)
-		goto out;
+		return err;
 
 	auth->ch.node_type = UBIFS_AUTH_NODE;
 	ubifs_prepare_node(c, auth, ubifs_auth_node_sz(c), 0);
-
-	err = 0;
-out:
-	kfree(hash);
-
-	return err;
+	return 0;
 }
 
 static struct shash_desc *ubifs_get_desc(const struct ubifs_info *c,
diff --git a/fs/ubifs/replay.c b/fs/ubifs/replay.c
index b28ac4dfb4070a..01fcf79750472b 100644
--- a/fs/ubifs/replay.c
+++ b/fs/ubifs/replay.c
@@ -601,18 +601,12 @@ static int authenticate_sleb(struct ubifs_info *c, struct ubifs_scan_leb *sleb,
 	struct ubifs_scan_node *snod;
 	int n_nodes = 0;
 	int err;
-	u8 *hash, *hmac;
+	u8 hash[UBIFS_HASH_ARR_SZ];
+	u8 hmac[UBIFS_HMAC_ARR_SZ];
 
 	if (!ubifs_authenticated(c))
 		return sleb->nodes_cnt;
 
-	hash = kmalloc(crypto_shash_descsize(c->hash_tfm), GFP_NOFS);
-	hmac = kmalloc(c->hmac_desc_len, GFP_NOFS);
-	if (!hash || !hmac) {
-		err = -ENOMEM;
-		goto out;
-	}
-
 	list_for_each_entry(snod, &sleb->nodes, list) {
 
 		n_nodes++;
@@ -662,9 +656,6 @@ static int authenticate_sleb(struct ubifs_info *c, struct ubifs_scan_leb *sleb,
 		err = 0;
 	}
 out:
-	kfree(hash);
-	kfree(hmac);
-
 	return err ? err : n_nodes - n_not_auth;
 }
 
-- 
2.26.2

