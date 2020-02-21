Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4CC4167ACA
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 11:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbgBUKbS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 05:31:18 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:45509 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgBUKbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Feb 2020 05:31:18 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1j55aT-0007x8-Qb; Fri, 21 Feb 2020 11:31:14 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 3F9D71C20C5;
        Fri, 21 Feb 2020 11:31:13 +0100 (CET)
Date:   Fri, 21 Feb 2020 10:31:12 -0000
From:   "tip-bot2 for Zenghui Yu" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] genirq/irqdomain: Make sure all irq domain flags
 are distinct
Cc:     Zenghui Yu <yuzenghui@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200221020725.2038-1-yuzenghui@huawei.com>
References: <20200221020725.2038-1-yuzenghui@huawei.com>
MIME-Version: 1.0
Message-ID: <158228107291.28353.2579324041035414462.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     2546287c5fb363a0165933ae2181c92f03e701d0
Gitweb:        https://git.kernel.org/tip/2546287c5fb363a0165933ae2181c92f03e701d0
Author:        Zenghui Yu <yuzenghui@huawei.com>
AuthorDate:    Fri, 21 Feb 2020 10:07:25 +08:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Fri, 21 Feb 2020 11:29:15 +01:00

genirq/irqdomain: Make sure all irq domain flags are distinct

This was noticed when printing debugfs for MSIs on my ARM64 server.  The
new dstate IRQD_MSI_NOMASK_QUIRK came out surprisingly while it should only
be the x86 stuff for the time being...

The new MSI quirk flag uses the same bit as IRQ_DOMAIN_NAME_ALLOCATED which
is oddly defined as bit 6 for no good reason.

Switch it to the non used bit 1.

Fixes: 6f1a4891a592 ("x86/apic/msi: Plug non-maskable MSI affinity race")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200221020725.2038-1-yuzenghui@huawei.com
---
 include/linux/irqdomain.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index b2d4757..8d062e8 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -192,7 +192,7 @@ enum {
 	IRQ_DOMAIN_FLAG_HIERARCHY	= (1 << 0),
 
 	/* Irq domain name was allocated in __irq_domain_add() */
-	IRQ_DOMAIN_NAME_ALLOCATED	= (1 << 6),
+	IRQ_DOMAIN_NAME_ALLOCATED	= (1 << 1),
 
 	/* Irq domain is an IPI domain with virq per cpu */
 	IRQ_DOMAIN_FLAG_IPI_PER_CPU	= (1 << 2),
