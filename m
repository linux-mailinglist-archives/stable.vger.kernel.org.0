Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F357D45C2EB
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349610AbhKXNeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:34:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:60584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351585AbhKXNci (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:32:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B05461165;
        Wed, 24 Nov 2021 12:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758385;
        bh=/unO2jc1AdsvwpIESGe4u7Z/eL4XQ2jr6rO8abw0EsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C7564oE0Yxivo1R3xFLmo11AJTGX/kLxP9brn/JcQSEWNgqdAltRgdalFTXx+vfx8
         l+gb9J1vswU2zh+C1POusXZHucJ2JNVIf+w0vYETZixiI37zIEBAgnQOWktFrBZAWG
         i5QUeTY2VBxpC4BDKuPWOqKO2C1eePNb0H6xRTx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Takashi YOSHII <takasi-y@ops.dti.ne.jp>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rich Felker <dalias@libc.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/154] sh: math-emu: drop unused functions
Date:   Wed, 24 Nov 2021 12:57:29 +0100
Message-Id: <20211124115704.045456773@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit e25c252a9b033523c626f039d4b9a304f12f6775 ]

Delete ieee_fpe_handler() since it is not used. After that is done,
delete denormal_to_double() since it is not used:

.../arch/sh/math-emu/math.c:505:12: error: 'ieee_fpe_handler' defined but not used [-Werror=unused-function]
  505 | static int ieee_fpe_handler(struct pt_regs *regs)

.../arch/sh/math-emu/math.c:477:13: error: 'denormal_to_double' defined but not used [-Werror=unused-function]
  477 | static void denormal_to_double(struct sh_fpu_soft_struct *fpu, int n)

Fixes: 7caf62de25554da3 ("sh: remove unused do_fpu_error")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Takashi YOSHII <takasi-y@ops.dti.ne.jp>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Rich Felker <dalias@libc.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/math-emu/math.c | 103 ----------------------------------------
 1 file changed, 103 deletions(-)

diff --git a/arch/sh/math-emu/math.c b/arch/sh/math-emu/math.c
index e8be0eca0444a..615ba932c398e 100644
--- a/arch/sh/math-emu/math.c
+++ b/arch/sh/math-emu/math.c
@@ -467,109 +467,6 @@ static int fpu_emulate(u16 code, struct sh_fpu_soft_struct *fregs, struct pt_reg
 		return id_sys(fregs, regs, code);
 }
 
-/**
- *	denormal_to_double - Given denormalized float number,
- *	                     store double float
- *
- *	@fpu: Pointer to sh_fpu_soft structure
- *	@n: Index to FP register
- */
-static void denormal_to_double(struct sh_fpu_soft_struct *fpu, int n)
-{
-	unsigned long du, dl;
-	unsigned long x = fpu->fpul;
-	int exp = 1023 - 126;
-
-	if (x != 0 && (x & 0x7f800000) == 0) {
-		du = (x & 0x80000000);
-		while ((x & 0x00800000) == 0) {
-			x <<= 1;
-			exp--;
-		}
-		x &= 0x007fffff;
-		du |= (exp << 20) | (x >> 3);
-		dl = x << 29;
-
-		fpu->fp_regs[n] = du;
-		fpu->fp_regs[n+1] = dl;
-	}
-}
-
-/**
- *	ieee_fpe_handler - Handle denormalized number exception
- *
- *	@regs: Pointer to register structure
- *
- *	Returns 1 when it's handled (should not cause exception).
- */
-static int ieee_fpe_handler(struct pt_regs *regs)
-{
-	unsigned short insn = *(unsigned short *)regs->pc;
-	unsigned short finsn;
-	unsigned long nextpc;
-	int nib[4] = {
-		(insn >> 12) & 0xf,
-		(insn >> 8) & 0xf,
-		(insn >> 4) & 0xf,
-		insn & 0xf};
-
-	if (nib[0] == 0xb ||
-	    (nib[0] == 0x4 && nib[2] == 0x0 && nib[3] == 0xb)) /* bsr & jsr */
-		regs->pr = regs->pc + 4;
-
-	if (nib[0] == 0xa || nib[0] == 0xb) { /* bra & bsr */
-		nextpc = regs->pc + 4 + ((short) ((insn & 0xfff) << 4) >> 3);
-		finsn = *(unsigned short *) (regs->pc + 2);
-	} else if (nib[0] == 0x8 && nib[1] == 0xd) { /* bt/s */
-		if (regs->sr & 1)
-			nextpc = regs->pc + 4 + ((char) (insn & 0xff) << 1);
-		else
-			nextpc = regs->pc + 4;
-		finsn = *(unsigned short *) (regs->pc + 2);
-	} else if (nib[0] == 0x8 && nib[1] == 0xf) { /* bf/s */
-		if (regs->sr & 1)
-			nextpc = regs->pc + 4;
-		else
-			nextpc = regs->pc + 4 + ((char) (insn & 0xff) << 1);
-		finsn = *(unsigned short *) (regs->pc + 2);
-	} else if (nib[0] == 0x4 && nib[3] == 0xb &&
-		 (nib[2] == 0x0 || nib[2] == 0x2)) { /* jmp & jsr */
-		nextpc = regs->regs[nib[1]];
-		finsn = *(unsigned short *) (regs->pc + 2);
-	} else if (nib[0] == 0x0 && nib[3] == 0x3 &&
-		 (nib[2] == 0x0 || nib[2] == 0x2)) { /* braf & bsrf */
-		nextpc = regs->pc + 4 + regs->regs[nib[1]];
-		finsn = *(unsigned short *) (regs->pc + 2);
-	} else if (insn == 0x000b) { /* rts */
-		nextpc = regs->pr;
-		finsn = *(unsigned short *) (regs->pc + 2);
-	} else {
-		nextpc = regs->pc + 2;
-		finsn = insn;
-	}
-
-	if ((finsn & 0xf1ff) == 0xf0ad) { /* fcnvsd */
-		struct task_struct *tsk = current;
-
-		if ((tsk->thread.xstate->softfpu.fpscr & (1 << 17))) {
-			/* FPU error */
-			denormal_to_double (&tsk->thread.xstate->softfpu,
-					    (finsn >> 8) & 0xf);
-			tsk->thread.xstate->softfpu.fpscr &=
-				~(FPSCR_CAUSE_MASK | FPSCR_FLAG_MASK);
-			task_thread_info(tsk)->status |= TS_USEDFPU;
-		} else {
-			force_sig_fault(SIGFPE, FPE_FLTINV,
-					(void __user *)regs->pc);
-		}
-
-		regs->pc = nextpc;
-		return 1;
-	}
-
-	return 0;
-}
-
 /**
  * fpu_init - Initialize FPU registers
  * @fpu: Pointer to software emulated FPU registers.
-- 
2.33.0



