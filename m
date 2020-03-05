Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8845917B08F
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 22:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgCEVV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 16:21:28 -0500
Received: from viti.kaiser.cx ([85.214.81.225]:55014 "EHLO viti.kaiser.cx"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbgCEVV2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 16:21:28 -0500
X-Greylist: delayed 1322 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Mar 2020 16:21:27 EST
Received: from 250.57.4.146.static.wline.lns.sme.cust.swisscom.ch ([146.4.57.250] helo=martin-debian-2.paytec.ch)
        by viti.kaiser.cx with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <martin@kaiser.cx>)
        id 1j9xaR-0000e9-TW; Thu, 05 Mar 2020 21:59:19 +0100
From:   Martin Kaiser <martin@kaiser.cx>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Martin Kaiser <martin@kaiser.cx>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/5] hwrng: imx-rngc - fix an error path
Date:   Thu,  5 Mar 2020 21:58:20 +0100
Message-Id: <20200305205824.4371-2-martin@kaiser.cx>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305205824.4371-1-martin@kaiser.cx>
References: <20200128110102.11522-1-martin@kaiser.cx>
 <20200305205824.4371-1-martin@kaiser.cx>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure that the rngc interrupt is masked if the rngc self test fails.
Self test failure means that probe fails as well. Interrupts should be
masked in this case, regardless of the error.

Cc: stable@vger.kernel.org
Fixes: 1d5449445bd0 ("hwrng: mx-rngc - add a driver for Freescale RNGC")
Reviewed-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
---
 drivers/char/hw_random/imx-rngc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
index 30cf00f8e9a0..0576801944fd 100644
--- a/drivers/char/hw_random/imx-rngc.c
+++ b/drivers/char/hw_random/imx-rngc.c
@@ -105,8 +105,10 @@ static int imx_rngc_self_test(struct imx_rngc *rngc)
 		return -ETIMEDOUT;
 	}
 
-	if (rngc->err_reg != 0)
+	if (rngc->err_reg != 0) {
+		imx_rngc_irq_mask_clear(rngc);
 		return -EIO;
+	}
 
 	return 0;
 }
-- 
2.20.1

