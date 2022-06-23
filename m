Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E9D5584F5
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232766AbiFWRve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235299AbiFWRvM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:51:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1487EAA;
        Thu, 23 Jun 2022 10:12:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0A5B61D17;
        Thu, 23 Jun 2022 17:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E64CC3411B;
        Thu, 23 Jun 2022 17:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004332;
        bh=qG/z7pGTlu7rIK35JdI01L2yl2wZZo3gEQBsnATcXHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XdV/hKH2OOvjwTytUTH7ZLlnv8kjuXpre9cbZwNDH0t6z0S/VLuPRxhyTIiXPM1VV
         URZc3RuvqJ+XJ1Nw1rPRC/eezaJ2vIMO1MZefiYJBKJHeZd1XOqC7RHdZsEP8glPMG
         WAzMclbuJnkkkyobp267XbDu5QcbGg0piPGw7UIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Sundberg <simon.sundberg@kau.se>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.15 6/9] bpf: Fix calling global functions from BPF_PROG_TYPE_EXT programs
Date:   Thu, 23 Jun 2022 18:44:49 +0200
Message-Id: <20220623164322.477144391@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164322.288837280@linuxfoundation.org>
References: <20220623164322.288837280@linuxfoundation.org>
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

From: Toke Høiland-Jørgensen <toke@redhat.com>

commit f858c2b2ca04fc7ead291821a793638ae120c11d upstream.

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
[ backport: open-code missing resolve_prog_type() helper, resolve context diff ]
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/btf.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5441,6 +5441,8 @@ static int btf_check_func_arg_match(stru
 				    struct bpf_reg_state *regs,
 				    bool ptr_to_mem_ok)
 {
+	enum bpf_prog_type prog_type = env->prog->type == BPF_PROG_TYPE_EXT ?
+		env->prog->aux->dst_prog->type : env->prog->type;
 	struct bpf_verifier_log *log = &env->log;
 	const char *func_name, *ref_tname;
 	const struct btf_type *t, *ref_t;
@@ -5533,8 +5535,7 @@ static int btf_check_func_arg_match(stru
 					reg_ref_tname);
 				return -EINVAL;
 			}
-		} else if (btf_get_prog_ctx_type(log, btf, t,
-						 env->prog->type, i)) {
+		} else if (btf_get_prog_ctx_type(log, btf, t, prog_type, i)) {
 			/* If function expects ctx type in BTF check that caller
 			 * is passing PTR_TO_CTX.
 			 */


