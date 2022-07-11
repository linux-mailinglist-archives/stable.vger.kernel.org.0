Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E388D56FA98
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbiGKJTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbiGKJTK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:19:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1F84E87D;
        Mon, 11 Jul 2022 02:12:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15463611F0;
        Mon, 11 Jul 2022 09:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AF2C34115;
        Mon, 11 Jul 2022 09:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530726;
        bh=zmAKCFuifIgrl8xnK7nnzm4KnOms+s9J9t89VFFdE/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TXGjBDabfSuNUihUJaGrVGvedaUuK55BvIC8BALUcxgqWz8AKigfyDHSkXsLg6a52
         Mrt0f0t4IdMTfPVZyYDGy0f2FMewvXuIneIAVZveaarwcHyM92zbZ8GxUd6mmOGKna
         +3oh8V4wzbv0CE/qyRpF+xr/2K29yLzcuBX02eVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuee K1r0a <liulin063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH 5.10 06/55] bpf: Fix incorrect verifier simulation around jmp32s jeq/jne
Date:   Mon, 11 Jul 2022 11:06:54 +0200
Message-Id: <20220711090541.951730942@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090541.764895984@linuxfoundation.org>
References: <20220711090541.764895984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit a12ca6277eca6aeeccf66e840c23a2b520e24c8f upstream.

Kuee reported a quirk in the jmp32's jeq/jne simulation, namely that the
register value does not match expectations for the fall-through path. For
example:

Before fix:

  0: R1=ctx(off=0,imm=0) R10=fp0
  0: (b7) r2 = 0                        ; R2_w=P0
  1: (b7) r6 = 563                      ; R6_w=P563
  2: (87) r2 = -r2                      ; R2_w=Pscalar()
  3: (87) r2 = -r2                      ; R2_w=Pscalar()
  4: (4c) w2 |= w6                      ; R2_w=Pscalar(umin=563,umax=4294967295,var_off=(0x233; 0xfffffdcc),s32_min=-2147483085) R6_w=P563
  5: (56) if w2 != 0x8 goto pc+1        ; R2_w=P571  <--- [*]
  6: (95) exit
  R0 !read_ok

After fix:

  0: R1=ctx(off=0,imm=0) R10=fp0
  0: (b7) r2 = 0                        ; R2_w=P0
  1: (b7) r6 = 563                      ; R6_w=P563
  2: (87) r2 = -r2                      ; R2_w=Pscalar()
  3: (87) r2 = -r2                      ; R2_w=Pscalar()
  4: (4c) w2 |= w6                      ; R2_w=Pscalar(umin=563,umax=4294967295,var_off=(0x233; 0xfffffdcc),s32_min=-2147483085) R6_w=P563
  5: (56) if w2 != 0x8 goto pc+1        ; R2_w=P8  <--- [*]
  6: (95) exit
  R0 !read_ok

As can be seen on line 5 for the branch fall-through path in R2 [*] is that
given condition w2 != 0x8 is false, verifier should conclude that r2 = 8 as
upper 32 bit are known to be zero. However, verifier incorrectly concludes
that r2 = 571 which is far off.

The problem is it only marks false{true}_reg as known in the switch for JE/NE
case, but at the end of the function, it uses {false,true}_{64,32}off to
update {false,true}_reg->var_off and they still hold the prior value of
{false,true}_reg->var_off before it got marked as known. The subsequent
__reg_combine_32_into_64() then propagates this old var_off and derives new
bounds. The information between min/max bounds on {false,true}_reg from
setting the register to known const combined with the {false,true}_reg->var_off
based on the old information then derives wrong register data.

Fix it by detangling the BPF_JEQ/BPF_JNE cases and updating relevant
{false,true}_{64,32}off tnums along with the register marking to known
constant.

Fixes: 3f50f132d840 ("bpf: Verifier, do explicit ALU32 bounds tracking")
Reported-by: Kuee K1r0a <liulin063@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20220701124727.11153-1-daniel@iogearbox.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   41 ++++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7512,26 +7512,33 @@ static void reg_set_min_max(struct bpf_r
 		return;
 
 	switch (opcode) {
+	/* JEQ/JNE comparison doesn't change the register equivalence.
+	 *
+	 * r1 = r2;
+	 * if (r1 == 42) goto label;
+	 * ...
+	 * label: // here both r1 and r2 are known to be 42.
+	 *
+	 * Hence when marking register as known preserve it's ID.
+	 */
 	case BPF_JEQ:
+		if (is_jmp32) {
+			__mark_reg32_known(true_reg, val32);
+			true_32off = tnum_subreg(true_reg->var_off);
+		} else {
+			___mark_reg_known(true_reg, val);
+			true_64off = true_reg->var_off;
+		}
+		break;
 	case BPF_JNE:
-	{
-		struct bpf_reg_state *reg =
-			opcode == BPF_JEQ ? true_reg : false_reg;
-
-		/* JEQ/JNE comparison doesn't change the register equivalence.
-		 * r1 = r2;
-		 * if (r1 == 42) goto label;
-		 * ...
-		 * label: // here both r1 and r2 are known to be 42.
-		 *
-		 * Hence when marking register as known preserve it's ID.
-		 */
-		if (is_jmp32)
-			__mark_reg32_known(reg, val32);
-		else
-			___mark_reg_known(reg, val);
+		if (is_jmp32) {
+			__mark_reg32_known(false_reg, val32);
+			false_32off = tnum_subreg(false_reg->var_off);
+		} else {
+			___mark_reg_known(false_reg, val);
+			false_64off = false_reg->var_off;
+		}
 		break;
-	}
 	case BPF_JSET:
 		if (is_jmp32) {
 			false_32off = tnum_and(false_32off, tnum_const(~val32));


