Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5BD821CDF
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 19:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbfEQRvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 13:51:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfEQRvp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 May 2019 13:51:45 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D1CC20815;
        Fri, 17 May 2019 17:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558115505;
        bh=ysAIbo/22ozqU8DB1szPTRAK2KFlDqa+HCqb4lufk5A=;
        h=From:To:Cc:Subject:Date:From;
        b=r/XUfiWlIhqNrq6uyoowbF0shQOsxUh0DR3VRokSFz/k+2ZVjrIs/+6yAr/mYJ5W3
         ZNR+kYD45gBoyTOkBbP4vnknYcRIxmVBOObZOAg8++06fg/qM27Gql7Q0exEw5snP3
         Yf2Umahud9bF9++A0gZUE+5uzk6fp/yVofXlOXO0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH 4.4] crypto: chacha20poly1305 - set cra_name correctly
Date:   Fri, 17 May 2019 10:50:03 -0700
Message-Id: <20190517175003.118301-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 5e27f38f1f3f45a0c938299c3a34a2d2db77165a upstream.
[Please apply to 4.4-stable.]

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
---
 crypto/chacha20poly1305.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index 0214600ba071e..6c4724222e3a0 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -637,8 +637,8 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
-		     "%s(%s,%s)", name, chacha_name,
-		     poly_name) >= CRYPTO_MAX_ALG_NAME)
+		     "%s(%s,%s)", name, chacha->cra_name,
+		     poly->cra_name) >= CRYPTO_MAX_ALG_NAME)
 		goto out_drop_chacha;
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "%s(%s,%s)", name, chacha->cra_driver_name,
-- 
2.21.0.1020.gf2820cf01a-goog

