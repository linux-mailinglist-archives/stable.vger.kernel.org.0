Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5470C450B8F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237462AbhKORZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:25:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:50942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237785AbhKORYD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:24:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E395A61BFE;
        Mon, 15 Nov 2021 17:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996576;
        bh=Ql7rMOURfqEFQwRGZpukoiwanEQEEIsGUX6ZWDEIsos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SIdLT0meDTCf3nhCG15PYklcNgJ2HiqXMK8B0iVi3qKC3BWcQJl9+T5zXh7GmspyH
         LKwvi8kE4Y4q0c9kz0JfIgrGu7dGsGmBxdP1Mx5eOh3E57j4OI6erxh6y7GSdoFTQ5
         6Y0LP1rmZJMYIi5UXzI+Nogn56M5vQiU4i3FcHoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 190/355] crypto: caam - disable pkc for non-E SoCs
Date:   Mon, 15 Nov 2021 18:01:54 +0100
Message-Id: <20211115165319.916565873@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
index 83f96d4f86e03..30e3f41ed8721 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -1087,16 +1087,27 @@ static struct caam_akcipher_alg caam_rsa = {
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
index 05127b70527d7..43975f01465d2 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -317,6 +317,9 @@ struct version_regs {
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



