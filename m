Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E804299CBA
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732066AbgJ0ABK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:01:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411158AbgJZX4a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:56:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F16220882;
        Mon, 26 Oct 2020 23:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756589;
        bh=521a74qcrXvM1yVRQVqJbIMY3jx6FOfk+jkg3AIP0Fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uoa+o+1P8OPQYm6RPr+wCevFPw0QEeHKs1TkRCE1OFrs+vfshwZdWCqV1Tw+9eHJh
         6EBaO782aRx9yqM3PqoSOGkr6gnJi++0JoowHqwmUNqLKjq+A8NRrFqYKbvfJBEs4f
         /V3RDMWxofgAYakpKQIZEu0jWlhBp+aTc8VqDhO4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Tomasz Maciej Nowak <tmn505@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 61/80] phy: marvell: comphy: Convert internal SMCC firmware return codes to errno
Date:   Mon, 26 Oct 2020 19:54:57 -0400
Message-Id: <20201026235516.1025100-61-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235516.1025100-1-sashal@kernel.org>
References: <20201026235516.1025100-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit ea17a0f153af2cd890e4ce517130dcccaa428c13 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/marvell/phy-mvebu-a3700-comphy.c | 14 +++++++++++---
 drivers/phy/marvell/phy-mvebu-cp110-comphy.c | 14 +++++++++++---
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/phy/marvell/phy-mvebu-a3700-comphy.c b/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
index 1a138be8bd6a0..810f25a476321 100644
--- a/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
+++ b/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
@@ -26,7 +26,6 @@
 #define COMPHY_SIP_POWER_ON			0x82000001
 #define COMPHY_SIP_POWER_OFF			0x82000002
 #define COMPHY_SIP_PLL_LOCK			0x82000003
-#define COMPHY_FW_NOT_SUPPORTED			(-1)
 
 #define COMPHY_FW_MODE_SATA			0x1
 #define COMPHY_FW_MODE_SGMII			0x2
@@ -112,10 +111,19 @@ static int mvebu_a3700_comphy_smc(unsigned long function, unsigned long lane,
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
@@ -220,7 +228,7 @@ static int mvebu_a3700_comphy_power_on(struct phy *phy)
 	}
 
 	ret = mvebu_a3700_comphy_smc(COMPHY_SIP_POWER_ON, lane->id, fw_param);
-	if (ret == COMPHY_FW_NOT_SUPPORTED)
+	if (ret == -EOPNOTSUPP)
 		dev_err(lane->dev,
 			"unsupported SMC call, try updating your firmware\n");
 
diff --git a/drivers/phy/marvell/phy-mvebu-cp110-comphy.c b/drivers/phy/marvell/phy-mvebu-cp110-comphy.c
index e3b87c94aaf69..849351b4805f5 100644
--- a/drivers/phy/marvell/phy-mvebu-cp110-comphy.c
+++ b/drivers/phy/marvell/phy-mvebu-cp110-comphy.c
@@ -123,7 +123,6 @@
 
 #define COMPHY_SIP_POWER_ON	0x82000001
 #define COMPHY_SIP_POWER_OFF	0x82000002
-#define COMPHY_FW_NOT_SUPPORTED	(-1)
 
 /*
  * A lane is described by the following bitfields:
@@ -273,10 +272,19 @@ static int mvebu_comphy_smc(unsigned long function, unsigned long phys,
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
@@ -819,7 +827,7 @@ static int mvebu_comphy_power_on(struct phy *phy)
 	if (!ret)
 		return ret;
 
-	if (ret == COMPHY_FW_NOT_SUPPORTED)
+	if (ret == -EOPNOTSUPP)
 		dev_err(priv->dev,
 			"unsupported SMC call, try updating your firmware\n");
 
-- 
2.25.1

