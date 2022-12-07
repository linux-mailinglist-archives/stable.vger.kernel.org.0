Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0045864602A
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 18:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiLGR0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 12:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiLGR0C (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 12:26:02 -0500
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FA25B5A4;
        Wed,  7 Dec 2022 09:25:59 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.229])
        by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4NS3sh1xb2z9xGZF;
        Thu,  8 Dec 2022 01:18:48 +0800 (CST)
Received: from huaweicloud.com (unknown [10.204.63.22])
        by APP1 (Coremail) with SMTP id LxC2BwD34m9YzJBjc9DJAA--.62662S6;
        Wed, 07 Dec 2022 18:25:35 +0100 (CET)
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, revest@chromium.org,
        jackmanb@chromium.org, mykolal@fb.com, paul@paul-moore.com,
        jmorris@namei.org, serge@hallyn.com, shuah@kernel.org
Cc:     bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Subject: [RFC][PATCH v2 4/7] bpf-lsm: Enforce return value limitations on security modules
Date:   Wed,  7 Dec 2022 18:24:31 +0100
Message-Id: <20221207172434.435893-5-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221207172434.435893-1-roberto.sassu@huaweicloud.com>
References: <20221207172434.435893-1-roberto.sassu@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LxC2BwD34m9YzJBjc9DJAA--.62662S6
X-Coremail-Antispam: 1UD129KBjvJXoW3GFy5Aw1xWF47tFWDJF1kXwb_yoWxGw1rpr
        WfAFyYkr4v93y7W3Wqyan5ZrZ5XF10ga1UGF98G34Fvr42vryvqw1UGrnIvry5Cryjgr1x
        Kr42grWjgw47ZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUPlb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
        Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
        rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
        AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E
        14v26r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrV
        C2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE
        7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262
        kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s02
        6c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GF
        v_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvE
        c7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aV
        AFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZF
        pf9x07j7GYLUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgATBF1jj4JqowAAsv
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

With the patch for the LSM infrastructure to redefine the LSM_HOOK() macro
and to introduce the return value flags, it becomes straightforward for
eBPF to leverage this information to enforce return values limitations on
eBPF programs implementing security hooks.

Update the bpf_lsm_hooks BTF ID set, by including the return value flags.
Then, introduce bpf_lsm_is_ret_value_allowed(), which determines in which
intervals the R0 register (which contains the return value) falls, and
checks if the corresponding return value flag is set for those intervals.

In addition, for the interval including zero, ensure that the hook is not
inode_init_security, otherwise report that zero is not allowed. By LSM
conventions, LSMs should return zero only if they set an xattr, which
currently eBPF programs cannot do.

Finally, expose the new function and add a call to it in the verifier.

Cc: stable@vger.kernel.org # 5.7.x
Fixes: 9d3fdea789c8 ("bpf: lsm: Provide attachment points for BPF LSM programs")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 include/linux/bpf_lsm.h |  9 +++++
 kernel/bpf/bpf_lsm.c    | 78 ++++++++++++++++++++++++++++++++++++++---
 kernel/bpf/verifier.c   |  7 ++--
 3 files changed, 87 insertions(+), 7 deletions(-)

diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
index 2f5757085dfd..0ce5948f3662 100644
--- a/include/linux/bpf_lsm.h
+++ b/include/linux/bpf_lsm.h
@@ -29,6 +29,8 @@ int bpf_lsm_verify_prog(struct bpf_verifier_log *vlog,
 
 bool bpf_lsm_is_sleepable_hook(u32 btf_id);
 bool bpf_lsm_is_trusted(const struct bpf_prog *prog);
+bool bpf_lsm_is_ret_value_allowed(struct bpf_verifier_log *vlog,
+				  struct bpf_reg_state *reg, u32 btf_id);
 
 static inline struct bpf_storage_blob *bpf_inode(
 	const struct inode *inode)
@@ -57,6 +59,13 @@ static inline bool bpf_lsm_is_trusted(const struct bpf_prog *prog)
 	return false;
 }
 
+static inline bool bpf_lsm_is_ret_value_allowed(struct bpf_verifier_log *vlog,
+						struct bpf_reg_state *reg,
+						u32 btf_id)
+{
+	return false;
+}
+
 static inline int bpf_lsm_verify_prog(struct bpf_verifier_log *vlog,
 				      const struct bpf_prog *prog)
 {
diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 98f810f661a6..39ddafc06021 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -31,11 +31,11 @@ noinline RET bpf_lsm_##NAME(__VA_ARGS__)	\
 #undef LSM_HOOK
 
 #define LSM_HOOK(RET, DEFAULT, RET_FLAGS, NAME, ...) \
-	BTF_ID(func, bpf_lsm_##NAME)
-BTF_SET_START(bpf_lsm_hooks)
+	BTF_ID_FLAGS(func, bpf_lsm_##NAME, RET_FLAGS)
+BTF_SET8_START(bpf_lsm_hooks)
 #include <linux/lsm_hook_defs.h>
 #undef LSM_HOOK
-BTF_SET_END(bpf_lsm_hooks)
+BTF_SET8_END(bpf_lsm_hooks)
 
 /* List of LSM hooks that should operate on 'current' cgroup regardless
  * of function signature.
@@ -105,7 +105,7 @@ int bpf_lsm_verify_prog(struct bpf_verifier_log *vlog,
 		return -EINVAL;
 	}
 
-	if (!btf_id_set_contains(&bpf_lsm_hooks, prog->aux->attach_btf_id)) {
+	if (!btf_id_set8_contains(&bpf_lsm_hooks, prog->aux->attach_btf_id)) {
 		bpf_log(vlog, "attach_btf_id %u points to wrong type name %s\n",
 			prog->aux->attach_btf_id, prog->aux->attach_func_name);
 		return -EINVAL;
@@ -367,6 +367,76 @@ bool bpf_lsm_is_trusted(const struct bpf_prog *prog)
 	return !btf_id_set_contains(&untrusted_lsm_hooks, prog->aux->attach_btf_id);
 }
 
+BTF_SET_START(zero_forbidden_lsm_hooks)
+BTF_ID(func, bpf_lsm_inode_init_security)
+BTF_SET_END(zero_forbidden_lsm_hooks)
+
+bool bpf_lsm_is_ret_value_allowed(struct bpf_verifier_log *vlog,
+				  struct bpf_reg_state *reg, u32 btf_id)
+{
+	u32 *id = btf_id_set8_contains(&bpf_lsm_hooks, btf_id);
+	s64 smin_value = reg->smin_value;
+	s64 smax_value = reg->smax_value;
+	u32 *ret_flags = id + 1;
+
+	/* See no_alu32/test_bpf_cookie.bpf.o for how return -EPERM is compiled:
+	 *
+	 * 11:	18 06 00 00 ff ff ff ff 00 00 00 00 00 00 00 00	r6 = 4294967295 ll
+	 * 13:	67 00 00 00 20 00 00 00	r0 <<= 32
+	 * 14:	77 00 00 00 20 00 00 00	r0 >>= 32
+	 * 15:	5d 08 07 00 00 00 00 00	if r8 != r0 goto +7 <LBB11_3>
+	 *
+	 * This causes predicted values to be:
+	 * smin_value = 0xffffffff, smax_value = 0xffffffff,
+	 * s32_min_value = 0xffffffff, s32_max_value = 0xffffffff,
+	 *
+	 * despite it is an ALU64 operation. So, checking reg->alu32 is not
+	 * enough. Then, if after casting the 64 bit values they are equal to
+	 * the 32 bit ones, use the latter ones (the LSM infrastructure takes
+	 * an int).
+	 */
+	if ((reg->s32_min_value == (u32)smin_value &&
+	    reg->s32_max_value == (u32)smax_value) || reg->alu32) {
+		smin_value = reg->s32_min_value;
+		smax_value = reg->s32_max_value;
+	}
+
+	/* Interval includes < 0 values. */
+	if (smin_value < 0) {
+		if (!(*ret_flags & LSM_RET_NEG)) {
+			bpf_log(vlog, "Invalid R0, cannot return < 0\n");
+			return false;
+		}
+	}
+
+	/* Interval includes 0. */
+	if (smin_value <= 0 && smax_value >= 0) {
+		if (!(*ret_flags & LSM_RET_ZERO) ||
+		    btf_id_set_contains(&zero_forbidden_lsm_hooks, btf_id)) {
+			bpf_log(vlog, "Invalid R0, cannot return 0\n");
+			return false;
+		}
+	}
+
+	/* Interval includes 1. */
+	if (smin_value <= 1 && smax_value >= 1) {
+		if (!(*ret_flags & LSM_RET_ONE)) {
+			bpf_log(vlog, "Invalid R0, cannot return 1\n");
+			return false;
+		}
+	}
+
+	/* Interval includes > 1 values. */
+	if (smax_value > 1) {
+		if (!(*ret_flags & LSM_RET_GT_ONE)) {
+			bpf_log(vlog, "Invalid R0, cannot return > 1\n");
+			return false;
+		}
+	}
+
+	return true;
+}
+
 const struct bpf_prog_ops lsm_prog_ops = {
 };
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index edce85c425a2..5d13b7f42238 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12064,9 +12064,10 @@ static int check_return_code(struct bpf_verifier_env *env)
 
 	case BPF_PROG_TYPE_LSM:
 		if (env->prog->expected_attach_type != BPF_LSM_CGROUP) {
-			/* Regular BPF_PROG_TYPE_LSM programs can return
-			 * any value.
-			 */
+			if (!bpf_lsm_is_ret_value_allowed(&env->log, reg,
+						env->prog->aux->attach_btf_id))
+				return -EINVAL;
+
 			return 0;
 		}
 		if (!env->prog->aux->attach_func_proto->type) {
-- 
2.25.1

