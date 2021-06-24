Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484BC3B3093
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 15:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhFXN5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 09:57:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229878AbhFXN5V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Jun 2021 09:57:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89723613F3;
        Thu, 24 Jun 2021 13:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624542902;
        bh=rd1Ldsy/Xi/aRE530doqETJ4x36iP7lOpVWS0XosFic=;
        h=Subject:To:From:Date:From;
        b=z/qKGT59x+d2npPNtKW7FQ4ZQacWNshK5n40jszcG1m9/uk4j2GRMHV90GEUFmS1v
         V0khKWHWfYKVh3HdSOI24XCFOBlQ33ywOseBIx8szvav6/LtGKX7Bpo3qKtioJy7ZK
         KiHCCyrZ9KF2J1cdexcV9+92qjOJm4f4V9Q/qWn8=
Subject: patch "bus: mhi: pci-generic: Add missing" added to char-misc-testing
To:     christophe.jaillet@wanadoo.fr, gregkh@linuxfoundation.org,
        manivannan.sadhasivam@linaro.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 24 Jun 2021 15:54:59 +0200
Message-ID: <1624542899209122@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    bus: mhi: pci-generic: Add missing

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From a25d144fb883c73506ba384de476bbaff8220a95 Mon Sep 17 00:00:00 2001
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Mon, 21 Jun 2021 21:46:13 +0530
Subject: bus: mhi: pci-generic: Add missing
 'pci_disable_pcie_error_reporting()' calls

If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
call

Add the missing call in the error handling path of the probe and in the
remove function.

Cc: <stable@vger.kernel.org>
Fixes: b012ee6bfe2a ("mhi: pci_generic: Add PCI error handlers")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/f70c14701f4922d67e717633c91b6c481b59f298.1623445348.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20210621161616.77524-6-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/pci_generic.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
index b3357a8a2fdb..ca3bc40427f8 100644
--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -665,7 +665,7 @@ static int mhi_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	err = mhi_register_controller(mhi_cntrl, mhi_cntrl_config);
 	if (err)
-		return err;
+		goto err_disable_reporting;
 
 	/* MHI bus does not power up the controller by default */
 	err = mhi_prepare_for_power_up(mhi_cntrl);
@@ -699,6 +699,8 @@ static int mhi_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mhi_unprepare_after_power_down(mhi_cntrl);
 err_unregister:
 	mhi_unregister_controller(mhi_cntrl);
+err_disable_reporting:
+	pci_disable_pcie_error_reporting(pdev);
 
 	return err;
 }
@@ -721,6 +723,7 @@ static void mhi_pci_remove(struct pci_dev *pdev)
 		pm_runtime_get_noresume(&pdev->dev);
 
 	mhi_unregister_controller(mhi_cntrl);
+	pci_disable_pcie_error_reporting(pdev);
 }
 
 static void mhi_pci_shutdown(struct pci_dev *pdev)
-- 
2.32.0


