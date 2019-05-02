Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F43111E8B
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbfEBPiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:38:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728647AbfEBPaI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:30:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB462214DA;
        Thu,  2 May 2019 15:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811007;
        bh=kZs4w61Wm8GmupGl4Zl/dizDqciv2pjqxJ5g7Jr4eVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MFczbivE7hIHqC0tW7KAP9u9P/YG7CyC+GF0iiAAc9pkNM/EdJAZ7IPYuEjxyB9C8
         SoPlSBaT2uacH6ebB5t0KbYEYaDxb0ZY2VBtJWia4Jh4kYifSeqtAYP8pLkg/ISMJi
         YJexW5O7GiIDd4z35HSSf0e94DauRO3d3icFC30k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Jean Delvare <jdelvare@suse.de>,
        Wolfram Sang <wsa@the-dreams.de>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 040/101] i2c: i801: Add support for Intel Comet Lake
Date:   Thu,  2 May 2019 17:20:42 +0200
Message-Id: <20190502143342.378307833@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
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
index f2c681971201..f8979abb9a19 100644
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



