Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5731B31146C
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbhBEWFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:05:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232950AbhBEO5b (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:57:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 999F86504F;
        Fri,  5 Feb 2021 14:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534333;
        bh=qr/yoZLausju5Sx+LBJnDBabV2P0SvQK/CaAIESv2vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GFR4nIGoIX/VlnJyGvn2ebGfeAOKc26qha42AR+Fm9Irmw+zrkcI1oUkesE3BGnpS
         kP0OU0FYruwnHfJAwBlERIIbAvjjuQVfieN2qEjQI8wq2DvqMTVunALmKXKPkb6GYS
         laVONta9jNTsLLKzYlLrPinQiLWq/p9y7B33dcdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 14/32] phy: cpcap-usb: Fix warning for missing regulator_disable
Date:   Fri,  5 Feb 2021 15:07:29 +0100
Message-Id: <20210205140652.948803445@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140652.348864025@linuxfoundation.org>
References: <20210205140652.348864025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 764257d9069a9c19758b626cc1ba4ae079335d9e ]

On deferred probe, we will get the following splat:

cpcap-usb-phy cpcap-usb-phy.0: could not initialize VBUS or ID IIO: -517
WARNING: CPU: 0 PID: 21 at drivers/regulator/core.c:2123 regulator_put+0x68/0x78
...
(regulator_put) from [<c068ebf0>] (release_nodes+0x1b4/0x1fc)
(release_nodes) from [<c068a9a4>] (really_probe+0x104/0x4a0)
(really_probe) from [<c068b034>] (driver_probe_device+0x58/0xb4)

Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20201230102105.11826-1-tony@atomide.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/motorola/phy-cpcap-usb.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/phy/motorola/phy-cpcap-usb.c b/drivers/phy/motorola/phy-cpcap-usb.c
index 5baf64dfb24de..1bebad36bf2e5 100644
--- a/drivers/phy/motorola/phy-cpcap-usb.c
+++ b/drivers/phy/motorola/phy-cpcap-usb.c
@@ -625,35 +625,42 @@ static int cpcap_usb_phy_probe(struct platform_device *pdev)
 	generic_phy = devm_phy_create(ddata->dev, NULL, &ops);
 	if (IS_ERR(generic_phy)) {
 		error = PTR_ERR(generic_phy);
-		return PTR_ERR(generic_phy);
+		goto out_reg_disable;
 	}
 
 	phy_set_drvdata(generic_phy, ddata);
 
 	phy_provider = devm_of_phy_provider_register(ddata->dev,
 						     of_phy_simple_xlate);
-	if (IS_ERR(phy_provider))
-		return PTR_ERR(phy_provider);
+	if (IS_ERR(phy_provider)) {
+		error = PTR_ERR(phy_provider);
+		goto out_reg_disable;
+	}
 
 	error = cpcap_usb_init_optional_pins(ddata);
 	if (error)
-		return error;
+		goto out_reg_disable;
 
 	cpcap_usb_init_optional_gpios(ddata);
 
 	error = cpcap_usb_init_iio(ddata);
 	if (error)
-		return error;
+		goto out_reg_disable;
 
 	error = cpcap_usb_init_interrupts(pdev, ddata);
 	if (error)
-		return error;
+		goto out_reg_disable;
 
 	usb_add_phy_dev(&ddata->phy);
 	atomic_set(&ddata->active, 1);
 	schedule_delayed_work(&ddata->detect_work, msecs_to_jiffies(1));
 
 	return 0;
+
+out_reg_disable:
+	regulator_disable(ddata->vusb);
+
+	return error;
 }
 
 static int cpcap_usb_phy_remove(struct platform_device *pdev)
-- 
2.27.0



