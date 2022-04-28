Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F5C533650
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 07:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238121AbiEYFJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 01:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiEYFJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 01:09:18 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFD66F49A
        for <stable@vger.kernel.org>; Tue, 24 May 2022 22:09:16 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.91,250,1647302400"; 
   d="scan'208";a="204911804"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-6fd66c4a.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 25 May 2022 05:09:05 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-6fd66c4a.us-west-2.amazon.com (Postfix) with ESMTPS id 7708881894
        for <stable@vger.kernel.org>; Wed, 25 May 2022 05:09:04 +0000 (UTC)
Received: from EX13D38UWB002.ant.amazon.com (10.43.161.171) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 25 May 2022 05:09:03 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D38UWB002.ant.amazon.com (10.43.161.171) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 25 May 2022 05:09:03 +0000
Received: from u178491f00a7154.ant.amazon.com (10.88.180.50) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS) id
 15.0.1497.36 via Frontend Transport; Wed, 25 May 2022 05:09:03 +0000
Received: from nmeyerha by u178491f00a7154.ant.amazon.com with local (Exim 4.93)
        (envelope-from <ec58bc58ec171ef8cc9a498aa9f7ace610527b45@u178491f00a7154.ant.amazon.com>)
        id 1ntjGZ-001rQq-E6
        for stable@vger.kernel.org; Tue, 24 May 2022 22:09:03 -0700
From:   Thomas Gleixner <tglx@linutronix.de>
Date:   Thu, 28 Apr 2022 15:50:54 +0200
Subject: [PATCH 4.14] x86/pci/xen: Disable PCI/MSI[-X] masking for XEN_HVM
 guests
To:     <stable@vger.kernel.org>
Message-ID: <E1ntjGZ-001rQq-E6@u178491f00a7154.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
[nmeyerha@amazon.com: backported to 4.14]
Signed-off-by: Noah Meyerhans <nmeyerha@amazon.com>
---
 arch/x86/pci/xen.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index c4b3646bd04c..7135f35f9de7 100644
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
 
-- 
2.25.1

