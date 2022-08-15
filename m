Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFA795940D3
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243805AbiHOVL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348240AbiHOVIX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:08:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CE453D11;
        Mon, 15 Aug 2022 12:18:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A354B60FC4;
        Mon, 15 Aug 2022 19:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9783AC433D6;
        Mon, 15 Aug 2022 19:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591118;
        bh=63nKvukSJ5KMQCSCJzjVeq6AEWGIFlAgJoHRSgTer+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0EeJKXL5PsnEpiHaEbobHEt1f26AfQ7qaXydp7qEY/XeI5s0D0mXMTSD/1JvPza5B
         lVLl4bbrBxzA+rL7lsgCf5gZvCelARm54cZmlVJAqJ5RhSARjcUQWLdpegFDCSwX5T
         ozyGPPr3k+8HyuqAw8d9I+aXvTUEiI+KmSqQdu58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0478/1095] bpf: Allow storing referenced kptr in map
Date:   Mon, 15 Aug 2022 19:57:57 +0200
Message-Id: <20220815180449.366002618@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit c0a5a21c25f37c9fd7b36072f9968cdff1e4aa13 ]

Extending the code in previous commits, introduce referenced kptr
support, which needs to be tagged using 'kptr_ref' tag instead. Unlike
unreferenced kptr, referenced kptr have a lot more restrictions. In
addition to the type matching, only a newly introduced bpf_kptr_xchg
helper is allowed to modify the map value at that offset. This transfers
the referenced pointer being stored into the map, releasing the
references state for the program, and returning the old value and
creating new reference state for the returned pointer.

Similar to unreferenced pointer case, return value for this case will
also be PTR_TO_BTF_ID_OR_NULL. The reference for the returned pointer
must either be eventually released by calling the corresponding release
function, otherwise it must be transferred into another map.

It is also allowed to call bpf_kptr_xchg with a NULL pointer, to clear
the value, and obtain the old value if any.

BPF_LDX, BPF_STX, and BPF_ST cannot access referenced kptr. A future
commit will permit using BPF_LDX for such pointers, but attempt at
making it safe, since the lifetime of object won't be guaranteed.

There are valid reasons to enforce the restriction of permitting only
bpf_kptr_xchg to operate on referenced kptr. The pointer value must be
consistent in face of concurrent modification, and any prior values
contained in the map must also be released before a new one is moved
into the map. To ensure proper transfer of this ownership, bpf_kptr_xchg
returns the old value, which the verifier would require the user to
either free or move into another map, and releases the reference held
for the pointer being moved in.

In the future, direct BPF_XCHG instruction may also be permitted to work
like bpf_kptr_xchg helper.

Note that process_kptr_func doesn't have to call
check_helper_mem_access, since we already disallow rdonly/wronly flags
for map, which is what check_map_access_type checks, and we already
ensure the PTR_TO_MAP_VALUE refers to kptr by obtaining its off_desc,
so check_map_access is also not required.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20220424214901.2743946-4-memxor@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h            |  8 +++
 include/uapi/linux/bpf.h       | 12 +++++
 kernel/bpf/btf.c               | 10 +++-
 kernel/bpf/helpers.c           | 24 +++++++++
 kernel/bpf/verifier.c          | 98 +++++++++++++++++++++++++++++-----
 tools/include/uapi/linux/bpf.h | 12 +++++
 6 files changed, 151 insertions(+), 13 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 2feae4a24d99..2f6e7fc474ea 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -160,8 +160,14 @@ enum {
 	BPF_MAP_VALUE_OFF_MAX = 8,
 };
 
+enum bpf_kptr_type {
+	BPF_KPTR_UNREF,
+	BPF_KPTR_REF,
+};
+
 struct bpf_map_value_off_desc {
 	u32 offset;
+	enum bpf_kptr_type type;
 	struct {
 		struct btf *btf;
 		u32 btf_id;
@@ -418,6 +424,7 @@ enum bpf_arg_type {
 	ARG_PTR_TO_STACK,	/* pointer to stack */
 	ARG_PTR_TO_CONST_STR,	/* pointer to a null terminated read-only string */
 	ARG_PTR_TO_TIMER,	/* pointer to bpf_timer */
+	ARG_PTR_TO_KPTR,	/* pointer to referenced kptr */
 	__BPF_ARG_TYPE_MAX,
 
 	/* Extended arg_types. */
@@ -427,6 +434,7 @@ enum bpf_arg_type {
 	ARG_PTR_TO_SOCKET_OR_NULL	= PTR_MAYBE_NULL | ARG_PTR_TO_SOCKET,
 	ARG_PTR_TO_ALLOC_MEM_OR_NULL	= PTR_MAYBE_NULL | ARG_PTR_TO_ALLOC_MEM,
 	ARG_PTR_TO_STACK_OR_NULL	= PTR_MAYBE_NULL | ARG_PTR_TO_STACK,
+	ARG_PTR_TO_BTF_ID_OR_NULL	= PTR_MAYBE_NULL | ARG_PTR_TO_BTF_ID,
 
 	/* This must be the last entry. Its purpose is to ensure the enum is
 	 * wide enough to hold the higher bits reserved for bpf_type_flag.
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a4f557338af7..ff9af73859ca 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5144,6 +5144,17 @@ union bpf_attr {
  *		The **hash_algo** is returned on success,
  *		**-EOPNOTSUP** if the hash calculation failed or **-EINVAL** if
  *		invalid arguments are passed.
+ *
+ * void *bpf_kptr_xchg(void *map_value, void *ptr)
+ *	Description
+ *		Exchange kptr at pointer *map_value* with *ptr*, and return the
+ *		old value. *ptr* can be NULL, otherwise it must be a referenced
+ *		pointer which will be released when this helper is called.
+ *	Return
+ *		The old value of kptr (which can be NULL). The returned pointer
+ *		if not NULL, is a reference which must be released using its
+ *		corresponding release function, or moved into a BPF map before
+ *		program exit.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5340,6 +5351,7 @@ union bpf_attr {
 	FN(copy_from_user_task),	\
 	FN(skb_set_tstamp),		\
 	FN(ima_file_hash),		\
+	FN(kptr_xchg),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 752de8112206..58fd6896c403 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3177,6 +3177,7 @@ enum {
 struct btf_field_info {
 	u32 type_id;
 	u32 off;
+	enum bpf_kptr_type type;
 };
 
 static int btf_find_struct(const struct btf *btf, const struct btf_type *t,
@@ -3193,6 +3194,7 @@ static int btf_find_struct(const struct btf *btf, const struct btf_type *t,
 static int btf_find_kptr(const struct btf *btf, const struct btf_type *t,
 			 u32 off, int sz, struct btf_field_info *info)
 {
+	enum bpf_kptr_type type;
 	u32 res_id;
 
 	/* For PTR, sz is always == 8 */
@@ -3205,7 +3207,11 @@ static int btf_find_kptr(const struct btf *btf, const struct btf_type *t,
 	/* Reject extra tags */
 	if (btf_type_is_type_tag(btf_type_by_id(btf, t->type)))
 		return -EINVAL;
-	if (strcmp("kptr", __btf_name_by_offset(btf, t->name_off)))
+	if (!strcmp("kptr", __btf_name_by_offset(btf, t->name_off)))
+		type = BPF_KPTR_UNREF;
+	else if (!strcmp("kptr_ref", __btf_name_by_offset(btf, t->name_off)))
+		type = BPF_KPTR_REF;
+	else
 		return -EINVAL;
 
 	/* Get the base type */
@@ -3216,6 +3222,7 @@ static int btf_find_kptr(const struct btf *btf, const struct btf_type *t,
 
 	info->type_id = res_id;
 	info->off = off;
+	info->type = type;
 	return BTF_FIELD_FOUND;
 }
 
@@ -3420,6 +3427,7 @@ struct bpf_map_value_off *btf_parse_kptrs(const struct btf *btf,
 		}
 
 		tab->off[i].offset = info_arr[i].off;
+		tab->off[i].type = info_arr[i].type;
 		tab->off[i].kptr.btf_id = id;
 		tab->off[i].kptr.btf = kernel_btf;
 	}
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 315053ef6a75..3e709fed5306 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1374,6 +1374,28 @@ void bpf_timer_cancel_and_free(void *val)
 	kfree(t);
 }
 
+BPF_CALL_2(bpf_kptr_xchg, void *, map_value, void *, ptr)
+{
+	unsigned long *kptr = map_value;
+
+	return xchg(kptr, (unsigned long)ptr);
+}
+
+/* Unlike other PTR_TO_BTF_ID helpers the btf_id in bpf_kptr_xchg()
+ * helper is determined dynamically by the verifier.
+ */
+#define BPF_PTR_POISON ((void *)((0xeB9FUL << 2) + POISON_POINTER_DELTA))
+
+const struct bpf_func_proto bpf_kptr_xchg_proto = {
+	.func         = bpf_kptr_xchg,
+	.gpl_only     = false,
+	.ret_type     = RET_PTR_TO_BTF_ID_OR_NULL,
+	.ret_btf_id   = BPF_PTR_POISON,
+	.arg1_type    = ARG_PTR_TO_KPTR,
+	.arg2_type    = ARG_PTR_TO_BTF_ID_OR_NULL | OBJ_RELEASE,
+	.arg2_btf_id  = BPF_PTR_POISON,
+};
+
 const struct bpf_func_proto bpf_get_current_task_proto __weak;
 const struct bpf_func_proto bpf_get_current_task_btf_proto __weak;
 const struct bpf_func_proto bpf_probe_read_user_proto __weak;
@@ -1452,6 +1474,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_timer_start_proto;
 	case BPF_FUNC_timer_cancel:
 		return &bpf_timer_cancel_proto;
+	case BPF_FUNC_kptr_xchg:
+		return &bpf_kptr_xchg_proto;
 	default:
 		break;
 	}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 4f19a86c2682..93c98f95901e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -258,6 +258,7 @@ struct bpf_call_arg_meta {
 	struct btf *ret_btf;
 	u32 ret_btf_id;
 	u32 subprogno;
+	struct bpf_map_value_off_desc *kptr_off_desc;
 };
 
 struct btf *btf_vmlinux;
@@ -489,7 +490,8 @@ static bool is_acquire_function(enum bpf_func_id func_id,
 	if (func_id == BPF_FUNC_sk_lookup_tcp ||
 	    func_id == BPF_FUNC_sk_lookup_udp ||
 	    func_id == BPF_FUNC_skc_lookup_tcp ||
-	    func_id == BPF_FUNC_ringbuf_reserve)
+	    func_id == BPF_FUNC_ringbuf_reserve ||
+	    func_id == BPF_FUNC_kptr_xchg)
 		return true;
 
 	if (func_id == BPF_FUNC_map_lookup_elem &&
@@ -3513,6 +3515,12 @@ static int map_kptr_match_type(struct bpf_verifier_env *env,
 	/* We need to verify reg->type and reg->btf, before accessing reg->btf */
 	reg_name = kernel_type_name(reg->btf, reg->btf_id);
 
+	/* For ref_ptr case, release function check should ensure we get one
+	 * referenced PTR_TO_BTF_ID, and that its fixed offset is 0. For the
+	 * normal store of unreferenced kptr, we must ensure var_off is zero.
+	 * Since ref_ptr cannot be accessed directly by BPF insns, checks for
+	 * reg->off and reg->ref_obj_id are not needed here.
+	 */
 	if (__check_ptr_off_reg(env, reg, regno, true))
 		return -EACCES;
 
@@ -3568,6 +3576,12 @@ static int check_map_kptr_access(struct bpf_verifier_env *env, u32 regno,
 		return -EACCES;
 	}
 
+	/* We cannot directly access kptr_ref */
+	if (off_desc->type == BPF_KPTR_REF) {
+		verbose(env, "accessing referenced kptr disallowed\n");
+		return -EACCES;
+	}
+
 	if (class == BPF_LDX) {
 		val_reg = reg_state(env, value_regno);
 		/* We can simply mark the value_regno receiving the pointer
@@ -5292,6 +5306,53 @@ static int process_timer_func(struct bpf_verifier_env *env, int regno,
 	return 0;
 }
 
+static int process_kptr_func(struct bpf_verifier_env *env, int regno,
+			     struct bpf_call_arg_meta *meta)
+{
+	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
+	struct bpf_map_value_off_desc *off_desc;
+	struct bpf_map *map_ptr = reg->map_ptr;
+	u32 kptr_off;
+	int ret;
+
+	if (!tnum_is_const(reg->var_off)) {
+		verbose(env,
+			"R%d doesn't have constant offset. kptr has to be at the constant offset\n",
+			regno);
+		return -EINVAL;
+	}
+	if (!map_ptr->btf) {
+		verbose(env, "map '%s' has to have BTF in order to use bpf_kptr_xchg\n",
+			map_ptr->name);
+		return -EINVAL;
+	}
+	if (!map_value_has_kptrs(map_ptr)) {
+		ret = PTR_ERR(map_ptr->kptr_off_tab);
+		if (ret == -E2BIG)
+			verbose(env, "map '%s' has more than %d kptr\n", map_ptr->name,
+				BPF_MAP_VALUE_OFF_MAX);
+		else if (ret == -EEXIST)
+			verbose(env, "map '%s' has repeating kptr BTF tags\n", map_ptr->name);
+		else
+			verbose(env, "map '%s' has no valid kptr\n", map_ptr->name);
+		return -EINVAL;
+	}
+
+	meta->map_ptr = map_ptr;
+	kptr_off = reg->off + reg->var_off.value;
+	off_desc = bpf_map_kptr_off_contains(map_ptr, kptr_off);
+	if (!off_desc) {
+		verbose(env, "off=%d doesn't point to kptr\n", kptr_off);
+		return -EACCES;
+	}
+	if (off_desc->type != BPF_KPTR_REF) {
+		verbose(env, "off=%d kptr isn't referenced kptr\n", kptr_off);
+		return -EACCES;
+	}
+	meta->kptr_off_desc = off_desc;
+	return 0;
+}
+
 static bool arg_type_is_mem_ptr(enum bpf_arg_type type)
 {
 	return base_type(type) == ARG_PTR_TO_MEM ||
@@ -5432,6 +5493,7 @@ static const struct bpf_reg_types func_ptr_types = { .types = { PTR_TO_FUNC } };
 static const struct bpf_reg_types stack_ptr_types = { .types = { PTR_TO_STACK } };
 static const struct bpf_reg_types const_str_ptr_types = { .types = { PTR_TO_MAP_VALUE } };
 static const struct bpf_reg_types timer_types = { .types = { PTR_TO_MAP_VALUE } };
+static const struct bpf_reg_types kptr_types = { .types = { PTR_TO_MAP_VALUE } };
 
 static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
 	[ARG_PTR_TO_MAP_KEY]		= &map_key_value_types,
@@ -5459,11 +5521,13 @@ static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
 	[ARG_PTR_TO_STACK]		= &stack_ptr_types,
 	[ARG_PTR_TO_CONST_STR]		= &const_str_ptr_types,
 	[ARG_PTR_TO_TIMER]		= &timer_types,
+	[ARG_PTR_TO_KPTR]		= &kptr_types,
 };
 
 static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
 			  enum bpf_arg_type arg_type,
-			  const u32 *arg_btf_id)
+			  const u32 *arg_btf_id,
+			  struct bpf_call_arg_meta *meta)
 {
 	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
 	enum bpf_reg_type expected, type = reg->type;
@@ -5516,8 +5580,11 @@ static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
 			arg_btf_id = compatible->btf_id;
 		}
 
-		if (!btf_struct_ids_match(&env->log, reg->btf, reg->btf_id, reg->off,
-					  btf_vmlinux, *arg_btf_id)) {
+		if (meta->func_id == BPF_FUNC_kptr_xchg) {
+			if (map_kptr_match_type(env, meta->kptr_off_desc, reg, regno))
+				return -EACCES;
+		} else if (!btf_struct_ids_match(&env->log, reg->btf, reg->btf_id, reg->off,
+						 btf_vmlinux, *arg_btf_id)) {
 			verbose(env, "R%d is of type %s but %s is expected\n",
 				regno, kernel_type_name(reg->btf, reg->btf_id),
 				kernel_type_name(btf_vmlinux, *arg_btf_id));
@@ -5624,7 +5691,7 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		 */
 		goto skip_type_check;
 
-	err = check_reg_type(env, regno, arg_type, fn->arg_btf_id[arg]);
+	err = check_reg_type(env, regno, arg_type, fn->arg_btf_id[arg], meta);
 	if (err)
 		return err;
 
@@ -5800,6 +5867,9 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 			verbose(env, "string is not zero-terminated\n");
 			return -EINVAL;
 		}
+	} else if (arg_type == ARG_PTR_TO_KPTR) {
+		if (process_kptr_func(env, regno, meta))
+			return -EACCES;
 	}
 
 	return err;
@@ -6143,10 +6213,10 @@ static bool check_btf_id_ok(const struct bpf_func_proto *fn)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(fn->arg_type); i++) {
-		if (fn->arg_type[i] == ARG_PTR_TO_BTF_ID && !fn->arg_btf_id[i])
+		if (base_type(fn->arg_type[i]) == ARG_PTR_TO_BTF_ID && !fn->arg_btf_id[i])
 			return false;
 
-		if (fn->arg_type[i] != ARG_PTR_TO_BTF_ID && fn->arg_btf_id[i])
+		if (base_type(fn->arg_type[i]) != ARG_PTR_TO_BTF_ID && fn->arg_btf_id[i])
 			return false;
 	}
 
@@ -7010,21 +7080,25 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 			regs[BPF_REG_0].btf_id = meta.ret_btf_id;
 		}
 	} else if (base_type(ret_type) == RET_PTR_TO_BTF_ID) {
+		struct btf *ret_btf;
 		int ret_btf_id;
 
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		regs[BPF_REG_0].type = PTR_TO_BTF_ID | ret_flag;
-		ret_btf_id = *fn->ret_btf_id;
+		if (func_id == BPF_FUNC_kptr_xchg) {
+			ret_btf = meta.kptr_off_desc->kptr.btf;
+			ret_btf_id = meta.kptr_off_desc->kptr.btf_id;
+		} else {
+			ret_btf = btf_vmlinux;
+			ret_btf_id = *fn->ret_btf_id;
+		}
 		if (ret_btf_id == 0) {
 			verbose(env, "invalid return type %u of func %s#%d\n",
 				base_type(ret_type), func_id_name(func_id),
 				func_id);
 			return -EINVAL;
 		}
-		/* current BPF helper definitions are only coming from
-		 * built-in code with type IDs from  vmlinux BTF
-		 */
-		regs[BPF_REG_0].btf = btf_vmlinux;
+		regs[BPF_REG_0].btf = ret_btf;
 		regs[BPF_REG_0].btf_id = ret_btf_id;
 	} else {
 		verbose(env, "unknown return type %u of func %s#%d\n",
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a4f557338af7..ff9af73859ca 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5144,6 +5144,17 @@ union bpf_attr {
  *		The **hash_algo** is returned on success,
  *		**-EOPNOTSUP** if the hash calculation failed or **-EINVAL** if
  *		invalid arguments are passed.
+ *
+ * void *bpf_kptr_xchg(void *map_value, void *ptr)
+ *	Description
+ *		Exchange kptr at pointer *map_value* with *ptr*, and return the
+ *		old value. *ptr* can be NULL, otherwise it must be a referenced
+ *		pointer which will be released when this helper is called.
+ *	Return
+ *		The old value of kptr (which can be NULL). The returned pointer
+ *		if not NULL, is a reference which must be released using its
+ *		corresponding release function, or moved into a BPF map before
+ *		program exit.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5340,6 +5351,7 @@ union bpf_attr {
 	FN(copy_from_user_task),	\
 	FN(skb_set_tstamp),		\
 	FN(ima_file_hash),		\
+	FN(kptr_xchg),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.35.1



