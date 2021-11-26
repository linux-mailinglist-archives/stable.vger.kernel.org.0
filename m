Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2628D45F406
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 19:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239352AbhKZS1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 13:27:20 -0500
Received: from mailgate.ics.forth.gr ([139.91.1.2]:45648 "EHLO
        mailgate.ics.forth.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234881AbhKZSZS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 13:25:18 -0500
X-Greylist: delayed 924 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Nov 2021 13:23:15 EST
Received: from av3.ics.forth.gr (av3in.ics.forth.gr [139.91.1.77])
        by mailgate.ics.forth.gr (8.15.2/ICS-FORTH/V10-1.8-GATE) with ESMTP id 1AQI4aws005324
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 20:04:36 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; d=ics.forth.gr; s=av; c=relaxed/simple;
        q=dns/txt; i=@ics.forth.gr; t=1637949871; x=1640541871;
        h=From:Sender:Reply-To:Subject:Date:Message-Id:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MvanV+rEo5Xp6JFqBDVWF0EkA5TJE46GGGiVMEKsDCs=;
        b=FnOdAaVKWdeWfD32YJZr3dXhwr4GmvkQmb75s8DqlIVzNaxG2U+kBK2wstVT/r24
        qd6LtgsI02hUtMbJbtkA5uxduTycAwZcew7DU4NFeiN3JmF9UYyTdsARDcGAGv8h
        C3pABgRfhwllFY+KFeNSqBaq8LKraZqXjYUP3e63X0iujbodhvDpQXR2UeNk9uvi
        3oVRkMzWx6yBtpaGEcSu1+j5nIYHlY8x3UbZ+SxW75SH16MxM2Ta2dFcsRFd5ZHA
        2PQHCxlmO1GtHcPE8OgrOBMbSNX6mDRsZ5pdQgDPa5faxOwCjHgTj3wdne/Q1ZN7
        XjaBAXfsWon7gHVIWi3zuw==;
X-AuditID: 8b5b014d-9a2477000000460a-a9-61a121afd79c
Received: from enigma.ics.forth.gr (enigma-2.ics.forth.gr [139.91.151.35])
        by av3.ics.forth.gr (Symantec Messaging Gateway) with SMTP id 99.14.17930.FA121A16; Fri, 26 Nov 2021 20:04:31 +0200 (EET)
X-ICS-AUTH-INFO: Authenticated user: mick@ics.forth.gr at ics.forth.gr
From:   Nick Kossifidis <mick@ics.forth.gr>
To:     palmer@dabbelt.com, paul.walmsley@sifive.com, aou@eecs.berkeley.edu
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nick Kossifidis <mick@ics.forth.gr>,
        Alexandre Ghiti <alex@ghiti.fr>, stable@vger.kernel.org
Subject: [PATCH 1/3] riscv: Don't use va_pa_offset on kdump
Date:   Fri, 26 Nov 2021 20:04:09 +0200
Message-Id: <20211126180411.187597-1-mick@ics.forth.gr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFLMWRmVeSWpSXmKPExsXSHT1dWXe94sJEg7erOSye3fnKarH19yx2
        i8u75rBZbPvcwmbR/O4cu8XLyz3MFm2z+C0WbHzE6MDh8eblSxaPwx1f2D3unZjG6vFw0yUm
        j81L6j0uNV9n9/i8SS6APYrLJiU1J7MstUjfLoEr49cxo4IdIhU7e14wNzBuFehi5OSQEDCR
        2LJlIXMXIxeHkMAxRolry56zQSTcJG7f38kKYrMJaErMv3SQBcQWEXCXWD35DxNIA7PARkaJ
        2+u2MoMkhAWsJa7s/cUEYrMIqEocP3UJrIFXwFzi9ZbPrBBD5SVOLTvIBBEXlDg58wlYDTNQ
        vHnrbOYJjDyzkKRmIUktYGRaxSiQWGasl5lcrJeWX1SSoZdetIkRHHyMvjsYb29+q3eIkYmD
        8RCjBAezkgivc+D8RCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8vHoT4oUE0hNLUrNTUwtSi2Cy
        TBycUg1MER+P/TLYrLphzYub31+Ur9ZWmyknycvUPefvu83mymVrPP8VeLkteGZhWHwmc+6k
        D+0Hp51YfHTGS/n387zN+TbpqqZJLuyv2nPxH/OCy5M3TnbJT3207eQz33M+f6QKYhw51LZ0
        FXgpNorEWap6rowKb38UqMAXni4Rv3dJoVQBX/fMFSUcuYfKc37W2uxTcjc6HvKnz4rjdLUp
        395jejlvTRc8eBj2oEbqwU0m1cunNTqKFNcFHNGZdTuX3UDxTLhV3IGsp59fCS9Pjq/TUM55
        7WO4RbUvcs/pyMUaS+pff1ZfsDokZO/lc7ktsycumMX2j0nM++LyI9sEXz+3Zk6+XbDxs2vO
        sx+6AWwFSizFGYmGWsxFxYkAQfKrE60CAAA=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On kdump instead of using an intermediate step to relocate the kernel,
that lives in a "control buffer" outside the current kernel's mapping,
we jump to the crash kernel directly by calling riscv_kexec_norelocate().
The current implementation uses va_pa_offset while switching to physical
addressing, however since we moved the kernel outside the linear mapping
this won't work anymore since riscv_kexec_norelocate() is part of the
kernel mapping and we should use kernel_map.va_kernel_pa_offset, and also
take XIP kernel into account.

We don't really need to use va_pa_offset on riscv_kexec_norelocate, we
can just set STVEC to the physical address of the new kernel instead and
let the hart jump to the new kernel on the next instruction after setting
SATP to zero. This fixes kdump and is also simpler/cleaner.

I tested this on the latest qemu and HiFive Unmatched and works as
expected.

v2: I removed the direct jump after setting satp as suggested.

Fixes: 2bfc6cd81bd1 ("riscv: Move kernel mapping outside of linear mapping")

Signed-off-by: Nick Kossifidis <mick@ics.forth.gr>
Reviewed-by: Alexandre Ghiti <alex@ghiti.fr>
Cc: <stable@vger.kernel.org> # 5.13
Cc: <stable@vger.kernel.org> # 5.14
---
 arch/riscv/kernel/kexec_relocate.S | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/riscv/kernel/kexec_relocate.S b/arch/riscv/kernel/kexec_relocate.S
index a80b52a74..059c5e216 100644
--- a/arch/riscv/kernel/kexec_relocate.S
+++ b/arch/riscv/kernel/kexec_relocate.S
@@ -159,25 +159,15 @@ SYM_CODE_START(riscv_kexec_norelocate)
 	 * s0: (const) Phys address to jump to
 	 * s1: (const) Phys address of the FDT image
 	 * s2: (const) The hartid of the current hart
-	 * s3: (const) kernel_map.va_pa_offset, used when switching MMU off
 	 */
 	mv	s0, a1
 	mv	s1, a2
 	mv	s2, a3
-	mv	s3, a4
 
 	/* Disable / cleanup interrupts */
 	csrw	CSR_SIE, zero
 	csrw	CSR_SIP, zero
 
-	/* Switch to physical addressing */
-	la	s4, 1f
-	sub	s4, s4, s3
-	csrw	CSR_STVEC, s4
-	csrw	CSR_SATP, zero
-
-.align 2
-1:
 	/* Pass the arguments to the next kernel  / Cleanup*/
 	mv	a0, s2
 	mv	a1, s1
@@ -214,7 +204,15 @@ SYM_CODE_START(riscv_kexec_norelocate)
 	csrw	CSR_SCAUSE, zero
 	csrw	CSR_SSCRATCH, zero
 
-	jalr	zero, a2, 0
+	/*
+	 * Switch to physical addressing
+	 * This will also trigger a jump to CSR_STVEC
+	 * which in this case is the address of the new
+	 * kernel.
+	 */
+	csrw	CSR_STVEC, a2
+	csrw	CSR_SATP, zero
+
 SYM_CODE_END(riscv_kexec_norelocate)
 
 .section ".rodata"
-- 
2.32.0

