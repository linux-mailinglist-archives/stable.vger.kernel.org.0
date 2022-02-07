Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C335B4ABA93
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383909AbiBGLYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352740AbiBGLMA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:12:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A83C043181;
        Mon,  7 Feb 2022 03:11:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EADCB80EE8;
        Mon,  7 Feb 2022 11:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73327C340F0;
        Mon,  7 Feb 2022 11:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232317;
        bh=A0RU8r+l+8sVWeobTgW/MCLtGu7DGf8IPAqtA1vxPvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YLIPIm/POsby5w19PVfnC+Z7om8M3SQp1hG4I58wCYoNb2pbcMeCyyZHR9mE2sfoN
         xCjDO8HOtYaru6fYgP0i9IUgTdvNHVKPFSX3AaSUEi/g6bZypIvMolRLRQZc+rZSzj
         8+VoGyMoAIdg9Yr402Wh3b+Vk8gA9da7x8zDdxYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Alessio Balsini <balsini@android.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.14 38/69] bpf: fix truncated jump targets on heavy expansions
Date:   Mon,  7 Feb 2022 12:06:00 +0100
Message-Id: <20220207103756.875238153@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103755.604121441@linuxfoundation.org>
References: <20220207103755.604121441@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 050fad7c4534c13c8eb1d9c2ba66012e014773cb upstream.

Recently during testing, I ran into the following panic:

  [  207.892422] Internal error: Accessing user space memory outside uaccess.h routines: 96000004 [#1] SMP
  [  207.901637] Modules linked in: binfmt_misc [...]
  [  207.966530] CPU: 45 PID: 2256 Comm: test_verifier Tainted: G        W         4.17.0-rc3+ #7
  [  207.974956] Hardware name: FOXCONN R2-1221R-A4/C2U4N_MB, BIOS G31FB18A 03/31/2017
  [  207.982428] pstate: 60400005 (nZCv daif +PAN -UAO)
  [  207.987214] pc : bpf_skb_load_helper_8_no_cache+0x34/0xc0
  [  207.992603] lr : 0xffff000000bdb754
  [  207.996080] sp : ffff000013703ca0
  [  207.999384] x29: ffff000013703ca0 x28: 0000000000000001
  [  208.004688] x27: 0000000000000001 x26: 0000000000000000
  [  208.009992] x25: ffff000013703ce0 x24: ffff800fb4afcb00
  [  208.015295] x23: ffff00007d2f5038 x22: ffff00007d2f5000
  [  208.020599] x21: fffffffffeff2a6f x20: 000000000000000a
  [  208.025903] x19: ffff000009578000 x18: 0000000000000a03
  [  208.031206] x17: 0000000000000000 x16: 0000000000000000
  [  208.036510] x15: 0000ffff9de83000 x14: 0000000000000000
  [  208.041813] x13: 0000000000000000 x12: 0000000000000000
  [  208.047116] x11: 0000000000000001 x10: ffff0000089e7f18
  [  208.052419] x9 : fffffffffeff2a6f x8 : 0000000000000000
  [  208.057723] x7 : 000000000000000a x6 : 00280c6160000000
  [  208.063026] x5 : 0000000000000018 x4 : 0000000000007db6
  [  208.068329] x3 : 000000000008647a x2 : 19868179b1484500
  [  208.073632] x1 : 0000000000000000 x0 : ffff000009578c08
  [  208.078938] Process test_verifier (pid: 2256, stack limit = 0x0000000049ca7974)
  [  208.086235] Call trace:
  [  208.088672]  bpf_skb_load_helper_8_no_cache+0x34/0xc0
  [  208.093713]  0xffff000000bdb754
  [  208.096845]  bpf_test_run+0x78/0xf8
  [  208.100324]  bpf_prog_test_run_skb+0x148/0x230
  [  208.104758]  sys_bpf+0x314/0x1198
  [  208.108064]  el0_svc_naked+0x30/0x34
  [  208.111632] Code: 91302260 f9400001 f9001fa1 d2800001 (29500680)
  [  208.117717] ---[ end trace 263cb8a59b5bf29f ]---

The program itself which caused this had a long jump over the whole
instruction sequence where all of the inner instructions required
heavy expansions into multiple BPF instructions. Additionally, I also
had BPF hardening enabled which requires once more rewrites of all
constant values in order to blind them. Each time we rewrite insns,
bpf_adj_branches() would need to potentially adjust branch targets
which cross the patchlet boundary to accommodate for the additional
delta. Eventually that lead to the case where the target offset could
not fit into insn->off's upper 0x7fff limit anymore where then offset
wraps around becoming negative (in s16 universe), or vice versa
depending on the jump direction.

Therefore it becomes necessary to detect and reject any such occasions
in a generic way for native eBPF and cBPF to eBPF migrations. For
the latter we can simply check bounds in the bpf_convert_filter()'s
BPF_EMIT_JMP helper macro and bail out once we surpass limits. The
bpf_patch_insn_single() for native eBPF (and cBPF to eBPF in case
of subsequent hardening) is a bit more complex in that we need to
detect such truncations before hitting the bpf_prog_realloc(). Thus
the latter is split into an extra pass to probe problematic offsets
on the original program in order to fail early. With that in place
and carefully tested I no longer hit the panic and the rewrites are
rejected properly. The above example panic I've seen on bpf-next,
though the issue itself is generic in that a guard against this issue
in bpf seems more appropriate in this case.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[ab: Dropped BPF_PSEUDO_CALL hardening, introoduced in 4.16]
Signed-off-by: Alessio Balsini <balsini@android.com>
Acked-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/core.c |   59 ++++++++++++++++++++++++++++++++++++++++++++++--------
 net/core/filter.c |   11 ++++++++--
 2 files changed, 60 insertions(+), 10 deletions(-)

--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -228,27 +228,57 @@ static bool bpf_is_jmp_and_has_target(co
 	       BPF_OP(insn->code) != BPF_EXIT;
 }
 
-static void bpf_adj_branches(struct bpf_prog *prog, u32 pos, u32 delta)
+static int bpf_adj_delta_to_off(struct bpf_insn *insn, u32 pos, u32 delta,
+				u32 curr, const bool probe_pass)
 {
+	const s32 off_min = S16_MIN, off_max = S16_MAX;
+	s32 off = insn->off;
+
+	if (curr < pos && curr + off + 1 > pos)
+		off += delta;
+	else if (curr > pos + delta && curr + off + 1 <= pos + delta)
+		off -= delta;
+	if (off < off_min || off > off_max)
+		return -ERANGE;
+	if (!probe_pass)
+		insn->off = off;
+	return 0;
+}
+
+static int bpf_adj_branches(struct bpf_prog *prog, u32 pos, u32 delta,
+			    const bool probe_pass)
+{
+	u32 i, insn_cnt = prog->len + (probe_pass ? delta : 0);
 	struct bpf_insn *insn = prog->insnsi;
-	u32 i, insn_cnt = prog->len;
+	int ret = 0;
 
 	for (i = 0; i < insn_cnt; i++, insn++) {
+		/* In the probing pass we still operate on the original,
+		 * unpatched image in order to check overflows before we
+		 * do any other adjustments. Therefore skip the patchlet.
+		 */
+		if (probe_pass && i == pos) {
+			i += delta + 1;
+			insn++;
+		}
+
 		if (!bpf_is_jmp_and_has_target(insn))
 			continue;
 
-		/* Adjust offset of jmps if we cross boundaries. */
-		if (i < pos && i + insn->off + 1 > pos)
-			insn->off += delta;
-		else if (i > pos + delta && i + insn->off + 1 <= pos + delta)
-			insn->off -= delta;
+		/* Adjust offset of jmps if we cross patch boundaries. */
+		ret = bpf_adj_delta_to_off(insn, pos, delta, i, probe_pass);
+		if (ret)
+			break;
 	}
+
+	return ret;
 }
 
 struct bpf_prog *bpf_patch_insn_single(struct bpf_prog *prog, u32 off,
 				       const struct bpf_insn *patch, u32 len)
 {
 	u32 insn_adj_cnt, insn_rest, insn_delta = len - 1;
+	const u32 cnt_max = S16_MAX;
 	struct bpf_prog *prog_adj;
 
 	/* Since our patchlet doesn't expand the image, we're done. */
@@ -259,6 +289,15 @@ struct bpf_prog *bpf_patch_insn_single(s
 
 	insn_adj_cnt = prog->len + insn_delta;
 
+	/* Reject anything that would potentially let the insn->off
+	 * target overflow when we have excessive program expansions.
+	 * We need to probe here before we do any reallocation where
+	 * we afterwards may not fail anymore.
+	 */
+	if (insn_adj_cnt > cnt_max &&
+	    bpf_adj_branches(prog, off, insn_delta, true))
+		return NULL;
+
 	/* Several new instructions need to be inserted. Make room
 	 * for them. Likely, there's no need for a new allocation as
 	 * last page could have large enough tailroom.
@@ -284,7 +323,11 @@ struct bpf_prog *bpf_patch_insn_single(s
 		sizeof(*patch) * insn_rest);
 	memcpy(prog_adj->insnsi + off, patch, sizeof(*patch) * len);
 
-	bpf_adj_branches(prog_adj, off, insn_delta);
+	/* We are guaranteed to not fail at this point, otherwise
+	 * the ship has sailed to reverse to the original state. An
+	 * overflow cannot happen at this point.
+	 */
+	BUG_ON(bpf_adj_branches(prog_adj, off, insn_delta, false));
 
 	return prog_adj;
 }
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -472,11 +472,18 @@ do_pass:
 
 #define BPF_EMIT_JMP							\
 	do {								\
+		const s32 off_min = S16_MIN, off_max = S16_MAX;		\
+		s32 off;						\
+									\
 		if (target >= len || target < 0)			\
 			goto err;					\
-		insn->off = addrs ? addrs[target] - addrs[i] - 1 : 0;	\
+		off = addrs ? addrs[target] - addrs[i] - 1 : 0;		\
 		/* Adjust pc relative offset for 2nd or 3rd insn. */	\
-		insn->off -= insn - tmp_insns;				\
+		off -= insn - tmp_insns;				\
+		/* Reject anything not fitting into insn->off. */	\
+		if (off < off_min || off > off_max)			\
+			goto err;					\
+		insn->off = off;					\
 	} while (0)
 
 		case BPF_JMP | BPF_JA:


