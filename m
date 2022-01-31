Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265BB4A43EF
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359079AbiAaLZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:25:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41222 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377442AbiAaLW4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:22:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DDE6B82A76;
        Mon, 31 Jan 2022 11:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7916DC340E8;
        Mon, 31 Jan 2022 11:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628174;
        bh=05u4659g45mJj8TYTwy6Hv2WqO2LL6t/KdgTntH3sjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RQEfE9GIDmobNcZ/7LTf2wQj07zDywsh6yMpQHq2s1IaYxihNGeomMxSMe7aUaZOO
         93XD+sqbQA/D36xqW922A6dqTB4AfU1/wdS85p6z4dIdoufLQo6nnFofu8HFGaORAe
         x/k86PKK1Ty8MB6B3tiZz5RyX5DmD3sfgWHjaRFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 131/200] net: phy: broadcom: hook up soft_reset for BCM54616S
Date:   Mon, 31 Jan 2022 11:56:34 +0100
Message-Id: <20220131105237.957986263@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit d15c7e875d44367005370e6a82e8f3a382a04f9b ]

A problem was encountered with the Bel-Fuse 1GBT-SFP05 SFP module (which
is a 1 Gbps copper module operating in SGMII mode with an internal
BCM54616S PHY device) using the Xilinx AXI Ethernet MAC core, where the
module would work properly on the initial insertion or boot of the
device, but after the device was rebooted, the link would either only
come up at 100 Mbps speeds or go up and down erratically.

I found no meaningful changes in the PHY configuration registers between
the working and non-working boots, but the status registers seemed to
have a lot of error indications set on the SERDES side of the device on
the non-working boot. I suspect the problem is that whatever happens on
the SGMII link when the device is rebooted and the FPGA logic gets
reloaded ends up putting the module's onboard PHY into a bad state.

Since commit 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
the genphy_soft_reset call is not made automatically by the PHY core
unless the callback is explicitly specified in the driver structure. For
most of these Broadcom devices, there is probably a hardware reset that
gets asserted to reset the PHY during boot, however for SFP modules
(where the BCM54616S is commonly found) no such reset line exists, so if
the board keeps the SFP cage powered up across a reboot, it will end up
with no reset occurring during reboots.

Hook up the genphy_soft_reset callback for BCM54616S to ensure that a
PHY reset is performed before the device is initialized. This appears to
fix the issue with erratic operation after a reboot with this SFP
module.

Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/broadcom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index bb5104ae46104..3c683e0e40e9e 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -854,6 +854,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.phy_id_mask	= 0xfffffff0,
 	.name		= "Broadcom BCM54616S",
 	/* PHY_GBIT_FEATURES */
+	.soft_reset     = genphy_soft_reset,
 	.config_init	= bcm54xx_config_init,
 	.config_aneg	= bcm54616s_config_aneg,
 	.config_intr	= bcm_phy_config_intr,
-- 
2.34.1



