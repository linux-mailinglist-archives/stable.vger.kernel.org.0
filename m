Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 925D27F467
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391711AbfHBJk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:40:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391705AbfHBJk3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:40:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AF7020679;
        Fri,  2 Aug 2019 09:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738828;
        bh=QWfytG9YLz53AlgWtzrZ87gSCd8TiSKOvSheHr/Jvdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ygzNOJyVohsC8l6Jy3at4aA/xAYG3TA6RR4vzJWFLTltFSc91KPJYx4W98ithNi+y
         KBAIFMyK8lGh/c7CLb0+b1vxaRtzw4Db93GyXhwx/ZtFsTFASQTARXmaaluGKzhVj9
         uI9re+MEUNscdbVYXYiTO6+Zrwp6aZhAApnQtgO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 011/223] crypto: talitos - fix skcipher failure due to wrong output IV
Date:   Fri,  2 Aug 2019 11:33:56 +0200
Message-Id: <20190802092239.645236580@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3e03e792865ae48b8cfc69a0b4d65f02f467389f ]

Selftests report the following:

[    2.984845] alg: skcipher: cbc-aes-talitos encryption test failed (wrong output IV) on test vector 0, cfg="in-place"
[    2.995377] 00000000: 3d af ba 42 9d 9e b4 30 b4 22 da 80 2c 9f ac 41
[    3.032673] alg: skcipher: cbc-des-talitos encryption test failed (wrong output IV) on test vector 0, cfg="in-place"
[    3.043185] 00000000: fe dc ba 98 76 54 32 10
[    3.063238] alg: skcipher: cbc-3des-talitos encryption test failed (wrong output IV) on test vector 0, cfg="in-place"
[    3.073818] 00000000: 7d 33 88 93 0f 93 b2 42

This above dumps show that the actual output IV is indeed the input IV.
This is due to the IV not being copied back into the request.

This patch fixes that.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/talitos.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 5a24a484ecc7..0b12772c7919 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1544,11 +1544,15 @@ static void ablkcipher_done(struct device *dev,
 			    int err)
 {
 	struct ablkcipher_request *areq = context;
+	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	unsigned int ivsize = crypto_ablkcipher_ivsize(cipher);
 	struct talitos_edesc *edesc;
 
 	edesc = container_of(desc, struct talitos_edesc, desc);
 
 	common_nonsnoop_unmap(dev, edesc, areq);
+	memcpy(areq->info, ctx->iv, ivsize);
 
 	kfree(edesc);
 
-- 
2.20.1



