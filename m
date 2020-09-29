Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7104327C43A
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbgI2LMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:12:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:53750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729306AbgI2LMG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:12:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DB51206A5;
        Tue, 29 Sep 2020 11:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377926;
        bh=ugSFzKxkxgqkHGdJE77qqLWjQsB1bCv2+wihC4OBFXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wjPyWMClTVu9kHIuU1O0dQgE3XmnllAbE3VolcZNE2w5/XmzKyt86/eVDp8qV3OyC
         X20KP+zvPqI8AlrJe/2buL5j6lsizKiiAMwJ8u9xqv7FeS7GL6NBEVsx3mvX74eU3P
         cRaOSovK6QNwQYV1/ipahDzJ5QUh5RFhUQcCxjiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Bakker <xc-racer2@live.ca>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 082/121] phy: samsung: s5pv210-usb2: Add delay after reset
Date:   Tue, 29 Sep 2020 13:00:26 +0200
Message-Id: <20200929105934.244365701@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



