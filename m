Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0BDA18A62A
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 22:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgCRVGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 17:06:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727932AbgCRUyk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 16:54:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3B5E2098B;
        Wed, 18 Mar 2020 20:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564879;
        bh=XWR/c2mFyUnFBcN4ZvpH7CqF7hzlvBkCtiq0tbgxXLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uTxgcdKCYwAqUCwZO2VGhTMd1SAQR2KhziCNccTbRIXKYq/pZZbokU5k0yx2bH2Vy
         CKiKdkTfdKML+FlTNB61/Sn8K/EPVVQ1rzp7DEnsVRfy511zmJDS+QWyEdZCnmLZyA
         5oI90SmyCPj9S05Og6rAl4QUnxgAPbWUAaw5AC4M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Martin Volf <martin.volf.42@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 49/73] i2c: i801: Do not add ICH_RES_IO_SMI for the iTCO_wdt device
Date:   Wed, 18 Mar 2020 16:53:13 -0400
Message-Id: <20200318205337.16279-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205337.16279-1-sashal@kernel.org>
References: <20200318205337.16279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 04bbb97d1b732b2d197f103c5818f5c214a4cf81 ]

Martin noticed that nct6775 driver does not load properly on his system
in v5.4+ kernels. The issue was bisected to commit b84398d6d7f9 ("i2c:
i801: Use iTCO version 6 in Cannon Lake PCH and beyond") but it is
likely not the culprit because the faulty code has been in the driver
already since commit 9424693035a5 ("i2c: i801: Create iTCO device on
newer Intel PCHs"). So more likely some commit that added PCI IDs of
recent chipsets made the driver to create the iTCO_wdt device on Martins
system.

The issue was debugged to be PCI configuration access to the PMC device
that is not present. This returns all 1's when read and this caused the
iTCO_wdt driver to accidentally request resourses used by nct6775.

It turns out that the SMI resource is only required for some ancient
systems, not the ones supported by this driver. For this reason do not
populate the SMI resource at all and drop all the related code. The
driver now always populates the main I/O resource and only in case of SPT
(Intel Sunrisepoint) compatible devices it adds another resource for the
NO_REBOOT bit. These two resources are of different types so
platform_get_resource() used by the iTCO_wdt driver continues to find
the both resources at index 0.

Link: https://lore.kernel.org/linux-hwmon/CAM1AHpQ4196tyD=HhBu-2donSsuogabkfP03v1YF26Q7_BgvgA@mail.gmail.com/
Fixes: 9424693035a5 ("i2c: i801: Create iTCO device on newer Intel PCHs")
[wsa: complete fix needs all of http://patchwork.ozlabs.org/project/linux-i2c/list/?series=160959&state=*]
Reported-by: Martin Volf <martin.volf.42@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-i801.c | 45 ++++++++++-------------------------
 1 file changed, 12 insertions(+), 33 deletions(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index f1c714acc2806..3ff6fbd79b127 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -129,11 +129,6 @@
 #define TCOBASE		0x050
 #define TCOCTL		0x054
 
-#define ACPIBASE		0x040
-#define ACPIBASE_SMI_OFF	0x030
-#define ACPICTRL		0x044
-#define ACPICTRL_EN		0x080
-
 #define SBREG_BAR		0x10
 #define SBREG_SMBCTRL		0xc6000c
 #define SBREG_SMBCTRL_DNV	0xcf000c
@@ -1544,7 +1539,7 @@ i801_add_tco_spt(struct i801_priv *priv, struct pci_dev *pci_dev,
 		pci_bus_write_config_byte(pci_dev->bus, devfn, 0xe1, hidden);
 	spin_unlock(&p2sb_spinlock);
 
-	res = &tco_res[ICH_RES_MEM_OFF];
+	res = &tco_res[1];
 	if (pci_dev->device == PCI_DEVICE_ID_INTEL_DNV_SMBUS)
 		res->start = (resource_size_t)base64_addr + SBREG_SMBCTRL_DNV;
 	else
@@ -1554,7 +1549,7 @@ i801_add_tco_spt(struct i801_priv *priv, struct pci_dev *pci_dev,
 	res->flags = IORESOURCE_MEM;
 
 	return platform_device_register_resndata(&pci_dev->dev, "iTCO_wdt", -1,
-					tco_res, 3, &spt_tco_platform_data,
+					tco_res, 2, &spt_tco_platform_data,
 					sizeof(spt_tco_platform_data));
 }
 
@@ -1567,17 +1562,16 @@ static struct platform_device *
 i801_add_tco_cnl(struct i801_priv *priv, struct pci_dev *pci_dev,
 		 struct resource *tco_res)
 {
-	return platform_device_register_resndata(&pci_dev->dev, "iTCO_wdt", -1,
-					tco_res, 2, &cnl_tco_platform_data,
-					sizeof(cnl_tco_platform_data));
+	return platform_device_register_resndata(&pci_dev->dev,
+			"iTCO_wdt", -1, tco_res, 1, &cnl_tco_platform_data,
+			sizeof(cnl_tco_platform_data));
 }
 
 static void i801_add_tco(struct i801_priv *priv)
 {
-	u32 base_addr, tco_base, tco_ctl, ctrl_val;
 	struct pci_dev *pci_dev = priv->pci_dev;
-	struct resource tco_res[3], *res;
-	unsigned int devfn;
+	struct resource tco_res[2], *res;
+	u32 tco_base, tco_ctl;
 
 	/* If we have ACPI based watchdog use that instead */
 	if (acpi_has_watchdog())
@@ -1592,30 +1586,15 @@ static void i801_add_tco(struct i801_priv *priv)
 		return;
 
 	memset(tco_res, 0, sizeof(tco_res));
-
-	res = &tco_res[ICH_RES_IO_TCO];
-	res->start = tco_base & ~1;
-	res->end = res->start + 32 - 1;
-	res->flags = IORESOURCE_IO;
-
 	/*
-	 * Power Management registers.
+	 * Always populate the main iTCO IO resource here. The second entry
+	 * for NO_REBOOT MMIO is filled by the SPT specific function.
 	 */
-	devfn = PCI_DEVFN(PCI_SLOT(pci_dev->devfn), 2);
-	pci_bus_read_config_dword(pci_dev->bus, devfn, ACPIBASE, &base_addr);
-
-	res = &tco_res[ICH_RES_IO_SMI];
-	res->start = (base_addr & ~1) + ACPIBASE_SMI_OFF;
-	res->end = res->start + 3;
+	res = &tco_res[0];
+	res->start = tco_base & ~1;
+	res->end = res->start + 32 - 1;
 	res->flags = IORESOURCE_IO;
 
-	/*
-	 * Enable the ACPI I/O space.
-	 */
-	pci_bus_read_config_dword(pci_dev->bus, devfn, ACPICTRL, &ctrl_val);
-	ctrl_val |= ACPICTRL_EN;
-	pci_bus_write_config_dword(pci_dev->bus, devfn, ACPICTRL, ctrl_val);
-
 	if (priv->features & FEATURE_TCO_CNL)
 		priv->tco_pdev = i801_add_tco_cnl(priv, pci_dev, tco_res);
 	else
-- 
2.20.1

