Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E13BC1216B7
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730704AbfLPSMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:12:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:56748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730901AbfLPSMJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:12:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EBA0206EC;
        Mon, 16 Dec 2019 18:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519927;
        bh=TE/kABcyzpWjrfLjULG4nenC1gq2QetzcRXtWGYidxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JHHmcE/BRDGDDZhE6Zq1ybSxkr1Ipq6x+sxyOiSP2gMfRTPIqa6ShL1L9mqZmqyr0
         LVR/V/eLhW9BAMlkC41wv/+MNYoRFSnBoldEl0K/bL05zLjCII6o6FrWWWfqeW8E55
         /U8Lc7M0bEbCwRCNeNmR9bLcSJbkmqGZWoan18Bo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Daniel Axtens <dja@axtens.net>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.3 127/180] powerpc/xive: Skip ioremap() of ESB pages for LSI interrupts
Date:   Mon, 16 Dec 2019 18:49:27 +0100
Message-Id: <20191216174841.417623141@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cédric Le Goater <clg@kaod.org>

commit b67a95f2abff0c34e5667c15ab8900de73d8d087 upstream.

The PCI INTx interrupts and other LSI interrupts are handled differently
under a sPAPR platform. When the interrupt source characteristics are
queried, the hypervisor returns an H_INT_ESB flag to inform the OS
that it should be using the H_INT_ESB hcall for interrupt management
and not loads and stores on the interrupt ESB pages.

A default -1 value is returned for the addresses of the ESB pages. The
driver ignores this condition today and performs a bogus IO mapping.
Recent changes and the DEBUG_VM configuration option make the bug
visible with :

  kernel BUG at arch/powerpc/include/asm/book3s/64/pgtable.h:612!
  Oops: Exception in kernel mode, sig: 5 [#1]
  LE PAGE_SIZE=64K MMU=Radix MMU=Hash SMP NR_CPUS=1024 NUMA pSeries
  Modules linked in:
  CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.4.0-0.rc6.git0.1.fc32.ppc64le #1
  NIP:  c000000000f63294 LR: c000000000f62e44 CTR: 0000000000000000
  REGS: c0000000fa45f0d0 TRAP: 0700   Not tainted  (5.4.0-0.rc6.git0.1.fc32.ppc64le)
  ...
  NIP ioremap_page_range+0x4c4/0x6e0
  LR  ioremap_page_range+0x74/0x6e0
  Call Trace:
    ioremap_page_range+0x74/0x6e0 (unreliable)
    do_ioremap+0x8c/0x120
    __ioremap_caller+0x128/0x140
    ioremap+0x30/0x50
    xive_spapr_populate_irq_data+0x170/0x260
    xive_irq_domain_map+0x8c/0x170
    irq_domain_associate+0xb4/0x2d0
    irq_create_mapping+0x1e0/0x3b0
    irq_create_fwspec_mapping+0x27c/0x3e0
    irq_create_of_mapping+0x98/0xb0
    of_irq_parse_and_map_pci+0x168/0x230
    pcibios_setup_device+0x88/0x250
    pcibios_setup_bus_devices+0x54/0x100
    __of_scan_bus+0x160/0x310
    pcibios_scan_phb+0x330/0x390
    pcibios_init+0x8c/0x128
    do_one_initcall+0x60/0x2c0
    kernel_init_freeable+0x290/0x378
    kernel_init+0x2c/0x148
    ret_from_kernel_thread+0x5c/0x80

Fixes: bed81ee181dd ("powerpc/xive: introduce H_INT_ESB hcall")
Cc: stable@vger.kernel.org # v4.14+
Signed-off-by: Cédric Le Goater <clg@kaod.org>
Tested-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191203163642.2428-1-clg@kaod.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/sysdev/xive/spapr.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/arch/powerpc/sysdev/xive/spapr.c
+++ b/arch/powerpc/sysdev/xive/spapr.c
@@ -356,20 +356,28 @@ static int xive_spapr_populate_irq_data(
 	data->esb_shift = esb_shift;
 	data->trig_page = trig_page;
 
+	data->hw_irq = hw_irq;
+
 	/*
 	 * No chip-id for the sPAPR backend. This has an impact how we
 	 * pick a target. See xive_pick_irq_target().
 	 */
 	data->src_chip = XIVE_INVALID_CHIP_ID;
 
+	/*
+	 * When the H_INT_ESB flag is set, the H_INT_ESB hcall should
+	 * be used for interrupt management. Skip the remapping of the
+	 * ESB pages which are not available.
+	 */
+	if (data->flags & XIVE_IRQ_FLAG_H_INT_ESB)
+		return 0;
+
 	data->eoi_mmio = ioremap(data->eoi_page, 1u << data->esb_shift);
 	if (!data->eoi_mmio) {
 		pr_err("Failed to map EOI page for irq 0x%x\n", hw_irq);
 		return -ENOMEM;
 	}
 
-	data->hw_irq = hw_irq;
-
 	/* Full function page supports trigger */
 	if (flags & XIVE_SRC_TRIGGER) {
 		data->trig_mmio = data->eoi_mmio;


