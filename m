Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D15FA2370D
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732617AbfETMUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:20:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387969AbfETMUT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:20:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43BC120656;
        Mon, 20 May 2019 12:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354818;
        bh=SouYgWQauP5ZFkhFFMqWevfg1i6+eLajnGKQ+6SjZq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l28Rxt1otr9s43vDW6TEIqQglVMfhFD8iNEdJqtw/GwsHc3DT00CRiPn9INFX9Djy
         X1FKnBfe69IXzFHbmfKK6GUAMKG7139jPLihzvI+DPLmYsaw6NebZbXiylUqL1hLr3
         Oh5H/W2umeSNDH3pkNH8MUktRZGfhcL4oRbCWlOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Willi <martin@strongswan.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.14 17/63] crypto: chacha20poly1305 - set cra_name correctly
Date:   Mon, 20 May 2019 14:13:56 +0200
Message-Id: <20190520115232.959361482@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115231.137981521@linuxfoundation.org>
References: <20190520115231.137981521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 5e27f38f1f3f45a0c938299c3a34a2d2db77165a upstream.

If the rfc7539 template is instantiated with specific implementations,
e.g. "rfc7539(chacha20-generic,poly1305-generic)" rather than
"rfc7539(chacha20,poly1305)", then the implementation names end up
included in the instance's cra_name.  This is incorrect because it then
prevents all users from allocating "rfc7539(chacha20,poly1305)", if the
highest priority implementations of chacha20 and poly1305 were selected.
Also, the self-tests aren't run on an instance allocated in this way.

Fix it by setting the instance's cra_name from the underlying
algorithms' actual cra_names, rather than from the requested names.
This matches what other templates do.

Fixes: 71ebc4d1b27d ("crypto: chacha20poly1305 - Add a ChaCha20-Poly1305 AEAD construction, RFC7539")
Cc: <stable@vger.kernel.org> # v4.2+
Cc: Martin Willi <martin@strongswan.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Martin Willi <martin@strongswan.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/chacha20poly1305.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -647,8 +647,8 @@ static int chachapoly_create(struct cryp
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
-		     "%s(%s,%s)", name, chacha_name,
-		     poly_name) >= CRYPTO_MAX_ALG_NAME)
+		     "%s(%s,%s)", name, chacha->base.cra_name,
+		     poly->cra_name) >= CRYPTO_MAX_ALG_NAME)
 		goto out_drop_chacha;
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "%s(%s,%s)", name, chacha->base.cra_driver_name,


