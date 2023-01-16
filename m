Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0F066C70A
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbjAPQ1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:27:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233127AbjAPQ1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:27:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2227027D66
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:15:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0FC860FDF
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:15:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5FD5C433F0;
        Mon, 16 Jan 2023 16:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885725;
        bh=Y9S/adRlmr/fyLsuYoWQk0+mu1ilzxeFTn/rLDWyXgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/RDx85xsZtskfvPwBV5HswG024/RjyNJXfSgoLNF4dfB0gZ4fmT00O44lmxVsW3b
         /PfhonKmfPvy6omfQnO/u253jQqGW2WjfViTdNjpILw6moNUn25j9NLIWnVEKrahJ9
         83bv6bsiJelRA+rZm3UZYE8/zro1QQ88/VLCFk8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 121/658] bpf: propagate precision in ALU/ALU64 operations
Date:   Mon, 16 Jan 2023 16:43:29 +0100
Message-Id: <20230116154915.012487359@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index f705d3752fe0..32b32ecad770 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5140,6 +5140,11 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
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



