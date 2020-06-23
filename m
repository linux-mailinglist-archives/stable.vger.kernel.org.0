Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788FC2065FB
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393769AbgFWVf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:35:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388785AbgFWUKH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:10:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC6D12082F;
        Tue, 23 Jun 2020 20:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943007;
        bh=o15EEKsDrIs/d1yTZqhyj0lnIaRHrjdGmY7nWh2Qw6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5BakaTAnhABTGjL4H4Ys20fstIJgXTK+6Uq6M8ux9UZ1b7J77WPg53sSmhfSz6EL
         QHzIeSo8ecmz3N4n1tZPEarfmyex+j+fkbSm2/b0IVRNFk9+zipSLoC/S9E8cCTDJf
         ZZkLdUd3SNw4WZos2IM3P9hsUMKEBVnT+4BRPzsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sanket Parmar <sparmar@cadence.com>,
        Roger Quadros <rogerq@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 222/477] phy: cadence: sierra: Fix for USB3 U1/U2 state
Date:   Tue, 23 Jun 2020 21:53:39 +0200
Message-Id: <20200623195418.076546963@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sanket Parmar <sparmar@cadence.com>

[ Upstream commit 2bcf14ca1a2f3202954f812f380c7fa8127fbd7f ]

Updated values of USB3 related Sierra PHY registers.
This change fixes USB3 device disconnect issue observed
while enternig U1/U2 state.

Signed-off-by: Sanket Parmar <sparmar@cadence.com>
Link: https://lore.kernel.org/r/1589804053-14302-1-git-send-email-sparmar@cadence.com
Reviewed-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/cadence/phy-cadence-sierra.c | 27 ++++++++++++------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/phy/cadence/phy-cadence-sierra.c b/drivers/phy/cadence/phy-cadence-sierra.c
index a5c08e5bd2bf7..faed652b73f79 100644
--- a/drivers/phy/cadence/phy-cadence-sierra.c
+++ b/drivers/phy/cadence/phy-cadence-sierra.c
@@ -685,10 +685,10 @@ static struct cdns_reg_pairs cdns_usb_cmn_regs_ext_ssc[] = {
 static struct cdns_reg_pairs cdns_usb_ln_regs_ext_ssc[] = {
 	{0xFE0A, SIERRA_DET_STANDEC_A_PREG},
 	{0x000F, SIERRA_DET_STANDEC_B_PREG},
-	{0x00A5, SIERRA_DET_STANDEC_C_PREG},
+	{0x55A5, SIERRA_DET_STANDEC_C_PREG},
 	{0x69ad, SIERRA_DET_STANDEC_D_PREG},
 	{0x0241, SIERRA_DET_STANDEC_E_PREG},
-	{0x0010, SIERRA_PSM_LANECAL_DLY_A1_RESETS_PREG},
+	{0x0110, SIERRA_PSM_LANECAL_DLY_A1_RESETS_PREG},
 	{0x0014, SIERRA_PSM_A0IN_TMR_PREG},
 	{0xCF00, SIERRA_PSM_DIAG_PREG},
 	{0x001F, SIERRA_PSC_TX_A0_PREG},
@@ -696,7 +696,7 @@ static struct cdns_reg_pairs cdns_usb_ln_regs_ext_ssc[] = {
 	{0x0003, SIERRA_PSC_TX_A2_PREG},
 	{0x0003, SIERRA_PSC_TX_A3_PREG},
 	{0x0FFF, SIERRA_PSC_RX_A0_PREG},
-	{0x0619, SIERRA_PSC_RX_A1_PREG},
+	{0x0003, SIERRA_PSC_RX_A1_PREG},
 	{0x0003, SIERRA_PSC_RX_A2_PREG},
 	{0x0001, SIERRA_PSC_RX_A3_PREG},
 	{0x0001, SIERRA_PLLCTRL_SUBRATE_PREG},
@@ -705,19 +705,19 @@ static struct cdns_reg_pairs cdns_usb_ln_regs_ext_ssc[] = {
 	{0x00CA, SIERRA_CLKPATH_BIASTRIM_PREG},
 	{0x2512, SIERRA_DFE_BIASTRIM_PREG},
 	{0x0000, SIERRA_DRVCTRL_ATTEN_PREG},
-	{0x873E, SIERRA_CLKPATHCTRL_TMR_PREG},
-	{0x03CF, SIERRA_RX_CREQ_FLTR_A_MODE1_PREG},
-	{0x01CE, SIERRA_RX_CREQ_FLTR_A_MODE0_PREG},
+	{0x823E, SIERRA_CLKPATHCTRL_TMR_PREG},
+	{0x078F, SIERRA_RX_CREQ_FLTR_A_MODE1_PREG},
+	{0x078F, SIERRA_RX_CREQ_FLTR_A_MODE0_PREG},
 	{0x7B3C, SIERRA_CREQ_CCLKDET_MODE01_PREG},
-	{0x033F, SIERRA_RX_CTLE_MAINTENANCE_PREG},
+	{0x023C, SIERRA_RX_CTLE_MAINTENANCE_PREG},
 	{0x3232, SIERRA_CREQ_FSMCLK_SEL_PREG},
 	{0x0000, SIERRA_CREQ_EQ_CTRL_PREG},
-	{0x8000, SIERRA_CREQ_SPARE_PREG},
+	{0x0000, SIERRA_CREQ_SPARE_PREG},
 	{0xCC44, SIERRA_CREQ_EQ_OPEN_EYE_THRESH_PREG},
-	{0x8453, SIERRA_CTLELUT_CTRL_PREG},
-	{0x4110, SIERRA_DFE_ECMP_RATESEL_PREG},
-	{0x4110, SIERRA_DFE_SMP_RATESEL_PREG},
-	{0x0002, SIERRA_DEQ_PHALIGN_CTRL},
+	{0x8452, SIERRA_CTLELUT_CTRL_PREG},
+	{0x4121, SIERRA_DFE_ECMP_RATESEL_PREG},
+	{0x4121, SIERRA_DFE_SMP_RATESEL_PREG},
+	{0x0003, SIERRA_DEQ_PHALIGN_CTRL},
 	{0x3200, SIERRA_DEQ_CONCUR_CTRL1_PREG},
 	{0x5064, SIERRA_DEQ_CONCUR_CTRL2_PREG},
 	{0x0030, SIERRA_DEQ_EPIPWR_CTRL2_PREG},
@@ -725,7 +725,7 @@ static struct cdns_reg_pairs cdns_usb_ln_regs_ext_ssc[] = {
 	{0x5A5A, SIERRA_DEQ_ERRCMP_CTRL_PREG},
 	{0x02F5, SIERRA_DEQ_OFFSET_CTRL_PREG},
 	{0x02F5, SIERRA_DEQ_GAIN_CTRL_PREG},
-	{0x9A8A, SIERRA_DEQ_VGATUNE_CTRL_PREG},
+	{0x9999, SIERRA_DEQ_VGATUNE_CTRL_PREG},
 	{0x0014, SIERRA_DEQ_GLUT0},
 	{0x0014, SIERRA_DEQ_GLUT1},
 	{0x0014, SIERRA_DEQ_GLUT2},
@@ -772,6 +772,7 @@ static struct cdns_reg_pairs cdns_usb_ln_regs_ext_ssc[] = {
 	{0x000F, SIERRA_LFPSFILT_NS_PREG},
 	{0x0009, SIERRA_LFPSFILT_RD_PREG},
 	{0x0001, SIERRA_LFPSFILT_MP_PREG},
+	{0x6013, SIERRA_SIGDET_SUPPORT_PREG},
 	{0x8013, SIERRA_SDFILT_H2L_A_PREG},
 	{0x8009, SIERRA_SDFILT_L2H_PREG},
 	{0x0024, SIERRA_RXBUFFER_CTLECTRL_PREG},
-- 
2.25.1



