Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4137853CEE2
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345171AbiFCRsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242471AbiFCRsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:48:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF61657114;
        Fri,  3 Jun 2022 10:44:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83F13B82433;
        Fri,  3 Jun 2022 17:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA81EC3411E;
        Fri,  3 Jun 2022 17:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278265;
        bh=eAgeRX0XfrOtYG0LIdo5Tzi4tDG+++Ix0SbqivlBhe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IuGydQr+uF753CPS05b+kvUnygsd2mLb6FmiHXg0OoMmTngqsqRCJUfsn4Z/dGOZA
         rxvc4vaMdpYGJpu8kSc+9qVNGBolGCwBPPTtZwNnxLkzSbAYaCWZO4hx50vWTpswUq
         2cRFW11enJqDNYLl3nefN9gSMFg+gCL9PTN03BP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Dusty Mabe <dustymabe@redhat.com>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Noah Meyerhans <noahm@debian.org>,
        Noah Meyerhans <nmeyerha@amazon.com>
Subject: [PATCH 5.4 02/34] x86/pci/xen: Disable PCI/MSI[-X] masking for XEN_HVM guests
Date:   Fri,  3 Jun 2022 19:42:58 +0200
Message-Id: <20220603173816.063706442@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173815.990072516@linuxfoundation.org>
References: <20220603173815.990072516@linuxfoundation.org>
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
[nmeyerha@amazon.com: backported to 5.4]
Signed-off-by: Noah Meyerhans <nmeyerha@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/pci/xen.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -442,6 +442,11 @@ void __init xen_msi_init(void)
 
 	x86_msi.setup_msi_irqs = xen_hvm_setup_msi_irqs;
 	x86_msi.teardown_msi_irq = xen_teardown_msi_irq;
+	/*
+	 * With XEN PIRQ/Eventchannels in use PCI/MSI[-X] masking is solely
+	 * controlled by the hypervisor.
+	 */
+	pci_msi_ignore_mask = 1;
 }
 #endif
 


