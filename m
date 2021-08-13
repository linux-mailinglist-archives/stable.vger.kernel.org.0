Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E0B3EB8C8
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241482AbhHMPQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:16:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242284AbhHMPNt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:13:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B193C6112E;
        Fri, 13 Aug 2021 15:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867586;
        bh=5bM0VwdyJN9ot4hCjJftDeLaiVlC+Sip1objMN7EOk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eu6EYwcrETrcdVywmLaM4hztb5tLlyLLuN/5JLlDTnJYwdHokE9j1Gh/N2vA2buqj
         GZnO2tF4cXqDE1dr5WhHae7UFEwyqhve1N0h380HTnVZuLXfOqgV7ETKL2/ogUVpSx
         pM8HZK5qXYk1hsHs9AaaAoWjJQLKbrPnLjHMXGbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Longfang Liu <liulongfang@huawei.com>
Subject: [PATCH 5.4 13/27] USB:ehci:fix Kunpeng920 ehci hardware problem
Date:   Fri, 13 Aug 2021 17:07:11 +0200
Message-Id: <20210813150523.797940870@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150523.364549385@linuxfoundation.org>
References: <20210813150523.364549385@linuxfoundation.org>
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
@@ -298,6 +298,9 @@ static int ehci_pci_setup(struct usb_hcd
 	if (pdev->vendor == PCI_VENDOR_ID_STMICRO
 	    && pdev->device == PCI_DEVICE_ID_STMICRO_USB_HOST)
 		;	/* ConneXT has no sbrn register */
+	else if (pdev->vendor == PCI_VENDOR_ID_HUAWEI
+			 && pdev->device == 0xa239)
+		;	/* HUAWEI Kunpeng920 USB EHCI has no sbrn register */
 	else
 		pci_read_config_byte(pdev, 0x60, &ehci->sbrn);
 


