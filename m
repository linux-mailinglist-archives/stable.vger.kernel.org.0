Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82D8D51A960
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236285AbiEDRMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356872AbiEDRJr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:47 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C265B43AF6;
        Wed,  4 May 2022 09:56:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 28AB9CE28AD;
        Wed,  4 May 2022 16:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C89C385AF;
        Wed,  4 May 2022 16:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683367;
        bh=+q2s/HQ66eGx5eZW7CMgSoE5sCjAqyFL5yBUXuzj48M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8QCg4au/CBR3mUI0Y4wpvlu0S3VYpWfEaPYtnlg+Klu+46gtLMyVpT/CtCpLHbeJ
         IvKwPzKDpOr/rojKtZ3XnItHlUz1rZ+HECA6gJJkd7ftwb3K4/YP+HCaUTOozOuafq
         9alGbwXAwODvYZvTDRF24CwbRFzT18hgQSW9pO+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Dusty Mabe <dustymabe@redhat.com>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Noah Meyerhans <noahm@debian.org>
Subject: [PATCH 5.17 052/225] x86/pci/xen: Disable PCI/MSI[-X] masking for XEN_HVM guests
Date:   Wed,  4 May 2022 18:44:50 +0200
Message-Id: <20220504153114.793472327@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Thomas Gleixner <tglx@linutronix.de>

commit 7e0815b3e09986d2fe651199363e135b9358132a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/pci/xen.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -467,7 +467,6 @@ static __init void xen_setup_pci_msi(voi
 		else
 			xen_msi_ops.setup_msi_irqs = xen_setup_msi_irqs;
 		xen_msi_ops.teardown_msi_irqs = xen_pv_teardown_msi_irqs;
-		pci_msi_ignore_mask = 1;
 	} else if (xen_hvm_domain()) {
 		xen_msi_ops.setup_msi_irqs = xen_hvm_setup_msi_irqs;
 		xen_msi_ops.teardown_msi_irqs = xen_teardown_msi_irqs;
@@ -481,6 +480,11 @@ static __init void xen_setup_pci_msi(voi
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


