Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7B81D3BCA
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbgENSyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 14:54:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728967AbgENSyL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:54:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E25C206DC;
        Thu, 14 May 2020 18:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482450;
        bh=6LSTh6Jz142Cw16FwoeYYoL+hbnrbkU/L7NgiAS1tzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VtkWud7DSt/9+DJeroDRsITkNd/BqPJXnd+dhJDYAmeivdbde/LeVoIeSqAwtoH3y
         Izt5n9ZuS4njtTgTDC8tBWMbln48HUvDl4QBDjTbuDR7c5ZF95TkZUFzyw7ZQfSYH1
         yIf3p18LetGv+2LT2N+2BJZVeWZ3iPDgMt/HPn3Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 49/49] gcc-10: avoid shadowing standard library 'free()' in crypto
Date:   Thu, 14 May 2020 14:53:10 -0400
Message-Id: <20200514185311.20294-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185311.20294-1-sashal@kernel.org>
References: <20200514185311.20294-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 1a263ae60b04de959d9ce9caea4889385eefcc7b ]

gcc-10 has started warning about conflicting types for a few new
built-in functions, particularly 'free()'.

This results in warnings like:

   crypto/xts.c:325:13: warning: conflicting types for built-in function ‘free’; expected ‘void(void *)’ [-Wbuiltin-declaration-mismatch]

because the crypto layer had its local freeing functions called
'free()'.

Gcc-10 is in the wrong here, since that function is marked 'static', and
thus there is no chance of confusion with any standard library function
namespace.

But the simplest thing to do is to just use a different name here, and
avoid this gcc mis-feature.

[ Side note: gcc knowing about 'free()' is in itself not the
  mis-feature: the semantics of 'free()' are special enough that a
  compiler can validly do special things when seeing it.

  So the mis-feature here is that gcc thinks that 'free()' is some
  restricted name, and you can't shadow it as a local static function.

  Making the special 'free()' semantics be a function attribute rather
  than tied to the name would be the much better model ]

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/lrw.c | 6 +++---
 crypto/xts.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index fda9414890865..1a47ff9dc5ea1 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -289,7 +289,7 @@ static void exit_tfm(struct crypto_skcipher *tfm)
 	crypto_free_skcipher(ctx->child);
 }
 
-static void free(struct skcipher_instance *inst)
+static void free_inst(struct skcipher_instance *inst)
 {
 	crypto_drop_skcipher(skcipher_instance_ctx(inst));
 	kfree(inst);
@@ -401,12 +401,12 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.encrypt = encrypt;
 	inst->alg.decrypt = decrypt;
 
-	inst->free = free;
+	inst->free = free_inst;
 
 	err = skcipher_register_instance(tmpl, inst);
 	if (err) {
 err_free_inst:
-		free(inst);
+		free_inst(inst);
 	}
 	return err;
 }
diff --git a/crypto/xts.c b/crypto/xts.c
index 73c648c373595..eead546d3124d 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -328,7 +328,7 @@ static void exit_tfm(struct crypto_skcipher *tfm)
 	crypto_free_cipher(ctx->tweak);
 }
 
-static void free(struct skcipher_instance *inst)
+static void free_inst(struct skcipher_instance *inst)
 {
 	crypto_drop_skcipher(skcipher_instance_ctx(inst));
 	kfree(inst);
@@ -439,12 +439,12 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.encrypt = encrypt;
 	inst->alg.decrypt = decrypt;
 
-	inst->free = free;
+	inst->free = free_inst;
 
 	err = skcipher_register_instance(tmpl, inst);
 	if (err) {
 err_free_inst:
-		free(inst);
+		free_inst(inst);
 	}
 	return err;
 }
-- 
2.20.1

