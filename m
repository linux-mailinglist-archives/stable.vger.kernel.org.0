Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4683B3A1B78
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 19:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbhFIRG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 13:06:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231303AbhFIRGz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 13:06:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75EA3613D0;
        Wed,  9 Jun 2021 17:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623258300;
        bh=HwA9vfLqC/L0DDzj6OjBUk165vyATdoHE9IJGyHv7gQ=;
        h=Subject:To:From:Date:From;
        b=FHuzGT4LrptPbkPOzaYsGlxqibVc79BQSx4KUusQX3pJvDZEkBNnCTZG1O/d6H567
         0JjHIFtOgCB73kXmiuKtptCNqclF1k7T9PXSz9bEcH2RhY0/lv6Y+0MSd2bMhDXD9K
         W7NuqzDfWnuUsPEcbR8CHzFG8JkN08HQ9EHd/rrc=
Subject: patch "bus: mhi: pci-generic: Fix hibernation" added to char-misc-linus
To:     loic.poulain@linaro.org, gregkh@linuxfoundation.org,
        manivannan.sadhasivam@linaro.org, stable@vger.kernel.org,
        wsj20369@163.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Jun 2021 19:04:49 +0200
Message-ID: <16232582891676@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    bus: mhi: pci-generic: Fix hibernation

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5f0c2ee1fe8de700dd0d1cdc63e1a7338e2d3a3d Mon Sep 17 00:00:00 2001
From: Loic Poulain <loic.poulain@linaro.org>
Date: Sun, 6 Jun 2021 21:07:41 +0530
Subject: bus: mhi: pci-generic: Fix hibernation

This patch fixes crash after resuming from hibernation. The issue
occurs when mhi stack is builtin and so part of the 'restore-kernel',
causing the device to be resumed from 'restored kernel' with a no
more valid context (memory mappings etc...) and leading to spurious
crashes.

This patch fixes the issue by implementing proper freeze/restore
callbacks.

Link: https://lore.kernel.org/r/1622571445-4505-1-git-send-email-loic.poulain@linaro.org
Reported-by: Shujun Wang <wsj20369@163.com>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20210606153741.20725-4-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/pci_generic.c | 36 ++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
index 0a6619ad292c..b3357a8a2fdb 100644
--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -935,9 +935,43 @@ static int __maybe_unused mhi_pci_resume(struct device *dev)
 	return ret;
 }
 
+static int __maybe_unused mhi_pci_freeze(struct device *dev)
+{
+	struct mhi_pci_device *mhi_pdev = dev_get_drvdata(dev);
+	struct mhi_controller *mhi_cntrl = &mhi_pdev->mhi_cntrl;
+
+	/* We want to stop all operations, hibernation does not guarantee that
+	 * device will be in the same state as before freezing, especially if
+	 * the intermediate restore kernel reinitializes MHI device with new
+	 * context.
+	 */
+	if (test_and_clear_bit(MHI_PCI_DEV_STARTED, &mhi_pdev->status)) {
+		mhi_power_down(mhi_cntrl, false);
+		mhi_unprepare_after_power_down(mhi_cntrl);
+	}
+
+	return 0;
+}
+
+static int __maybe_unused mhi_pci_restore(struct device *dev)
+{
+	struct mhi_pci_device *mhi_pdev = dev_get_drvdata(dev);
+
+	/* Reinitialize the device */
+	queue_work(system_long_wq, &mhi_pdev->recovery_work);
+
+	return 0;
+}
+
 static const struct dev_pm_ops mhi_pci_pm_ops = {
 	SET_RUNTIME_PM_OPS(mhi_pci_runtime_suspend, mhi_pci_runtime_resume, NULL)
-	SET_SYSTEM_SLEEP_PM_OPS(mhi_pci_suspend, mhi_pci_resume)
+#ifdef CONFIG_PM_SLEEP
+	.suspend = mhi_pci_suspend,
+	.resume = mhi_pci_resume,
+	.freeze = mhi_pci_freeze,
+	.thaw = mhi_pci_restore,
+	.restore = mhi_pci_restore,
+#endif
 };
 
 static struct pci_driver mhi_pci_driver = {
-- 
2.32.0


