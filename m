Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 524951F2E7C
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731018AbgFIAmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:42:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729137AbgFHXMc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81E4A208C3;
        Mon,  8 Jun 2020 23:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657952;
        bh=0f6+8/gWP04A7gXm4h6LYSgsObNR/CCROKDlx9F8Tbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VyLJbuPf++DX0toDS2huR7jnyUpXSb52GKzTsDsUx4mvgI7DgMz8Df/SnjX9P326q
         9MbXSG0hFf5fzB0s75okBfNjWdT1ekCezOb9JSf+PtWUS1ZxVdzZofs6HEra+9PuXa
         IoJ+MoF9OHDvNAR8jifAodV6BU4BlxtoXFzLVx+o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 017/606] gcc-10: avoid shadowing standard library 'free()' in crypto
Date:   Mon,  8 Jun 2020 19:02:22 -0400
Message-Id: <20200608231211.3363633-17-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
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

commit 1a263ae60b04de959d9ce9caea4889385eefcc7b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/lrw.c | 4 ++--
 crypto/xts.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index 63c485c0d8a6..9b20fc4b2efb 100644
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
@@ -400,7 +400,7 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.encrypt = encrypt;
 	inst->alg.decrypt = decrypt;
 
-	inst->free = free;
+	inst->free = free_inst;
 
 	err = skcipher_register_instance(tmpl, inst);
 	if (err)
diff --git a/crypto/xts.c b/crypto/xts.c
index 29efa15f1495..983dae2bb2db 100644
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
@@ -434,7 +434,7 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.encrypt = encrypt;
 	inst->alg.decrypt = decrypt;
 
-	inst->free = free;
+	inst->free = free_inst;
 
 	err = skcipher_register_instance(tmpl, inst);
 	if (err)
-- 
2.25.1

