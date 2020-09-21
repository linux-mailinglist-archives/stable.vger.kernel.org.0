Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4D4272ED8
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbgIUQwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:52:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727805AbgIUQtd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:49:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5DD62223E;
        Mon, 21 Sep 2020 16:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706972;
        bh=oXD+Njbvw8mxGqlBlIuUpk2+7z5KiA1cV9ic8bOHTeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UQRfrj8HjA0T807v2N7RR/wpNuqTQQsyY6+dAOJiaBDcPD+u5Vg4nRxbKak+LrIgL
         DLsooc/BoO52wwG2Wqs8ylywcNbLTokK5m2PpLbz2LdxKgmVqxrVy0WIw041LSruXm
         /BAQCqsO6pSTPn7lb6dhBU99frlNoaoDxUPkmA10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Yauheni Kaliuta <yauheni.kaliuta@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 47/72] arm64: bpf: Fix branch offset in JIT
Date:   Mon, 21 Sep 2020 18:31:26 +0200
Message-Id: <20200921163124.113419164@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
References: <20200921163121.870386357@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>

[ Upstream commit 32f6865c7aa3c422f710903baa6eb81abc6f559b ]

Running the eBPF test_verifier leads to random errors looking like this:

[ 6525.735488] Unexpected kernel BRK exception at EL1
[ 6525.735502] Internal error: ptrace BRK handler: f2000100 [#1] SMP
[ 6525.741609] Modules linked in: nls_utf8 cifs libdes libarc4 dns_resolver fscache binfmt_misc nls_ascii nls_cp437 vfat fat aes_ce_blk crypto_simd cryptd aes_ce_cipher ghash_ce gf128mul efi_pstore sha2_ce sha256_arm64 sha1_ce evdev efivars efivarfs ip_tables x_tables autofs4 btrfs blake2b_generic xor xor_neon zstd_compress raid6_pq libcrc32c crc32c_generic ahci xhci_pci libahci xhci_hcd igb libata i2c_algo_bit nvme realtek usbcore nvme_core scsi_mod t10_pi netsec mdio_devres of_mdio gpio_keys fixed_phy libphy gpio_mb86s7x
[ 6525.787760] CPU: 3 PID: 7881 Comm: test_verifier Tainted: G        W         5.9.0-rc1+ #47
[ 6525.796111] Hardware name: Socionext SynQuacer E-series DeveloperBox, BIOS build #1 Jun  6 2020
[ 6525.804812] pstate: 20000005 (nzCv daif -PAN -UAO BTYPE=--)
[ 6525.810390] pc : bpf_prog_c3d01833289b6311_F+0xc8/0x9f4
[ 6525.815613] lr : bpf_prog_d53bb52e3f4483f9_F+0x38/0xc8c
[ 6525.820832] sp : ffff8000130cbb80
[ 6525.824141] x29: ffff8000130cbbb0 x28: 0000000000000000
[ 6525.829451] x27: 000005ef6fcbf39b x26: 0000000000000000
[ 6525.834759] x25: ffff8000130cbb80 x24: ffff800011dc7038
[ 6525.840067] x23: ffff8000130cbd00 x22: ffff0008f624d080
[ 6525.845375] x21: 0000000000000001 x20: ffff800011dc7000
[ 6525.850682] x19: 0000000000000000 x18: 0000000000000000
[ 6525.855990] x17: 0000000000000000 x16: 0000000000000000
[ 6525.861298] x15: 0000000000000000 x14: 0000000000000000
[ 6525.866606] x13: 0000000000000000 x12: 0000000000000000
[ 6525.871913] x11: 0000000000000001 x10: ffff8000000a660c
[ 6525.877220] x9 : ffff800010951810 x8 : ffff8000130cbc38
[ 6525.882528] x7 : 0000000000000000 x6 : 0000009864cfa881
[ 6525.887836] x5 : 00ffffffffffffff x4 : 002880ba1a0b3e9f
[ 6525.893144] x3 : 0000000000000018 x2 : ffff8000000a4374
[ 6525.898452] x1 : 000000000000000a x0 : 0000000000000009
[ 6525.903760] Call trace:
[ 6525.906202]  bpf_prog_c3d01833289b6311_F+0xc8/0x9f4
[ 6525.911076]  bpf_prog_d53bb52e3f4483f9_F+0x38/0xc8c
[ 6525.915957]  bpf_dispatcher_xdp_func+0x14/0x20
[ 6525.920398]  bpf_test_run+0x70/0x1b0
[ 6525.923969]  bpf_prog_test_run_xdp+0xec/0x190
[ 6525.928326]  __do_sys_bpf+0xc88/0x1b28
[ 6525.932072]  __arm64_sys_bpf+0x24/0x30
[ 6525.935820]  el0_svc_common.constprop.0+0x70/0x168
[ 6525.940607]  do_el0_svc+0x28/0x88
[ 6525.943920]  el0_sync_handler+0x88/0x190
[ 6525.947838]  el0_sync+0x140/0x180
[ 6525.951154] Code: d4202000 d4202000 d4202000 d4202000 (d4202000)
[ 6525.957249] ---[ end trace cecc3f93b14927e2 ]---

The reason is the offset[] creation and later usage, while building
the eBPF body. The code currently omits the first instruction, since
build_insn() will increase our ctx->idx before saving it.
That was fine up until bounded eBPF loops were introduced. After that
introduction, offset[0] must be the offset of the end of prologue which
is the start of the 1st insn while, offset[n] holds the
offset of the end of n-th insn.

When "taken loop with back jump to 1st insn" test runs, it will
eventually call bpf2a64_offset(-1, 2, ctx). Since negative indexing is
permitted, the current outcome depends on the value stored in
ctx->offset[-1], which has nothing to do with our array.
If the value happens to be 0 the tests will work. If not this error
triggers.

commit 7c2e988f400e ("bpf: fix x64 JIT code generation for jmp to 1st insn")
fixed an indentical bug on x86 when eBPF bounded loops were introduced.

So let's fix it by creating the ctx->offset[] differently. Track the
beginning of instruction and account for the extra instruction while
calculating the arm instruction offsets.

Fixes: 2589726d12a1 ("bpf: introduce bounded loops")
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: Jiri Olsa <jolsa@kernel.org>
Co-developed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Co-developed-by: Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20200917084925.177348-1-ilias.apalodimas@linaro.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 43 +++++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index cdc79de0c794a..945e5f690edec 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -141,14 +141,17 @@ static inline void emit_addr_mov_i64(const int reg, const u64 val,
 	}
 }
 
-static inline int bpf2a64_offset(int bpf_to, int bpf_from,
+static inline int bpf2a64_offset(int bpf_insn, int off,
 				 const struct jit_ctx *ctx)
 {
-	int to = ctx->offset[bpf_to];
-	/* -1 to account for the Branch instruction */
-	int from = ctx->offset[bpf_from] - 1;
-
-	return to - from;
+	/* BPF JMP offset is relative to the next instruction */
+	bpf_insn++;
+	/*
+	 * Whereas arm64 branch instructions encode the offset
+	 * from the branch itself, so we must subtract 1 from the
+	 * instruction offset.
+	 */
+	return ctx->offset[bpf_insn + off] - (ctx->offset[bpf_insn] - 1);
 }
 
 static void jit_fill_hole(void *area, unsigned int size)
@@ -532,7 +535,7 @@ emit_bswap_uxt:
 
 	/* JUMP off */
 	case BPF_JMP | BPF_JA:
-		jmp_offset = bpf2a64_offset(i + off, i, ctx);
+		jmp_offset = bpf2a64_offset(i, off, ctx);
 		check_imm26(jmp_offset);
 		emit(A64_B(jmp_offset), ctx);
 		break;
@@ -559,7 +562,7 @@ emit_bswap_uxt:
 	case BPF_JMP32 | BPF_JSLE | BPF_X:
 		emit(A64_CMP(is64, dst, src), ctx);
 emit_cond_jmp:
-		jmp_offset = bpf2a64_offset(i + off, i, ctx);
+		jmp_offset = bpf2a64_offset(i, off, ctx);
 		check_imm19(jmp_offset);
 		switch (BPF_OP(code)) {
 		case BPF_JEQ:
@@ -780,10 +783,21 @@ static int build_body(struct jit_ctx *ctx, bool extra_pass)
 	const struct bpf_prog *prog = ctx->prog;
 	int i;
 
+	/*
+	 * - offset[0] offset of the end of prologue,
+	 *   start of the 1st instruction.
+	 * - offset[1] - offset of the end of 1st instruction,
+	 *   start of the 2nd instruction
+	 * [....]
+	 * - offset[3] - offset of the end of 3rd instruction,
+	 *   start of 4th instruction
+	 */
 	for (i = 0; i < prog->len; i++) {
 		const struct bpf_insn *insn = &prog->insnsi[i];
 		int ret;
 
+		if (ctx->image == NULL)
+			ctx->offset[i] = ctx->idx;
 		ret = build_insn(insn, ctx, extra_pass);
 		if (ret > 0) {
 			i++;
@@ -791,11 +805,16 @@ static int build_body(struct jit_ctx *ctx, bool extra_pass)
 				ctx->offset[i] = ctx->idx;
 			continue;
 		}
-		if (ctx->image == NULL)
-			ctx->offset[i] = ctx->idx;
 		if (ret)
 			return ret;
 	}
+	/*
+	 * offset is allocated with prog->len + 1 so fill in
+	 * the last element with the offset after the last
+	 * instruction (end of program)
+	 */
+	if (ctx->image == NULL)
+		ctx->offset[i] = ctx->idx;
 
 	return 0;
 }
@@ -871,7 +890,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	memset(&ctx, 0, sizeof(ctx));
 	ctx.prog = prog;
 
-	ctx.offset = kcalloc(prog->len, sizeof(int), GFP_KERNEL);
+	ctx.offset = kcalloc(prog->len + 1, sizeof(int), GFP_KERNEL);
 	if (ctx.offset == NULL) {
 		prog = orig_prog;
 		goto out_off;
@@ -951,7 +970,7 @@ skip_init_ctx:
 	prog->jited_len = image_size;
 
 	if (!prog->is_func || extra_pass) {
-		bpf_prog_fill_jited_linfo(prog, ctx.offset);
+		bpf_prog_fill_jited_linfo(prog, ctx.offset + 1);
 out_off:
 		kfree(ctx.offset);
 		kfree(jit_data);
-- 
2.25.1



