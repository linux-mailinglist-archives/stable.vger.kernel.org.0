Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64D1D789B9
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 12:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387424AbfG2Kkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 06:40:36 -0400
Received: from foss.arm.com ([217.140.110.172]:41736 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387428AbfG2Kkg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 06:40:36 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 561F7344;
        Mon, 29 Jul 2019 03:40:35 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (unknown [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EF1643F694;
        Mon, 29 Jul 2019 03:40:33 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] crypto: ccree: use the full crypt length value
Date:   Mon, 29 Jul 2019 13:40:18 +0300
Message-Id: <20190729104020.3681-2-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190729104020.3681-1-gilad@benyossef.com>
References: <20190729104020.3681-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In case of AEAD decryption verifcation error we were using the
wrong value to zero out the plaintext buffer leaving the end of
the buffer with the false plaintext.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Fixes: ff27e85a85bb ("crypto: ccree - add AEAD support")
CC: stable@vger.kernel.org # v4.17+
---
 drivers/crypto/ccree/cc_aead.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index 19abb872329c..8a6c825d40e8 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -268,7 +268,7 @@ static void cc_aead_complete(struct device *dev, void *cc_req, int err)
 			/* In case of payload authentication failure, MUST NOT
 			 * revealed the decrypted message --> zero its memory.
 			 */
-			cc_zero_sgl(areq->dst, areq_ctx->cryptlen);
+			cc_zero_sgl(areq->dst, areq->cryptlen);
 			err = -EBADMSG;
 		}
 	/*ENCRYPT*/
-- 
2.21.0

