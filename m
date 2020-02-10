Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6544F157787
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729794AbgBJMkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:40:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:41428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729414AbgBJMkp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:45 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 924DB24672;
        Mon, 10 Feb 2020 12:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338444;
        bh=8nb5Kb/aNnx3b2+BuP2kxWHE/LxEWpN7ibvn/DYhSMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dGwHW4Fby6rx1cXstj+36BYNsZo5Cc8FU3ty19jmewY+vfRC6zY9OOjoD6JIdaGpe
         rO1CaruOF3YoJEeozr2Wak+ojDdkNSACYJduN8i6IGvrR+0PAuQ39Un45wdAA1lNpp
         DqhtP6I2CcDg9X7e6awIaK+1bDkvIhNZ00W6w7h0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.5 185/367] crypto: api - Fix race condition in crypto_spawn_alg
Date:   Mon, 10 Feb 2020 04:31:38 -0800
Message-Id: <20200210122441.754434395@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 73669cc556462f4e50376538d77ee312142e8a8a upstream.

The function crypto_spawn_alg is racy because it drops the lock
before shooting the dying algorithm.  The algorithm could disappear
altogether before we shoot it.

This patch fixes it by moving the shooting into the locked section.

Fixes: 6bfd48096ff8 ("[CRYPTO] api: Added spawns")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/algapi.c   |   16 +++++-----------
 crypto/api.c      |    3 +--
 crypto/internal.h |    1 -
 3 files changed, 6 insertions(+), 14 deletions(-)

--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -697,22 +697,16 @@ EXPORT_SYMBOL_GPL(crypto_drop_spawn);
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
@@ -346,13 +346,12 @@ static unsigned int crypto_ctxsize(struc
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
@@ -68,7 +68,6 @@ void crypto_alg_tested(const char *name,
 void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 			  struct crypto_alg *nalg);
 void crypto_remove_final(struct list_head *list);
-void crypto_shoot_alg(struct crypto_alg *alg);
 struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 				      u32 mask);
 void *crypto_create_tfm(struct crypto_alg *alg,


