Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5484F26ED65
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729200AbgIRCTR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:19:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729570AbgIRCRn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:17:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEF0723772;
        Fri, 18 Sep 2020 02:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395462;
        bh=ugSFzKxkxgqkHGdJE77qqLWjQsB1bCv2+wihC4OBFXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xuuU1ZGFdOOaHUyaZJhBRJkWQYCX39fzIOvS45ctiW7GhhqxUOp9R3SOtfWoIbJZQ
         G7wIUY0XdvRMIDDse1cWb8gah6aGzMxTDW5IYkZ9ztKHKIOQaijCmETH2I1tYXvikH
         Uu8k9lQfaLrJ2PkBZyDtkmV05BRa8e0tcXNTr/QM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan Bakker <xc-racer2@live.ca>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 48/64] phy: samsung: s5pv210-usb2: Add delay after reset
Date:   Thu, 17 Sep 2020 22:16:27 -0400
Message-Id: <20200918021643.2067895-48-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021643.2067895-1-sashal@kernel.org>
References: <20200918021643.2067895-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Bakker <xc-racer2@live.ca>

[ Upstream commit 05942b8c36c7eb5d3fc5e375d4b0d0c49562e85d ]

The USB phy takes some time to reset, so make sure we give it to it. The
delay length was taken from the 4x12 phy driver.

This manifested in issues with the DWC2 driver since commit fe369e1826b3
("usb: dwc2: Make dwc2_readl/writel functions endianness-agnostic.")
where the endianness check would read the DWC ID as 0 due to the phy still
resetting, resulting in the wrong endian mode being chosen.

Signed-off-by: Jonathan Bakker <xc-racer2@live.ca>
Link: https://lore.kernel.org/r/BN6PR04MB06605D52502816E500683553A3D10@BN6PR04MB0660.namprd04.prod.outlook.com
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/phy-s5pv210-usb2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/phy/phy-s5pv210-usb2.c b/drivers/phy/phy-s5pv210-usb2.c
index 004d320767e4d..bb36cfd4e3e90 100644
--- a/drivers/phy/phy-s5pv210-usb2.c
+++ b/drivers/phy/phy-s5pv210-usb2.c
@@ -142,6 +142,10 @@ static void s5pv210_phy_pwr(struct samsung_usb2_phy_instance *inst, bool on)
 		udelay(10);
 		rst &= ~rstbits;
 		writel(rst, drv->reg_phy + S5PV210_UPHYRST);
+		/* The following delay is necessary for the reset sequence to be
+		 * completed
+		 */
+		udelay(80);
 	} else {
 		pwr = readl(drv->reg_phy + S5PV210_UPHYPWR);
 		pwr |= phypwr;
-- 
2.25.1

