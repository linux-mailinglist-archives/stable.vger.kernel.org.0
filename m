Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204EB37C354
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbhELPSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:18:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234318AbhELPQ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:16:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BB1261969;
        Wed, 12 May 2021 15:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831980;
        bh=h59MSIG9erklP9in9YiIPm0y8p9QmQYL0ytDECAvG+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZIJFFGfNVjbhIEzjbNWVBSLzuAeZCMKMEV4pJXahsP89fdM7PnrlUcnbh2AKWrIzZ
         aL9e7CohXhz6lex2QaIST36iWMayTuzRE7hJ+YQBvDytrxcF8EIYpa61GIGk+ug+fk
         yRosxETjP/l0w2z/9xB5OI+b3zHOa1qVYct34WM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Babu Moger <babu.moger@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 092/530] KVM: x86: Remove emulators broken checks on CR0/CR3/CR4 loads
Date:   Wed, 12 May 2021 16:43:22 +0200
Message-Id: <20210512144822.819785618@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit d0fe7b6404408835ed60232cb3bf28324b2f95db upstream.

Remove the emulator's checks for illegal CR0, CR3, and CR4 values, as
the checks are redundant, outdated, and in the case of SEV's C-bit,
broken.  The emulator manually calculates MAXPHYADDR from CPUID and
neglects to mask off the C-bit.  For all other checks, kvm_set_cr*() are
a superset of the emulator checks, e.g. see CR4.LA57.

Fixes: a780a3ea6282 ("KVM: X86: Fix reserved bits check for MOV to CR3")
Cc: Babu Moger <babu.moger@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210422022128.3464144-2-seanjc@google.com>
Cc: stable@vger.kernel.org
[Unify check_cr_read and check_cr_write. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/emulate.c |   80 +------------------------------------------------
 1 file changed, 3 insertions(+), 77 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4220,7 +4220,7 @@ static bool valid_cr(int nr)
 	}
 }
 
-static int check_cr_read(struct x86_emulate_ctxt *ctxt)
+static int check_cr_access(struct x86_emulate_ctxt *ctxt)
 {
 	if (!valid_cr(ctxt->modrm_reg))
 		return emulate_ud(ctxt);
@@ -4228,80 +4228,6 @@ static int check_cr_read(struct x86_emul
 	return X86EMUL_CONTINUE;
 }
 
-static int check_cr_write(struct x86_emulate_ctxt *ctxt)
-{
-	u64 new_val = ctxt->src.val64;
-	int cr = ctxt->modrm_reg;
-	u64 efer = 0;
-
-	static u64 cr_reserved_bits[] = {
-		0xffffffff00000000ULL,
-		0, 0, 0, /* CR3 checked later */
-		CR4_RESERVED_BITS,
-		0, 0, 0,
-		CR8_RESERVED_BITS,
-	};
-
-	if (!valid_cr(cr))
-		return emulate_ud(ctxt);
-
-	if (new_val & cr_reserved_bits[cr])
-		return emulate_gp(ctxt, 0);
-
-	switch (cr) {
-	case 0: {
-		u64 cr4;
-		if (((new_val & X86_CR0_PG) && !(new_val & X86_CR0_PE)) ||
-		    ((new_val & X86_CR0_NW) && !(new_val & X86_CR0_CD)))
-			return emulate_gp(ctxt, 0);
-
-		cr4 = ctxt->ops->get_cr(ctxt, 4);
-		ctxt->ops->get_msr(ctxt, MSR_EFER, &efer);
-
-		if ((new_val & X86_CR0_PG) && (efer & EFER_LME) &&
-		    !(cr4 & X86_CR4_PAE))
-			return emulate_gp(ctxt, 0);
-
-		break;
-		}
-	case 3: {
-		u64 rsvd = 0;
-
-		ctxt->ops->get_msr(ctxt, MSR_EFER, &efer);
-		if (efer & EFER_LMA) {
-			u64 maxphyaddr;
-			u32 eax, ebx, ecx, edx;
-
-			eax = 0x80000008;
-			ecx = 0;
-			if (ctxt->ops->get_cpuid(ctxt, &eax, &ebx, &ecx,
-						 &edx, true))
-				maxphyaddr = eax & 0xff;
-			else
-				maxphyaddr = 36;
-			rsvd = rsvd_bits(maxphyaddr, 63);
-			if (ctxt->ops->get_cr(ctxt, 4) & X86_CR4_PCIDE)
-				rsvd &= ~X86_CR3_PCID_NOFLUSH;
-		}
-
-		if (new_val & rsvd)
-			return emulate_gp(ctxt, 0);
-
-		break;
-		}
-	case 4: {
-		ctxt->ops->get_msr(ctxt, MSR_EFER, &efer);
-
-		if ((efer & EFER_LMA) && !(new_val & X86_CR4_PAE))
-			return emulate_gp(ctxt, 0);
-
-		break;
-		}
-	}
-
-	return X86EMUL_CONTINUE;
-}
-
 static int check_dr7_gd(struct x86_emulate_ctxt *ctxt)
 {
 	unsigned long dr7;
@@ -4841,10 +4767,10 @@ static const struct opcode twobyte_table
 	D(ImplicitOps | ModRM | SrcMem | NoAccess), /* 8 * reserved NOP */
 	D(ImplicitOps | ModRM | SrcMem | NoAccess), /* NOP + 7 * reserved NOP */
 	/* 0x20 - 0x2F */
-	DIP(ModRM | DstMem | Priv | Op3264 | NoMod, cr_read, check_cr_read),
+	DIP(ModRM | DstMem | Priv | Op3264 | NoMod, cr_read, check_cr_access),
 	DIP(ModRM | DstMem | Priv | Op3264 | NoMod, dr_read, check_dr_read),
 	IIP(ModRM | SrcMem | Priv | Op3264 | NoMod, em_cr_write, cr_write,
-						check_cr_write),
+						check_cr_access),
 	IIP(ModRM | SrcMem | Priv | Op3264 | NoMod, em_dr_write, dr_write,
 						check_dr_write),
 	N, N, N, N,


