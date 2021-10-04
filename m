Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28542420E7D
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236921AbhJDNZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:25:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237013AbhJDNXr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:23:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41C1D61BFB;
        Mon,  4 Oct 2021 13:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353021;
        bh=qJXFG26th9wZxf6QEx7gX5IEgfcdnPJNwgHZPfN/k8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wwirKvkhU0BrtjROUAkoZgJgHhC0yx3jH2rzJ4vVYTK+/XLGnTb4cPDheMJf85Mho
         FG6bylKydGVqGrVfNOJKukv/5W6/LZPIvhuMRthYZPJY34JOIqVCxf+bX8F87rjpRb
         ODNH1PKuLru5lFAYNAY3IHbdfVcNI1q5NkNvIRnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 26/93] bpf: Handle return value of BPF_PROG_TYPE_STRUCT_OPS prog
Date:   Mon,  4 Oct 2021 14:52:24 +0200
Message-Id: <20211004125035.442488954@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 356ed64991c6847a0c4f2e8fa3b1133f7a14f1fc ]

Currently if a function ptr in struct_ops has a return value, its
caller will get a random return value from it, because the return
value of related BPF_PROG_TYPE_STRUCT_OPS prog is just dropped.

So adding a new flag BPF_TRAMP_F_RET_FENTRY_RET to tell bpf trampoline
to save and return the return value of struct_ops prog if ret_size of
the function ptr is greater than 0. Also restricting the flag to be
used alone.

Fixes: 85d33df357b6 ("bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20210914023351.3664499-1-houtao1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 53 ++++++++++++++++++++++++++++---------
 include/linux/bpf.h         |  2 ++
 kernel/bpf/bpf_struct_ops.c |  7 +++--
 3 files changed, 47 insertions(+), 15 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 0a962cd6bac1..a0a7ead52698 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1547,7 +1547,7 @@ static void restore_regs(const struct btf_func_model *m, u8 **prog, int nr_args,
 }
 
 static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
-			   struct bpf_prog *p, int stack_size, bool mod_ret)
+			   struct bpf_prog *p, int stack_size, bool save_ret)
 {
 	u8 *prog = *pprog;
 	int cnt = 0;
@@ -1573,11 +1573,15 @@ static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
 	if (emit_call(&prog, p->bpf_func, prog))
 		return -EINVAL;
 
-	/* BPF_TRAMP_MODIFY_RETURN trampolines can modify the return
+	/*
+	 * BPF_TRAMP_MODIFY_RETURN trampolines can modify the return
 	 * of the previous call which is then passed on the stack to
 	 * the next BPF program.
+	 *
+	 * BPF_TRAMP_FENTRY trampoline may need to return the return
+	 * value of BPF_PROG_TYPE_STRUCT_OPS prog.
 	 */
-	if (mod_ret)
+	if (save_ret)
 		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -8);
 
 	if (p->aux->sleepable) {
@@ -1645,13 +1649,15 @@ static int emit_cond_near_jump(u8 **pprog, void *func, void *ip, u8 jmp_cond)
 }
 
 static int invoke_bpf(const struct btf_func_model *m, u8 **pprog,
-		      struct bpf_tramp_progs *tp, int stack_size)
+		      struct bpf_tramp_progs *tp, int stack_size,
+		      bool save_ret)
 {
 	int i;
 	u8 *prog = *pprog;
 
 	for (i = 0; i < tp->nr_progs; i++) {
-		if (invoke_bpf_prog(m, &prog, tp->progs[i], stack_size, false))
+		if (invoke_bpf_prog(m, &prog, tp->progs[i], stack_size,
+				    save_ret))
 			return -EINVAL;
 	}
 	*pprog = prog;
@@ -1694,6 +1700,23 @@ static int invoke_bpf_mod_ret(const struct btf_func_model *m, u8 **pprog,
 	return 0;
 }
 
+static bool is_valid_bpf_tramp_flags(unsigned int flags)
+{
+	if ((flags & BPF_TRAMP_F_RESTORE_REGS) &&
+	    (flags & BPF_TRAMP_F_SKIP_FRAME))
+		return false;
+
+	/*
+	 * BPF_TRAMP_F_RET_FENTRY_RET is only used by bpf_struct_ops,
+	 * and it must be used alone.
+	 */
+	if ((flags & BPF_TRAMP_F_RET_FENTRY_RET) &&
+	    (flags & ~BPF_TRAMP_F_RET_FENTRY_RET))
+		return false;
+
+	return true;
+}
+
 /* Example:
  * __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev);
  * its 'struct btf_func_model' will be nr_args=2
@@ -1766,17 +1789,19 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	struct bpf_tramp_progs *fmod_ret = &tprogs[BPF_TRAMP_MODIFY_RETURN];
 	u8 **branches = NULL;
 	u8 *prog;
+	bool save_ret;
 
 	/* x86-64 supports up to 6 arguments. 7+ can be added in the future */
 	if (nr_args > 6)
 		return -ENOTSUPP;
 
-	if ((flags & BPF_TRAMP_F_RESTORE_REGS) &&
-	    (flags & BPF_TRAMP_F_SKIP_FRAME))
+	if (!is_valid_bpf_tramp_flags(flags))
 		return -EINVAL;
 
-	if (flags & BPF_TRAMP_F_CALL_ORIG)
-		stack_size += 8; /* room for return value of orig_call */
+	/* room for return value of orig_call or fentry prog */
+	save_ret = flags & (BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_RET_FENTRY_RET);
+	if (save_ret)
+		stack_size += 8;
 
 	if (flags & BPF_TRAMP_F_SKIP_FRAME)
 		/* skip patched call instruction and point orig_call to actual
@@ -1803,7 +1828,8 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	}
 
 	if (fentry->nr_progs)
-		if (invoke_bpf(m, &prog, fentry, stack_size))
+		if (invoke_bpf(m, &prog, fentry, stack_size,
+			       flags & BPF_TRAMP_F_RET_FENTRY_RET))
 			return -EINVAL;
 
 	if (fmod_ret->nr_progs) {
@@ -1850,7 +1876,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	}
 
 	if (fexit->nr_progs)
-		if (invoke_bpf(m, &prog, fexit, stack_size)) {
+		if (invoke_bpf(m, &prog, fexit, stack_size, false)) {
 			ret = -EINVAL;
 			goto cleanup;
 		}
@@ -1870,9 +1896,10 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 			ret = -EINVAL;
 			goto cleanup;
 		}
-		/* restore original return value back into RAX */
-		emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, -8);
 	}
+	/* restore return value of orig_call or fentry prog back into RAX */
+	if (save_ret)
+		emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, -8);
 
 	EMIT1(0x5B); /* pop rbx */
 	EMIT1(0xC9); /* leave */
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 3f93a50c25ef..0caa448f7b40 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -526,6 +526,8 @@ struct btf_func_model {
  * programs only. Should not be used with normal calls and indirect calls.
  */
 #define BPF_TRAMP_F_SKIP_FRAME		BIT(2)
+/* Return the return value of fentry prog. Only used by bpf_struct_ops. */
+#define BPF_TRAMP_F_RET_FENTRY_RET	BIT(4)
 
 /* Each call __bpf_prog_enter + call bpf_func + call __bpf_prog_exit is ~50
  * bytes on x86.  Pick a number to fit into BPF_IMAGE_SIZE / 2
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index f527063864b5..ac283f9b2332 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -367,6 +367,7 @@ static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
 		const struct btf_type *mtype, *ptype;
 		struct bpf_prog *prog;
 		u32 moff;
+		u32 flags;
 
 		moff = btf_member_bit_offset(t, member) / 8;
 		ptype = btf_type_resolve_ptr(btf_vmlinux, member->type, NULL);
@@ -430,10 +431,12 @@ static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
 
 		tprogs[BPF_TRAMP_FENTRY].progs[0] = prog;
 		tprogs[BPF_TRAMP_FENTRY].nr_progs = 1;
+		flags = st_ops->func_models[i].ret_size > 0 ?
+			BPF_TRAMP_F_RET_FENTRY_RET : 0;
 		err = arch_prepare_bpf_trampoline(NULL, image,
 						  st_map->image + PAGE_SIZE,
-						  &st_ops->func_models[i], 0,
-						  tprogs, NULL);
+						  &st_ops->func_models[i],
+						  flags, tprogs, NULL);
 		if (err < 0)
 			goto reset_unlock;
 
-- 
2.33.0



