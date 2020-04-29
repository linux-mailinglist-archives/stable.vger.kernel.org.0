Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B15C1BD6D8
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 10:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgD2IIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 04:08:49 -0400
Received: from 7.mo179.mail-out.ovh.net ([46.105.61.94]:41571 "EHLO
        7.mo179.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbgD2IIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Apr 2020 04:08:49 -0400
X-Greylist: delayed 1036 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Apr 2020 04:08:48 EDT
Received: from player714.ha.ovh.net (unknown [10.110.171.250])
        by mo179.mail-out.ovh.net (Postfix) with ESMTP id 917511605AF
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 09:51:31 +0200 (CEST)
Received: from kaod.org (82-64-250-170.subs.proxad.net [82.64.250.170])
        (Authenticated sender: clg@kaod.org)
        by player714.ha.ovh.net (Postfix) with ESMTPSA id 32EA111CA9161;
        Wed, 29 Apr 2020 07:51:27 +0000 (UTC)
From:   =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     linuxppc-dev@lists.ozlabs.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/3] powerpc/xive: Clear the page tables for the ESB IO mapping
Date:   Wed, 29 Apr 2020 09:51:20 +0200
Message-Id: <20200429075122.1216388-2-clg@kaod.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200429075122.1216388-1-clg@kaod.org>
References: <20200429075122.1216388-1-clg@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 3603724131002518449
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedriedvgdduvddvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvffufffkofgjfhggtgfgsehtkeertdertdejnecuhfhrohhmpeevrogurhhitgcunfgvucfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecukfhppedtrddtrddtrddtpdekvddrieegrddvhedtrddujedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepphhlrgihvghrjedugedrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpegtlhhgsehkrghougdrohhrghdprhgtphhtthhopehsthgrsghlvgesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 1ca3dec2b2df ("powerpc/xive: Prevent page fault issues in the
machine crash handler") fixed an issue in the FW assisted dump of
machines using hash MMU and the XIVE interrupt mode under the POWER
hypervisor. It forced the mapping of the ESB page of interrupts being
mapped in the Linux IRQ number space to make sure the 'crash kexec'
sequence worked during such an event. But it didn't handle the
un-mapping.

This mapping is now blocking the removal of a passthrough IO adapter
under the POWER hypervisor because it expects the guest OS to have
cleared all page table entries related to the adapter. If some are
still present, the RTAS call which isolates the PCI slot returns error
9001 "valid outstanding translations".

Remove these mapping in the IRQ data cleanup routine.

Under KVM, this cleanup is not required because the ESB pages for the
adapter interrupts are un-mapped from the guest by the hypervisor in
the KVM XIVE native device. This is now redundant but it's harmless.

Fixes: 1ca3dec2b2df ("powerpc/xive: Prevent page fault issues in the machine crash handler")
Cc: stable@vger.kernel.org # v5.5+
Signed-off-by: Cédric Le Goater <clg@kaod.org>
---
 arch/powerpc/sysdev/xive/common.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
index 9603b2830d03..3dbc94cb4380 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -19,6 +19,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/msi.h>
+#include <linux/vmalloc.h>
 
 #include <asm/debugfs.h>
 #include <asm/prom.h>
@@ -1020,12 +1021,16 @@ EXPORT_SYMBOL_GPL(is_xive_irq);
 void xive_cleanup_irq_data(struct xive_irq_data *xd)
 {
 	if (xd->eoi_mmio) {
+		unmap_kernel_range((unsigned long)xd->eoi_mmio,
+				   1u << xd->esb_shift);
 		iounmap(xd->eoi_mmio);
 		if (xd->eoi_mmio == xd->trig_mmio)
 			xd->trig_mmio = NULL;
 		xd->eoi_mmio = NULL;
 	}
 	if (xd->trig_mmio) {
+		unmap_kernel_range((unsigned long)xd->trig_mmio,
+				   1u << xd->esb_shift);
 		iounmap(xd->trig_mmio);
 		xd->trig_mmio = NULL;
 	}
-- 
2.25.4

