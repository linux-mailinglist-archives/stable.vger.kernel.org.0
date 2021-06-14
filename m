Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6FF3A641E
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234996AbhFNLU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:20:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235641AbhFNLSh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:18:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C14276145E;
        Mon, 14 Jun 2021 10:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667860;
        bh=0SzKsHY06HqIkjEwOux3vJkvCtftzeboNkPSe7emRfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PRzoMTqRkvfFGZIvV4aLy6CJOso08Ux/V+3f8cHieOn5oTsfmEyC0fD7L77LY1n7Z
         EmdV1gx1KIjwsmskDoBH36sR/q08Tv7MpVueRyYi8tnQr8wC0ieQK7d6w9sadarxCt
         J9YZjp7C1n2LdtkOtg4mwCuvUDgPsetr5dmcLil0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Hemant kumar <hemantk@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH 5.12 069/173] bus: mhi: pci_generic: Fix possible use-after-free in mhi_pci_remove()
Date:   Mon, 14 Jun 2021 12:26:41 +0200
Message-Id: <20210614102700.455303176@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

commit 0b67808ade8893a1b3608ddd74fac7854786c919 upstream.

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
 drivers/bus/mhi/pci_generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -505,7 +505,7 @@ static void mhi_pci_remove(struct pci_de
 	struct mhi_pci_device *mhi_pdev = pci_get_drvdata(pdev);
 	struct mhi_controller *mhi_cntrl = &mhi_pdev->mhi_cntrl;
 
-	del_timer(&mhi_pdev->health_check_timer);
+	del_timer_sync(&mhi_pdev->health_check_timer);
 	cancel_work_sync(&mhi_pdev->recovery_work);
 
 	if (test_and_clear_bit(MHI_PCI_DEV_STARTED, &mhi_pdev->status)) {


