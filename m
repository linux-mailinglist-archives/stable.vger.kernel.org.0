Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 374A8121560
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbfLPSVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:21:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:55000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731497AbfLPSVU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:21:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C80F92176D;
        Mon, 16 Dec 2019 18:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520480;
        bh=iZp58qNXZvgK6F6h9EXZCbeZ/XmPYK+/k0w3Cu9ND8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1LBgtOpevlRvJcoHRWaTYUUS/GE5yAddsPWmtXWfdbofpu/sTpQHRRdbDKlVoJ2xz
         9rbQRRqHnk0djDZG+tC0ZtntSlk1e6D8iDsXSnuiI72//5lvRSnn3HStEvXjudks7C
         u2YQ0wXjNAwFMAaADbpnursiefy7g6hbeu55d7Nk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.4 170/177] s390/kaslr: store KASLR offset for early dumps
Date:   Mon, 16 Dec 2019 18:50:26 +0100
Message-Id: <20191216174850.302004899@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

commit a9f2f6865d784477e1c7b59269d3a384abafd9ca upstream.

The KASLR offset is added to vmcoreinfo in arch_crash_save_vmcoreinfo(),
so that it can be found by crash when processing kernel dumps.

However, arch_crash_save_vmcoreinfo() is called during a subsys_initcall,
so if the kernel crashes before that, we have no vmcoreinfo and no KASLR
offset.

Fix this by storing the KASLR offset in the lowcore, where the vmcore_info
pointer will be stored, and where it can be found by crash. In order to
make it distinguishable from a real vmcore_info pointer, mark it as uneven
(KASLR offset itself is aligned to THREAD_SIZE).

When arch_crash_save_vmcoreinfo() stores the real vmcore_info pointer in
the lowcore, it overwrites the KASLR offset. At that point, the KASLR
offset is not yet added to vmcoreinfo, so we also need to move the
mem_assign_absolute() behind the vmcoreinfo_append_str().

Fixes: b2d24b97b2a9 ("s390/kernel: add support for kernel address space layout randomization (KASLR)")
Cc: <stable@vger.kernel.org> # v5.2+
Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/boot/startup.c         |    5 +++++
 arch/s390/kernel/machine_kexec.c |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/arch/s390/boot/startup.c
+++ b/arch/s390/boot/startup.c
@@ -170,6 +170,11 @@ void startup_kernel(void)
 		handle_relocs(__kaslr_offset);
 
 	if (__kaslr_offset) {
+		/*
+		 * Save KASLR offset for early dumps, before vmcore_info is set.
+		 * Mark as uneven to distinguish from real vmcore_info pointer.
+		 */
+		S390_lowcore.vmcore_info = __kaslr_offset | 0x1UL;
 		/* Clear non-relocated kernel */
 		if (IS_ENABLED(CONFIG_KERNEL_UNCOMPRESSED))
 			memset(img, 0, vmlinux.image_size);
--- a/arch/s390/kernel/machine_kexec.c
+++ b/arch/s390/kernel/machine_kexec.c
@@ -254,10 +254,10 @@ void arch_crash_save_vmcoreinfo(void)
 	VMCOREINFO_SYMBOL(lowcore_ptr);
 	VMCOREINFO_SYMBOL(high_memory);
 	VMCOREINFO_LENGTH(lowcore_ptr, NR_CPUS);
-	mem_assign_absolute(S390_lowcore.vmcore_info, paddr_vmcoreinfo_note());
 	vmcoreinfo_append_str("SDMA=%lx\n", __sdma);
 	vmcoreinfo_append_str("EDMA=%lx\n", __edma);
 	vmcoreinfo_append_str("KERNELOFFSET=%lx\n", kaslr_offset());
+	mem_assign_absolute(S390_lowcore.vmcore_info, paddr_vmcoreinfo_note());
 }
 
 void machine_shutdown(void)


