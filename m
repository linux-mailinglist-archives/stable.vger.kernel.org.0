Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49AB2378780
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237633AbhEJLPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:15:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236496AbhEJLIP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:08:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F6016199D;
        Mon, 10 May 2021 11:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644503;
        bh=WhF6uKum6G33mRzMhCdLDaGU2CoRECY0syxpn7YVxh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1FYl8MgPhPWMHDjtcIps/jr0PXkDizUxBZxHOJmh1rWi53/TXAfaeShuI7jAxlQuW
         FoRuW8WnuYSi+O8fG6IEy5buxMjJDSAY5VDarIXPGLT+3GxpLfu4gVGYR7Bl8m0Buc
         xjoQuUcz8S8IQZf91kHh+prX7yy7uUP7XaGp7ryE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 108/384] bus: mhi: pci_generic: Implement PCI shutdown callback
Date:   Mon, 10 May 2021 12:18:17 +0200
Message-Id: <20210510102018.448890485@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

[ Upstream commit 757072abe1c0b67cb226936c709291889658a222 ]

Deinit the device on shutdown to halt MHI/PCI operation on device
side. This change fixes floating device state with some hosts that
do not fully shutdown PCIe device when rebooting.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/1616169037-7969-1-git-send-email-loic.poulain@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/pci_generic.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
index 356c19ce4bbf..ef549c695b55 100644
--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -516,6 +516,12 @@ static void mhi_pci_remove(struct pci_dev *pdev)
 	mhi_unregister_controller(mhi_cntrl);
 }
 
+static void mhi_pci_shutdown(struct pci_dev *pdev)
+{
+	mhi_pci_remove(pdev);
+	pci_set_power_state(pdev, PCI_D3hot);
+}
+
 static void mhi_pci_reset_prepare(struct pci_dev *pdev)
 {
 	struct mhi_pci_device *mhi_pdev = pci_get_drvdata(pdev);
@@ -686,6 +692,7 @@ static struct pci_driver mhi_pci_driver = {
 	.id_table	= mhi_pci_id_table,
 	.probe		= mhi_pci_probe,
 	.remove		= mhi_pci_remove,
+	.shutdown	= mhi_pci_shutdown,
 	.err_handler	= &mhi_pci_err_handler,
 	.driver.pm	= &mhi_pci_pm_ops
 };
-- 
2.30.2



