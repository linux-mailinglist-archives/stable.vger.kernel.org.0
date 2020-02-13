Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8FA15C12B
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbgBMPPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:15:07 -0500
Received: from mga12.intel.com ([192.55.52.136]:61547 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgBMPPH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:15:07 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Feb 2020 07:15:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,437,1574150400"; 
   d="scan'208";a="227114683"
Received: from mylly.fi.intel.com (HELO mylly.fi.intel.com.) ([10.237.72.54])
  by fmsmga007.fm.intel.com with ESMTP; 13 Feb 2020 07:15:05 -0800
From:   Jarkko Nikula <jarkko.nikula@linux.intel.com>
To:     linux-i2c@vger.kernel.org
Cc:     Wolfram Sang <wsa@the-dreams.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] i2c: designware-pci: Fix BUG_ON during device removal
Date:   Thu, 13 Feb 2020 17:15:03 +0200
Message-Id: <20200213151503.545269-1-jarkko.nikula@linux.intel.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Function i2c_dw_pci_remove() -> pci_free_irq_vectors() ->
pci_disable_msi() -> free_msi_irqs() will throw a BUG_ON() for MSI
enabled device since the driver has not released the requested IRQ before
calling the pci_free_irq_vectors().

Here driver requests an IRQ using devm_request_irq() but automatic
release happens only after remove callback. Fix this by explicitly
freeing the IRQ before calling pci_free_irq_vectors().

Fixes: 21aa3983d619 ("i2c: designware-pci: Switch over to MSI interrupts")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
---
 drivers/i2c/busses/i2c-designware-pcidrv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index 050adda7c1bd..05b35ac33ce3 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -313,6 +313,7 @@ static void i2c_dw_pci_remove(struct pci_dev *pdev)
 	pm_runtime_get_noresume(&pdev->dev);
 
 	i2c_del_adapter(&dev->adapter);
+	devm_free_irq(&pdev->dev, dev->irq, dev);
 	pci_free_irq_vectors(pdev);
 }
 
-- 
2.25.0

