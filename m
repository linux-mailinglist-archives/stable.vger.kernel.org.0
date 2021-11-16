Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6CA453325
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 14:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236771AbhKPNud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 08:50:33 -0500
Received: from smtpout2.mo529.mail-out.ovh.net ([79.137.123.220]:34463 "EHLO
        smtpout2.mo529.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232201AbhKPNub (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 08:50:31 -0500
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Nov 2021 08:50:31 EST
Received: from mxplan5.mail.ovh.net (unknown [10.108.20.10])
        by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 7AE36CBDABAD;
        Tue, 16 Nov 2021 14:40:28 +0100 (CET)
Received: from kaod.org (37.59.142.102) by DAG4EX1.mxp5.local (172.16.2.31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Tue, 16 Nov
 2021 14:40:27 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-102R004ba902aba-7469-4690-932b-30ee350104e4,
                    BFAEB7FE3C4E2C4D96001007C3BA12B7689A693E) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 129.41.46.1
From:   =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
To:     <linuxppc-dev@lists.ozlabs.org>
CC:     Michael Ellerman <mpe@ellerman.id.au>, Greg Kurz <groug@kaod.org>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Marc Zyngier <maz@kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH] powerpc/xive: Change IRQ domain to a tree domain
Date:   Tue, 16 Nov 2021 14:40:22 +0100
Message-ID: <20211116134022.420412-1-clg@kaod.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.102]
X-ClientProxiedBy: DAG7EX2.mxp5.local (172.16.2.62) To DAG4EX1.mxp5.local
 (172.16.2.31)
X-Ovh-Tracer-GUID: 8a1d5da2-01c1-4648-a552-ae3e5b97b2ab
X-Ovh-Tracer-Id: 13027787825618848550
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvuddrfedvgdehgecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkofggtgfgihesthekredtredtjeenucfhrhhomhepveorughrihgtucfnvgcuifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeefvdeutddvieekkeeuhfekudejjefggffghfetgfelgfevveefgefhvdegtdelveenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddruddtvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtpdhhvghlohepmhigphhlrghnhedrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpegtlhhgsehkrghougdrohhrghdprhgtphhtthhopegtlhhgsehkrghougdrohhrgh
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 4f86a06e2d6e ("irqdomain: Make normal and nomap irqdomains
exclusive") introduced an IRQ_DOMAIN_FLAG_NO_MAP flag to isolate the
'nomap' domains still in use under the powerpc arch. With this new
flag, the revmap_tree of the IRQ domain is not used anymore. This
change broke the support of shared LSIs [1] in the XIVE driver because
it was relying on a lookup in the revmap_tree to query previously
mapped interrupts. Linux now creates two distinct IRQ mappings on the
same HW IRQ which can lead to unexpected behavior in the drivers.

The XIVE IRQ domain is not a direct mapping domain and its HW IRQ
interrupt number space is rather large : 1M/socket on POWER9 and
POWER10, change the XIVE driver to use a 'tree' domain type instead.

[1] For instance, a linux KVM guest with virtio-rng and virtio-balloon
    devices.

Cc: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org # v5.14+
Fixes: 4f86a06e2d6e ("irqdomain: Make normal and nomap irqdomains exclusive")
Signed-off-by: Cédric Le Goater <clg@kaod.org>
---

 Marc,

 The Fixes tag is there because the patch in question revealed that
 something was broken in XIVE. genirq is not in cause. However, I
 don't know for PS3 and Cell. May be less critical for now. 
 
 arch/powerpc/sysdev/xive/common.c | 3 +--
 arch/powerpc/sysdev/xive/Kconfig  | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
index fed6fd16c8f4..9d0f0fe25598 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -1536,8 +1536,7 @@ static const struct irq_domain_ops xive_irq_domain_ops = {
 
 static void __init xive_init_host(struct device_node *np)
 {
-	xive_irq_domain = irq_domain_add_nomap(np, XIVE_MAX_IRQ,
-					       &xive_irq_domain_ops, NULL);
+	xive_irq_domain = irq_domain_add_tree(np, &xive_irq_domain_ops, NULL);
 	if (WARN_ON(xive_irq_domain == NULL))
 		return;
 	irq_set_default_host(xive_irq_domain);
diff --git a/arch/powerpc/sysdev/xive/Kconfig b/arch/powerpc/sysdev/xive/Kconfig
index 97796c6b63f0..785c292d104b 100644
--- a/arch/powerpc/sysdev/xive/Kconfig
+++ b/arch/powerpc/sysdev/xive/Kconfig
@@ -3,7 +3,6 @@ config PPC_XIVE
 	bool
 	select PPC_SMP_MUXED_IPI
 	select HARDIRQS_SW_RESEND
-	select IRQ_DOMAIN_NOMAP
 
 config PPC_XIVE_NATIVE
 	bool
-- 
2.31.1

