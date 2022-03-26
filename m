Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFF94E8172
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 15:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbiCZOnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 10:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233312AbiCZOnN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 10:43:13 -0400
Received: from theia.8bytes.org (8bytes.org [81.169.241.247])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA4320288F
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 07:41:36 -0700 (PDT)
Received: from cap.home.8bytes.org (p5b006cf2.dip0.t-ipconnect.de [91.0.108.242])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 66E6F4ED;
        Sat, 26 Mar 2022 15:41:30 +0100 (CET)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, hpa@zytor.com,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v3] x86/sev: Unroll string mmio with CC_ATTR_GUEST_UNROLL_STRING_IO
Date:   Sat, 26 Mar 2022 15:41:27 +0100
Message-Id: <20220326144127.15967-1-joro@8bytes.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The io specific memcpy/memset functions use string mmio accesses to do
their work. Under SEV the hypervisor can't emulate these instructions,
because they read/write directly from/to encrypted memory.

KVM will inject a page fault exception into the guest when it is asked
to emulate string mmio instructions for an SEV guest:

	BUG: unable to handle page fault for address: ffffc90000065068
	#PF: supervisor read access in kernel mode
	#PF: error_code(0x0000) - not-present page
	PGD 8000100000067 P4D 8000100000067 PUD 80001000fb067 PMD 80001000fc067 PTE 80000000fed40173
	Oops: 0000 [#1] PREEMPT SMP NOPTI
	CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.17.0-rc7 #3

As string mmio for an SEV guest can not be supported by the
hypervisor, unroll the instructions for CC_ATTR_GUEST_UNROLL_STRING_IO
enabled kernels.

This issue appears when kernels are launched in recent libvirt-managed
SEV virtual machines, because libvirt started to add a tpm-crb device
to the guest by default.

The kernel driver for tpm-crb uses memcpy_to/from_io() functions to
access MMIO memory, resulting in a page-fault injected by KVM and
crashing the kernel at boot.

Cc: stable@vger.kernel.org #4.15+
Fixes: d8aa7eea78a1 ('x86/mm: Add Secure Encrypted Virtualization (SEV) support')
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
Changes v2->v3:
	- Fix sparse warnings introduced by v2

 arch/x86/lib/iomem.c | 65 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 57 insertions(+), 8 deletions(-)

diff --git a/arch/x86/lib/iomem.c b/arch/x86/lib/iomem.c
index df50451d94ef..3e2f33fc33de 100644
--- a/arch/x86/lib/iomem.c
+++ b/arch/x86/lib/iomem.c
@@ -22,7 +22,7 @@ static __always_inline void rep_movs(void *to, const void *from, size_t n)
 		     : "memory");
 }
 
-void memcpy_fromio(void *to, const volatile void __iomem *from, size_t n)
+static void string_memcpy_fromio(void *to, const volatile void __iomem *from, size_t n)
 {
 	if (unlikely(!n))
 		return;
@@ -38,9 +38,8 @@ void memcpy_fromio(void *to, const volatile void __iomem *from, size_t n)
 	}
 	rep_movs(to, (const void *)from, n);
 }
-EXPORT_SYMBOL(memcpy_fromio);
 
-void memcpy_toio(volatile void __iomem *to, const void *from, size_t n)
+static void string_memcpy_toio(volatile void __iomem *to, const void *from, size_t n)
 {
 	if (unlikely(!n))
 		return;
@@ -56,14 +55,64 @@ void memcpy_toio(volatile void __iomem *to, const void *from, size_t n)
 	}
 	rep_movs((void *)to, (const void *) from, n);
 }
+
+static void unrolled_memcpy_fromio(void *to, const volatile void __iomem *from, size_t n)
+{
+	const volatile char __iomem *in = from;
+	char *out = to;
+	int i;
+
+	for (i = 0; i < n; ++i)
+		out[i] = readb(&in[i]);
+}
+
+static void unrolled_memcpy_toio(volatile void __iomem *to, const void *from, size_t n)
+{
+	volatile char __iomem *out = to;
+	const char *in = from;
+	int i;
+
+	for (i = 0; i < n; ++i)
+		writeb(in[i], &out[i]);
+}
+
+static void unrolled_memset_io(volatile void __iomem *a, int b, size_t c)
+{
+	volatile char __iomem *mem = a;
+	int i;
+
+	for (i = 0; i < c; ++i)
+		writeb(b, &mem[i]);
+}
+
+void memcpy_fromio(void *to, const volatile void __iomem *from, size_t n)
+{
+	if (cc_platform_has(CC_ATTR_GUEST_UNROLL_STRING_IO))
+		unrolled_memcpy_fromio(to, from, n);
+	else
+		string_memcpy_fromio(to, from, n);
+}
+EXPORT_SYMBOL(memcpy_fromio);
+
+void memcpy_toio(volatile void __iomem *to, const void *from, size_t n)
+{
+	if (cc_platform_has(CC_ATTR_GUEST_UNROLL_STRING_IO))
+		unrolled_memcpy_toio(to, from, n);
+	else
+		string_memcpy_toio(to, from, n);
+}
 EXPORT_SYMBOL(memcpy_toio);
 
 void memset_io(volatile void __iomem *a, int b, size_t c)
 {
-	/*
-	 * TODO: memset can mangle the IO patterns quite a bit.
-	 * perhaps it would be better to use a dumb one:
-	 */
-	memset((void *)a, b, c);
+	if (cc_platform_has(CC_ATTR_GUEST_UNROLL_STRING_IO)) {
+		unrolled_memset_io(a, b, c);
+	} else {
+		/*
+		 * TODO: memset can mangle the IO patterns quite a bit.
+		 * perhaps it would be better to use a dumb one:
+		 */
+		memset((void *)a, b, c);
+	}
 }
 EXPORT_SYMBOL(memset_io);
-- 
2.35.1

