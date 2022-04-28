Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD6A513F4A
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 02:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353488AbiD2ACs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 20:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353504AbiD2ACr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 20:02:47 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DB4A146B
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 16:59:31 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2eb2bc9018aso61055297b3.18
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 16:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=m9G3VNa+snrD+/d38LQSYm9CBBIrNYzrh6zwl4mLU64=;
        b=gZcE7uw8WP9QLDR+NXZ08TI4BvpB80vrRzCqoTW3XwNW2OgVbPnojAV+c5PfOPkEHw
         2EzbflwYeU7mvdSF7Ttv2x/R+nbPVFTAjgSwbG5+92E4wX8LZGbC9FvgxBhCq/Vf28Yo
         cx0x3fAdTMz5lHXZvpRoVNIYQZ20vxurBxEDPnXnhqIveAT3crlLS2BwQ7MkyQ/ipMZd
         du5VtqULUKSMoIBaJ8p5fccULWCaRvxfWrZuIIk5WpHjkBM57z2Xhb0C65R8J1gLXX98
         rz3O+oCkZocW0sVaxZ8lG27q2/4ZsDUodahc4voXiDuKe0yAJc2bXj0EQhqz5y67d8sT
         NKxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=m9G3VNa+snrD+/d38LQSYm9CBBIrNYzrh6zwl4mLU64=;
        b=Jn4B47Rgzlw7HYYHXrnz5AR2cX0XwmFS1OGCBOzunGsQlycdojUXFYagfkvHxw14sX
         4GhpeYfRycXyby6w2LRJkL/6l3Bq8Ufzpa2W2+BX8PLFhX/ZZf/USAX1ogIcfeErCUor
         SXV4vqyyhiURYNG1wb6BDNCia99ov1vHn6RUn3EB5wYtVek/+fvS36ZSR0DFW+Et6vqs
         IRn7knuwl+xpZBmnzJo+uz9a9U6w1chkI+/89JzrB8f+u+uplAHDh3S73DdWNsvr7+j/
         0Fa279X1rzZlM8bLxfWyFDy9lXx+9hxo/5J10bsUxNnekcWDcCwBtdZMI6LrgMtPjopG
         fRoA==
X-Gm-Message-State: AOAM530UVb3HqqQhTFQTbYy3zndFcw0MLwjiPgcp57Qvqu6H/GqfbBjN
        O1w0a0bCDStLn7aNvAAByRXdWVbnGWU=
X-Google-Smtp-Source: ABdhPJzQF1eAuab2mWCnbNWi1wZMzuphMGtNsT8UkZgNMQ/Dc5NxotIflWh7/ozVGyv8lfjnixThuk2us5s=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:25cd:1665:36bc:f38e])
 (user=haoluo job=sendgmr) by 2002:a05:6902:1381:b0:633:3683:78da with SMTP id
 x1-20020a056902138100b00633368378damr32388145ybu.275.1651190370200; Thu, 28
 Apr 2022 16:59:30 -0700 (PDT)
Date:   Thu, 28 Apr 2022 16:57:48 -0700
In-Reply-To: <20220428235751.103203-1-haoluo@google.com>
Message-Id: <20220428235751.103203-8-haoluo@google.com>
Mime-Version: 1.0
References: <20220428235751.103203-1-haoluo@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH stable linux-5.15.y 07/10] bpf: Make per_cpu_ptr return rdonly PTR_TO_MEM.
From:   Hao Luo <haoluo@google.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, laura@labbott.name,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        stable@vger.kernel.org, Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 34d3a78c681e8e7844b43d1a2f4671a04249c821 upstream.

Tag the return type of {per, this}_cpu_ptr with RDONLY_MEM. The
returned value of this pair of helpers is kernel object, which
can not be updated by bpf programs. Previously these two helpers
return PTR_OT_MEM for kernel objects of scalar type, which allows
one to directly modify the memory. Now with RDONLY_MEM tagging,
the verifier will reject programs that write into RDONLY_MEM.

Fixes: 63d9b80dcf2c ("bpf: Introducte bpf_this_cpu_ptr()")
Fixes: eaa6bcb71ef6 ("bpf: Introduce bpf_per_cpu_ptr()")
Fixes: 4976b718c355 ("bpf: Introduce pseudo_btf_id")
Signed-off-by: Hao Luo <haoluo@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20211217003152.48334-8-haoluo@google.com
Cc: stable@vger.kernel.org # 5.15.x
---
 kernel/bpf/helpers.c  |  4 ++--
 kernel/bpf/verifier.c | 30 ++++++++++++++++++++++++++----
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 2565cd6625b6..7db5511cc300 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -667,7 +667,7 @@ BPF_CALL_2(bpf_per_cpu_ptr, const void *, ptr, u32, cpu)
 const struct bpf_func_proto bpf_per_cpu_ptr_proto = {
 	.func		= bpf_per_cpu_ptr,
 	.gpl_only	= false,
-	.ret_type	= RET_PTR_TO_MEM_OR_BTF_ID | PTR_MAYBE_NULL,
+	.ret_type	= RET_PTR_TO_MEM_OR_BTF_ID | PTR_MAYBE_NULL | MEM_RDONLY,
 	.arg1_type	= ARG_PTR_TO_PERCPU_BTF_ID,
 	.arg2_type	= ARG_ANYTHING,
 };
@@ -680,7 +680,7 @@ BPF_CALL_1(bpf_this_cpu_ptr, const void *, percpu_ptr)
 const struct bpf_func_proto bpf_this_cpu_ptr_proto = {
 	.func		= bpf_this_cpu_ptr,
 	.gpl_only	= false,
-	.ret_type	= RET_PTR_TO_MEM_OR_BTF_ID,
+	.ret_type	= RET_PTR_TO_MEM_OR_BTF_ID | MEM_RDONLY,
 	.arg1_type	= ARG_PTR_TO_PERCPU_BTF_ID,
 };
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0aff2e4976d6..42b64d844eae 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4166,15 +4166,30 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 				mark_reg_unknown(env, regs, value_regno);
 			}
 		}
-	} else if (reg->type == PTR_TO_MEM) {
+	} else if (base_type(reg->type) == PTR_TO_MEM) {
+		bool rdonly_mem = type_is_rdonly_mem(reg->type);
+
+		if (type_may_be_null(reg->type)) {
+			verbose(env, "R%d invalid mem access '%s'\n", regno,
+				reg_type_str(env, reg->type));
+			return -EACCES;
+		}
+
+		if (t == BPF_WRITE && rdonly_mem) {
+			verbose(env, "R%d cannot write into %s\n",
+				regno, reg_type_str(env, reg->type));
+			return -EACCES;
+		}
+
 		if (t == BPF_WRITE && value_regno >= 0 &&
 		    is_pointer_value(env, value_regno)) {
 			verbose(env, "R%d leaks addr into mem\n", value_regno);
 			return -EACCES;
 		}
+
 		err = check_mem_region_access(env, regno, off, size,
 					      reg->mem_size, false);
-		if (!err && t == BPF_READ && value_regno >= 0)
+		if (!err && value_regno >= 0 && (t == BPF_READ || rdonly_mem))
 			mark_reg_unknown(env, regs, value_regno);
 	} else if (reg->type == PTR_TO_CTX) {
 		enum bpf_reg_type reg_type = SCALAR_VALUE;
@@ -6370,6 +6385,13 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 			regs[BPF_REG_0].type = PTR_TO_MEM | ret_flag;
 			regs[BPF_REG_0].mem_size = tsize;
 		} else {
+			/* MEM_RDONLY may be carried from ret_flag, but it
+			 * doesn't apply on PTR_TO_BTF_ID. Fold it, otherwise
+			 * it will confuse the check of PTR_TO_BTF_ID in
+			 * check_mem_access().
+			 */
+			ret_flag &= ~MEM_RDONLY;
+
 			regs[BPF_REG_0].type = PTR_TO_BTF_ID | ret_flag;
 			regs[BPF_REG_0].btf = meta.ret_btf;
 			regs[BPF_REG_0].btf_id = meta.ret_btf_id;
@@ -9172,7 +9194,7 @@ static int check_ld_imm(struct bpf_verifier_env *env, struct bpf_insn *insn)
 
 	if (insn->src_reg == BPF_PSEUDO_BTF_ID) {
 		dst_reg->type = aux->btf_var.reg_type;
-		switch (dst_reg->type) {
+		switch (base_type(dst_reg->type)) {
 		case PTR_TO_MEM:
 			dst_reg->mem_size = aux->btf_var.mem_size;
 			break;
@@ -11313,7 +11335,7 @@ static int check_pseudo_btf_id(struct bpf_verifier_env *env,
 			err = -EINVAL;
 			goto err_put;
 		}
-		aux->btf_var.reg_type = PTR_TO_MEM;
+		aux->btf_var.reg_type = PTR_TO_MEM | MEM_RDONLY;
 		aux->btf_var.mem_size = tsize;
 	} else {
 		aux->btf_var.reg_type = PTR_TO_BTF_ID;
-- 
2.36.0.464.gb9c8b46e94-goog

