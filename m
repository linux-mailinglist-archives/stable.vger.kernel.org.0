Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 903A953CD91
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 18:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344117AbiFCQyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 12:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344110AbiFCQyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 12:54:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05F82F3A5
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 09:54:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13E16B823A6
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 16:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F39C385A9;
        Fri,  3 Jun 2022 16:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654275275;
        bh=exaxaa5+cP1E5j7wu4Gb/VBi4s8xZKFI12zmi2Nk4+k=;
        h=Subject:To:Cc:From:Date:From;
        b=kOdsHaVP3O1cxfkt5IUZ7OgS11Juy1QqBMv1MYl1VJeeQM+Ob2JUHpkoTbH9nIWJD
         0Fs+yjbwvUySsQYQkhijzGscawwK7knii6zVXST2Z/W515pwvl8gljD/IQxgpYJtVF
         00Az31uxLuz4l9zv4sRNIA9V5TkM7KqHfeybPb6w=
Subject: FAILED: patch "[PATCH] bpf: Do write access check for kfunc and global func" failed to apply to 5.17-stable tree
To:     memxor@gmail.com, ast@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 Jun 2022 18:54:24 +0200
Message-ID: <1654275264101186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.17-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From be77354a3d7ebd4897ee18eca26dca6df9224c76 Mon Sep 17 00:00:00 2001
From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date: Sat, 19 Mar 2022 13:38:23 +0530
Subject: [PATCH] bpf: Do write access check for kfunc and global func

When passing pointer to some map value to kfunc or global func, in
verifier we are passing meta as NULL to various functions, which uses
meta->raw_mode to check whether memory is being written to. Since some
kfunc or global funcs may also write to memory pointers they receive as
arguments, we must check for write access to memory. E.g. in some case
map may be read only and this will be missed by current checks.

However meta->raw_mode allows for uninitialized memory (e.g. on stack),
since there is not enough info available through BTF, we must perform
one call for read access (raw_mode = false), and one for write access
(raw_mode = true).

Fixes: e5069b9c23b3 ("bpf: Support pointers in global func args")
Fixes: d583691c47dc ("bpf: Introduce mem, size argument pair support for kfunc")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20220319080827.73251-2-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d175b70067b3..e9807e6e1090 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4919,8 +4919,7 @@ static int check_mem_size_reg(struct bpf_verifier_env *env,
 	 * out. Only upper bounds can be learned because retval is an
 	 * int type and negative retvals are allowed.
 	 */
-	if (meta)
-		meta->msize_max_value = reg->umax_value;
+	meta->msize_max_value = reg->umax_value;
 
 	/* The register is SCALAR_VALUE; the access check
 	 * happens using its boundaries.
@@ -4963,24 +4962,33 @@ static int check_mem_size_reg(struct bpf_verifier_env *env,
 int check_mem_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
 		   u32 regno, u32 mem_size)
 {
+	bool may_be_null = type_may_be_null(reg->type);
+	struct bpf_reg_state saved_reg;
+	struct bpf_call_arg_meta meta;
+	int err;
+
 	if (register_is_null(reg))
 		return 0;
 
-	if (type_may_be_null(reg->type)) {
-		/* Assuming that the register contains a value check if the memory
-		 * access is safe. Temporarily save and restore the register's state as
-		 * the conversion shouldn't be visible to a caller.
-		 */
-		const struct bpf_reg_state saved_reg = *reg;
-		int rv;
-
+	memset(&meta, 0, sizeof(meta));
+	/* Assuming that the register contains a value check if the memory
+	 * access is safe. Temporarily save and restore the register's state as
+	 * the conversion shouldn't be visible to a caller.
+	 */
+	if (may_be_null) {
+		saved_reg = *reg;
 		mark_ptr_not_null_reg(reg);
-		rv = check_helper_mem_access(env, regno, mem_size, true, NULL);
-		*reg = saved_reg;
-		return rv;
 	}
 
-	return check_helper_mem_access(env, regno, mem_size, true, NULL);
+	err = check_helper_mem_access(env, regno, mem_size, true, &meta);
+	/* Check access for BPF_WRITE */
+	meta.raw_mode = true;
+	err = err ?: check_helper_mem_access(env, regno, mem_size, true, &meta);
+
+	if (may_be_null)
+		*reg = saved_reg;
+
+	return err;
 }
 
 int check_kfunc_mem_size_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
@@ -4989,16 +4997,22 @@ int check_kfunc_mem_size_reg(struct bpf_verifier_env *env, struct bpf_reg_state
 	struct bpf_reg_state *mem_reg = &cur_regs(env)[regno - 1];
 	bool may_be_null = type_may_be_null(mem_reg->type);
 	struct bpf_reg_state saved_reg;
+	struct bpf_call_arg_meta meta;
 	int err;
 
 	WARN_ON_ONCE(regno < BPF_REG_2 || regno > BPF_REG_5);
 
+	memset(&meta, 0, sizeof(meta));
+
 	if (may_be_null) {
 		saved_reg = *mem_reg;
 		mark_ptr_not_null_reg(mem_reg);
 	}
 
-	err = check_mem_size_reg(env, reg, regno, true, NULL);
+	err = check_mem_size_reg(env, reg, regno, true, &meta);
+	/* Check access for BPF_WRITE */
+	meta.raw_mode = true;
+	err = err ?: check_mem_size_reg(env, reg, regno, true, &meta);
 
 	if (may_be_null)
 		*mem_reg = saved_reg;

