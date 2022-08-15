Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFDB75941EE
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbiHOVJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347994AbiHOVHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:07:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BA62E681;
        Mon, 15 Aug 2022 12:17:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6D916009B;
        Mon, 15 Aug 2022 19:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF7CC433D6;
        Mon, 15 Aug 2022 19:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591049;
        bh=fNf3lYZ3JXkcpaPS13aW1IHh+HAR/gsUqnLFHXNzqIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dsYmP9qZ30Y+vXmrFaa0rijYfoDFkIwMrykdWafwixhu77pjjMh6zOCcYtswR7vX7
         zmoxpW1FlWCrX6qKw5/bBQzgIu+Tr493ZiHtoQ88CIfHm4THAt4ycd6MlV1CTbAv9c
         wNrX1qNMUsDizOYiL8ti3vzB5lkyg8N3Kb90Z8Kk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Ambardar <Tony.Ambardar@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0455/1095] bpf, x64: Add predicate for bpf2bpf with tailcalls support in JIT
Date:   Mon, 15 Aug 2022 19:57:34 +0200
Message-Id: <20220815180448.447796708@linuxfoundation.org>
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

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit 95acd8817e66d031d2e6ee7def3f1e1874819317 ]

The BPF core/verifier is hard-coded to permit mixing bpf2bpf and tail
calls for only x86-64. Change the logic to instead rely on a new weak
function 'bool bpf_jit_supports_subprog_tailcalls(void)', which a capable
JIT backend can override.

Update the x86-64 eBPF JIT to reflect this.

Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
[jakub: drop MIPS bits and tweak patch subject]
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220617105735.733938-2-jakub@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 6 ++++++
 include/linux/filter.h      | 1 +
 kernel/bpf/core.c           | 6 ++++++
 kernel/bpf/verifier.c       | 3 ++-
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 9ec96d5a8239..124456bb23b9 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -2477,3 +2477,9 @@ void *bpf_arch_text_copy(void *dst, void *src, size_t len)
 		return ERR_PTR(-EINVAL);
 	return dst;
 }
+
+/* Indicate the JIT backend supports mixing bpf2bpf and tailcalls. */
+bool bpf_jit_supports_subprog_tailcalls(void)
+{
+	return true;
+}
diff --git a/include/linux/filter.h b/include/linux/filter.h
index ed0c0ff42ad5..d9a0db845b50 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -948,6 +948,7 @@ u64 __bpf_call_base(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog);
 void bpf_jit_compile(struct bpf_prog *prog);
 bool bpf_jit_needs_zext(void);
+bool bpf_jit_supports_subprog_tailcalls(void);
 bool bpf_jit_supports_kfunc_call(void);
 bool bpf_helper_changes_pkt_data(void *func);
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 3adff3831c04..7a1ce697689b 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2712,6 +2712,12 @@ bool __weak bpf_jit_needs_zext(void)
 	return false;
 }
 
+/* Return TRUE if the JIT backend supports mixing bpf2bpf and tailcalls. */
+bool __weak bpf_jit_supports_subprog_tailcalls(void)
+{
+	return false;
+}
+
 bool __weak bpf_jit_supports_kfunc_call(void)
 {
 	return false;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d04147a5efa5..a6d3a8972355 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5696,7 +5696,8 @@ static bool may_update_sockmap(struct bpf_verifier_env *env, int func_id)
 
 static bool allow_tail_call_in_subprogs(struct bpf_verifier_env *env)
 {
-	return env->prog->jit_requested && IS_ENABLED(CONFIG_X86_64);
+	return env->prog->jit_requested &&
+	       bpf_jit_supports_subprog_tailcalls();
 }
 
 static int check_map_func_compatibility(struct bpf_verifier_env *env,
-- 
2.35.1



