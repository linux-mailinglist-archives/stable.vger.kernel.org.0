Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D48073905
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388801AbfGXTf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:35:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388951AbfGXTf5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:35:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57CC320659;
        Wed, 24 Jul 2019 19:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996956;
        bh=3qMwmjDkCoCfgkdAGp/mueibKfxoUb9z1llMH7RJw2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBbX38I9QQdZD8FCmSNlHtcXS72h3WMPSTAbmk7uYKu4SkbGrsAwED2wbKn9slbN/
         aPFoHBeqOeFwGvUEW+wb9431RNgOkh+d5hqsN+8JSvwwQbPbJCTiGE2W36kLUMv6X1
         Hcp5MFGRCSJbapwSETs976Kvihspj5pWHPh2Oc0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Armijn Hemel <armijn@tjaldur.nl>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        linux-crypto@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.2 274/413] crypto: crypto4xx - fix a potential double free in ppc4xx_trng_probe
Date:   Wed, 24 Jul 2019 21:19:25 +0200
Message-Id: <20190724191755.858461201@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wen.yang99@zte.com.cn>

commit 95566aa75cd6b3b404502c06f66956b5481194b3 upstream.

There is a possible double free issue in ppc4xx_trng_probe():

85:	dev->trng_base = of_iomap(trng, 0);
86:	of_node_put(trng);          ---> released here
87:	if (!dev->trng_base)
88:		goto err_out;
...
110:	ierr_out:
111:		of_node_put(trng);  ---> double released here
...

This issue was detected by using the Coccinelle software.
We fix it by removing the unnecessary of_node_put().

Fixes: 5343e674f32f ("crypto4xx: integrate ppc4xx-rng into crypto4xx")
Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: <stable@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Allison Randal <allison@lohutok.net>
Cc: Armijn Hemel <armijn@tjaldur.nl>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/amcc/crypto4xx_trng.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/crypto/amcc/crypto4xx_trng.c
+++ b/drivers/crypto/amcc/crypto4xx_trng.c
@@ -108,7 +108,6 @@ void ppc4xx_trng_probe(struct crypto4xx_
 	return;
 
 err_out:
-	of_node_put(trng);
 	iounmap(dev->trng_base);
 	kfree(rng);
 	dev->trng_base = NULL;


