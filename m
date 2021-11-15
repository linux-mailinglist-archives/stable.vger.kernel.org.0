Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C84D45109E
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242729AbhKOSvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:51:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:54772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242684AbhKOSs7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:48:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94AA66329C;
        Mon, 15 Nov 2021 18:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999702;
        bh=G7iF7BWLw3NatKyU1LmP+Six9fftezIoKHMjGeriogo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d5ac6OeFuJ89nAp7zTTuei4sU23zK+SJPhCVd4zUZd9lhReiN7xtrdwZVasw/Mx/U
         JFBK9nZEJEV3sxDioo6gLD0xcW03OPEjheIicQhhiaWLI01xnDrdPbBUEoCDYCZKI0
         M+f7MFp16Z6FlJBpxp8Wq/pLEksrLsdNisXyyM38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 359/849] crypto: caam - disable pkc for non-E SoCs
Date:   Mon, 15 Nov 2021 17:57:22 +0100
Message-Id: <20211115165432.381817437@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit f20311cc9c58052e0b215013046cbf390937910c ]

On newer CAAM versions, not all accelerators are disabled if the SoC is
a non-E variant. While the driver checks most of the modules for
availability, there is one - PKHA - which sticks out. On non-E variants
it is still reported as available, that is the number of instances is
non-zero, but it has limited functionality. In particular it doesn't
support encryption and decryption, but just signing and verifying. This
is indicated by a bit in the PKHA_MISC field. Take this bit into account
if we are checking for availability.

This will the following error:
[    8.167817] caam_jr 8020000.jr: 20000b0f: CCB: desc idx 11: : Invalid CHA selected.

Tested on an NXP LS1028A (non-E) SoC.

Fixes: d239b10d4ceb ("crypto: caam - add register map changes cf. Era 10")
Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/caampkc.c | 19 +++++++++++++++----
 drivers/crypto/caam/regs.h    |  3 +++
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index e313233ec6de7..bf6275ffc4aad 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -1153,16 +1153,27 @@ static struct caam_akcipher_alg caam_rsa = {
 int caam_pkc_init(struct device *ctrldev)
 {
 	struct caam_drv_private *priv = dev_get_drvdata(ctrldev);
-	u32 pk_inst;
+	u32 pk_inst, pkha;
 	int err;
 	init_done = false;
 
 	/* Determine public key hardware accelerator presence. */
-	if (priv->era < 10)
+	if (priv->era < 10) {
 		pk_inst = (rd_reg32(&priv->ctrl->perfmon.cha_num_ls) &
 			   CHA_ID_LS_PK_MASK) >> CHA_ID_LS_PK_SHIFT;
-	else
-		pk_inst = rd_reg32(&priv->ctrl->vreg.pkha) & CHA_VER_NUM_MASK;
+	} else {
+		pkha = rd_reg32(&priv->ctrl->vreg.pkha);
+		pk_inst = pkha & CHA_VER_NUM_MASK;
+
+		/*
+		 * Newer CAAMs support partially disabled functionality. If this is the
+		 * case, the number is non-zero, but this bit is set to indicate that
+		 * no encryption or decryption is supported. Only signing and verifying
+		 * is supported.
+		 */
+		if (pkha & CHA_VER_MISC_PKHA_NO_CRYPT)
+			pk_inst = 0;
+	}
 
 	/* Do not register algorithms if PKHA is not present. */
 	if (!pk_inst)
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index af61f3a2c0d46..3738625c02509 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -322,6 +322,9 @@ struct version_regs {
 /* CHA Miscellaneous Information - AESA_MISC specific */
 #define CHA_VER_MISC_AES_GCM	BIT(1 + CHA_VER_MISC_SHIFT)
 
+/* CHA Miscellaneous Information - PKHA_MISC specific */
+#define CHA_VER_MISC_PKHA_NO_CRYPT	BIT(7 + CHA_VER_MISC_SHIFT)
+
 /*
  * caam_perfmon - Performance Monitor/Secure Memory Status/
  *                CAAM Global Status/Component Version IDs
-- 
2.33.0



