Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B792C833F
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 12:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729166AbgK3L3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 06:29:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbgK3L3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 06:29:45 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BCCC0613CF;
        Mon, 30 Nov 2020 03:29:05 -0800 (PST)
Date:   Mon, 30 Nov 2020 11:29:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606735743;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l0pjxdzVT2soZbYSgLF/KFW8zRzTkl95WGxMx0fC1w8=;
        b=TR0L6UD4z6FaQFfyjjNmfb9Gfv7bVkqQD1i93DxhJEAnAFVSO7Z27bC6NvpetvV5D/LoIn
        WCM6wzSTZNEDWh4hm/ELJKfiLGggKOWxEpCISy9p/KgD6BgdlWcV1ocUGF0M6I8iLshlon
        aHykp0Lv1nu3eLC/Zo2Pq8mkRw2PvIgma2aG84ApADdyphNGffc5vAcolGE546SPiP6due
        w7ruFiL9XG0Ozmgw7A7J1/P5BVWGnGBQOYVWrRu57vROl2/yZ2bkg9tiAwQmtvep85Z4Co
        MaDmNi4rNauOm7f/YA541uWjiX4XvhjQDo1jV+7GnXQZM4xMGSDyWL4dB/CI1A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606735743;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l0pjxdzVT2soZbYSgLF/KFW8zRzTkl95WGxMx0fC1w8=;
        b=9aKoRS7v/jzR1QtJF1GyVlXSKWNfk4/BAcwimilDKIrCJ9M35G6DZmraLJvXBguPv/6/I4
        RRgE+uzGcvIMpwDg==
From:   "tip-bot2 for Laurent Vivier" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] powerpc/pseries: Pass MSI affinity to irq_create_mapping()
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kurz <groug@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, maz@kernel.org
In-Reply-To: <20201126082852.1178497-3-lvivier@redhat.com>
References: <20201126082852.1178497-3-lvivier@redhat.com>
MIME-Version: 1.0
Message-ID: <160673574245.3364.4192827087700999581.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     9ea69a55b3b9a71cded9726af591949c1138f235
Gitweb:        https://git.kernel.org/tip/9ea69a55b3b9a71cded9726af591949c1138f235
Author:        Laurent Vivier <lvivier@redhat.com>
AuthorDate:    Thu, 26 Nov 2020 09:28:52 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Mon, 30 Nov 2020 12:22:04 +01:00

powerpc/pseries: Pass MSI affinity to irq_create_mapping()

With virtio multiqueue, normally each queue IRQ is mapped to a CPU.

Commit 0d9f0a52c8b9f ("virtio_scsi: use virtio IRQ affinity") exposed
an existing shortcoming of the arch code by moving virtio_scsi to
the automatic IRQ affinity assignment.

The affinity is correctly computed in msi_desc but this is not applied
to the system IRQs.

It appears the affinity is correctly passed to rtas_setup_msi_irqs() but
lost at this point and never passed to irq_domain_alloc_descs()
(see commit 06ee6d571f0e ("genirq: Add affinity hint to irq allocation"))
because irq_create_mapping() doesn't take an affinity parameter.

Use the new irq_create_mapping_affinity() function, which allows to forward
the affinity setting from rtas_setup_msi_irqs() to irq_domain_alloc_descs().

With this change, the virtqueues are correctly dispatched between the CPUs
on pseries.

Fixes: e75eafb9b039 ("genirq/msi: Switch to new irq spreading infrastructure")
Signed-off-by: Laurent Vivier <lvivier@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Greg Kurz <groug@kaod.org>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201126082852.1178497-3-lvivier@redhat.com
---
 arch/powerpc/platforms/pseries/msi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/msi.c b/arch/powerpc/platforms/pseries/msi.c
index 133f6ad..b3ac245 100644
--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -458,7 +458,8 @@ again:
 			return hwirq;
 		}
 
-		virq = irq_create_mapping(NULL, hwirq);
+		virq = irq_create_mapping_affinity(NULL, hwirq,
+						   entry->affinity);
 
 		if (!virq) {
 			pr_debug("rtas_msi: Failed mapping hwirq %d\n", hwirq);
