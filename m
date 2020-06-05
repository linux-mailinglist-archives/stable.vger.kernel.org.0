Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D355B1EFB06
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbgFEORm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:17:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728513AbgFEORk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:17:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ED39208A9;
        Fri,  5 Jun 2020 14:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366660;
        bh=soooZv++TuidiX10DgFCAXqHp7cSQXQK3XNQuUOTahw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/REGVQQ4+oomSmAUwvshye6LNTou26LW9Xk3lUvIFbPDuT+dJ9YeJhBDvfrjZnEq
         5PxSUEHzW7yalMn3Ss8NNJsu70gC2fDL61r7huxoow+7j1Bf9xpD0ICOOANCEreiB2
         agBjv6MJanK9VC9e4vDQrL7CZ5LWV3/b8RPnH8iM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+fc0674cde00b66844470@syzkaller.appspotmail.com,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.6 37/43] crypto: api - Fix use-after-free and race in crypto_spawn_alg
Date:   Fri,  5 Jun 2020 16:15:07 +0200
Message-Id: <20200605140154.465450526@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140152.493743366@linuxfoundation.org>
References: <20200605140152.493743366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 6603523bf5e432c7c8490fb500793bb15d4e5f61 upstream.

There are two problems in crypto_spawn_alg.  First of all it may
return spawn->alg even if spawn->dead is set.  This results in a
double-free as detected by syzbot.

Secondly the setting of the DYING flag is racy because we hold
the read-lock instead of the write-lock.  We should instead call
crypto_shoot_alg in a safe manner by gaining a refcount, dropping
the lock, and then releasing the refcount.

This patch fixes both problems.

Reported-by: syzbot+fc0674cde00b66844470@syzkaller.appspotmail.com
Fixes: 4f87ee118d16 ("crypto: api - Do not zap spawn->alg")
Fixes: 73669cc55646 ("crypto: api - Fix race condition in...")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/algapi.c   |   22 ++++++++++++++++------
 crypto/api.c      |    3 ++-
 crypto/internal.h |    1 +
 3 files changed, 19 insertions(+), 7 deletions(-)

--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -716,17 +716,27 @@ EXPORT_SYMBOL_GPL(crypto_drop_spawn);
 
 static struct crypto_alg *crypto_spawn_alg(struct crypto_spawn *spawn)
 {
-	struct crypto_alg *alg;
+	struct crypto_alg *alg = ERR_PTR(-EAGAIN);
+	struct crypto_alg *target;
+	bool shoot = false;
 
 	down_read(&crypto_alg_sem);
-	alg = spawn->alg;
-	if (!spawn->dead && !crypto_mod_get(alg)) {
-		alg->cra_flags |= CRYPTO_ALG_DYING;
-		alg = NULL;
+	if (!spawn->dead) {
+		alg = spawn->alg;
+		if (!crypto_mod_get(alg)) {
+			target = crypto_alg_get(alg);
+			shoot = true;
+			alg = ERR_PTR(-EAGAIN);
+		}
 	}
 	up_read(&crypto_alg_sem);
 
-	return alg ?: ERR_PTR(-EAGAIN);
+	if (shoot) {
+		crypto_shoot_alg(target);
+		crypto_alg_put(target);
+	}
+
+	return alg;
 }
 
 struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn, u32 type,
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -333,12 +333,13 @@ static unsigned int crypto_ctxsize(struc
 	return len;
 }
 
-static void crypto_shoot_alg(struct crypto_alg *alg)
+void crypto_shoot_alg(struct crypto_alg *alg)
 {
 	down_write(&crypto_alg_sem);
 	alg->cra_flags |= CRYPTO_ALG_DYING;
 	up_write(&crypto_alg_sem);
 }
+EXPORT_SYMBOL_GPL(crypto_shoot_alg);
 
 struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 				      u32 mask)
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -65,6 +65,7 @@ void crypto_alg_tested(const char *name,
 void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 			  struct crypto_alg *nalg);
 void crypto_remove_final(struct list_head *list);
+void crypto_shoot_alg(struct crypto_alg *alg);
 struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 				      u32 mask);
 void *crypto_create_tfm(struct crypto_alg *alg,


