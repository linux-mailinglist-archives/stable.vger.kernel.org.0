Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE036086D0
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbiJVHxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbiJVHwg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:52:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170655A140;
        Sat, 22 Oct 2022 00:46:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F4EF60BA3;
        Sat, 22 Oct 2022 07:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D75AC433D6;
        Sat, 22 Oct 2022 07:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424668;
        bh=N/eEKm28DGri4kRdFiJuk/ocMDA5G7uunqNFPqEF9o8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w4nzGHsBrCX6AqB7B3z8riz9bPqqZ1t7ZuduoCeaAr7ccaFMljzv0BH0JZJAARo3q
         hU8vkb2QSmF9ump4OhYl7okojCAGdh4OvLNSpwMj/wnLlzZgjrCV7/fyh4ml1fwFVx
         oyglqkaEdlvSqBK+qZVCB7N9dGbYbkgXed/SRzCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 202/717] bpf: Fix non-static bpf_func_proto struct definitions
Date:   Sat, 22 Oct 2022 09:21:21 +0200
Message-Id: <20221022072451.091195507@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joanne Koong <joannelkoong@gmail.com>

[ Upstream commit dc368e1c658e4f478a45e8d1d5b0c8392ca87506 ]

This patch does two things:

1) Marks the dynptr bpf_func_proto structs that were added in [1]
   as static, as pointed out by the kernel test robot in [2].

2) There are some bpf_func_proto structs marked as extern which can
   instead be statically defined.

  [1] https://lore.kernel.org/bpf/20220523210712.3641569-1-joannelkoong@gmail.com/
  [2] https://lore.kernel.org/bpf/62ab89f2.Pko7sI08RAKdF8R6%25lkp@intel.com/

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220616225407.1878436-1-joannelkoong@gmail.com
Stable-dep-of: 883743422ced ("bpf: Fix ref_obj_id for dynptr data slices in verifier")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h  |  3 ---
 kernel/bpf/helpers.c | 12 ++++++------
 kernel/bpf/syscall.c |  2 +-
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index ed352c00330c..647438166558 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2273,12 +2273,9 @@ extern const struct bpf_func_proto bpf_for_each_map_elem_proto;
 extern const struct bpf_func_proto bpf_btf_find_by_name_kind_proto;
 extern const struct bpf_func_proto bpf_sk_setsockopt_proto;
 extern const struct bpf_func_proto bpf_sk_getsockopt_proto;
-extern const struct bpf_func_proto bpf_kallsyms_lookup_name_proto;
 extern const struct bpf_func_proto bpf_find_vma_proto;
 extern const struct bpf_func_proto bpf_loop_proto;
-extern const struct bpf_func_proto bpf_strncmp_proto;
 extern const struct bpf_func_proto bpf_copy_from_user_task_proto;
-extern const struct bpf_func_proto bpf_kptr_xchg_proto;
 
 const struct bpf_func_proto *tracing_prog_func_proto(
   enum bpf_func_id func_id, const struct bpf_prog *prog);
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index fb03f40116eb..ed7649b04704 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -584,7 +584,7 @@ BPF_CALL_3(bpf_strncmp, const char *, s1, u32, s1_sz, const char *, s2)
 	return strncmp(s1, s2, s1_sz);
 }
 
-const struct bpf_func_proto bpf_strncmp_proto = {
+static const struct bpf_func_proto bpf_strncmp_proto = {
 	.func		= bpf_strncmp,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
@@ -1402,7 +1402,7 @@ BPF_CALL_2(bpf_kptr_xchg, void *, map_value, void *, ptr)
  */
 #define BPF_PTR_POISON ((void *)((0xeB9FUL << 2) + POISON_POINTER_DELTA))
 
-const struct bpf_func_proto bpf_kptr_xchg_proto = {
+static const struct bpf_func_proto bpf_kptr_xchg_proto = {
 	.func         = bpf_kptr_xchg,
 	.gpl_only     = false,
 	.ret_type     = RET_PTR_TO_BTF_ID_OR_NULL,
@@ -1489,7 +1489,7 @@ BPF_CALL_4(bpf_dynptr_from_mem, void *, data, u32, size, u64, flags, struct bpf_
 	return err;
 }
 
-const struct bpf_func_proto bpf_dynptr_from_mem_proto = {
+static const struct bpf_func_proto bpf_dynptr_from_mem_proto = {
 	.func		= bpf_dynptr_from_mem,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
@@ -1516,7 +1516,7 @@ BPF_CALL_5(bpf_dynptr_read, void *, dst, u32, len, struct bpf_dynptr_kern *, src
 	return 0;
 }
 
-const struct bpf_func_proto bpf_dynptr_read_proto = {
+static const struct bpf_func_proto bpf_dynptr_read_proto = {
 	.func		= bpf_dynptr_read,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
@@ -1544,7 +1544,7 @@ BPF_CALL_5(bpf_dynptr_write, struct bpf_dynptr_kern *, dst, u32, offset, void *,
 	return 0;
 }
 
-const struct bpf_func_proto bpf_dynptr_write_proto = {
+static const struct bpf_func_proto bpf_dynptr_write_proto = {
 	.func		= bpf_dynptr_write,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
@@ -1572,7 +1572,7 @@ BPF_CALL_3(bpf_dynptr_data, struct bpf_dynptr_kern *, ptr, u32, offset, u32, len
 	return (unsigned long)(ptr->data + ptr->offset + offset);
 }
 
-const struct bpf_func_proto bpf_dynptr_data_proto = {
+static const struct bpf_func_proto bpf_dynptr_data_proto = {
 	.func		= bpf_dynptr_data,
 	.gpl_only	= false,
 	.ret_type	= RET_PTR_TO_DYNPTR_MEM_OR_NULL,
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index d334aeb23407..7a3444988c84 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -5138,7 +5138,7 @@ BPF_CALL_4(bpf_kallsyms_lookup_name, const char *, name, int, name_sz, int, flag
 	return *res ? 0 : -ENOENT;
 }
 
-const struct bpf_func_proto bpf_kallsyms_lookup_name_proto = {
+static const struct bpf_func_proto bpf_kallsyms_lookup_name_proto = {
 	.func		= bpf_kallsyms_lookup_name,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
-- 
2.35.1



