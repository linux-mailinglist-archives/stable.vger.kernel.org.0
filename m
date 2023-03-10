Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98BFD6B40CB
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjCJNqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:46:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbjCJNqQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:46:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B1F10A2B2
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:46:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B328B82291
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92CAC433D2;
        Fri, 10 Mar 2023 13:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678455972;
        bh=OmxWNCV8SP08sIO5rpzDjqIm+AN6Akcyz2mI6esh3WU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jk6koF4ai+Qez3Og+FgprnC+fEz99HXl8Ag2NyU3W0F4hw88gpHM7XHeSGz9YUoMj
         uJ7rBjWngczNvOAv2qd3/L/lun0VITOJOuJwb3lUxi6ewci0ObuMOzZSXjH6D0wc6N
         eHfmgg+asGyr43IOcNECHrQPgRNhlqxWrZJwY81k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Edward Liaw <edliaw@google.com>
Subject: [PATCH 4.14 008/193] bpf: Fix truncation handling for mod32 dst reg wrt zero
Date:   Fri, 10 Mar 2023 14:36:30 +0100
Message-Id: <20230310133711.199169219@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

Commit 9b00f1b78809309163dda2d044d9e94a3c0248a3 upstream.

Recently noticed that when mod32 with a known src reg of 0 is performed,
then the dst register is 32-bit truncated in verifier:

  0: R1=ctx(id=0,off=0,imm=0) R10=fp0
  0: (b7) r0 = 0
  1: R0_w=inv0 R1=ctx(id=0,off=0,imm=0) R10=fp0
  1: (b7) r1 = -1
  2: R0_w=inv0 R1_w=inv-1 R10=fp0
  2: (b4) w2 = -1
  3: R0_w=inv0 R1_w=inv-1 R2_w=inv4294967295 R10=fp0
  3: (9c) w1 %= w0
  4: R0_w=inv0 R1_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff)) R2_w=inv4294967295 R10=fp0
  4: (b7) r0 = 1
  5: R0_w=inv1 R1_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff)) R2_w=inv4294967295 R10=fp0
  5: (1d) if r1 == r2 goto pc+1
   R0_w=inv1 R1_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff)) R2_w=inv4294967295 R10=fp0
  6: R0_w=inv1 R1_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff)) R2_w=inv4294967295 R10=fp0
  6: (b7) r0 = 2
  7: R0_w=inv2 R1_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff)) R2_w=inv4294967295 R10=fp0
  7: (95) exit
  7: R0=inv1 R1=inv(id=0,umin_value=4294967295,umax_value=4294967295,var_off=(0x0; 0xffffffff)) R2=inv4294967295 R10=fp0
  7: (95) exit

However, as a runtime result, we get 2 instead of 1, meaning the dst
register does not contain (u32)-1 in this case. The reason is fairly
straight forward given the 0 test leaves the dst register as-is:

  # ./bpftool p d x i 23
   0: (b7) r0 = 0
   1: (b7) r1 = -1
   2: (b4) w2 = -1
   3: (16) if w0 == 0x0 goto pc+1
   4: (9c) w1 %= w0
   5: (b7) r0 = 1
   6: (1d) if r1 == r2 goto pc+1
   7: (b7) r0 = 2
   8: (95) exit

This was originally not an issue given the dst register was marked as
completely unknown (aka 64 bit unknown). However, after 468f6eafa6c4
("bpf: fix 32-bit ALU op verification") the verifier casts the register
output to 32 bit, and hence it becomes 32 bit unknown. Note that for
the case where the src register is unknown, the dst register is marked
64 bit unknown. After the fix, the register is truncated by the runtime
and the test passes:

  # ./bpftool p d x i 23
   0: (b7) r0 = 0
   1: (b7) r1 = -1
   2: (b4) w2 = -1
   3: (16) if w0 == 0x0 goto pc+2
   4: (9c) w1 %= w0
   5: (05) goto pc+1
   6: (bc) w1 = w1
   7: (b7) r0 = 1
   8: (1d) if r1 == r2 goto pc+1
   9: (b7) r0 = 2
  10: (95) exit

Semantics also match with {R,W}x mod{64,32} 0 -> {R,W}x. Invalid div
has always been {R,W}x div{64,32} 0 -> 0. Rewrites are as follows:

  mod32:                            mod64:

  (16) if w0 == 0x0 goto pc+2       (15) if r0 == 0x0 goto pc+1
  (9c) w1 %= w0                     (9f) r1 %= r0
  (05) goto pc+1
  (bc) w1 = w1

[Salvatore Bonaccorso: This is an earlier version based on work by
Daniel and John which does not rely on availability of the BPF_JMP32
instruction class. This means it is not even strictly a backport of the
upstream commit mentioned but based on Daniel's and John's work to
address the issue and was finalized by Thadeu Lima de Souza Cascardo.]

Fixes: 468f6eafa6c4 ("bpf: fix 32-bit ALU op verification")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Tested-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Edward Liaw <edliaw@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4846,7 +4846,7 @@ static int fixup_bpf_calls(struct bpf_ve
 			bool is64 = BPF_CLASS(insn->code) == BPF_ALU64;
 			struct bpf_insn mask_and_div[] = {
 				BPF_MOV_REG(BPF_CLASS(insn->code), BPF_REG_AX, insn->src_reg),
-				/* Rx div 0 -> 0 */
+				/* [R,W]x div 0 -> 0 */
 				BPF_JMP_IMM(BPF_JEQ, BPF_REG_AX, 0, 2),
 				BPF_RAW_REG(*insn, insn->dst_reg, BPF_REG_AX),
 				BPF_JMP_IMM(BPF_JA, 0, 0, 1),
@@ -4854,9 +4854,10 @@ static int fixup_bpf_calls(struct bpf_ve
 			};
 			struct bpf_insn mask_and_mod[] = {
 				BPF_MOV_REG(BPF_CLASS(insn->code), BPF_REG_AX, insn->src_reg),
-				/* Rx mod 0 -> Rx */
-				BPF_JMP_IMM(BPF_JEQ, BPF_REG_AX, 0, 1),
+				BPF_JMP_IMM(BPF_JEQ, BPF_REG_AX, 0, 1 + (is64 ? 0 : 1)),
 				BPF_RAW_REG(*insn, insn->dst_reg, BPF_REG_AX),
+				BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+				BPF_MOV32_REG(insn->dst_reg, insn->dst_reg),
 			};
 			struct bpf_insn *patchlet;
 
@@ -4866,7 +4867,7 @@ static int fixup_bpf_calls(struct bpf_ve
 				cnt = ARRAY_SIZE(mask_and_div);
 			} else {
 				patchlet = mask_and_mod;
-				cnt = ARRAY_SIZE(mask_and_mod);
+				cnt = ARRAY_SIZE(mask_and_mod) - (is64 ? 2 : 0);
 			}
 
 			new_prog = bpf_patch_insn_data(env, i + delta, patchlet, cnt);


