Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89FA40E14C
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242010AbhIPQ3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:29:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242190AbhIPQ1J (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:27:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F29C6154B;
        Thu, 16 Sep 2021 16:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809048;
        bh=tupHmxPw+XerXzPsoto+Ct0/EvARjfdxIA1OwPdZcs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RkwGkcPRvC5s6kvcBNqFs6P1K8hThtlvuPW3mB/7ILkMdnoAbNMGjpif0ZciArJ27
         DAn9Ya7focNOqKYfa2LiuRigRksIy3hXQfcmkBJyX0Bt6wVj3PegHnBAEK+lT92lvu
         22fAk1xhkH6sqMHr0GRzsGQ35AyrVW3IyEPUde0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.13 012/380] PCI/MSI: Skip masking MSI-X on Xen PV
Date:   Thu, 16 Sep 2021 17:56:09 +0200
Message-Id: <20210916155804.388603016@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>

commit 1a519dc7a73c977547d8b5108d98c6e769c89f4b upstream.

When running as Xen PV guest, masking MSI-X is a responsibility of the
hypervisor. The guest has no write access to the relevant BAR at all - when
it tries to, it results in a crash like this:

    BUG: unable to handle page fault for address: ffffc9004069100c
    #PF: supervisor write access in kernel mode
    #PF: error_code(0x0003) - permissions violation
    RIP: e030:__pci_enable_msix_range.part.0+0x26b/0x5f0
     e1000e_set_interrupt_capability+0xbf/0xd0 [e1000e]
     e1000_probe+0x41f/0xdb0 [e1000e]
     local_pci_probe+0x42/0x80
    (...)

The recently introduced function msix_mask_all() does not check the global
variable pci_msi_ignore_mask which is set by XEN PV to bypass the masking
of MSI[-X] interrupts.

Add the check to make this function XEN PV compatible.

Fixes: 7d5ec3d36123 ("PCI/MSI: Mask all unused MSI-X entries")
Signed-off-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210826170342.135172-1-marmarek@invisiblethingslab.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/msi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -776,6 +776,9 @@ static void msix_mask_all(void __iomem *
 	u32 ctrl = PCI_MSIX_ENTRY_CTRL_MASKBIT;
 	int i;
 
+	if (pci_msi_ignore_mask)
+		return;
+
 	for (i = 0; i < tsize; i++, base += PCI_MSIX_ENTRY_SIZE)
 		writel(ctrl, base + PCI_MSIX_ENTRY_VECTOR_CTRL);
 }


