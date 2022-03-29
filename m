Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA3194EAF65
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 16:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbiC2Oki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 10:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbiC2Okh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 10:40:37 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284FA1BE8E;
        Tue, 29 Mar 2022 07:38:54 -0700 (PDT)
Date:   Tue, 29 Mar 2022 14:38:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1648564732;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UKckQnJOCfFqfkTupAwTwDN05oNgl1gAN+rYy9bq1BI=;
        b=p6X8I/iXjdvz6+wd+KAFnD9tBOy93HKq/k/FhRlMljpHBa9Ut4dRlWMtvAL1pm5O71aqpz
        5v+4m943DfafWNggIPxMihH0x69HrmrYTTelb2+2xmNeGt6q7JE5lGydDpFXP23/HKt9yo
        wnsd57y0s8B5U4LN1XbuYQQtOn4rqcghjmuc3HhGUOeN2Q/XVpkrrs6ovO598wrfuHbcd6
        LQMjY39dmYrPd8hA/7V7q+9P9ibgDxZ3m5h94cC68zVHIRJT5qQylwVEAci9d4mDzUp+Lo
        VK9rAoKF4U7a96CXHLKkF01qbyfSlqiKhnIv2QHM3Vh3f45uxUoeKelf1YPGAA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1648564732;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UKckQnJOCfFqfkTupAwTwDN05oNgl1gAN+rYy9bq1BI=;
        b=czlzVgzmPl7yrwhj24UTyxzAdUNvV6369/G6xbAHdpCdG2BrBz85+FI27cea7nBkP+kbCy
        yE+Nc53q/iBbN9Dg==
From:   "tip-bot2 for Joerg Roedel" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/sev: Unroll string mmio with
 CC_ATTR_GUEST_UNROLL_STRING_IO
Cc:     Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20220321093351.23976-1-joro@8bytes.org>
References: <20220321093351.23976-1-joro@8bytes.org>
MIME-Version: 1.0
Message-ID: <164856473151.389.17789498051927031377.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     4009a4ac82dd95b8cd2b62bd30019476983f0aff
Gitweb:        https://git.kernel.org/tip/4009a4ac82dd95b8cd2b62bd30019476983f0aff
Author:        Joerg Roedel <jroedel@suse.de>
AuthorDate:    Mon, 21 Mar 2022 10:33:51 +01:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 29 Mar 2022 15:59:16 +02:00

x86/sev: Unroll string mmio with CC_ATTR_GUEST_UNROLL_STRING_IO

The io-specific memcpy/memset functions use string mmio accesses to do
their work. Under SEV, the hypervisor can't emulate these instructions
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
SEV virtual machines, because virt-install started to add a tpm-crb
device to the guest by default and proactively because, raisins:

  https://github.com/virt-manager/virt-manager/commit/eb58c09f488b0633ed1eea012cd311e48864401e

and as that commit says, the default adding of a TPM can be disabled
with "virt-install ... --tpm none".

The kernel driver for tpm-crb uses memcpy_to/from_io() functions to
access MMIO memory, resulting in a page-fault injected by KVM and
crashing the kernel at boot.

  [ bp: Massage and extend commit message. ]

Fixes: d8aa7eea78a1 ('x86/mm: Add Secure Encrypted Virtualization (SEV) support')
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220321093351.23976-1-joro@8bytes.org
---
 arch/x86/lib/iomem.c | 65 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 57 insertions(+), 8 deletions(-)

diff --git a/arch/x86/lib/iomem.c b/arch/x86/lib/iomem.c
index df50451..3e2f33f 100644
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
