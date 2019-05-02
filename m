Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B43811E26
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfEBP0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:26:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727243AbfEBP0h (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:26:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08BD520449;
        Thu,  2 May 2019 15:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810796;
        bh=wh/+CGYcjcOyd00zfoAleIkvjxkt7sjKpRDXbfPKTD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fNPoD6ag6WrC95QUS/KR0vpQ0BQ/bu5uXgxWD4U6CugfwaU5mGlfb5bC/IEF5fQz2
         60TZ9oq6x/K8jUK9N/tbLDi0NdqNgwjk/ebrE/lpVpGy017sR+2ugQwGzeWzUDbhAy
         /AREJ9MZ5B6IrGcgRa02aDX050xvY7x97jJn3h6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Jean Delvare <jdelvare@suse.de>,
        Wolfram Sang <wsa@the-dreams.de>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.19 32/72] i2c: i801: Add support for Intel Comet Lake
Date:   Thu,  2 May 2019 17:20:54 +0200
Message-Id: <20190502143336.054332206@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143333.437607839@linuxfoundation.org>
References: <20190502143333.437607839@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5cd1c56c42beb6d228cc8d4373fdc5f5ec78a5ad ]

Add PCI ID for Intel Comet Lake PCH.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 Documentation/i2c/busses/i2c-i801 | 1 +
 drivers/i2c/busses/Kconfig        | 1 +
 drivers/i2c/busses/i2c-i801.c     | 4 ++++
 3 files changed, 6 insertions(+)

diff --git a/Documentation/i2c/busses/i2c-i801 b/Documentation/i2c/busses/i2c-i801
index d1ee484a787d..ee9984f35868 100644
--- a/Documentation/i2c/busses/i2c-i801
+++ b/Documentation/i2c/busses/i2c-i801
@@ -36,6 +36,7 @@ Supported adapters:
   * Intel Cannon Lake (PCH)
   * Intel Cedar Fork (PCH)
   * Intel Ice Lake (PCH)
+  * Intel Comet Lake (PCH)
    Datasheets: Publicly available at the Intel website
 
 On Intel Patsburg and later chipsets, both the normal host SMBus controller
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index ac4b09642f63..8f803812ea24 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -131,6 +131,7 @@ config I2C_I801
 	    Cannon Lake (PCH)
 	    Cedar Fork (PCH)
 	    Ice Lake (PCH)
+	    Comet Lake (PCH)
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-i801.
diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index c91e145ef5a5..679c6c41f64b 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -71,6 +71,7 @@
  * Cannon Lake-LP (PCH)		0x9da3	32	hard	yes	yes	yes
  * Cedar Fork (PCH)		0x18df	32	hard	yes	yes	yes
  * Ice Lake-LP (PCH)		0x34a3	32	hard	yes	yes	yes
+ * Comet Lake (PCH)		0x02a3	32	hard	yes	yes	yes
  *
  * Features supported by this driver:
  * Software PEC				no
@@ -240,6 +241,7 @@
 #define PCI_DEVICE_ID_INTEL_LEWISBURG_SSKU_SMBUS	0xa223
 #define PCI_DEVICE_ID_INTEL_KABYLAKE_PCH_H_SMBUS	0xa2a3
 #define PCI_DEVICE_ID_INTEL_CANNONLAKE_H_SMBUS		0xa323
+#define PCI_DEVICE_ID_INTEL_COMETLAKE_SMBUS		0x02a3
 
 struct i801_mux_config {
 	char *gpio_chip;
@@ -1038,6 +1040,7 @@ static const struct pci_device_id i801_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_CANNONLAKE_H_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_CANNONLAKE_LP_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICELAKE_LP_SMBUS) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_COMETLAKE_SMBUS) },
 	{ 0, }
 };
 
@@ -1534,6 +1537,7 @@ static int i801_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	case PCI_DEVICE_ID_INTEL_DNV_SMBUS:
 	case PCI_DEVICE_ID_INTEL_KABYLAKE_PCH_H_SMBUS:
 	case PCI_DEVICE_ID_INTEL_ICELAKE_LP_SMBUS:
+	case PCI_DEVICE_ID_INTEL_COMETLAKE_SMBUS:
 		priv->features |= FEATURE_I2C_BLOCK_READ;
 		priv->features |= FEATURE_IRQ;
 		priv->features |= FEATURE_SMBUS_PEC;
-- 
2.19.1



