Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F111C1F2359
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729649AbgFHXN6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:13:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728813AbgFHXN5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:13:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AB6C21527;
        Mon,  8 Jun 2020 23:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658036;
        bh=AOqm3Fgp/+ECFDkKYPL67fC7r9lGY6j3IklwCRudwTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJ6pKdvVbrVwu8aiArkJ8OjSufGr4VyO5H+DAOhN3XZCIoZQvu5xXh7qMoa43xIzq
         chdA/Q7iUmEWHhOYNcenhFgEzkhf+9HeVqhk+sUhZehSTH60kNGf1O/IgFnkF4sV+U
         R6/52VlN9rc0bUb+4xZpO8fCAp6z1pK0XHIbsGWM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>, linux-mtd@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 086/606] ubifs: fix wrong use of crypto_shash_descsize()
Date:   Mon,  8 Jun 2020 19:03:31 -0400
Message-Id: <20200608231211.3363633-86-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 3c3c32f85b6cc05e5db78693457deff03ac0f434 ]

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
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/auth.c   | 17 ++++-------------
 fs/ubifs/replay.c | 13 ++-----------
 2 files changed, 6 insertions(+), 24 deletions(-)

diff --git a/fs/ubifs/auth.c b/fs/ubifs/auth.c
index 8cdbd53d780c..f985a3fbbb36 100644
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
index b28ac4dfb407..01fcf7975047 100644
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
2.25.1

