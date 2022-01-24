Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9006F499E58
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382286AbiAXWcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1585427AbiAXWXd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:23:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64ABDC054331;
        Mon, 24 Jan 2022 12:53:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E806B81218;
        Mon, 24 Jan 2022 20:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9E4C340ED;
        Mon, 24 Jan 2022 20:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057623;
        bh=sPzD3sIHCoQZ6kq2zRn0RcdzuU13RsPBbpmhmt4Sj7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gBJhMhpUwx3GDTbbjD+vQpF544o1mBEsyiDzzzoYyZZxvEWavO2Jw5H4uoKFqCy7k
         psnSlOghs8HX276w87l5XdWe3kiWaol8sR/rvZLtR11SHzDwb4k0A6eNCMrqszV/W1
         UrmFxiM6kK/hTlkBAYziXqMrR/tHsOJfvB7M7s80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Kossifidis <mick@ics.forth.gr>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.16 0026/1039] riscv: Dont use va_pa_offset on kdump
Date:   Mon, 24 Jan 2022 19:30:15 +0100
Message-Id: <20220124184126.019245044@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Kossifidis <mick@ics.forth.gr>

commit a11c07f032a0e9a562a32ece73af96b0e754c4b3 upstream.

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

Fixes: 2bfc6cd81bd1 ("riscv: Move kernel mapping outside of linear mapping")
Signed-off-by: Nick Kossifidis <mick@ics.forth.gr>
Reviewed-by: Alexandre Ghiti <alex@ghiti.fr>
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/kexec_relocate.S |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

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


