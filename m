Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A776D21D1B
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 20:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbfEQSIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 14:08:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727909AbfEQSIW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 May 2019 14:08:22 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9964321726;
        Fri, 17 May 2019 18:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558116501;
        bh=Q7nmDqeGIKrH5HcUpuIBQ7lO+ia/Yyl+Bhc6o6nht2E=;
        h=From:To:Cc:Subject:Date:From;
        b=ARwTpVl1bCkFHUb65Jt+KrjxS2nFFgaSy/eYSf0oRV5Bp/6namP0Rph2+C/Ttc8pB
         0zI+b40HmL37QikiJhfZQMB9LvrOkx9vQEaH4/e6bburrm/8zRS0oF4N83E5R7i2XG
         9hWtKo8U7YtiO9qE3xRnS1Dn/McKmZCWur5z7B4Q=
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH 4.4 1/2] crypto: gcm - Fix error return code in crypto_gcm_create_common()
Date:   Fri, 17 May 2019 11:06:09 -0700
Message-Id: <20190517180610.150453-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

commit 9b40f79c08e81234d759f188b233980d7e81df6c upstream.
[Please apply to 4.4-stable.]

Fix to return error code -EINVAL from the invalid alg ivsize error
handling case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/gcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index 0a12c09d7cb2b..f1c16589af8bb 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -670,11 +670,11 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 	ctr = crypto_skcipher_spawn_alg(&ctx->ctr);
 
 	/* We only support 16-byte blocks. */
+	err = -EINVAL;
 	if (ctr->cra_ablkcipher.ivsize != 16)
 		goto out_put_ctr;
 
 	/* Not a stream cipher? */
-	err = -EINVAL;
 	if (ctr->cra_blocksize != 1)
 		goto out_put_ctr;
 
-- 
2.21.0.1020.gf2820cf01a-goog

