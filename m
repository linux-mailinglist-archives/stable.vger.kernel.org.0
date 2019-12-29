Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC9412C8DA
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387446AbfL2R6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:58:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:48912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387443AbfL2R6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:58:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECFBD206DB;
        Sun, 29 Dec 2019 17:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642280;
        bh=IyPu3MbB6w5uYj8Crjut7fmRYmeipanSJO0+eXlVHjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W9zaTt3zrTL7Cjfo3iLq5ZiCSucf6vLUwE0ab/8gRVLWcJIc2Ne4GpDjsnErl1Fd5
         nBiGCGZNJ1RwMzV8Pm71s34GOs/DavDxNFC9J2KUYPCmwtIE8k+ILI29cTL9bfL81r
         Ws3U/NiTlGoJye2GOCAOD2RnWErctyQxNbVl8sZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcus Comstedt <marcus@mc.pp.se>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 415/434] KVM: PPC: Book3S HV: Fix regression on big endian hosts
Date:   Sun, 29 Dec 2019 18:27:48 +0100
Message-Id: <20191229172730.414961353@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcus Comstedt <marcus@mc.pp.se>

commit 228b607d8ea1b7d4561945058d5692709099d432 upstream.

VCPU_CR is the offset of arch.regs.ccr in kvm_vcpu.
arch/powerpc/include/asm/kvm_host.h defines arch.regs as a struct
pt_regs, and arch/powerpc/include/asm/ptrace.h defines the ccr field
of pt_regs as "unsigned long ccr".  Since unsigned long is 64 bits, a
64-bit load needs to be used to load it, unless an endianness specific
correction offset is added to access the desired subpart.  In this
case there is no reason to _not_ use a 64 bit load though.

Fixes: 6c85b7bc637b ("powerpc/kvm: Use UV_RETURN ucall to return to ultravisor")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Marcus Comstedt <marcus@mc.pp.se>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191215094900.46740-1-marcus@mc.pp.se
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -1117,7 +1117,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 	ld	r7, VCPU_GPR(R7)(r4)
 	bne	ret_to_ultra
 
-	lwz	r0, VCPU_CR(r4)
+	ld	r0, VCPU_CR(r4)
 	mtcr	r0
 
 	ld	r0, VCPU_GPR(R0)(r4)
@@ -1137,7 +1137,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
  *   R3 = UV_RETURN
  */
 ret_to_ultra:
-	lwz	r0, VCPU_CR(r4)
+	ld	r0, VCPU_CR(r4)
 	mtcr	r0
 
 	ld	r0, VCPU_GPR(R3)(r4)


