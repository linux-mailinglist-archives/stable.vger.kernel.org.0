Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E00A657CE5
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbiL1PhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:37:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233912AbiL1PhL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:37:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A7515807
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:37:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9300DCE1369
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:37:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841DCC433D2;
        Wed, 28 Dec 2022 15:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241826;
        bh=p+eY2TjcsOwquZj+ByI+oHfYOuhzPT2quqjoTKWHHBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNFYzPfSgaJdkGhj6XlkJHHTohKRsuXZrBfuI4WfKFYOWuzFA2M5Lc4YCnZaeHa43
         S5M9u8wi+NycgOjYqEyh2Z9MlmyxG9bXfXGu5HX0P4fbUaX4a/i0e+BJ3oEY9k8pGC
         mDuqE/912SopSgpWikjKvHhsCFwajKGF07mNRcQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0293/1146] bpf: propagate precision in ALU/ALU64 operations
Date:   Wed, 28 Dec 2022 15:30:32 +0100
Message-Id: <20221228144338.097958617@linuxfoundation.org>
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

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit a3b666bfa9c9edc05bca62a87abafe0936bd7f97 ]

When processing ALU/ALU64 operations (apart from BPF_MOV, which is
handled correctly already; and BPF_NEG and BPF_END are special and don't
have source register), if destination register is already marked
precise, this causes problem with potentially missing precision tracking
for the source register. E.g., when we have r1 >>= r5 and r1 is marked
precise, but r5 isn't, this will lead to r5 staying as imprecise. This
is due to the precision backtracking logic stopping early when it sees
r1 is already marked precise. If r1 wasn't precise, we'd keep
backtracking and would add r5 to the set of registers that need to be
marked precise. So there is a discrepancy here which can lead to invalid
and incompatible states matched due to lack of precision marking on r5.
If r1 wasn't precise, precision backtracking would correctly mark both
r1 and r5 as precise.

This is simple to fix, though. During the forward instruction simulation
pass, for arithmetic operations of `scalar <op>= scalar` form (where
<op> is ALU or ALU64 operations), if destination register is already
precise, mark source register as precise. This applies only when both
involved registers are SCALARs. `ptr += scalar` and `scalar += ptr`
cases are already handled correctly.

This does have (negative) effect on some selftest programs and few
Cilium programs.  ~/baseline-tmp-results.csv are veristat results with
this patch, while ~/baseline-results.csv is without it. See post
scriptum for instructions on how to make Cilium programs testable with
veristat. Correctness has a price.

$ ./veristat -C -e file,prog,insns,states ~/baseline-results.csv ~/baseline-tmp-results.csv | grep -v '+0'
File                     Program               Total insns (A)  Total insns (B)  Total insns (DIFF)  Total states (A)  Total states (B)  Total states (DIFF)
-----------------------  --------------------  ---------------  ---------------  ------------------  ----------------  ----------------  -------------------
bpf_cubic.bpf.linked1.o  bpf_cubic_cong_avoid              997             1700      +703 (+70.51%)                62                90        +28 (+45.16%)
test_l4lb.bpf.linked1.o  balancer_ingress                 4559             5469      +910 (+19.96%)               118               126          +8 (+6.78%)
-----------------------  --------------------  ---------------  ---------------  ------------------  ----------------  ----------------  -------------------

$ ./veristat -C -e file,prog,verdict,insns,states ~/baseline-results-cilium.csv ~/baseline-tmp-results-cilium.csv | grep -v '+0'
File           Program                         Total insns (A)  Total insns (B)  Total insns (DIFF)  Total states (A)  Total states (B)  Total states (DIFF)
-------------  ------------------------------  ---------------  ---------------  ------------------  ----------------  ----------------  -------------------
bpf_host.o     tail_nodeport_nat_ingress_ipv6             4448             5261      +813 (+18.28%)               234               247         +13 (+5.56%)
bpf_host.o     tail_nodeport_nat_ipv6_egress              3396             3446        +50 (+1.47%)               201               203          +2 (+1.00%)
bpf_lxc.o      tail_nodeport_nat_ingress_ipv6             4448             5261      +813 (+18.28%)               234               247         +13 (+5.56%)
bpf_overlay.o  tail_nodeport_nat_ingress_ipv6             4448             5261      +813 (+18.28%)               234               247         +13 (+5.56%)
bpf_xdp.o      tail_lb_ipv4                              71736            73442      +1706 (+2.38%)              4295              4370         +75 (+1.75%)
-------------  ------------------------------  ---------------  ---------------  ------------------  ----------------  ----------------  -------------------

P.S. To make Cilium ([0]) programs libbpf-compatible and thus
veristat-loadable, apply changes from topmost commit in [1], which does
minimal changes to Cilium source code, mostly around SEC() annotations
and BPF map definitions.

  [0] https://github.com/cilium/cilium/
  [1] https://github.com/anakryiko/cilium/commits/libbpf-friendliness

Fixes: b5dc0163d8fd ("bpf: precise scalar_value tracking")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20221104163649.121784-2-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d533488b75c6..110d306df4ed 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9215,6 +9215,11 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
 				return err;
 			return adjust_ptr_min_max_vals(env, insn,
 						       dst_reg, src_reg);
+		} else if (dst_reg->precise) {
+			/* if dst_reg is precise, src_reg should be precise as well */
+			err = mark_chain_precision(env, insn->src_reg);
+			if (err)
+				return err;
 		}
 	} else {
 		/* Pretend the src is a reg with a known value, since we only
-- 
2.35.1



