Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067CE3C558F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbhGLILB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:11:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353747AbhGLICt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF3CA61879;
        Mon, 12 Jul 2021 07:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076624;
        bh=x/ZAvooZq+6qW7aleeg580YEvCOUqRUUXFjKFwpw0+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+dQ8tzb8Zr4xMai5N4do1PybuY3SLUndLhSoLJxiP5pTFjlUfVbIfTPlzfB6Bzxu
         L5rzZak2XjXN9qZYvpLxDKEc5Wv41eQRYoWIUDUT383IVNM8xx6OZd39f1W21YuOPc
         p4dyJiKASKGDRGmn1mC/2T0z9N7HN9qJe3ZMb9X8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 723/800] usb: phy: tegra: Correct definition of B_SESS_VLD_WAKEUP_EN bit
Date:   Mon, 12 Jul 2021 08:12:26 +0200
Message-Id: <20210712061043.659315195@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 7917e90667bc8dce02daa3c2e6df47f6fc9481f7 ]

The B_SESS_VLD_WAKEUP_EN bit 6 was added by a mistake in a previous
commit. This bit corresponds to B_SESS_END_WAKEUP_EN, which we don't use.
The B_VBUS_VLD_WAKEUP_EN doesn't exist at all and B_SESS_VLD_WAKEUP_EN
needs to be in place of it. We don't utilize B-sensors in the driver,
so it never was a problem, nevertheless let's correct the definition of
the bits.

Fixes: 35192007d28d ("usb: phy: tegra: Support waking up from a low power mode")
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20210613145936.9902-2-digetx@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/phy/phy-tegra-usb.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
index 10fafcf9801b..c0f432d509aa 100644
--- a/drivers/usb/phy/phy-tegra-usb.c
+++ b/drivers/usb/phy/phy-tegra-usb.c
@@ -58,8 +58,7 @@
 #define   USB_WAKEUP_DEBOUNCE_COUNT(x)		(((x) & 0x7) << 16)
 
 #define USB_PHY_VBUS_SENSORS			0x404
-#define   B_SESS_VLD_WAKEUP_EN			BIT(6)
-#define   B_VBUS_VLD_WAKEUP_EN			BIT(14)
+#define   B_SESS_VLD_WAKEUP_EN			BIT(14)
 #define   A_SESS_VLD_WAKEUP_EN			BIT(22)
 #define   A_VBUS_VLD_WAKEUP_EN			BIT(30)
 
@@ -545,7 +544,7 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
 
 		val = readl_relaxed(base + USB_PHY_VBUS_SENSORS);
 		val &= ~(A_VBUS_VLD_WAKEUP_EN | A_SESS_VLD_WAKEUP_EN);
-		val &= ~(B_VBUS_VLD_WAKEUP_EN | B_SESS_VLD_WAKEUP_EN);
+		val &= ~(B_SESS_VLD_WAKEUP_EN);
 		writel_relaxed(val, base + USB_PHY_VBUS_SENSORS);
 
 		val = readl_relaxed(base + UTMIP_BAT_CHRG_CFG0);
-- 
2.30.2



