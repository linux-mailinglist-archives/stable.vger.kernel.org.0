Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5CA20E526
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732928AbgF2VdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:33:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728651AbgF2SlC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:41:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00B482416D;
        Mon, 29 Jun 2020 15:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443944;
        bh=gSiUwkc1B7r7Sw6zCT4JbM2AnDQ3E6AeyBCc4gj96ZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wp4C30ndZKR/SDztitYDyey6uQPfgVVIxraatSyxo68V2UGSY8XEoOUjo8zZgdDMK
         9na8sOt5k2eGlzkSEuSUS1zyvBTVWwFhPBs0SOzfyBzSklnX5XhzC+QFZkPe1kkNmB
         SCcONvoJOrCvbUdjkfcwNmYahWncayv77Tlaj7Cs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 045/265] net: phy: mscc: avoid skcipher API for single block AES encryption
Date:   Mon, 29 Jun 2020 11:14:38 -0400
Message-Id: <20200629151818.2493727-46-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 8acd2edbe0e8e36261d98d89ce91b810dd7f4b0d ]

The skcipher API dynamically instantiates the transformation object
on request that implements the requested algorithm optimally on the
given platform. This notion of optimality only matters for cases like
bulk network or disk encryption, where performance can be a bottleneck,
or in cases where the algorithm itself is not known at compile time.

In the mscc case, we are dealing with AES encryption of a single
block, and so neither concern applies, and we are better off using
the AES library interface, which is lightweight and safe for this
kind of use.

Note that the scatterlist API does not permit references to buffers
that are located on the stack, so the existing code is incorrect in
any case, but avoiding the skcipher and scatterlist APIs entirely is
the most straight-forward approach to fixing this.

Cc: Antoine Tenart <antoine.tenart@bootlin.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: <stable@vger.kernel.org>
Fixes: 28c5107aa904e ("net: phy: mscc: macsec support")
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/Kconfig            |  3 +--
 drivers/net/phy/mscc/mscc_macsec.c | 40 +++++++-----------------------
 2 files changed, 10 insertions(+), 33 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 3fa33d27eebaf..d140e3c93fe34 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -461,8 +461,7 @@ config MICROCHIP_T1_PHY
 config MICROSEMI_PHY
 	tristate "Microsemi PHYs"
 	depends on MACSEC || MACSEC=n
-	select CRYPTO_AES
-	select CRYPTO_ECB
+	select CRYPTO_LIB_AES if MACSEC
 	---help---
 	  Currently supports VSC8514, VSC8530, VSC8531, VSC8540 and VSC8541 PHYs
 
diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
index b4d3dc4068e27..d53ca884b5c9e 100644
--- a/drivers/net/phy/mscc/mscc_macsec.c
+++ b/drivers/net/phy/mscc/mscc_macsec.c
@@ -10,7 +10,7 @@
 #include <linux/phy.h>
 #include <dt-bindings/net/mscc-phy-vsc8531.h>
 
-#include <crypto/skcipher.h>
+#include <crypto/aes.h>
 
 #include <net/macsec.h>
 
@@ -500,39 +500,17 @@ static u32 vsc8584_macsec_flow_context_id(struct macsec_flow *flow)
 static int vsc8584_macsec_derive_key(const u8 key[MACSEC_KEYID_LEN],
 				     u16 key_len, u8 hkey[16])
 {
-	struct crypto_skcipher *tfm = crypto_alloc_skcipher("ecb(aes)", 0, 0);
-	struct skcipher_request *req = NULL;
-	struct scatterlist src, dst;
-	DECLARE_CRYPTO_WAIT(wait);
-	u32 input[4] = {0};
+	const u8 input[AES_BLOCK_SIZE] = {0};
+	struct crypto_aes_ctx ctx;
 	int ret;
 
-	if (IS_ERR(tfm))
-		return PTR_ERR(tfm);
-
-	req = skcipher_request_alloc(tfm, GFP_KERNEL);
-	if (!req) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
-				      CRYPTO_TFM_REQ_MAY_SLEEP, crypto_req_done,
-				      &wait);
-	ret = crypto_skcipher_setkey(tfm, key, key_len);
-	if (ret < 0)
-		goto out;
-
-	sg_init_one(&src, input, 16);
-	sg_init_one(&dst, hkey, 16);
-	skcipher_request_set_crypt(req, &src, &dst, 16, NULL);
-
-	ret = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
+	ret = aes_expandkey(&ctx, key, key_len);
+	if (ret)
+		return ret;
 
-out:
-	skcipher_request_free(req);
-	crypto_free_skcipher(tfm);
-	return ret;
+	aes_encrypt(&ctx, hkey, input);
+	memzero_explicit(&ctx, sizeof(ctx));
+	return 0;
 }
 
 static int vsc8584_macsec_transformation(struct phy_device *phydev,
-- 
2.25.1

