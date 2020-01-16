Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B911913F4D2
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389589AbgAPSwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:52:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:42450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389435AbgAPRId (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:08:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8FEE24679;
        Thu, 16 Jan 2020 17:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194512;
        bh=RBid+Qq/oMKKbGaIRbLd1k1uRq7RReLZptLuXOrbulQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fOKUHm3GAPVofYgixOuLbgT4t7I1BMQFlfIDn1gjP8Zg4qOPK9fz4+GjzjP3OVA2P
         pmSoUlpud98e1tqfQrpvJ+jES3qaY1SgGlTxS71XI6r/iyWUQa2cNUmfIzR3WaRukj
         O6zpnO82TKYHNeEBnlk7QFo/0zEe8tL3BvI57eYM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com
Subject: [PATCH AUTOSEL 4.19 406/671] phy: usb: phy-brcm-usb: Remove sysfs attributes upon driver removal
Date:   Thu, 16 Jan 2020 12:00:44 -0500
Message-Id: <20200116170509.12787-143-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit d9e100829fca6cbd270d7e005b0c0bb2d14924b8 ]

We are not destroying the sysfs attribute groupe we registered during
the probe function which will make subsequent probe calls to that
driver fail. Correct that with adding a remove function which only
removes those attributes since the reference counting on clocks did its
job already.

Fixes: 415060b21f31 ("phy: usb: phy-brcm-usb: Add ability to force DRD mode to host or device")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/broadcom/phy-brcm-usb.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/phy/broadcom/phy-brcm-usb.c b/drivers/phy/broadcom/phy-brcm-usb.c
index d1dab36fa5b7..e2455ffb8597 100644
--- a/drivers/phy/broadcom/phy-brcm-usb.c
+++ b/drivers/phy/broadcom/phy-brcm-usb.c
@@ -378,6 +378,13 @@ static int brcm_usb_phy_probe(struct platform_device *pdev)
 	return 0;
 }
 
+static int brcm_usb_phy_remove(struct platform_device *pdev)
+{
+	sysfs_remove_group(&pdev->dev.kobj, &brcm_usb_phy_group);
+
+	return 0;
+}
+
 #ifdef CONFIG_PM_SLEEP
 static int brcm_usb_phy_suspend(struct device *dev)
 {
@@ -443,6 +450,7 @@ MODULE_DEVICE_TABLE(of, brcm_usb_dt_ids);
 
 static struct platform_driver brcm_usb_driver = {
 	.probe		= brcm_usb_phy_probe,
+	.remove		= brcm_usb_phy_remove,
 	.driver		= {
 		.name	= "brcmstb-usb-phy",
 		.owner	= THIS_MODULE,
-- 
2.20.1

