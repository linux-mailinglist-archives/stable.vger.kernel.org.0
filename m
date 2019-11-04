Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26EE3EEF72
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388673AbfKDV5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:57:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:54436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388662AbfKDV5w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:57:52 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28AB6214D8;
        Mon,  4 Nov 2019 21:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904670;
        bh=C75VLfqpVWlTQjWho7nVElo2KOBDwPzs8aywPc+W+pQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VaWFmCiNYZQIGrroWROvfkCvqT90TahuC4xY7Q+x6Dxv6vCaP0epItih265ckrXYN
         MrUQ5cBf0zrLv5S94Y3vCmDBjGoCyHlJcWt4gQSj8fQqV8s1MPtVYWn0VSxqkuayvi
         QtM5dGhJCVntOGDRxuEVs9gyeoXCVNnnvBb0gZTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Alan Cox <alan@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Darren Hart <dvhart@infradead.org>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 028/149] platform/x86: Fix config space access for intel_atomisp2_pm
Date:   Mon,  4 Nov 2019 22:43:41 +0100
Message-Id: <20191104212137.759598580@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 6a31061833a52a79c99221b6251db08cf377470e ]

We lose even config space access when we power gate the ISP
via the PUNIT. That makes lspci & co. produce gibberish.

To fix that let's try to implement actual runtime pm hooks
and inform the pci core that the device always goes to
D3cold. That will cause the pci core to resume the device
before attempting config space access.

This introduces another annoyance though. We get the
following error every time we try to resume the device:
intel_atomisp2_pm 0000:00:03.0: Refused to change power state, currently in D3

The reason being that the pci core tries to put the device
back into D0 via the standard PCI PM mechanism before
calling the driver resume hook. To fix this properly
we'd need to infiltrate the platform pm hooks (could
turn ugly real fast), or use pm domains (which don't
seem to exist on x86), or some extra early resume
hook for the driver (which doesn't exist either).
So maybe we just choose to live with the error?

Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Darren Hart <dvhart@infradead.org>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_atomisp2_pm.c | 68 +++++++++++++++++-------
 1 file changed, 48 insertions(+), 20 deletions(-)

diff --git a/drivers/platform/x86/intel_atomisp2_pm.c b/drivers/platform/x86/intel_atomisp2_pm.c
index 4a2ec5eeb6d8a..b0f421fea2a58 100644
--- a/drivers/platform/x86/intel_atomisp2_pm.c
+++ b/drivers/platform/x86/intel_atomisp2_pm.c
@@ -33,46 +33,45 @@
 #define ISPSSPM0_IUNIT_POWER_ON		0x0
 #define ISPSSPM0_IUNIT_POWER_OFF	0x3
 
-static int isp_probe(struct pci_dev *dev, const struct pci_device_id *id)
+static int isp_set_power(struct pci_dev *dev, bool enable)
 {
 	unsigned long timeout;
-	u32 val;
-
-	pci_write_config_dword(dev, PCI_INTERRUPT_CTRL, 0);
-
-	/*
-	 * MRFLD IUNIT DPHY is located in an always-power-on island
-	 * MRFLD HW design need all CSI ports are disabled before
-	 * powering down the IUNIT.
-	 */
-	pci_read_config_dword(dev, PCI_CSI_CONTROL, &val);
-	val |= PCI_CSI_CONTROL_PORTS_OFF_MASK;
-	pci_write_config_dword(dev, PCI_CSI_CONTROL, val);
+	u32 val = enable ? ISPSSPM0_IUNIT_POWER_ON :
+		ISPSSPM0_IUNIT_POWER_OFF;
 
-	/* Write 0x3 to ISPSSPM0 bit[1:0] to power off the IUNIT */
+	/* Write to ISPSSPM0 bit[1:0] to power on/off the IUNIT */
 	iosf_mbi_modify(BT_MBI_UNIT_PMC, MBI_REG_READ, ISPSSPM0,
-			ISPSSPM0_IUNIT_POWER_OFF, ISPSSPM0_ISPSSC_MASK);
+			val, ISPSSPM0_ISPSSC_MASK);
 
 	/*
 	 * There should be no IUNIT access while power-down is
 	 * in progress HW sighting: 4567865
 	 * Wait up to 50 ms for the IUNIT to shut down.
+	 * And we do the same for power on.
 	 */
 	timeout = jiffies + msecs_to_jiffies(50);
 	while (1) {
-		/* Wait until ISPSSPM0 bit[25:24] shows 0x3 */
-		iosf_mbi_read(BT_MBI_UNIT_PMC, MBI_REG_READ, ISPSSPM0, &val);
-		val = (val & ISPSSPM0_ISPSSS_MASK) >> ISPSSPM0_ISPSSS_OFFSET;
-		if (val == ISPSSPM0_IUNIT_POWER_OFF)
+		u32 tmp;
+
+		/* Wait until ISPSSPM0 bit[25:24] shows the right value */
+		iosf_mbi_read(BT_MBI_UNIT_PMC, MBI_REG_READ, ISPSSPM0, &tmp);
+		tmp = (tmp & ISPSSPM0_ISPSSS_MASK) >> ISPSSPM0_ISPSSS_OFFSET;
+		if (tmp == val)
 			break;
 
 		if (time_after(jiffies, timeout)) {
-			dev_err(&dev->dev, "IUNIT power-off timeout.\n");
+			dev_err(&dev->dev, "IUNIT power-%s timeout.\n",
+				enable ? "on" : "off");
 			return -EBUSY;
 		}
 		usleep_range(1000, 2000);
 	}
 
+	return 0;
+}
+
+static int isp_probe(struct pci_dev *dev, const struct pci_device_id *id)
+{
 	pm_runtime_allow(&dev->dev);
 	pm_runtime_put_sync_suspend(&dev->dev);
 
@@ -87,11 +86,40 @@ static void isp_remove(struct pci_dev *dev)
 
 static int isp_pci_suspend(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
+	u32 val;
+
+	pci_write_config_dword(pdev, PCI_INTERRUPT_CTRL, 0);
+
+	/*
+	 * MRFLD IUNIT DPHY is located in an always-power-on island
+	 * MRFLD HW design need all CSI ports are disabled before
+	 * powering down the IUNIT.
+	 */
+	pci_read_config_dword(pdev, PCI_CSI_CONTROL, &val);
+	val |= PCI_CSI_CONTROL_PORTS_OFF_MASK;
+	pci_write_config_dword(pdev, PCI_CSI_CONTROL, val);
+
+	/*
+	 * We lose config space access when punit power gates
+	 * the ISP. Can't use pci_set_power_state() because
+	 * pmcsr won't actually change when we write to it.
+	 */
+	pci_save_state(pdev);
+	pdev->current_state = PCI_D3cold;
+	isp_set_power(pdev, false);
+
 	return 0;
 }
 
 static int isp_pci_resume(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	isp_set_power(pdev, true);
+	pdev->current_state = PCI_D0;
+	pci_restore_state(pdev);
+
 	return 0;
 }
 
-- 
2.20.1



