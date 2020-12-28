Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1539B2E3AD0
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404074AbgL1Nlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:41:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:42146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404069AbgL1Nly (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:41:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60205206ED;
        Mon, 28 Dec 2020 13:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162873;
        bh=dyWkDjoN4+LbMxdoKB7/zPr4aeXpCUykO/2BiZOpTK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UQd8HgVH9EpgS7noTsAri3vcC0WGjVsw/D1W9zLjCaDSkByfhenK983DuozWcCo85
         k8iYTNWB8u0inY2rgQ7R4V4ipI30I3gFJg7PGvgEnOzZSgpHGG8VUQvLy6c4BdUXFI
         FaL5Htz5q9+alg5GKZEo9uxsOj/ydpNOcmOdnfBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/453] x86/apic: Fix x2apic enablement without interrupt remapping
Date:   Mon, 28 Dec 2020 13:45:26 +0100
Message-Id: <20201228124941.564347749@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

[ Upstream commit 26573a97746c7a99f394f9d398ce91a8853b3b89 ]

Currently, Linux as a hypervisor guest will enable x2apic only if there are
no CPUs present at boot time with an APIC ID above 255.

Hotplugging a CPU later with a higher APIC ID would result in a CPU which
cannot be targeted by external interrupts.

Add a filter in x2apic_apic_id_valid() which can be used to prevent such
CPUs from coming online, and allow x2apic to be enabled even if they are
present at boot time.

Fixes: ce69a784504 ("x86/apic: Enable x2APIC without interrupt remapping under KVM")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20201024213535.443185-2-dwmw2@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/apic.h        |  1 +
 arch/x86/kernel/apic/apic.c        | 14 ++++++++------
 arch/x86/kernel/apic/x2apic_phys.c |  9 +++++++++
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 19e94af9cc5d7..6016559ed1713 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -259,6 +259,7 @@ static inline u64 native_x2apic_icr_read(void)
 
 extern int x2apic_mode;
 extern int x2apic_phys;
+extern void __init x2apic_set_max_apicid(u32 apicid);
 extern void __init check_x2apic(void);
 extern void x2apic_setup(void);
 static inline int x2apic_enabled(void)
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index fce94c799f015..06fa808d72032 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1886,20 +1886,22 @@ static __init void try_to_enable_x2apic(int remap_mode)
 		return;
 
 	if (remap_mode != IRQ_REMAP_X2APIC_MODE) {
-		/* IR is required if there is APIC ID > 255 even when running
-		 * under KVM
+		/*
+		 * Using X2APIC without IR is not architecturally supported
+		 * on bare metal but may be supported in guests.
 		 */
-		if (max_physical_apicid > 255 ||
-		    !x86_init.hyper.x2apic_available()) {
+		if (!x86_init.hyper.x2apic_available()) {
 			pr_info("x2apic: IRQ remapping doesn't support X2APIC mode\n");
 			x2apic_disable();
 			return;
 		}
 
 		/*
-		 * without IR all CPUs can be addressed by IOAPIC/MSI
-		 * only in physical mode
+		 * Without IR, all CPUs can be addressed by IOAPIC/MSI only
+		 * in physical mode, and CPUs with an APIC ID that cannnot
+		 * be addressed must not be brought online.
 		 */
+		x2apic_set_max_apicid(255);
 		x2apic_phys = 1;
 	}
 	x2apic_enable();
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index bc9693841353c..e14eae6d6ea71 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -8,6 +8,12 @@
 int x2apic_phys;
 
 static struct apic apic_x2apic_phys;
+static u32 x2apic_max_apicid __ro_after_init;
+
+void __init x2apic_set_max_apicid(u32 apicid)
+{
+	x2apic_max_apicid = apicid;
+}
 
 static int __init set_x2apic_phys_mode(char *arg)
 {
@@ -98,6 +104,9 @@ static int x2apic_phys_probe(void)
 /* Common x2apic functions, also used by x2apic_cluster */
 int x2apic_apic_id_valid(u32 apicid)
 {
+	if (x2apic_max_apicid && apicid > x2apic_max_apicid)
+		return 0;
+
 	return 1;
 }
 
-- 
2.27.0



