Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2346137DBF
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbgAKKAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:00:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:57562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729064AbgAKKAv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:00:51 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB8A92082E;
        Sat, 11 Jan 2020 10:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736850;
        bh=/m9tjbU0+CnjBeSRGS7TlOATIewy4GJ57V1oDDytE78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGYCuhWEn3PwxG7+b4Z2VoHfcqnw8aA/uD9N2frMlafWGfoZJ+xrM+XmyAd9uC6pH
         J8KPgw8lnH8sFFW2/62TEgPUmRXxZc8kcAHxfEOZqAKK6O6DrSPj8SxCQ3r56+0Vio
         O3izB+t22FDLKUYsO4/epRSLnlwKBRB03Fa48d90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.9 28/91] ata: ahci_brcm: Fix AHCI resources management
Date:   Sat, 11 Jan 2020 10:49:21 +0100
Message-Id: <20200111094854.961696898@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094844.748507863@linuxfoundation.org>
References: <20200111094844.748507863@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit c0cdf2ac4b5bf3e5ef2451ea29fb4104278cdabc upstream.

The AHCI resources management within ahci_brcm.c is a little
convoluted, largely because it historically had a dedicated clock that
was managed within this file in the downstream tree. Once brough
upstream though, the clock was left to be managed by libahci_platform.c
which is entirely appropriate.

This patch series ensures that the AHCI resources are fetched and
enabled before any register access is done, thus avoiding bus errors on
platforms which clock gate the controller by default.

As a result we need to re-arrange the suspend() and resume() functions
in order to avoid accessing registers after the clocks have been turned
off respectively before the clocks have been turned on. Finally, we can
refactor brcm_ahci_get_portmask() in order to fetch the number of ports
from hpriv->mmio which is now accessible without jumping through hoops
like we used to do.

The commit pointed in the Fixes tag is both old and new enough not to
require major headaches for backporting of this patch.

Fixes: eba68f829794 ("ata: ahci_brcmstb: rename to support across Broadcom SoC's")
Cc: stable@vger.kernel.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci_brcm.c |  105 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 76 insertions(+), 29 deletions(-)

--- a/drivers/ata/ahci_brcm.c
+++ b/drivers/ata/ahci_brcm.c
@@ -228,19 +228,12 @@ static void brcm_sata_phys_disable(struc
 			brcm_sata_phy_disable(priv, i);
 }
 
-static u32 brcm_ahci_get_portmask(struct platform_device *pdev,
+static u32 brcm_ahci_get_portmask(struct ahci_host_priv *hpriv,
 				  struct brcm_ahci_priv *priv)
 {
-	void __iomem *ahci;
-	struct resource *res;
 	u32 impl;
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ahci");
-	ahci = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(ahci))
-		return 0;
-
-	impl = readl(ahci + HOST_PORTS_IMPL);
+	impl = readl(hpriv->mmio + HOST_PORTS_IMPL);
 
 	if (fls(impl) > SATA_TOP_MAX_PHYS)
 		dev_warn(priv->dev, "warning: more ports than PHYs (%#x)\n",
@@ -248,9 +241,6 @@ static u32 brcm_ahci_get_portmask(struct
 	else if (!impl)
 		dev_info(priv->dev, "no ports found\n");
 
-	devm_iounmap(&pdev->dev, ahci);
-	devm_release_mem_region(&pdev->dev, res->start, resource_size(res));
-
 	return impl;
 }
 
@@ -277,11 +267,10 @@ static int brcm_ahci_suspend(struct devi
 	struct ata_host *host = dev_get_drvdata(dev);
 	struct ahci_host_priv *hpriv = host->private_data;
 	struct brcm_ahci_priv *priv = hpriv->plat_data;
-	int ret;
 
-	ret = ahci_platform_suspend(dev);
 	brcm_sata_phys_disable(priv);
-	return ret;
+
+	return ahci_platform_suspend(dev);
 }
 
 static int brcm_ahci_resume(struct device *dev)
@@ -289,11 +278,44 @@ static int brcm_ahci_resume(struct devic
 	struct ata_host *host = dev_get_drvdata(dev);
 	struct ahci_host_priv *hpriv = host->private_data;
 	struct brcm_ahci_priv *priv = hpriv->plat_data;
+	int ret;
+
+	/* Make sure clocks are turned on before re-configuration */
+	ret = ahci_platform_enable_clks(hpriv);
+	if (ret)
+		return ret;
 
 	brcm_sata_init(priv);
 	brcm_sata_phys_enable(priv);
 	brcm_sata_alpm_init(hpriv);
-	return ahci_platform_resume(dev);
+
+	/* Since we had to enable clocks earlier on, we cannot use
+	 * ahci_platform_resume() as-is since a second call to
+	 * ahci_platform_enable_resources() would bump up the resources
+	 * (regulators, clocks, PHYs) count artificially so we copy the part
+	 * after ahci_platform_enable_resources().
+	 */
+	ret = ahci_platform_enable_phys(hpriv);
+	if (ret)
+		goto out_disable_phys;
+
+	ret = ahci_platform_resume_host(dev);
+	if (ret)
+		goto out_disable_platform_phys;
+
+	/* We resumed so update PM runtime state */
+	pm_runtime_disable(dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
+	return 0;
+
+out_disable_platform_phys:
+	ahci_platform_disable_phys(hpriv);
+out_disable_phys:
+	brcm_sata_phys_disable(priv);
+	ahci_platform_disable_clks(hpriv);
+	return ret;
 }
 #endif
 
@@ -345,37 +367,62 @@ static int brcm_ahci_probe(struct platfo
 		priv->quirks |= BRCM_AHCI_QUIRK_SKIP_PHY_ENABLE;
 	}
 
+	hpriv = ahci_platform_get_resources(pdev);
+	if (IS_ERR(hpriv)) {
+		ret = PTR_ERR(hpriv);
+		goto out_reset;
+	}
+
+	ret = ahci_platform_enable_clks(hpriv);
+	if (ret)
+		goto out_reset;
+
+	/* Must be first so as to configure endianness including that
+	 * of the standard AHCI register space.
+	 */
 	brcm_sata_init(priv);
 
-	priv->port_mask = brcm_ahci_get_portmask(pdev, priv);
-	if (!priv->port_mask)
-		return -ENODEV;
+	/* Initializes priv->port_mask which is used below */
+	priv->port_mask = brcm_ahci_get_portmask(hpriv, priv);
+	if (!priv->port_mask) {
+		ret = -ENODEV;
+		goto out_disable_clks;
+	}
 
+	/* Must be done before ahci_platform_enable_phys() */
 	brcm_sata_phys_enable(priv);
 
-	hpriv = ahci_platform_get_resources(pdev);
-	if (IS_ERR(hpriv))
-		return PTR_ERR(hpriv);
 	hpriv->plat_data = priv;
 	hpriv->flags = AHCI_HFLAG_WAKE_BEFORE_STOP;
 
 	brcm_sata_alpm_init(hpriv);
 
-	ret = ahci_platform_enable_resources(hpriv);
-	if (ret)
-		return ret;
-
 	if (priv->quirks & BRCM_AHCI_QUIRK_NO_NCQ)
 		hpriv->flags |= AHCI_HFLAG_NO_NCQ;
 
+	ret = ahci_platform_enable_phys(hpriv);
+	if (ret)
+		goto out_disable_phys;
+
 	ret = ahci_platform_init_host(pdev, hpriv, &ahci_brcm_port_info,
 				      &ahci_platform_sht);
 	if (ret)
-		return ret;
+		goto out_disable_platform_phys;
 
 	dev_info(dev, "Broadcom AHCI SATA3 registered\n");
 
 	return 0;
+
+out_disable_platform_phys:
+	ahci_platform_disable_phys(hpriv);
+out_disable_phys:
+	brcm_sata_phys_disable(priv);
+out_disable_clks:
+	ahci_platform_disable_clks(hpriv);
+out_reset:
+	if (!IS_ERR_OR_NULL(priv->rcdev))
+		reset_control_assert(priv->rcdev);
+	return ret;
 }
 
 static int brcm_ahci_remove(struct platform_device *pdev)
@@ -385,12 +432,12 @@ static int brcm_ahci_remove(struct platf
 	struct brcm_ahci_priv *priv = hpriv->plat_data;
 	int ret;
 
+	brcm_sata_phys_disable(priv);
+
 	ret = ata_platform_remove_one(pdev);
 	if (ret)
 		return ret;
 
-	brcm_sata_phys_disable(priv);
-
 	return 0;
 }
 


