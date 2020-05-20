Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47E01DB6F8
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgETO2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:28:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60958 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726826AbgETOWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:22 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbu-00035O-Vf; Wed, 20 May 2020 15:22:19 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbu-007DPH-AB; Wed, 20 May 2020 15:22:18 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Wed, 20 May 2020 15:13:46 +0100
Message-ID: <lsq.1589984008.725547610@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 18/99] crypto: api - Fix race condition in
 crypto_spawn_alg
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 73669cc556462f4e50376538d77ee312142e8a8a upstream.

The function crypto_spawn_alg is racy because it drops the lock
before shooting the dying algorithm.  The algorithm could disappear
altogether before we shoot it.

This patch fixes it by moving the shooting into the locked section.

Fixes: 6bfd48096ff8 ("[CRYPTO] api: Added spawns")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 crypto/algapi.c   | 16 +++++-----------
 crypto/api.c      |  3 +--
 crypto/internal.h |  1 -
 3 files changed, 6 insertions(+), 14 deletions(-)

--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -628,22 +628,16 @@ EXPORT_SYMBOL_GPL(crypto_drop_spawn);
 static struct crypto_alg *crypto_spawn_alg(struct crypto_spawn *spawn)
 {
 	struct crypto_alg *alg;
-	struct crypto_alg *alg2;
 
 	down_read(&crypto_alg_sem);
 	alg = spawn->alg;
-	alg2 = alg;
-	if (alg2)
-		alg2 = crypto_mod_get(alg2);
-	up_read(&crypto_alg_sem);
-
-	if (!alg2) {
-		if (alg)
-			crypto_shoot_alg(alg);
-		return ERR_PTR(-EAGAIN);
+	if (alg && !crypto_mod_get(alg)) {
+		alg->cra_flags |= CRYPTO_ALG_DYING;
+		alg = NULL;
 	}
+	up_read(&crypto_alg_sem);
 
-	return alg;
+	return alg ?: ERR_PTR(-EAGAIN);
 }
 
 struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn, u32 type,
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -345,13 +345,12 @@ static unsigned int crypto_ctxsize(struc
 	return len;
 }
 
-void crypto_shoot_alg(struct crypto_alg *alg)
+static void crypto_shoot_alg(struct crypto_alg *alg)
 {
 	down_write(&crypto_alg_sem);
 	alg->cra_flags |= CRYPTO_ALG_DYING;
 	up_write(&crypto_alg_sem);
 }
-EXPORT_SYMBOL_GPL(crypto_shoot_alg);
 
 struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 				      u32 mask)
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -88,7 +88,6 @@ void crypto_alg_tested(const char *name,
 void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 			  struct crypto_alg *nalg);
 void crypto_remove_final(struct list_head *list);
-void crypto_shoot_alg(struct crypto_alg *alg);
 struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 				      u32 mask);
 void *crypto_create_tfm(struct crypto_alg *alg,

