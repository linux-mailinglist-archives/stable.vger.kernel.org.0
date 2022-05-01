Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47608516299
	for <lists+stable@lfdr.de>; Sun,  1 May 2022 10:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242703AbiEAIQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 May 2022 04:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiEAIQD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 May 2022 04:16:03 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA131402A;
        Sun,  1 May 2022 01:12:39 -0700 (PDT)
Date:   Sun, 01 May 2022 08:12:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1651392757;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Btm8cdhggXjho6O0WPgq4RkAAi9zylcOI/eBifzYWp8=;
        b=WLK3Z36jq0QkP6HqWQgymJ+5w6nepgQbmdC4B5mau7rLZJjyyBC12c+ADWi3ALCCoEityh
        9eQnaq4ASKphRUnPu5MTnOaWL3mwiFoSbvuB0Yj30ij3pHQax/vbsHjGE3fTpOW9qnjw6y
        DHnz55tZKuHP4MbKyxtLHeDpP8vv7D/tiqedJ3ZNm0YCYFdpcK+1c1JUqYBvtQcGrnURZ2
        sB+gkxJ+LXaFFYdm+bN1iY4cpaP9V1DlZaolPuvBHBlSvcpTWBXetQ8xS0lh7VgA+6PjhC
        N0tFfedGbZvA3AtLNwZkqJn16qquyZzNzHkfyaiQSf2GmL7SFUdDrSFbb+3Fbw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1651392757;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Btm8cdhggXjho6O0WPgq4RkAAi9zylcOI/eBifzYWp8=;
        b=eeGr6Yw/+j0xBR79JMNk1GCZz/kWWvkfLK/C4b0J2vxmG+Dq5rtg0ScHm4/RMH4N+s8RU5
        LCvv3xTQOuFeBjBg==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/pci/xen: Disable PCI/MSI[-X] masking for XEN_HVM guests
Cc:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Dusty Mabe <dustymabe@redhat.com>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Noah Meyerhans <noahm@debian.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <87tuaduxj5.ffs@tglx>
References: <87tuaduxj5.ffs@tglx>
MIME-Version: 1.0
Message-ID: <165139275608.4207.16060979873182920732.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     7e0815b3e09986d2fe651199363e135b9358132a
Gitweb:        https://git.kernel.org/tip/7e0815b3e09986d2fe651199363e135b9358132a
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Thu, 28 Apr 2022 15:50:54 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Fri, 29 Apr 2022 14:37:39 +02:00

x86/pci/xen: Disable PCI/MSI[-X] masking for XEN_HVM guests

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

---
 arch/x86/pci/xen.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 9bb1e29..b94f727 100644
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
