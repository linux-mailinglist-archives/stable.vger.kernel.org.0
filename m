Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C17065518BE
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 14:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242062AbiFTMU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 08:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240070AbiFTMU5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:20:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C21632F
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 05:20:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEF4AB81136
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 12:20:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7D4C3411B;
        Mon, 20 Jun 2022 12:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655727653;
        bh=00zo9H40+E0PgNXSOGWrSvyl0QkrTuSOx5FlbnnnQ4A=;
        h=Subject:To:Cc:From:Date:From;
        b=lJA34Jm/Zjcyg8lAw0a2mQRLJhD0gykhwXiBPgL1M4ye4psgOhltoQVoteU0166ok
         F4UBO/DnhMD8RXdxppayAt3fPnjucU0QS1VAg7mn8YF/f8pNi0gNmi3kAYLLhvaEnr
         rDpQprvTaZLuLd8lE8pXHipW1cCUp/qdfUfQHbyE=
Subject: FAILED: patch "[PATCH] bpf: Fix calling global functions from BPF_PROG_TYPE_EXT" failed to apply to 5.18-stable tree
To:     toke@redhat.com, ast@kernel.org, simon.sundberg@kau.se
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jun 2022 14:20:50 +0200
Message-ID: <165572765086164@kroah.com>
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


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f858c2b2ca04fc7ead291821a793638ae120c11d Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Date: Mon, 6 Jun 2022 09:52:51 +0200
Subject: [PATCH] bpf: Fix calling global functions from BPF_PROG_TYPE_EXT
 programs
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The verifier allows programs to call global functions as long as their
argument types match, using BTF to check the function arguments. One of the
allowed argument types to such global functions is PTR_TO_CTX; however the
check for this fails on BPF_PROG_TYPE_EXT functions because the verifier
uses the wrong type to fetch the vmlinux BTF ID for the program context
type. This failure is seen when an XDP program is loaded using
libxdp (which loads it as BPF_PROG_TYPE_EXT and attaches it to a global XDP
type program).

Fix the issue by passing in the target program type instead of the
BPF_PROG_TYPE_EXT type to bpf_prog_get_ctx() when checking function
argument compatibility.

The first Fixes tag refers to the latest commit that touched the code in
question, while the second one points to the code that first introduced
the global function call verification.

v2:
- Use resolve_prog_type()

Fixes: 3363bd0cfbb8 ("bpf: Extend kfunc with PTR_TO_CTX, PTR_TO_MEM argument support")
Fixes: 51c39bb1d5d1 ("bpf: Introduce function-by-function verification")
Reported-by: Simon Sundberg <simon.sundberg@kau.se>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/20220606075253.28422-1-toke@redhat.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 7bccaa4646e5..63d0ac7dfe2f 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6054,6 +6054,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				    struct bpf_reg_state *regs,
 				    bool ptr_to_mem_ok)
 {
+	enum bpf_prog_type prog_type = resolve_prog_type(env->prog);
 	struct bpf_verifier_log *log = &env->log;
 	u32 i, nargs, ref_id, ref_obj_id = 0;
 	bool is_kfunc = btf_is_kernel(btf);
@@ -6171,7 +6172,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				return -EINVAL;
 			}
 			/* rest of the arguments can be anything, like normal kfunc */
-		} else if (btf_get_prog_ctx_type(log, btf, t, env->prog->type, i)) {
+		} else if (btf_get_prog_ctx_type(log, btf, t, prog_type, i)) {
 			/* If function expects ctx type in BTF check that caller
 			 * is passing PTR_TO_CTX.
 			 */

