Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 930655CE8E
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 13:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfGBLjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 07:39:37 -0400
Received: from foss.arm.com ([217.140.110.172]:48110 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbfGBLjh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 07:39:37 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 85B84344;
        Tue,  2 Jul 2019 04:39:36 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (unknown [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 27EF93F246;
        Tue,  2 Jul 2019 04:39:34 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] crypto: ccree: account for TEE not ready to report
Date:   Tue,  2 Jul 2019 14:39:19 +0300
Message-Id: <20190702113922.24911-3-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190702113922.24911-1-gilad@benyossef.com>
References: <20190702113922.24911-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When ccree driver runs it checks the state of the Trusted Execution
Environment CryptoCell driver before proceeding. We did not account
for cases where the TEE side is not ready or not available at all.
Fix it by only considering TEE error state after sync with the TEE
side driver.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Fixes: ab8ec9658f5a ("crypto: ccree - add FIPS support")
CC: stable@vger.kernel.org # v4.17+
---
 drivers/crypto/ccree/cc_fips.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_fips.c b/drivers/crypto/ccree/cc_fips.c
index 5ad3ffb7acaa..040e09c0e1af 100644
--- a/drivers/crypto/ccree/cc_fips.c
+++ b/drivers/crypto/ccree/cc_fips.c
@@ -21,7 +21,13 @@ static bool cc_get_tee_fips_status(struct cc_drvdata *drvdata)
 	u32 reg;
 
 	reg = cc_ioread(drvdata, CC_REG(GPR_HOST));
-	return (reg == (CC_FIPS_SYNC_TEE_STATUS | CC_FIPS_SYNC_MODULE_OK));
+	/* Did the TEE report status? */
+	if (reg & CC_FIPS_SYNC_TEE_STATUS)
+		/* Yes. Is it OK? */
+		return (reg & CC_FIPS_SYNC_MODULE_OK);
+
+	/* No. It's either not in use or will be reported later */
+	return true;
 }
 
 /*
-- 
2.21.0

