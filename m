Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38C4E14CC91
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 15:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgA2OiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 09:38:11 -0500
Received: from foss.arm.com ([217.140.110.172]:41970 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbgA2OiK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jan 2020 09:38:10 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 81E9E31B;
        Wed, 29 Jan 2020 06:38:10 -0800 (PST)
Received: from e110176-lin.kfn.arm.com (unknown [10.50.4.146])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DDA743F52E;
        Wed, 29 Jan 2020 06:38:08 -0800 (PST)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] crypto: ccree - only try to map auth tag if needed
Date:   Wed, 29 Jan 2020 16:37:55 +0200
Message-Id: <20200129143757.680-3-gilad@benyossef.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200129143757.680-1-gilad@benyossef.com>
References: <20200129143757.680-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to only add the size of the auth tag to the source mapping
for encryption if it is an in-place operation. Failing to do this
previously caused us to try and map auth size len bytes from a NULL
mapping and crashing if both the cryptlen and assoclen are zero.

Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: stable@vger.kernel.org # v4.19+
---
 drivers/crypto/ccree/cc_buffer_mgr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index b938ceae7ae7..885347b5b372 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -1109,9 +1109,11 @@ int cc_map_aead_request(struct cc_drvdata *drvdata, struct aead_request *req)
 	}
 
 	size_to_map = req->cryptlen + areq_ctx->assoclen;
-	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_ENCRYPT)
+	/* If we do in-place encryption, we also need the auth tag */
+	if ((areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_ENCRYPT) &&
+	   (req->src == req->dst)) {
 		size_to_map += authsize;
-
+	}
 	if (is_gcm4543)
 		size_to_map += crypto_aead_ivsize(tfm);
 	rc = cc_map_sg(dev, req->src, size_to_map, DMA_BIDIRECTIONAL,
-- 
2.25.0

