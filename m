Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4166C31BD34
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhBOPmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:42:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:49636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230396AbhBOPiI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:38:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71C8B64EEF;
        Mon, 15 Feb 2021 15:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403250;
        bh=rJ3cqbEgNSmAErDCZ7J+vtEJej8rLb/DxMwN4DWhHaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1gZXAKgJZOfsHRsMW2Nf2nVJ7s81rnG5T3nT7rZ2Wyyv+ti71arLYb4rXNLlbItL
         mHljBYdk8zJIbBDwZ4rRUgsQnH0HGp2WjclguqnwDwYwH8hiAkt+GPD3iibuESdgvn
         dRhlFZhfB8XMQMJmkzeEMpY6ni5bZCx80+EE8zCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.10 085/104] x86/pci: Create PCI/MSI irqdomain after x86_init.pci.arch_init()
Date:   Mon, 15 Feb 2021 16:27:38 +0100
Message-Id: <20210215152722.200008050@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 70245f86c109e0eafb92ea9653184c0e44b4b35c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/pci/init.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

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


