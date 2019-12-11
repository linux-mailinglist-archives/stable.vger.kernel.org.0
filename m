Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4A111B4DB
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732604AbfLKPW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:22:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:53218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732273AbfLKPW3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:22:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4217E2073D;
        Wed, 11 Dec 2019 15:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077747;
        bh=Qpgqb5KvDYOCNjH4+L/VVnzPHJ1CyAFeSY01MUeSrw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ppa+x0UEhwZDkgZAu6frC0l2ZueFt0szEGhDsk0Haq+l2QuzIeOShbtZ+Q4asOWMa
         QdVm1rzsBSgD07XhjOI9WOWsx+0VecCdsdLvD3y4Qk1f+WYhn4apvC2tj2RHR0u1BB
         I+qybhToP3VHBYSJ/c6ebsGsy06XVPQuCakvm4Po=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 108/243] sparc: Fix JIT fused branch convergance.
Date:   Wed, 11 Dec 2019 16:04:30 +0100
Message-Id: <20191211150346.421950243@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Miller <davem@davemloft.net>

[ Upstream commit c44768a33da81b4a0986e79bbf0588f1a0651dec ]

On T4 and later sparc64 cpus we can use the fused compare and branch
instruction.

However, it can only be used if the branch destination is in the range
of a signed 10-bit immediate offset.  This amounts to 1024
instructions forwards or backwards.

After the commit referenced in the Fixes: tag, the largest possible
size program seen by the JIT explodes by a significant factor.

As a result of this convergance takes many more passes since the
expanded "BPF_LDX | BPF_MSH | BPF_B" code sequence, for example,
contains several embedded branch on condition instructions.

On each pass, as suddenly new fused compare and branch instances
become valid, this makes thousands more in range for the next pass.
And so on and so forth.

This is most greatly exemplified by "BPF_MAXINSNS: exec all MSH" which
takes 35 passes to converge, and shrinks the image by about 64K.

To decrease the cost of this number of convergance passes, do the
convergance pass before we have the program image allocated, just like
other JITs (such as x86) do.

Fixes: e0cea7ce988c ("bpf: implement ld_abs/ld_ind in native bpf")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/net/bpf_jit_comp_64.c | 77 ++++++++++++++++++++------------
 1 file changed, 49 insertions(+), 28 deletions(-)

diff --git a/arch/sparc/net/bpf_jit_comp_64.c b/arch/sparc/net/bpf_jit_comp_64.c
index 222785af550b4..7217d63596431 100644
--- a/arch/sparc/net/bpf_jit_comp_64.c
+++ b/arch/sparc/net/bpf_jit_comp_64.c
@@ -1425,12 +1425,12 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	struct bpf_prog *tmp, *orig_prog = prog;
 	struct sparc64_jit_data *jit_data;
 	struct bpf_binary_header *header;
+	u32 prev_image_size, image_size;
 	bool tmp_blinded = false;
 	bool extra_pass = false;
 	struct jit_ctx ctx;
-	u32 image_size;
 	u8 *image_ptr;
-	int pass;
+	int pass, i;
 
 	if (!prog->jit_requested)
 		return orig_prog;
@@ -1461,61 +1461,82 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 		header = jit_data->header;
 		extra_pass = true;
 		image_size = sizeof(u32) * ctx.idx;
+		prev_image_size = image_size;
+		pass = 1;
 		goto skip_init_ctx;
 	}
 
 	memset(&ctx, 0, sizeof(ctx));
 	ctx.prog = prog;
 
-	ctx.offset = kcalloc(prog->len, sizeof(unsigned int), GFP_KERNEL);
+	ctx.offset = kmalloc_array(prog->len, sizeof(unsigned int), GFP_KERNEL);
 	if (ctx.offset == NULL) {
 		prog = orig_prog;
 		goto out_off;
 	}
 
-	/* Fake pass to detect features used, and get an accurate assessment
-	 * of what the final image size will be.
+	/* Longest sequence emitted is for bswap32, 12 instructions.  Pre-cook
+	 * the offset array so that we converge faster.
 	 */
-	if (build_body(&ctx)) {
-		prog = orig_prog;
-		goto out_off;
-	}
-	build_prologue(&ctx);
-	build_epilogue(&ctx);
+	for (i = 0; i < prog->len; i++)
+		ctx.offset[i] = i * (12 * 4);
 
-	/* Now we know the actual image size. */
-	image_size = sizeof(u32) * ctx.idx;
-	header = bpf_jit_binary_alloc(image_size, &image_ptr,
-				      sizeof(u32), jit_fill_hole);
-	if (header == NULL) {
-		prog = orig_prog;
-		goto out_off;
-	}
-
-	ctx.image = (u32 *)image_ptr;
-skip_init_ctx:
-	for (pass = 1; pass < 3; pass++) {
+	prev_image_size = ~0U;
+	for (pass = 1; pass < 40; pass++) {
 		ctx.idx = 0;
 
 		build_prologue(&ctx);
-
 		if (build_body(&ctx)) {
-			bpf_jit_binary_free(header);
 			prog = orig_prog;
 			goto out_off;
 		}
-
 		build_epilogue(&ctx);
 
 		if (bpf_jit_enable > 1)
-			pr_info("Pass %d: shrink = %d, seen = [%c%c%c%c%c%c]\n", pass,
-				image_size - (ctx.idx * 4),
+			pr_info("Pass %d: size = %u, seen = [%c%c%c%c%c%c]\n", pass,
+				ctx.idx * 4,
 				ctx.tmp_1_used ? '1' : ' ',
 				ctx.tmp_2_used ? '2' : ' ',
 				ctx.tmp_3_used ? '3' : ' ',
 				ctx.saw_frame_pointer ? 'F' : ' ',
 				ctx.saw_call ? 'C' : ' ',
 				ctx.saw_tail_call ? 'T' : ' ');
+
+		if (ctx.idx * 4 == prev_image_size)
+			break;
+		prev_image_size = ctx.idx * 4;
+		cond_resched();
+	}
+
+	/* Now we know the actual image size. */
+	image_size = sizeof(u32) * ctx.idx;
+	header = bpf_jit_binary_alloc(image_size, &image_ptr,
+				      sizeof(u32), jit_fill_hole);
+	if (header == NULL) {
+		prog = orig_prog;
+		goto out_off;
+	}
+
+	ctx.image = (u32 *)image_ptr;
+skip_init_ctx:
+	ctx.idx = 0;
+
+	build_prologue(&ctx);
+
+	if (build_body(&ctx)) {
+		bpf_jit_binary_free(header);
+		prog = orig_prog;
+		goto out_off;
+	}
+
+	build_epilogue(&ctx);
+
+	if (ctx.idx * 4 != prev_image_size) {
+		pr_err("bpf_jit: Failed to converge, prev_size=%u size=%d\n",
+		       prev_image_size, ctx.idx * 4);
+		bpf_jit_binary_free(header);
+		prog = orig_prog;
+		goto out_off;
 	}
 
 	if (bpf_jit_enable > 1)
-- 
2.20.1



