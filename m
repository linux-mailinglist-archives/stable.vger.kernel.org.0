Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B25E4F3346
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237011AbiDEJDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236715AbiDEIQ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:16:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 381BCAD11A;
        Tue,  5 Apr 2022 01:04:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF6A2B81B14;
        Tue,  5 Apr 2022 08:04:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146CDC385A5;
        Tue,  5 Apr 2022 08:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145847;
        bh=CvB8JKAPIol81ku7JPoq4jxmTvMADYjPHtQLRiqDkL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=irFNGorpcr+Ru6KVBgudMpB3bON+XC9fHjAnaAE3Of9r4xM3DfFQLf1SxSIODcnbi
         Lzhrd4GBpHaNVi1PVtMWgtQIsDZTFqAEUYUed9c+eHdqjTWHf3bf9Z1hNSPmq+xOv7
         TqHh9aiISx1XvLTdVLg24cZdCpN1vVF9CwbUp7NA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+53619be9444215e785ed@syzkaller.appspotmail.com,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0512/1126] bpf: Fix a btf decl_tag bug when tagging a function
Date:   Tue,  5 Apr 2022 09:20:59 +0200
Message-Id: <20220405070422.656759041@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Yonghong Song <yhs@fb.com>

[ Upstream commit d7e7b42f4f956f2c68ad8cda87d750093dbba737 ]

syzbot reported a btf decl_tag bug with stack trace below:

  general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  CPU: 0 PID: 3592 Comm: syz-executor914 Not tainted 5.16.0-syzkaller-11424-gb7892f7d5cb2 #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  RIP: 0010:btf_type_vlen include/linux/btf.h:231 [inline]
  RIP: 0010:btf_decl_tag_resolve+0x83e/0xaa0 kernel/bpf/btf.c:3910
  ...
  Call Trace:
   <TASK>
   btf_resolve+0x251/0x1020 kernel/bpf/btf.c:4198
   btf_check_all_types kernel/bpf/btf.c:4239 [inline]
   btf_parse_type_sec kernel/bpf/btf.c:4280 [inline]
   btf_parse kernel/bpf/btf.c:4513 [inline]
   btf_new_fd+0x19fe/0x2370 kernel/bpf/btf.c:6047
   bpf_btf_load kernel/bpf/syscall.c:4039 [inline]
   __sys_bpf+0x1cbb/0x5970 kernel/bpf/syscall.c:4679
   __do_sys_bpf kernel/bpf/syscall.c:4738 [inline]
   __se_sys_bpf kernel/bpf/syscall.c:4736 [inline]
   __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4736
   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
   entry_SYSCALL_64_after_hwframe+0x44/0xae

The kasan error is triggered with an illegal BTF like below:
   type 0: void
   type 1: int
   type 2: decl_tag to func type 3
   type 3: func to func_proto type 8
The total number of types is 4 and the type 3 is illegal
since its func_proto type is out of range.

Currently, the target type of decl_tag can be struct/union, var or func.
Both struct/union and var implemented their own 'resolve' callback functions
and hence handled properly in kernel.
But func type doesn't have 'resolve' callback function. When
btf_decl_tag_resolve() tries to check func type, it tries to get
vlen of its func_proto type, which triggered the above kasan error.

To fix the issue, btf_decl_tag_resolve() needs to do btf_func_check()
before trying to accessing func_proto type.
In the current implementation, func type is checked with
btf_func_check() in the main checking function btf_check_all_types().
To fix the above kasan issue, let us implement 'resolve' callback
func type properly. The 'resolve' callback will be also called
in btf_check_all_types() for func types.

Fixes: b5ea834dde6b ("bpf: Support for new btf kind BTF_KIND_TAG")
Reported-by: syzbot+53619be9444215e785ed@syzkaller.appspotmail.com
Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20220203191727.741862-1-yhs@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index a3b5a6bf99e7..ac89e65d1692 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -403,6 +403,9 @@ static struct btf_type btf_void;
 static int btf_resolve(struct btf_verifier_env *env,
 		       const struct btf_type *t, u32 type_id);
 
+static int btf_func_check(struct btf_verifier_env *env,
+			  const struct btf_type *t);
+
 static bool btf_type_is_modifier(const struct btf_type *t)
 {
 	/* Some of them is not strictly a C modifier
@@ -579,6 +582,7 @@ static bool btf_type_needs_resolve(const struct btf_type *t)
 	       btf_type_is_struct(t) ||
 	       btf_type_is_array(t) ||
 	       btf_type_is_var(t) ||
+	       btf_type_is_func(t) ||
 	       btf_type_is_decl_tag(t) ||
 	       btf_type_is_datasec(t);
 }
@@ -3533,9 +3537,24 @@ static s32 btf_func_check_meta(struct btf_verifier_env *env,
 	return 0;
 }
 
+static int btf_func_resolve(struct btf_verifier_env *env,
+			    const struct resolve_vertex *v)
+{
+	const struct btf_type *t = v->t;
+	u32 next_type_id = t->type;
+	int err;
+
+	err = btf_func_check(env, t);
+	if (err)
+		return err;
+
+	env_stack_pop_resolved(env, next_type_id, 0);
+	return 0;
+}
+
 static struct btf_kind_operations func_ops = {
 	.check_meta = btf_func_check_meta,
-	.resolve = btf_df_resolve,
+	.resolve = btf_func_resolve,
 	.check_member = btf_df_check_member,
 	.check_kflag_member = btf_df_check_kflag_member,
 	.log_details = btf_ref_type_log,
@@ -4156,7 +4175,7 @@ static bool btf_resolve_valid(struct btf_verifier_env *env,
 		return !btf_resolved_type_id(btf, type_id) &&
 		       !btf_resolved_type_size(btf, type_id);
 
-	if (btf_type_is_decl_tag(t))
+	if (btf_type_is_decl_tag(t) || btf_type_is_func(t))
 		return btf_resolved_type_id(btf, type_id) &&
 		       !btf_resolved_type_size(btf, type_id);
 
@@ -4246,12 +4265,6 @@ static int btf_check_all_types(struct btf_verifier_env *env)
 			if (err)
 				return err;
 		}
-
-		if (btf_type_is_func(t)) {
-			err = btf_func_check(env, t);
-			if (err)
-				return err;
-		}
 	}
 
 	return 0;
-- 
2.34.1



