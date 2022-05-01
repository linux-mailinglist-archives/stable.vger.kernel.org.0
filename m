Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C6F51670E
	for <lists+stable@lfdr.de>; Sun,  1 May 2022 20:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235990AbiEAScl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 May 2022 14:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbiEASck (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 May 2022 14:32:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E9C62107
        for <stable@vger.kernel.org>; Sun,  1 May 2022 11:29:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E26F2B80DC1
        for <stable@vger.kernel.org>; Sun,  1 May 2022 18:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11DBC385A9;
        Sun,  1 May 2022 18:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651429750;
        bh=dIP3WT5FJd78Q7BWabsYFztLdKmSWlf/cRaip52xd70=;
        h=Subject:To:Cc:From:Date:From;
        b=hIGvGweMe84w4Y+5/6pnphyGGSd+9ycE+V084d9bX5x625RbyY/HUn11eiIXPmh3C
         Ufhzjjmrs8b4F7gRwsqnPWg1qIrzkl3/64n13winf38wypfQp+XYBxsqFqzou9FwCn
         JS7c0dZ1Q86giTV5+OFOQoWmHqts1wsBxyspTFZ0=
Subject: FAILED: patch "[PATCH] x86/pci/xen: Disable PCI/MSI[-X] masking for XEN_HVM guests" failed to apply to 4.14-stable tree
To:     tglx@linutronix.de, carnil@debian.org, dustymabe@redhat.com,
        jpiotrowski@linux.microsoft.com, noahm@debian.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 01 May 2022 20:28:50 +0200
Message-ID: <165142973021963@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7e0815b3e09986d2fe651199363e135b9358132a Mon Sep 17 00:00:00 2001
From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 28 Apr 2022 15:50:54 +0200
Subject: [PATCH] x86/pci/xen: Disable PCI/MSI[-X] masking for XEN_HVM guests

When a XEN_HVM guest uses the XEN PIRQ/Eventchannel mechanism, then
PCI/MSI[-X] masking is solely controlled by the hypervisor, but contrary to
XEN_PV guests this does not disable PCI/MSI[-X] masking in the PCI/MSI
layer.

This can lead to a situation where the PCI/MSI layer masks an MSI[-X]
interrupt and the hypervisor grants the write despite the fact that it
already requested the interrupt. As a consequence interrupt delivery on the
affected device is not happening ever.

Set pci_msi_ignore_mask to prevent that like it's done for XEN_PV guests
already.

Fixes: 809f9267bbab ("xen: map MSIs into pirqs")
Reported-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Reported-by: Dusty Mabe <dustymabe@redhat.com>
Reported-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Noah Meyerhans <noahm@debian.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87tuaduxj5.ffs@tglx

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 9bb1e2941179..b94f727251b6 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -467,7 +467,6 @@ static __init void xen_setup_pci_msi(void)
 		else
 			xen_msi_ops.setup_msi_irqs = xen_setup_msi_irqs;
 		xen_msi_ops.teardown_msi_irqs = xen_pv_teardown_msi_irqs;
-		pci_msi_ignore_mask = 1;
 	} else if (xen_hvm_domain()) {
 		xen_msi_ops.setup_msi_irqs = xen_hvm_setup_msi_irqs;
 		xen_msi_ops.teardown_msi_irqs = xen_teardown_msi_irqs;
@@ -481,6 +480,11 @@ static __init void xen_setup_pci_msi(void)
 	 * in allocating the native domain and never use it.
 	 */
 	x86_init.irqs.create_pci_msi_domain = xen_create_pci_msi_domain;
+	/*
+	 * With XEN PIRQ/Eventchannels in use PCI/MSI[-X] masking is solely
+	 * controlled by the hypervisor.
+	 */
+	pci_msi_ignore_mask = 1;
 }
 
 #else /* CONFIG_PCI_MSI */

