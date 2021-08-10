Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11F63E564D
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 11:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238678AbhHJJIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 05:08:15 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41874 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238628AbhHJJIK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 05:08:10 -0400
Date:   Tue, 10 Aug 2021 09:07:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628586466;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h6Gn03aDoUvJFxrpWmheTVCvJLR4JDX1gKgWkTybXzA=;
        b=v7SeherpwONI238S+ymIsA57f63NRCenS5f4UITlZVzIUD9qyXkK0kfA9UfekisLNrmolj
        QkFeMYsI43s4MABqIxwNOMHyhLxw0kubQQW9RaDk6QwAwJTsAOBRy7zWclkBLUyuTuodEL
        400qm2RHwkqJ+Z208r8tWKIFyWdD7IeXN74H9bucx1KrwJzKGRKErvrfXb4LQeweIpfsZf
        PjNE3L3egOO8ql0H+S2o68gsv/BeZAG9QW+/5ikNlJ/a9GPZxd9opMScRUiwd6qQxFcpPz
        XtUgw8TNuihVWwYBRIMFRYePHcaf0rmZec8gVZGZYhkaYl0pcuj8qXpjBht7wQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628586466;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h6Gn03aDoUvJFxrpWmheTVCvJLR4JDX1gKgWkTybXzA=;
        b=xYZup98//iXNiDGXAEDHTg6ME9b7Ps9LH6okpkhMnBemccBG4VAN4nudxflKP3WKbSVT+O
        EmCtFfb6S11p6JCg==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/core] PCI/MSI: Enforce MSI[X] entry updates to be visible
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210729222542.515188147@linutronix.de>
References: <20210729222542.515188147@linutronix.de>
MIME-Version: 1.0
Message-ID: <162858646605.395.9862515344185034186.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/core branch of tip:

Commit-ID:     b9255a7cb51754e8d2645b65dd31805e282b4f3e
Gitweb:        https://git.kernel.org/tip/b9255a7cb51754e8d2645b65dd31805e282b4f3e
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Thu, 29 Jul 2021 23:51:43 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 10 Aug 2021 10:59:20 +02:00

PCI/MSI: Enforce MSI[X] entry updates to be visible

Nothing enforces the posted writes to be visible when the function
returns. Flush them even if the flush might be redundant when the entry is
masked already as the unmask will flush as well. This is either setup or a
rare affinity change event so the extra flush is not the end of the world.

While this is more a theoretical issue especially the logic in the X86
specific msi_set_affinity() function relies on the assumption that the
update has reached the hardware when the function returns.

Again, as this never has been enforced the Fixes tag refers to a commit in:
   git://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git

Fixes: f036d4ea5fa7 ("[PATCH] ia32 Message Signalled Interrupt support")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210729222542.515188147@linutronix.de

---
 drivers/pci/msi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 7ee1ac4..434c704 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -311,6 +311,9 @@ void __pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 
 		if (unmasked)
 			__pci_msix_desc_mask_irq(entry, 0);
+
+		/* Ensure that the writes are visible in the device */
+		readl(base + PCI_MSIX_ENTRY_DATA);
 	} else {
 		int pos = dev->msi_cap;
 		u16 msgctl;
@@ -331,6 +334,8 @@ void __pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 			pci_write_config_word(dev, pos + PCI_MSI_DATA_32,
 					      msg->data);
 		}
+		/* Ensure that the writes are visible in the device */
+		pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &msgctl);
 	}
 
 skip:
