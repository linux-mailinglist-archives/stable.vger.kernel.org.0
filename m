Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A29FB6945A
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404361AbfGOOuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:50:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391947AbfGOOqB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:46:01 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCA2120C01;
        Mon, 15 Jul 2019 14:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563201960;
        bh=JtoJsZuclAftWZhOWO9t7/AiuGR8oEKq9jRQeyxM9/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJrU9pZ2dVW/k1ZQ1rj/cT+YJwAeDON/D94IZEGHBVCRh+fRPeCrEoRgzJKkLpGfB
         MemHGMqI92MUods1KZna+YPF42e+a1jpvYzrybRzv9KyrgfM1e66lpfhIPdn6wRQv2
         r8nsjNSXHELgfpd/sGMBBSRnnP/EdbF8VNlRqOkk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 07/53] crypto: talitos - fix skcipher failure due to wrong output IV
Date:   Mon, 15 Jul 2019 10:44:49 -0400
Message-Id: <20190715144535.11636-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715144535.11636-1-sashal@kernel.org>
References: <20190715144535.11636-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

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
index 62ce93568e11..a000c2667392 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1446,11 +1446,15 @@ static void ablkcipher_done(struct device *dev,
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

