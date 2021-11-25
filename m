Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0EB45D208
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 01:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244992AbhKYAbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 19:31:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:45994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245499AbhKYA3c (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 19:29:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16E8C610A7;
        Thu, 25 Nov 2021 00:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637799982;
        bh=5WXN6G9uRT3t8lz5/whVrC8GNOM5x70zs62sPU2b8lI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FRMM7tysng2+G070YEuvpdMlzudib7A3+u1OdglA1FrTA6/ADSZfBjAmQQmSOq+L1
         Ha9K/MZB0q80nHQKsN9HYav1MQLE/w4IEohEbw8G27QhbU0dI2SH8hJkhtkYhTPqM3
         BmV4t0nwpGvhZebbltz0yYb1jq25FpP0Go22CwqJ/onvyZgd6xYflD1pzTqrPFTeEy
         DWVbooLsHmoQduZuMrK7eVuNBTcqlYYPba+BZJr0/7olKezdnOxLmyvPozNf5CpGg/
         HoZABwUKiSB4h72VMtqQtW+ZrvXZFYFC69FcsDz75YVLNNlB1ITdIf0h+aY82oUa83
         J52LI/X2G9JYQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        Remi Pommarel <repk@triplefau.lt>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.4 01/22] PCI: aardvark: Wait for endpoint to be ready before training link
Date:   Thu, 25 Nov 2021 01:25:55 +0100
Message-Id: <20211125002616.31363-2-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211125002616.31363-1-kabel@kernel.org>
References: <20211125002616.31363-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Remi Pommarel <repk@triplefau.lt>

commit f4c7d053d7f77cd5c1a1ba7c7ce085ddba13d1d7 upstream.

When configuring pcie reset pin from gpio (e.g. initially set by
u-boot) to pcie function this pin goes low for a brief moment
asserting the PERST# signal. Thus connected device enters fundamental
reset process and link configuration can only begin after a minimal
100ms delay (see [1]).

Because the pin configuration comes from the "default" pinctrl it is
implicitly configured before the probe callback is called:

driver_probe_device()
  really_probe()
    ...
    pinctrl_bind_pins() /* Here pin goes from gpio to PCIE reset
                           function and PERST# is asserted */
    ...
    drv->probe()

[1] "PCI Express Base Specification", REV. 4.0
    PCI Express, February 19 2014, 6.6.1 Conventional Reset

Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 45794ba643d4..9774896397b0 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -432,6 +432,14 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 	reg |= PIO_CTRL_ADDR_WIN_DISABLE;
 	advk_writel(pcie, reg, PIO_CTRL);
 
+	/*
+	 * PERST# signal could have been asserted by pinctrl subsystem before
+	 * probe() callback has been called, making the endpoint going into
+	 * fundamental reset. As required by PCI Express spec a delay for at
+	 * least 100ms after such a reset before link training is needed.
+	 */
+	msleep(PCI_PM_D3COLD_WAIT);
+
 	/* Start link training */
 	reg = advk_readl(pcie, PCIE_CORE_LINK_CTRL_STAT_REG);
 	reg |= PCIE_CORE_LINK_TRAINING;
-- 
2.32.0

