Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E29071481F2
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390818AbgAXLYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:24:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:36968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388606AbgAXLX6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:23:58 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8EDA206D4;
        Fri, 24 Jan 2020 11:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865037;
        bh=133xA4VF1oQQJFYUCOcynO9vUt/JVJBclCo/934+ItE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yxNrM9asotGkvmPbcqQAT+7QjXmT+wXG31h1iJkvZmbyw87JY4Vrdc9DRvi7DRiH+
         P4JgQnUMWWRmZ2UCno692Kqwqe2YM18uwsqcD6+8ajvfF2Q+xZ2COV7EuLAoLZt0xM
         eNnU+ixr2q3siYEr5OtU8jjGrzkmVRII/ROwi5Ic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 421/639] phy: usb: phy-brcm-usb: Remove sysfs attributes upon driver removal
Date:   Fri, 24 Jan 2020 10:29:51 +0100
Message-Id: <20200124093139.812496508@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index d1dab36fa5b7b..e2455ffb85979 100644
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



