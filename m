Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F7A1D3C9A
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbgENTIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 15:08:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728582AbgENSxG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:53:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18F8D20675;
        Thu, 14 May 2020 18:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482385;
        bh=soRgXhcKTdcEJSOkgZmtOz+brcKNV0jmvZTIADF0urs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gMMValtfXCyWBRIVollkbTowh5uE6pHj6OFcRvnC0m4EQqUOfEKhTGwje7v2HbNa9
         HjGucjpgs9l6anLmX+GrXh+I3Bv5qjS03NLDj9LBxcPATJ77uWIsuq7sRp/SWEpZCr
         9cT0Cs0r4AP9TaongtKPgk7gEX14fP9Aj8VrKvxI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 62/62] gcc-10: avoid shadowing standard library 'free()' in crypto
Date:   Thu, 14 May 2020 14:51:47 -0400
Message-Id: <20200514185147.19716-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185147.19716-1-sashal@kernel.org>
References: <20200514185147.19716-1-sashal@kernel.org>
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
index 376d7ed3f1f87..3c734b81b3a20 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -287,7 +287,7 @@ static void exit_tfm(struct crypto_skcipher *tfm)
 	crypto_free_skcipher(ctx->child);
 }
 
-static void free(struct skcipher_instance *inst)
+static void free_inst(struct skcipher_instance *inst)
 {
 	crypto_drop_skcipher(skcipher_instance_ctx(inst));
 	kfree(inst);
@@ -400,12 +400,12 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
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
index dbdd8af629e69..6d8cea94b3cfb 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -322,7 +322,7 @@ static void exit_tfm(struct crypto_skcipher *tfm)
 	crypto_free_cipher(ctx->tweak);
 }
 
-static void free(struct skcipher_instance *inst)
+static void free_inst(struct skcipher_instance *inst)
 {
 	crypto_drop_skcipher(skcipher_instance_ctx(inst));
 	kfree(inst);
@@ -434,12 +434,12 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
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

