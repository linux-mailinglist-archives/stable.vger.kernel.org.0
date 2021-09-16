Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC37740DFEF
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234478AbhIPQQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:16:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240705AbhIPQOW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:14:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5537613A9;
        Thu, 16 Sep 2021 16:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808619;
        bh=xVZaS4VY1CagNFx46DC7CHstYvPqRAR5sckPHTXIT3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UF5e4X8Nx+fHkVKse9nUNZ8MqNkk2uYXqKA425zxKZ0ZCdpAxzpaGzlUYPxJCYQun
         CQxGQQ0hisfSGcJA7fxiW1WK7HDt725xTbWrYxE+wMymf+iTK0pNV89x2juuvroxi6
         G+uHMinPZ3wUQsOlDFOz1yMotbe06focgfDRpumU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 160/306] s390: make PCI mio support a machine flag
Date:   Thu, 16 Sep 2021 17:58:25 +0200
Message-Id: <20210916155759.534410826@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit 3322ba0d7bea1e24ae464418626f6a15b69533ab ]

Kernel support for the newer PCI mio instructions can be toggled off
with the pci=nomio command line option which needs to integrate with
common code PCI option parsing. However this option then toggles static
branches which can't be toggled yet in an early_param() call.

Thus commit 9964f396f1d0 ("s390: fix setting of mio addressing control")
moved toggling the static branches to the PCI init routine.

With this setup however we can't check for mio support outside the PCI
code during early boot, i.e. before switching the static branches, which
we need to be able to export this as an ELF HWCAP.

Improve on this by turning mio availability into a machine flag that
gets initially set based on CONFIG_PCI and the facility bit and gets
toggled off if pci=nomio is found during PCI option parsing allowing
simple access to this machine flag after early init.

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/setup.h | 2 ++
 arch/s390/kernel/early.c      | 4 ++++
 arch/s390/pci/pci.c           | 5 ++---
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/setup.h b/arch/s390/include/asm/setup.h
index bdb242a1544e..75a2ecec2ab8 100644
--- a/arch/s390/include/asm/setup.h
+++ b/arch/s390/include/asm/setup.h
@@ -38,6 +38,7 @@
 #define MACHINE_FLAG_NX		BIT(15)
 #define MACHINE_FLAG_GS		BIT(16)
 #define MACHINE_FLAG_SCC	BIT(17)
+#define MACHINE_FLAG_PCI_MIO	BIT(18)
 
 #define LPP_MAGIC		BIT(31)
 #define LPP_PID_MASK		_AC(0xffffffff, UL)
@@ -113,6 +114,7 @@ extern unsigned long mio_wb_bit_mask;
 #define MACHINE_HAS_NX		(S390_lowcore.machine_flags & MACHINE_FLAG_NX)
 #define MACHINE_HAS_GS		(S390_lowcore.machine_flags & MACHINE_FLAG_GS)
 #define MACHINE_HAS_SCC		(S390_lowcore.machine_flags & MACHINE_FLAG_SCC)
+#define MACHINE_HAS_PCI_MIO	(S390_lowcore.machine_flags & MACHINE_FLAG_PCI_MIO)
 
 /*
  * Console mode. Override with conmode=
diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index 705844f73934..985e1e755333 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -238,6 +238,10 @@ static __init void detect_machine_facilities(void)
 		clock_comparator_max = -1ULL >> 1;
 		__ctl_set_bit(0, 53);
 	}
+	if (IS_ENABLED(CONFIG_PCI) && test_facility(153)) {
+		S390_lowcore.machine_flags |= MACHINE_FLAG_PCI_MIO;
+		/* the control bit is set during PCI initialization */
+	}
 }
 
 static inline void save_vector_registers(void)
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 0ddb1fe353dc..f5ddbc625c1a 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -866,7 +866,6 @@ static void zpci_mem_exit(void)
 }
 
 static unsigned int s390_pci_probe __initdata = 1;
-static unsigned int s390_pci_no_mio __initdata;
 unsigned int s390_pci_force_floating __initdata;
 static unsigned int s390_pci_initialized;
 
@@ -877,7 +876,7 @@ char * __init pcibios_setup(char *str)
 		return NULL;
 	}
 	if (!strcmp(str, "nomio")) {
-		s390_pci_no_mio = 1;
+		S390_lowcore.machine_flags &= ~MACHINE_FLAG_PCI_MIO;
 		return NULL;
 	}
 	if (!strcmp(str, "force_floating")) {
@@ -906,7 +905,7 @@ static int __init pci_base_init(void)
 	if (!test_facility(69) || !test_facility(71))
 		return 0;
 
-	if (test_facility(153) && !s390_pci_no_mio) {
+	if (MACHINE_HAS_PCI_MIO) {
 		static_branch_enable(&have_mio);
 		ctl_set_bit(2, 5);
 	}
-- 
2.30.2



