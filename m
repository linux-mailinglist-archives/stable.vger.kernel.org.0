Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3834F32D6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239211AbiDEIox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241121AbiDEIcv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C750315A31;
        Tue,  5 Apr 2022 01:27:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81B2CB81B13;
        Tue,  5 Apr 2022 08:27:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4545C385A1;
        Tue,  5 Apr 2022 08:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147277;
        bh=CsCfsrqveqsvvCg/VUPqJOnuL/ZARRvyzdCgukRxZig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Chi9LlevsCp+K2EVpmYZvnEWiulU7wLFs4lsfpj9UmXpq30s2SBHHg1VzcQzUxsu+
         0TGfqU2L6YCBdLrmNxXm1BiB7smI1lYSEdj2bQgisq9pHeNw5MRIlzfoNZTCiURKiP
         vb7hpf5a2wtYj/z0FgjAU4r2kxS29ihyC3W4YofY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 5.17 1066/1126] x86/sev: Unroll string mmio with CC_ATTR_GUEST_UNROLL_STRING_IO
Date:   Tue,  5 Apr 2022 09:30:13 +0200
Message-Id: <20220405070438.747427541@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

commit 4009a4ac82dd95b8cd2b62bd30019476983f0aff upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/lib/iomem.c |   65 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 57 insertions(+), 8 deletions(-)

--- a/arch/x86/lib/iomem.c
+++ b/arch/x86/lib/iomem.c
@@ -22,7 +22,7 @@ static __always_inline void rep_movs(voi
 		     : "memory");
 }
 
-void memcpy_fromio(void *to, const volatile void __iomem *from, size_t n)
+static void string_memcpy_fromio(void *to, const volatile void __iomem *from, size_t n)
 {
 	if (unlikely(!n))
 		return;
@@ -38,9 +38,8 @@ void memcpy_fromio(void *to, const volat
 	}
 	rep_movs(to, (const void *)from, n);
 }
-EXPORT_SYMBOL(memcpy_fromio);
 
-void memcpy_toio(volatile void __iomem *to, const void *from, size_t n)
+static void string_memcpy_toio(volatile void __iomem *to, const void *from, size_t n)
 {
 	if (unlikely(!n))
 		return;
@@ -56,14 +55,64 @@ void memcpy_toio(volatile void __iomem *
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


