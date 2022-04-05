Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F1D4F2F5B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242398AbiDEJgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235430AbiDEJCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:02:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D843CCE;
        Tue,  5 Apr 2022 01:53:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDC4D609D0;
        Tue,  5 Apr 2022 08:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02667C385A1;
        Tue,  5 Apr 2022 08:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148832;
        bh=sdZSVqqIUKYImkqKfFXcls0oMxfp3eb4lHqdIelvcyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nlKIHTwpaRWOv1ZtPIjIVJ+KPWihWUPePQxe8ajcFzR2H6CpoNmspHBmostWb+QvF
         TP4lvM9YBLMJ3qGiDvr+1wpq1W5Mk6rqnKgSQXOKVDtuuoUc1FdEBEAJ6vpGtLQIXp
         9zZNqFBhIMZWbdW4W3px+uVhS8s52h0tU+b90n7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+53619be9444215e785ed@syzkaller.appspotmail.com,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0470/1017] bpf: Fix a btf decl_tag bug when tagging a function
Date:   Tue,  5 Apr 2022 09:23:03 +0200
Message-Id: <20220405070408.249913058@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index 1f7967ab9e46..ebbb2f4d3b9c 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -401,6 +401,9 @@ static struct btf_type btf_void;
 static int btf_resolve(struct btf_verifier_env *env,
 		       const struct btf_type *t, u32 type_id);
 
+static int btf_func_check(struct btf_verifier_env *env,
+			  const struct btf_type *t);
+
 static bool btf_type_is_modifier(const struct btf_type *t)
 {
 	/* Some of them is not strictly a C modifier
@@ -576,6 +579,7 @@ static bool btf_type_needs_resolve(const struct btf_type *t)
 	       btf_type_is_struct(t) ||
 	       btf_type_is_array(t) ||
 	       btf_type_is_var(t) ||
+	       btf_type_is_func(t) ||
 	       btf_type_is_decl_tag(t) ||
 	       btf_type_is_datasec(t);
 }
@@ -3521,9 +3525,24 @@ static s32 btf_func_check_meta(struct btf_verifier_env *env,
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
@@ -4143,7 +4162,7 @@ static bool btf_resolve_valid(struct btf_verifier_env *env,
 		return !btf_resolved_type_id(btf, type_id) &&
 		       !btf_resolved_type_size(btf, type_id);
 
-	if (btf_type_is_decl_tag(t))
+	if (btf_type_is_decl_tag(t) || btf_type_is_func(t))
 		return btf_resolved_type_id(btf, type_id) &&
 		       !btf_resolved_type_size(btf, type_id);
 
@@ -4233,12 +4252,6 @@ static int btf_check_all_types(struct btf_verifier_env *env)
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



