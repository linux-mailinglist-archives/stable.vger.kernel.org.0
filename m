Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6AA447AFBF
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238427AbhLTPSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:18:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238398AbhLTPRY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:17:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1814C08EC8B;
        Mon, 20 Dec 2021 06:58:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36FDBB80EE3;
        Mon, 20 Dec 2021 14:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E14AC36AE8;
        Mon, 20 Dec 2021 14:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012318;
        bh=73aHFsXyJZB631o321IEXEw6G3TTQGz94vFly0eqiMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qcCRWrySc8ffpOhrPVEaFBzH8FfqtkE9EvvSaKu2Ki6wQ//ihUDRDFRf83KZkyfXi
         IYVS6Qsc88678R1TAkefZtq/9ockWPvRD9R/IrriWJ/EE1ipsYvvZCFAYLd1R0xqv3
         FEiWe1RfeB8XqZu606EBSauZnIwXRx32kiD55mEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.15 158/177] bpf: Fix extable address check.
Date:   Mon, 20 Dec 2021 15:35:08 +0100
Message-Id: <20211220143045.401881209@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

commit 588a25e92458c6efeb7a261d5ca5726f5de89184 upstream.

The verifier checks that PTR_TO_BTF_ID pointer is either valid or NULL,
but it cannot distinguish IS_ERR pointer from valid one.

When offset is added to IS_ERR pointer it may become small positive
value which is a user address that is not handled by extable logic
and has to be checked for at the runtime.

Tighten BPF_PROBE_MEM pointer check code to prevent this case.

Fixes: 4c5de127598e ("bpf: Emit explicit NULL pointer checks for PROBE_LDX instructions.")
Reported-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/net/bpf_jit_comp.c |   49 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 42 insertions(+), 7 deletions(-)

--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1280,19 +1280,54 @@ st:			if (is_imm8(insn->off))
 		case BPF_LDX | BPF_MEM | BPF_DW:
 		case BPF_LDX | BPF_PROBE_MEM | BPF_DW:
 			if (BPF_MODE(insn->code) == BPF_PROBE_MEM) {
-				/* test src_reg, src_reg */
-				maybe_emit_mod(&prog, src_reg, src_reg, true); /* always 1 byte */
-				EMIT2(0x85, add_2reg(0xC0, src_reg, src_reg));
-				/* jne start_of_ldx */
-				EMIT2(X86_JNE, 0);
+				/* Though the verifier prevents negative insn->off in BPF_PROBE_MEM
+				 * add abs(insn->off) to the limit to make sure that negative
+				 * offset won't be an issue.
+				 * insn->off is s16, so it won't affect valid pointers.
+				 */
+				u64 limit = TASK_SIZE_MAX + PAGE_SIZE + abs(insn->off);
+				u8 *end_of_jmp1, *end_of_jmp2;
+
+				/* Conservatively check that src_reg + insn->off is a kernel address:
+				 * 1. src_reg + insn->off >= limit
+				 * 2. src_reg + insn->off doesn't become small positive.
+				 * Cannot do src_reg + insn->off >= limit in one branch,
+				 * since it needs two spare registers, but JIT has only one.
+				 */
+
+				/* movabsq r11, limit */
+				EMIT2(add_1mod(0x48, AUX_REG), add_1reg(0xB8, AUX_REG));
+				EMIT((u32)limit, 4);
+				EMIT(limit >> 32, 4);
+				/* cmp src_reg, r11 */
+				maybe_emit_mod(&prog, src_reg, AUX_REG, true);
+				EMIT2(0x39, add_2reg(0xC0, src_reg, AUX_REG));
+				/* if unsigned '<' goto end_of_jmp2 */
+				EMIT2(X86_JB, 0);
+				end_of_jmp1 = prog;
+
+				/* mov r11, src_reg */
+				emit_mov_reg(&prog, true, AUX_REG, src_reg);
+				/* add r11, insn->off */
+				maybe_emit_1mod(&prog, AUX_REG, true);
+				EMIT2_off32(0x81, add_1reg(0xC0, AUX_REG), insn->off);
+				/* jmp if not carry to start_of_ldx
+				 * Otherwise ERR_PTR(-EINVAL) + 128 will be the user addr
+				 * that has to be rejected.
+				 */
+				EMIT2(0x73 /* JNC */, 0);
+				end_of_jmp2 = prog;
+
 				/* xor dst_reg, dst_reg */
 				emit_mov_imm32(&prog, false, dst_reg, 0);
 				/* jmp byte_after_ldx */
 				EMIT2(0xEB, 0);
 
-				/* populate jmp_offset for JNE above */
-				temp[4] = prog - temp - 5 /* sizeof(test + jne) */;
+				/* populate jmp_offset for JB above to jump to xor dst_reg */
+				end_of_jmp1[-1] = end_of_jmp2 - end_of_jmp1;
+				/* populate jmp_offset for JNC above to jump to start_of_ldx */
 				start_of_ldx = prog;
+				end_of_jmp2[-1] = start_of_ldx - end_of_jmp2;
 			}
 			emit_ldx(&prog, BPF_SIZE(insn->code), dst_reg, src_reg, insn->off);
 			if (BPF_MODE(insn->code) == BPF_PROBE_MEM) {


