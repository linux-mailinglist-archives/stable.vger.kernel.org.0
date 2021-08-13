Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBB93EB7ED
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241240AbhHMPKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:10:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241235AbhHMPJD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:09:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2708061153;
        Fri, 13 Aug 2021 15:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867316;
        bh=hB1ZqywZVYuDQf7z/EFxyNDz5gV77JsuSqEQx0lqY5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2LLHO9vLHAWb+YfIz3sQ18fxWo9dwX2EBh5VWOZqYlGBMLxDM2h3MvRFXjpbCcuYY
         hr99HhQEKdu5fpyTzvbeCpGzJ04bKj9xEO8aWc0Kap6x1Wmdq6IcGRag83Mc4XjeET
         +UFzbitdsMocr2Zsn7/tEqxvC36Ff8UD3Jni6BpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Longfang Liu <liulongfang@huawei.com>
Subject: [PATCH 4.4 23/25] USB:ehci:fix Kunpeng920 ehci hardware problem
Date:   Fri, 13 Aug 2021 17:06:47 +0200
Message-Id: <20210813150521.470150195@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150520.718161915@linuxfoundation.org>
References: <20210813150520.718161915@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Longfang Liu <liulongfang@huawei.com>

commit 26b75952ca0b8b4b3050adb9582c8e2f44d49687 upstream.

Kunpeng920's EHCI controller does not have SBRN register.
Reading the SBRN register when the controller driver is
initialized will get 0.

When rebooting the EHCI driver, ehci_shutdown() will be called.
if the sbrn flag is 0, ehci_shutdown() will return directly.
The sbrn flag being 0 will cause the EHCI interrupt signal to
not be turned off after reboot. this interrupt that is not closed
will cause an exception to the device sharing the interrupt.

Therefore, the EHCI controller of Kunpeng920 needs to skip
the read operation of the SBRN register.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Link: https://lore.kernel.org/r/1617958081-17999-1-git-send-email-liulongfang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ehci-pci.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -312,6 +312,9 @@ static int ehci_pci_setup(struct usb_hcd
 	if (pdev->vendor == PCI_VENDOR_ID_STMICRO
 	    && pdev->device == PCI_DEVICE_ID_STMICRO_USB_HOST)
 		;	/* ConneXT has no sbrn register */
+	else if (pdev->vendor == PCI_VENDOR_ID_HUAWEI
+			 && pdev->device == 0xa239)
+		;	/* HUAWEI Kunpeng920 USB EHCI has no sbrn register */
 	else
 		pci_read_config_byte(pdev, 0x60, &ehci->sbrn);
 


