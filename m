Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23C77657FAD
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbiL1QHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:07:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiL1QHX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:07:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69CA11A38
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:07:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8195B6156E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:07:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A44C433D2;
        Wed, 28 Dec 2022 16:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243640;
        bh=7GydrrTjOzdgf2hje16VfZtC5LQQgvcVHgjQHzD9SU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y3ufaECjrxEnBAW/RCyKOKq3b4Ag3+T1020SyOZZi0qqRrVNuSS2E8GKSRUKzdioo
         YgvzR8QhQ0Fv62sqRCX5sIdAjLO/ZPiXXtABL4V/v4uxa4goDeKMa+GD2x0wxTsYLl
         0Nccp60FjQgcS+xpP0goPRC7Wnx4U5FAYF2Kb+4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yonghong Song <yhs@meta.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0526/1146] bpf: Do not zero-extend kfunc return values
Date:   Wed, 28 Dec 2022 15:34:25 +0100
Message-Id: <20221228144344.463507611@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Björn Töpel <bjorn@rivosinc.com>

[ Upstream commit d35af0a7feb077c43ff0233bba5a8c6e75b73e35 ]

In BPF all global functions, and BPF helpers return a 64-bit
value. For kfunc calls, this is not the case, and they can return
e.g. 32-bit values.

The return register R0 for kfuncs calls can therefore be marked as
subreg_def != DEF_NOT_SUBREG. In general, if a register is marked with
subreg_def != DEF_NOT_SUBREG, some archs (where bpf_jit_needs_zext()
returns true) require the verifier to insert explicit zero-extension
instructions.

For kfuncs calls, however, the caller should do sign/zero extension
for return values. In other words, the compiler is responsible to
insert proper instructions, not the verifier.

An example, provided by Yonghong Song:

$ cat t.c
extern unsigned foo(void);
unsigned bar1(void) {
     return foo();
}
unsigned bar2(void) {
     if (foo()) return 10; else return 20;
}

$ clang -target bpf -mcpu=v3 -O2 -c t.c && llvm-objdump -d t.o
t.o:    file format elf64-bpf

Disassembly of section .text:

0000000000000000 <bar1>:
	0:       85 10 00 00 ff ff ff ff call -0x1
	1:       95 00 00 00 00 00 00 00 exit

0000000000000010 <bar2>:
	2:       85 10 00 00 ff ff ff ff call -0x1
	3:       bc 01 00 00 00 00 00 00 w1 = w0
	4:       b4 00 00 00 14 00 00 00 w0 = 0x14
	5:       16 01 01 00 00 00 00 00 if w1 == 0x0 goto +0x1 <LBB1_2>
	6:       b4 00 00 00 0a 00 00 00 w0 = 0xa

0000000000000038 <LBB1_2>:
	7:       95 00 00 00 00 00 00 00 exit

If the return value of 'foo()' is used in the BPF program, the proper
zero-extension will be done.

Currently, the verifier correctly marks, say, a 32-bit return value as
subreg_def != DEF_NOT_SUBREG, but will fail performing the actual
zero-extension, due to a verifier bug in
opt_subreg_zext_lo32_rnd_hi32(). load_reg is not properly set to R0,
and the following path will be taken:

		if (WARN_ON(load_reg == -1)) {
			verbose(env, "verifier bug. zext_dst is set, but no reg is defined\n");
			return -EFAULT;
		}

A longer discussion from v1 can be found in the link below.

Correct the verifier by avoiding doing explicit zero-extension of R0
for kfunc calls. Note that R0 will still be marked as a sub-register
for return values smaller than 64-bit.

Fixes: 83a2881903f3 ("bpf: Account for BPF_FETCH in insn_has_def32()")
Link: https://lore.kernel.org/bpf/20221202103620.1915679-1-bjorn@kernel.org/
Suggested-by: Yonghong Song <yhs@meta.com>
Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/r/20221207103540.396496-1-bjorn@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 5bd27b5196cb..4e098999610e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13402,6 +13402,10 @@ static int opt_subreg_zext_lo32_rnd_hi32(struct bpf_verifier_env *env,
 		if (!bpf_jit_needs_zext() && !is_cmpxchg_insn(&insn))
 			continue;
 
+		/* Zero-extension is done by the caller. */
+		if (bpf_pseudo_kfunc_call(&insn))
+			continue;
+
 		if (WARN_ON(load_reg == -1)) {
 			verbose(env, "verifier bug. zext_dst is set, but no reg is defined\n");
 			return -EFAULT;
-- 
2.35.1



