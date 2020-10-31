Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B552A1693
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgJaLq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:46:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727819AbgJaLqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:46:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 974F6205F4;
        Sat, 31 Oct 2020 11:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144769;
        bh=lp61+OWJbjIgZGSPK/gfon+MQDZYdOwpgU2lyciFs/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UQo03ZXqyMB1Gp69Zuqmv+SJNKJoRByA7IFDNynbRJ/b1tI2sFPk1qIPlikH+zOgx
         qSNnr9cHgaaBgh0LXMc0iBYfyZaduG92nw4ylsVEVL5IubnCZqqa24Z7J8O1Hjiypa
         ZDM0q3hVtNr72WuypRc8WSZ/TvcrA+VgiNPTk8Qg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomasz Maciej Nowak <tmn505@gmail.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.9 74/74] phy: marvell: comphy: Convert internal SMCC firmware return codes to errno
Date:   Sat, 31 Oct 2020 12:36:56 +0100
Message-Id: <20201031113503.580240574@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit ea17a0f153af2cd890e4ce517130dcccaa428c13 upstream.

Driver ->power_on and ->power_off callbacks leaks internal SMCC firmware
return codes to phy caller. This patch converts SMCC error codes to
standard linux errno codes. Include file linux/arm-smccc.h already provides
defines for SMCC error codes, so use them instead of custom driver defines.
Note that return value is signed 32bit, but stored in unsigned long type
with zero padding.

Tested-by: Tomasz Maciej Nowak <tmn505@gmail.com>
Link: https://lore.kernel.org/r/20200902144344.16684-2-pali@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/phy/marvell/phy-mvebu-a3700-comphy.c |   14 +++++++++++---
 drivers/phy/marvell/phy-mvebu-cp110-comphy.c |   14 +++++++++++---
 2 files changed, 22 insertions(+), 6 deletions(-)

--- a/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
+++ b/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
@@ -26,7 +26,6 @@
 #define COMPHY_SIP_POWER_ON			0x82000001
 #define COMPHY_SIP_POWER_OFF			0x82000002
 #define COMPHY_SIP_PLL_LOCK			0x82000003
-#define COMPHY_FW_NOT_SUPPORTED			(-1)
 
 #define COMPHY_FW_MODE_SATA			0x1
 #define COMPHY_FW_MODE_SGMII			0x2
@@ -112,10 +111,19 @@ static int mvebu_a3700_comphy_smc(unsign
 				  unsigned long mode)
 {
 	struct arm_smccc_res res;
+	s32 ret;
 
 	arm_smccc_smc(function, lane, mode, 0, 0, 0, 0, 0, &res);
+	ret = res.a0;
 
-	return res.a0;
+	switch (ret) {
+	case SMCCC_RET_SUCCESS:
+		return 0;
+	case SMCCC_RET_NOT_SUPPORTED:
+		return -EOPNOTSUPP;
+	default:
+		return -EINVAL;
+	}
 }
 
 static int mvebu_a3700_comphy_get_fw_mode(int lane, int port,
@@ -220,7 +228,7 @@ static int mvebu_a3700_comphy_power_on(s
 	}
 
 	ret = mvebu_a3700_comphy_smc(COMPHY_SIP_POWER_ON, lane->id, fw_param);
-	if (ret == COMPHY_FW_NOT_SUPPORTED)
+	if (ret == -EOPNOTSUPP)
 		dev_err(lane->dev,
 			"unsupported SMC call, try updating your firmware\n");
 
--- a/drivers/phy/marvell/phy-mvebu-cp110-comphy.c
+++ b/drivers/phy/marvell/phy-mvebu-cp110-comphy.c
@@ -123,7 +123,6 @@
 
 #define COMPHY_SIP_POWER_ON	0x82000001
 #define COMPHY_SIP_POWER_OFF	0x82000002
-#define COMPHY_FW_NOT_SUPPORTED	(-1)
 
 /*
  * A lane is described by the following bitfields:
@@ -273,10 +272,19 @@ static int mvebu_comphy_smc(unsigned lon
 			    unsigned long lane, unsigned long mode)
 {
 	struct arm_smccc_res res;
+	s32 ret;
 
 	arm_smccc_smc(function, phys, lane, mode, 0, 0, 0, 0, &res);
+	ret = res.a0;
 
-	return res.a0;
+	switch (ret) {
+	case SMCCC_RET_SUCCESS:
+		return 0;
+	case SMCCC_RET_NOT_SUPPORTED:
+		return -EOPNOTSUPP;
+	default:
+		return -EINVAL;
+	}
 }
 
 static int mvebu_comphy_get_mode(bool fw_mode, int lane, int port,
@@ -819,7 +827,7 @@ static int mvebu_comphy_power_on(struct
 	if (!ret)
 		return ret;
 
-	if (ret == COMPHY_FW_NOT_SUPPORTED)
+	if (ret == -EOPNOTSUPP)
 		dev_err(priv->dev,
 			"unsupported SMC call, try updating your firmware\n");
 


