Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18CFE12C95E
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbfL2SGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:06:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:33596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731686AbfL2Rtl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:49:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C94C8206A4;
        Sun, 29 Dec 2019 17:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641780;
        bh=NNXekNtXdNf+DdK1b33AJEUCouQqwbzXFl1ip74gVWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bihry9P3qmH1mne4/7H4B91cbMAkJN3jn8Qjn5yZqivrhNbczSfVA6AZmxb9n9ist
         QQSWNHHA+uJJ4Ll5/DF1IbYVXQkkfvpvnJ1qy/solryIkE5L7esbZEDUPDuONvRcRz
         EzFO2YRQI55R75EXwpwA7i9dv2NqzJ+tbVDHdZKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 208/434] phy: qcom-usb-hs: Fix extcon double register after power cycle
Date:   Sun, 29 Dec 2019 18:24:21 +0100
Message-Id: <20191229172715.644527022@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 64f86b9978449ff05bfa6c64b4c5439e21e9c80b ]

Commit f0b5c2c96370 ("phy: qcom-usb-hs: Replace the extcon API")
switched from extcon_register_notifier() to the resource-managed
API, i.e. devm_extcon_register_notifier().

This is problematic in this case, because the extcon notifier
is dynamically registered/unregistered whenever the PHY is powered
on/off. The resource-managed API does not unregister the notifier
until the driver is removed, so as soon as the PHY is power cycled,
attempting to register the notifier again results in:

	double register detected
	WARNING: CPU: 1 PID: 182 at kernel/notifier.c:26 notifier_chain_register+0x74/0xa0
	Call trace:
	 ...
	 extcon_register_notifier+0x74/0xb8
	 devm_extcon_register_notifier+0x54/0xb8
	 qcom_usb_hs_phy_power_on+0x1fc/0x208
	 ...

... and USB stops working after plugging the cable out and in
another time.

The easiest way to fix this is to make a partial revert of
commit f0b5c2c96370 ("phy: qcom-usb-hs: Replace the extcon API")
and avoid using the resource-managed API in this case.

Fixes: f0b5c2c96370 ("phy: qcom-usb-hs: Replace the extcon API")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-usb-hs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-usb-hs.c b/drivers/phy/qualcomm/phy-qcom-usb-hs.c
index b163b3a1558d..61054272a7c8 100644
--- a/drivers/phy/qualcomm/phy-qcom-usb-hs.c
+++ b/drivers/phy/qualcomm/phy-qcom-usb-hs.c
@@ -158,8 +158,8 @@ static int qcom_usb_hs_phy_power_on(struct phy *phy)
 		/* setup initial state */
 		qcom_usb_hs_phy_vbus_notifier(&uphy->vbus_notify, state,
 					      uphy->vbus_edev);
-		ret = devm_extcon_register_notifier(&ulpi->dev, uphy->vbus_edev,
-				EXTCON_USB, &uphy->vbus_notify);
+		ret = extcon_register_notifier(uphy->vbus_edev, EXTCON_USB,
+					       &uphy->vbus_notify);
 		if (ret)
 			goto err_ulpi;
 	}
@@ -180,6 +180,9 @@ static int qcom_usb_hs_phy_power_off(struct phy *phy)
 {
 	struct qcom_usb_hs_phy *uphy = phy_get_drvdata(phy);
 
+	if (uphy->vbus_edev)
+		extcon_unregister_notifier(uphy->vbus_edev, EXTCON_USB,
+					   &uphy->vbus_notify);
 	regulator_disable(uphy->v3p3);
 	regulator_disable(uphy->v1p8);
 	clk_disable_unprepare(uphy->sleep_clk);
-- 
2.20.1



