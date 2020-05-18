Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A481D809E
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729176AbgERRkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:40:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729164AbgERRku (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:40:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 962B720657;
        Mon, 18 May 2020 17:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823650;
        bh=ybPCDmouDFF/PZ/wxtR3Cd0tZ9peoJhFptvo+Rz9Omw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jdXCPq2U6UTkj7vHohCZqNgLDP/I43KAj+XOK0m901tSen4uN+E1a7TRId4u68IWH
         8SRUDlT5dgpunbnr53a1xNVF2HB2KkYPkzbol2Ojx/m4x6k1gdgL+43ynwQmmS8Xn5
         h1W5Kr93kDqxXmjYOcOolywn2F2WtzNMIewUiUmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 68/86] gcc-10: avoid shadowing standard library free() in crypto
Date:   Mon, 18 May 2020 19:36:39 +0200
Message-Id: <20200518173504.126873286@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
References: <20200518173450.254571947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 crypto/lrw.c |    4 ++--
 crypto/xts.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -377,7 +377,7 @@ out_put_alg:
 	return inst;
 }
 
-static void free(struct crypto_instance *inst)
+static void free_inst(struct crypto_instance *inst)
 {
 	crypto_drop_spawn(crypto_instance_ctx(inst));
 	kfree(inst);
@@ -386,7 +386,7 @@ static void free(struct crypto_instance
 static struct crypto_template crypto_tmpl = {
 	.name = "lrw",
 	.alloc = alloc,
-	.free = free,
+	.free = free_inst,
 	.module = THIS_MODULE,
 };
 
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -334,7 +334,7 @@ out_put_alg:
 	return inst;
 }
 
-static void free(struct crypto_instance *inst)
+static void free_inst(struct crypto_instance *inst)
 {
 	crypto_drop_spawn(crypto_instance_ctx(inst));
 	kfree(inst);
@@ -343,7 +343,7 @@ static void free(struct crypto_instance
 static struct crypto_template crypto_tmpl = {
 	.name = "xts",
 	.alloc = alloc,
-	.free = free,
+	.free = free_inst,
 	.module = THIS_MODULE,
 };
 


