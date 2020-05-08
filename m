Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E261CAAE0
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgEHMhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:37:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728101AbgEHMhc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:37:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C655221473;
        Fri,  8 May 2020 12:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941452;
        bh=QpgNNNgtpRDIJAcTfcoz9PXG4wnbDuhokr3Mjko/7KQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aldtj/ho/NQ77qiaBg8m6HVi+baQrI3JyelSaK5vm0o5SSEqYV8mJVoPZoKSJ5PNm
         q7TMCiIiRdRXItgCH+DRnEiXoLqj1AJSPkc9g43UTQT6BRrb4ZKF4sF5ak+NkNQe/Z
         Q3D8vr3IR2ex3ToGkUqSHPoK+8ZLwniE9OfP/GoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Burton <paul.burton@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        "Maciej W. Rozycki" <macro@imgtec.com>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 4.4 020/312] MIPS: math-emu: Fix BC1{EQ,NE}Z emulation
Date:   Fri,  8 May 2020 14:30:11 +0200
Message-Id: <20200508123125.906625030@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Burton <paul.burton@imgtec.com>

commit 93583e178ebfdd2fadf950eef1547f305cac12ca upstream.

The conditions for branching when emulating the BC1EQZ & BC1NEZ
instructions were backwards, leading to each of those instructions being
treated as the other. Fix this by reversing the conditions, and clear up
the code a little for readability & checkpatch.

Fixes: c909ca718e8f ("MIPS: math-emu: Emulate missing BC1{EQ,NE}Z instructions")
Signed-off-by: Paul Burton <paul.burton@imgtec.com>
Reviewed-by: James Hogan <james.hogan@imgtec.com>
Cc: Maciej W. Rozycki <macro@imgtec.com>
Cc: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Patchwork: https://patchwork.linux-mips.org/patch/13150/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/math-emu/cp1emu.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/arch/mips/math-emu/cp1emu.c
+++ b/arch/mips/math-emu/cp1emu.c
@@ -975,9 +975,10 @@ static int cop1Emulate(struct pt_regs *x
 		struct mm_decoded_insn dec_insn, void *__user *fault_addr)
 {
 	unsigned long contpc = xcp->cp0_epc + dec_insn.pc_inc;
-	unsigned int cond, cbit;
+	unsigned int cond, cbit, bit0;
 	mips_instruction ir;
 	int likely, pc_inc;
+	union fpureg *fpr;
 	u32 __user *wva;
 	u64 __user *dva;
 	u32 wval;
@@ -1189,14 +1190,14 @@ emul:
 				return SIGILL;
 
 			cond = likely = 0;
+			fpr = &current->thread.fpu.fpr[MIPSInst_RT(ir)];
+			bit0 = get_fpr32(fpr, 0) & 0x1;
 			switch (MIPSInst_RS(ir)) {
 			case bc1eqz_op:
-				if (get_fpr32(&current->thread.fpu.fpr[MIPSInst_RT(ir)], 0) & 0x1)
-				    cond = 1;
+				cond = bit0 == 0;
 				break;
 			case bc1nez_op:
-				if (!(get_fpr32(&current->thread.fpu.fpr[MIPSInst_RT(ir)], 0) & 0x1))
-				    cond = 1;
+				cond = bit0 != 0;
 				break;
 			}
 			goto branch_common;


