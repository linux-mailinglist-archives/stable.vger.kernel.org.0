Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5FBB3C5031
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240917AbhGLHbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:31:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343645AbhGLH2l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:28:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBB04611AD;
        Mon, 12 Jul 2021 07:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074657;
        bh=EYuVSNaOUkLThm0haDpdFQlpTFKIsTJ0fAoZnBlV6v4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ps/pkkLCiJQ5rGTferhPnmGd+0DzmvWpjZkh0HZ/H+zgtKGPN+bdVpd+zqA10q/Jb
         uy8MZzcNufwvIVCjOH3PPGTjtkVtHeQivkoDxkGN0/7hkH+BnTFWdu6XsCsU3xMywB
         ioWGT6SraviCwbIuCRZD7hLFFRfLpXiuTFtZYaho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@kernel.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        Maxim Schwalm <maxim.schwalm@gmail.com>
Subject: [PATCH 5.12 626/700] usb: phy: tegra: Wait for VBUS wakeup status deassertion on suspend
Date:   Mon, 12 Jul 2021 08:11:49 +0200
Message-Id: <20210712061042.410996320@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 6f8d39a8ef55efde414b6e574384acbce70c3119 ]

Some devices need an extra delay after losing VBUS, otherwise VBUS may
be detected as active at suspend time, preventing the PHY's suspension
by the VBUS detection sensor. This problem was found on Asus Transformer
TF700T (Tegra30) tablet device, where the USB PHY wakes up immediately
from suspend because VBUS sensor continues to detect VBUS as active after
disconnection. We need to poll the PHY's VBUS wakeup status until it's
deasserted before suspending PHY in order to fix this minor trouble.

Fixes: 35192007d28d ("usb: phy: tegra: Support waking up from a low power mode")
Reported-by: Maxim Schwalm <maxim.schwalm@gmail.com> # Asus TF700T
Tested-by: Maxim Schwalm <maxim.schwalm@gmail.com> # Asus TF700T
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20210613145936.9902-1-digetx@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/phy/phy-tegra-usb.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
index a48452a6172b..10fafcf9801b 100644
--- a/drivers/usb/phy/phy-tegra-usb.c
+++ b/drivers/usb/phy/phy-tegra-usb.c
@@ -64,6 +64,7 @@
 #define   A_VBUS_VLD_WAKEUP_EN			BIT(30)
 
 #define USB_PHY_VBUS_WAKEUP_ID			0x408
+#define   VBUS_WAKEUP_STS			BIT(10)
 #define   VBUS_WAKEUP_WAKEUP_EN			BIT(30)
 
 #define USB1_LEGACY_CTRL			0x410
@@ -642,6 +643,15 @@ static int utmi_phy_power_off(struct tegra_usb_phy *phy)
 	void __iomem *base = phy->regs;
 	u32 val;
 
+	/*
+	 * Give hardware time to settle down after VBUS disconnection,
+	 * otherwise PHY will immediately wake up from suspend.
+	 */
+	if (phy->wakeup_enabled && phy->mode != USB_DR_MODE_HOST)
+		readl_relaxed_poll_timeout(base + USB_PHY_VBUS_WAKEUP_ID,
+					   val, !(val & VBUS_WAKEUP_STS),
+					   5000, 100000);
+
 	utmi_phy_clk_disable(phy);
 
 	/* PHY won't resume if reset is asserted */
-- 
2.30.2



