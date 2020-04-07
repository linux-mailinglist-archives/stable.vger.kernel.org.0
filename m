Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD3691A0BAF
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbgDGKZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:25:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728382AbgDGKZa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:25:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44F972078C;
        Tue,  7 Apr 2020 10:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255129;
        bh=o3tP7Cu4+TLVKKugQELhD56pEd5zccyb22KcNkQy/QE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PBdLnQOo043FAP32tqqVHXOlFhD6fBS4DqcUcdvO6GHgQz4qyt8p+HBZ2jQaixMY7
         WkHvRDAZKrr1y+Zs99t2rc8IO3Q3QznBmS9YpM3jgyvzRga/1HFdV30MIIeiD3B7Hw
         /iS0w6VxSIiyr/T4i2OUJU8uY2BIM0Hj29sxHjo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Volf <martin.volf.42@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 5.5 42/46] i2c: i801: Do not add ICH_RES_IO_SMI for the iTCO_wdt device
Date:   Tue,  7 Apr 2020 12:22:13 +0200
Message-Id: <20200407101503.858623897@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101459.502593074@linuxfoundation.org>
References: <20200407101459.502593074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 04bbb97d1b732b2d197f103c5818f5c214a4cf81 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-i801.c |   45 +++++++++++-------------------------------
 1 file changed, 12 insertions(+), 33 deletions(-)

--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -131,11 +131,6 @@
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
@@ -1550,7 +1545,7 @@ i801_add_tco_spt(struct i801_priv *priv,
 		pci_bus_write_config_byte(pci_dev->bus, devfn, 0xe1, hidden);
 	spin_unlock(&p2sb_spinlock);
 
-	res = &tco_res[ICH_RES_MEM_OFF];
+	res = &tco_res[1];
 	if (pci_dev->device == PCI_DEVICE_ID_INTEL_DNV_SMBUS)
 		res->start = (resource_size_t)base64_addr + SBREG_SMBCTRL_DNV;
 	else
@@ -1560,7 +1555,7 @@ i801_add_tco_spt(struct i801_priv *priv,
 	res->flags = IORESOURCE_MEM;
 
 	return platform_device_register_resndata(&pci_dev->dev, "iTCO_wdt", -1,
-					tco_res, 3, &spt_tco_platform_data,
+					tco_res, 2, &spt_tco_platform_data,
 					sizeof(spt_tco_platform_data));
 }
 
@@ -1573,17 +1568,16 @@ static struct platform_device *
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
@@ -1598,30 +1592,15 @@ static void i801_add_tco(struct i801_pri
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


