Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465C23F90C2
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 01:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243832AbhHZWeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 18:34:20 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:34806 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243830AbhHZWeU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 18:34:20 -0400
Date:   Thu, 26 Aug 2021 22:33:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1630017210;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ueYcKMjKqWc2jkgbgBjNJJRDkwkVL9Ry3yP8oZkxo18=;
        b=32hQDMgXiq8awb9Q+9EbRxHr/MQ8y+jxZCxBhjXMhubQ6CFdRhxv0qE8CkNfzs/88VL/dv
        3gmJL0Lyj1MX0Jl6Orxjea7Fsxwtugkqd8E1mnBhb/cudiCv2NcrSRyzBivCocCruYYz5m
        83BJmCXl0IGhgrJH/xUI0D7ABnnNkFbF8EsjoQGKPpnQmx3gXlKAv/YAmcn3rl8unATuou
        m/Mw1nDDpBE2BqIrHNSGFhRtc4Rh78arYF2O58OHl0s/E287wms3+jUAJWpZ9aYNbai3Le
        Lx05DHj4GY6acis7yyTgnMuKcXEigrGlLO709ipy0iwKmPfsp+ZgMl1lQ8w38w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1630017210;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ueYcKMjKqWc2jkgbgBjNJJRDkwkVL9Ry3yP8oZkxo18=;
        b=J3dG6DYzL4s9pYScz4v8FD5D4rMzDe/JSX5NOuuP4IhqclADBQEHu9uICjeaezh7tz2Bwt
        MqULztrYvheuSIDw==
From:   tip-bot2 for Marek =?utf-8?q?Marczykowski-G=C3=B3recki?= 
        <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] PCI/MSI: Skip masking MSI-X on Xen PV
Cc:     marmarek@invisiblethingslab.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, maz@kernel.org
In-Reply-To: <20210826170342.135172-1-marmarek@invisiblethingslab.com>
References: <20210826170342.135172-1-marmarek@invisiblethingslab.com>
MIME-Version: 1.0
Message-ID: <163001720943.25758.17463061644086046608.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     1a519dc7a73c977547d8b5108d98c6e769c89f4b
Gitweb:        https://git.kernel.org/tip/1a519dc7a73c977547d8b5108d98c6e769c=
89f4b
Author:        Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingslab.c=
om>
AuthorDate:    Thu, 26 Aug 2021 19:03:42 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Fri, 27 Aug 2021 00:27:15 +02:00

PCI/MSI: Skip masking MSI-X on Xen PV

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
Signed-off-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingslab.c=
om>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210826170342.135172-1-marmarek@invisiblethi=
ngslab.com
---
 drivers/pci/msi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index e5e7533..3a9f4f8 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -776,6 +776,9 @@ static void msix_mask_all(void __iomem *base, int tsize)
 	u32 ctrl =3D PCI_MSIX_ENTRY_CTRL_MASKBIT;
 	int i;
=20
+	if (pci_msi_ignore_mask)
+		return;
+
 	for (i =3D 0; i < tsize; i++, base +=3D PCI_MSIX_ENTRY_SIZE)
 		writel(ctrl, base + PCI_MSIX_ENTRY_VECTOR_CTRL);
 }
