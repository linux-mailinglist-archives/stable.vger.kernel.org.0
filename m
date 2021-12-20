Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6071F47ABF7
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbhLTOk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234846AbhLTOj1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:39:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A671C06137B;
        Mon, 20 Dec 2021 06:39:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66B36B80EE2;
        Mon, 20 Dec 2021 14:39:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDFBC36AFD;
        Mon, 20 Dec 2021 14:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011165;
        bh=VhOrL/DH55XRMr5wXHlqUBaF5ME1VEu5G5uh3iurAS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pfrhFRtaMlBqrC0EhbUJiDjE1e6aM4r2Zj8+Ghmiaw6KVX/fL01MwmnixEhnJUjSr
         fReyQYEuUqJoQNpzzwnui+ZBEf9m3cqRQWEhqKbG/nsbOLELYTjoTmsWV8ntD7XN7t
         l2JNORaQl0SzVoGeDR0UusS1bZjnZB6F000bkhHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Roese <sr@denx.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Marek Vasut <marex@denx.de>
Subject: [PATCH 4.14 26/45] PCI/MSI: Clear PCI_MSIX_FLAGS_MASKALL on error
Date:   Mon, 20 Dec 2021 15:34:21 +0100
Message-Id: <20211220143023.146401248@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143022.266532675@linuxfoundation.org>
References: <20211220143022.266532675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 94185adbfad56815c2c8401e16d81bdb74a79201 upstream.

PCI_MSIX_FLAGS_MASKALL is set in the MSI-X control register at MSI-X
interrupt setup time. It's cleared on success, but the error handling path
only clears the PCI_MSIX_FLAGS_ENABLE bit.

That's incorrect as the reset state of the PCI_MSIX_FLAGS_MASKALL bit is
zero. That can be observed via lspci:

        Capabilities: [b0] MSI-X: Enable- Count=67 Masked+

Clear the bit in the error path to restore the reset state.

Fixes: 438553958ba1 ("PCI/MSI: Enable and mask MSI-X early")
Reported-by: Stefan Roese <sr@denx.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Stefan Roese <sr@denx.de>
Cc: linux-pci@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: Marek Vasut <marex@denx.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87tufevoqx.ffs@tglx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/msi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -847,7 +847,7 @@ out_free:
 	free_msi_irqs(dev);
 
 out_disable:
-	pci_msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_ENABLE, 0);
+	pci_msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_MASKALL | PCI_MSIX_FLAGS_ENABLE, 0);
 
 	return ret;
 }


