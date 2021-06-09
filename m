Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E8E3A1B77
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 19:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhFIRG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 13:06:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231290AbhFIRGx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 13:06:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D5FE613C7;
        Wed,  9 Jun 2021 17:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623258298;
        bh=RPsrLBmKMihEml1+AMQpig7RKilO9Jz6Isyqz2EuyTE=;
        h=Subject:To:From:Date:From;
        b=nN0xsN8htN6W4SryjLFrALPwfSJrq/LCpXb/fSheQAl9zlAeqq1+XYgEhF5k+022l
         0q8ZfAEfFyXNi5XeWTGMTg21CSqjj8pPGYpjxxT+YPPq1v9YhfBTgIOIqlLeGEeG2F
         nJUIhjFNAUWCOyLsvfJDnXS+DpYQxZer2NAk4zbQ=
Subject: patch "bus: mhi: pci_generic: Fix possible use-after-free in" added to char-misc-linus
To:     weiyongjun1@huawei.com, gregkh@linuxfoundation.org,
        hemantk@codeaurora.org, hulkci@huawei.com, loic.poulain@linaro.org,
        manivannan.sadhasivam@linaro.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Jun 2021 19:04:48 +0200
Message-ID: <1623258288193102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    bus: mhi: pci_generic: Fix possible use-after-free in

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0b67808ade8893a1b3608ddd74fac7854786c919 Mon Sep 17 00:00:00 2001
From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Sun, 6 Jun 2021 21:07:40 +0530
Subject: bus: mhi: pci_generic: Fix possible use-after-free in
 mhi_pci_remove()

This driver's remove path calls del_timer(). However, that function
does not wait until the timer handler finishes. This means that the
timer handler may still be running after the driver's remove function
has finished, which would result in a use-after-free.

Fix by calling del_timer_sync(), which makes sure the timer handler
has finished, and unable to re-schedule itself.

Link: https://lore.kernel.org/r/20210413160318.2003699-1-weiyongjun1@huawei.com
Fixes: 8562d4fe34a3 ("mhi: pci_generic: Add health-check")
Cc: stable <stable@vger.kernel.org>
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Hemant kumar <hemantk@codeaurora.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20210606153741.20725-3-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/pci_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
index 8c7f6576e421..0a6619ad292c 100644
--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -708,7 +708,7 @@ static void mhi_pci_remove(struct pci_dev *pdev)
 	struct mhi_pci_device *mhi_pdev = pci_get_drvdata(pdev);
 	struct mhi_controller *mhi_cntrl = &mhi_pdev->mhi_cntrl;
 
-	del_timer(&mhi_pdev->health_check_timer);
+	del_timer_sync(&mhi_pdev->health_check_timer);
 	cancel_work_sync(&mhi_pdev->recovery_work);
 
 	if (test_and_clear_bit(MHI_PCI_DEV_STARTED, &mhi_pdev->status)) {
-- 
2.32.0


