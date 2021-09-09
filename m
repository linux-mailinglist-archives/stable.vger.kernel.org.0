Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B275405336
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355660AbhIIMtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:49:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355284AbhIIMpF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:45:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7C65613A7;
        Thu,  9 Sep 2021 11:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188550;
        bh=Gzp0EJzkHuDhxjp51t7I5moS+Z52F5QgC3NbHB6kIuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q5YSRha+WEIcJBXzmLURNpqOlVn8r+4jHLdJwCU1Ph/zq+4HJQx+9KLKZ448xO9nV
         5ikyYx/I9OvAFa68f76h0VCSnPsFvg5OUxwVGosTnbKuQLpUiei6jEs0XPCEn4E+Gk
         he+yJ/J+IrIUGY0sTxtlMawB4PLeU4FSrmISym3ZxTq24b7UaJwhWMLcD4BL+podsh
         ysmAxQfI8yJHRfuGcqQ6EYc1vJSrfr5Y2wUa7axqxGxHxKTjZBZN+ii+2nOEY3WgLf
         pRAQrUF9E+uU0JVO5OrRAiHJqWOKg8YoHB3JLnnxhTRhCjkxbbWJax3DGf027o+1/h
         vxnVn6AdxFaxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 034/109] s390: make PCI mio support a machine flag
Date:   Thu,  9 Sep 2021 07:53:51 -0400
Message-Id: <20210909115507.147917-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115507.147917-1-sashal@kernel.org>
References: <20210909115507.147917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 1932088686a6..e6a5007f017d 100644
--- a/arch/s390/include/asm/setup.h
+++ b/arch/s390/include/asm/setup.h
@@ -39,6 +39,7 @@
 #define MACHINE_FLAG_NX		BIT(15)
 #define MACHINE_FLAG_GS		BIT(16)
 #define MACHINE_FLAG_SCC	BIT(17)
+#define MACHINE_FLAG_PCI_MIO	BIT(18)
 
 #define LPP_MAGIC		BIT(31)
 #define LPP_PID_MASK		_AC(0xffffffff, UL)
@@ -106,6 +107,7 @@ extern unsigned long __swsusp_reset_dma;
 #define MACHINE_HAS_NX		(S390_lowcore.machine_flags & MACHINE_FLAG_NX)
 #define MACHINE_HAS_GS		(S390_lowcore.machine_flags & MACHINE_FLAG_GS)
 #define MACHINE_HAS_SCC		(S390_lowcore.machine_flags & MACHINE_FLAG_SCC)
+#define MACHINE_HAS_PCI_MIO	(S390_lowcore.machine_flags & MACHINE_FLAG_PCI_MIO)
 
 /*
  * Console mode. Override with conmode=
diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index 2531776cf6cf..eb89cb0aa60b 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -252,6 +252,10 @@ static __init void detect_machine_facilities(void)
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
index 6105b1b6e49b..b8ddacf1efe1 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -854,7 +854,6 @@ static void zpci_mem_exit(void)
 }
 
 static unsigned int s390_pci_probe __initdata = 1;
-static unsigned int s390_pci_no_mio __initdata;
 unsigned int s390_pci_force_floating __initdata;
 static unsigned int s390_pci_initialized;
 
@@ -865,7 +864,7 @@ char * __init pcibios_setup(char *str)
 		return NULL;
 	}
 	if (!strcmp(str, "nomio")) {
-		s390_pci_no_mio = 1;
+		S390_lowcore.machine_flags &= ~MACHINE_FLAG_PCI_MIO;
 		return NULL;
 	}
 	if (!strcmp(str, "force_floating")) {
@@ -890,7 +889,7 @@ static int __init pci_base_init(void)
 	if (!test_facility(69) || !test_facility(71))
 		return 0;
 
-	if (test_facility(153) && !s390_pci_no_mio) {
+	if (MACHINE_HAS_PCI_MIO) {
 		static_branch_enable(&have_mio);
 		ctl_set_bit(2, 5);
 	}
-- 
2.30.2

