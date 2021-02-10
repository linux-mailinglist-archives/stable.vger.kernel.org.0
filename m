Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83DF7317212
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 22:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbhBJVLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 16:11:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbhBJVK5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 16:10:57 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40193C061574;
        Wed, 10 Feb 2021 13:10:16 -0800 (PST)
Date:   Wed, 10 Feb 2021 21:10:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1612991414;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gngjeJPNcZZcgmyt6/v2khOLAQVyDcojVu/JN00cNBY=;
        b=aQnMd/CN9ux3ON8NLtKjiGUGk0bv9NldIvkAK6H2vk4dT2A6HT130dxS3EyrwRUvLqx4S6
        tCuG4mVv18GTR57VfEkpc09Oo7/7CVFLHPXvFjg7N2I1w8W5K41M2mDy5ikaoBn/8Ldeu6
        uVhBmPau05NQmuJ2+vMUFSWksMSL/msLtH8lBT05+ZoFS0qCYyoplyB5mHXQm0DVO+dIl7
        bWkq5jEBKyNw8k/LqPs2rSkLpXpshj81YKsxIfNU1eKlbOYKCruC6Mj4jQ7yq7zJGIn321
        Fm9wNr7NEnEcD3YmD12OwAqlanAoFPVqTu79uCT+5YCm77cMoFBowhkqck7Hkw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1612991414;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gngjeJPNcZZcgmyt6/v2khOLAQVyDcojVu/JN00cNBY=;
        b=OA17cxdwMMMoqlgshG/WDLTV2hlYomxccsUwStwlKjafBgRQ+eR6c2xnAmg2I7Rdj721MC
        Ush82G/5PimCRtDQ==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/pci: Create PCI/MSI irqdomain after
 x86_init.pci.arch_init()
Cc:     Juergen Gross <jgross@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <87pn18djte.fsf@nanos.tec.linutronix.de>
References: <87pn18djte.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Message-ID: <161299141323.23325.8366354176580288665.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     70245f86c109e0eafb92ea9653184c0e44b4b35c
Gitweb:        https://git.kernel.org/tip/70245f86c109e0eafb92ea9653184c0e44b4b35c
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Wed, 10 Feb 2021 16:27:41 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Wed, 10 Feb 2021 22:06:47 +01:00

x86/pci: Create PCI/MSI irqdomain after x86_init.pci.arch_init()

Invoking x86_init.irqs.create_pci_msi_domain() before
x86_init.pci.arch_init() breaks XEN PV.

The XEN_PV specific pci.arch_init() function overrides the default
create_pci_msi_domain() which is obviously too late.

As a consequence the XEN PV PCI/MSI allocation goes through the native
path which runs out of vectors and causes malfunction.

Invoke it after x86_init.pci.arch_init().

Fixes: 6b15ffa07dc3 ("x86/irq: Initialize PCI/MSI domain at PCI init time")
Reported-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Juergen Gross <jgross@suse.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87pn18djte.fsf@nanos.tec.linutronix.de
---
 arch/x86/pci/init.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/pci/init.c b/arch/x86/pci/init.c
index 00bfa1e..0bb3b8b 100644
--- a/arch/x86/pci/init.c
+++ b/arch/x86/pci/init.c
@@ -9,16 +9,23 @@
    in the right sequence from here. */
 static __init int pci_arch_init(void)
 {
-	int type;
-
-	x86_create_pci_msi_domain();
+	int type, pcbios = 1;
 
 	type = pci_direct_probe();
 
 	if (!(pci_probe & PCI_PROBE_NOEARLY))
 		pci_mmcfg_early_init();
 
-	if (x86_init.pci.arch_init && !x86_init.pci.arch_init())
+	if (x86_init.pci.arch_init)
+		pcbios = x86_init.pci.arch_init();
+
+	/*
+	 * Must happen after x86_init.pci.arch_init(). Xen sets up the
+	 * x86_init.irqs.create_pci_msi_domain there.
+	 */
+	x86_create_pci_msi_domain();
+
+	if (!pcbios)
 		return 0;
 
 	pci_pcbios_init();
