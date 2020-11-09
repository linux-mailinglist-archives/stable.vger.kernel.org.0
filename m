Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 891E62ABBC3
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731806AbgKINa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:30:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:36584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731172AbgKINLI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:11:08 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB1412083B;
        Mon,  9 Nov 2020 13:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927467;
        bh=JjnGyfOU+bbL945u0KT2+6VtCgEeYRNzkIyX7bBv24c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tM9upgeDFcY+iTTjQGELDGjvhfmYIHNUD08kLqb6DSJFCBby+G17+xYtwK8oXM6AO
         houwqTRm1OY6+/h2HK16tfKyvOCoovlqSH0OvgOrrueYiRgYjQy5OAKq26avH1ISRF
         yWdiRAIR+GEKA8EiW4oVUDPhDufGdGPWDj7XeJrQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Borislav Petkov <bp@alien8.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Dave Young" <dyoung@redhat.com>,
        Alexander Potapenko <glider@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andy Lutomirski <luto@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Ingo Molnar <mingo@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>,
        Toshimitsu Kani <toshi.kani@hpe.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 39/71] mm: always have io_remap_pfn_range() set pgprot_decrypted()
Date:   Mon,  9 Nov 2020 13:55:33 +0100
Message-Id: <20201109125021.750404211@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

commit f8f6ae5d077a9bdaf5cbf2ac960a5d1a04b47482 upstream.

The purpose of io_remap_pfn_range() is to map IO memory, such as a
memory mapped IO exposed through a PCI BAR.  IO devices do not
understand encryption, so this memory must always be decrypted.
Automatically call pgprot_decrypted() as part of the generic
implementation.

This fixes a bug where enabling AMD SME causes subsystems, such as RDMA,
using io_remap_pfn_range() to expose BAR pages to user space to fail.
The CPU will encrypt access to those BAR pages instead of passing
unencrypted IO directly to the device.

Places not mapping IO should use remap_pfn_range().

Fixes: aca20d546214 ("x86/mm: Add support to make use of Secure Memory Encryption")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: "Dave Young" <dyoung@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Toshimitsu Kani <toshi.kani@hpe.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/0-v1-025d64bdf6c4+e-amd_sme_fix_jgg@nvidia.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/asm-generic/pgtable.h |    4 ----
 include/linux/mm.h            |    9 +++++++++
 2 files changed, 9 insertions(+), 4 deletions(-)

--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -1115,10 +1115,6 @@ static inline bool arch_has_pfn_modify_c
 
 #endif /* !__ASSEMBLY__ */
 
-#ifndef io_remap_pfn_range
-#define io_remap_pfn_range remap_pfn_range
-#endif
-
 #ifndef has_transparent_hugepage
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define has_transparent_hugepage() 1
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2561,6 +2561,15 @@ static inline vm_fault_t vmf_insert_pfn(
 	return VM_FAULT_NOPAGE;
 }
 
+#ifndef io_remap_pfn_range
+static inline int io_remap_pfn_range(struct vm_area_struct *vma,
+				     unsigned long addr, unsigned long pfn,
+				     unsigned long size, pgprot_t prot)
+{
+	return remap_pfn_range(vma, addr, pfn, size, pgprot_decrypted(prot));
+}
+#endif
+
 static inline vm_fault_t vmf_error(int err)
 {
 	if (err == -ENOMEM)


