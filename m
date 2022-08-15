Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0E859485C
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355426AbiHOX4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354929AbiHOXvF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:51:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A1F91081;
        Mon, 15 Aug 2022 13:16:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6E056069F;
        Mon, 15 Aug 2022 20:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE0BC433D6;
        Mon, 15 Aug 2022 20:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594572;
        bh=hkB8txI6DXqZCUcx5c6Inq/0XsFh1cldRNeTZZowmFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X5MVZLQ4Tv7VHUxvfgU2O0yqWaUVnsicYJFC4uBIYqaibON25hZfHT1zixSU9/CbI
         Zm5UuW8XfT76BJfkmUwgXwaO+dHVddJ4zlNFV2/BId5R6ZToqcY1tOg+xfvB4mctQ2
         q7DkcbfAhrnPABtXnK2ukhzGkAbpQM808rc084lE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Ambardar <Tony.Ambardar@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0491/1157] bpf, x64: Add predicate for bpf2bpf with tailcalls support in JIT
Date:   Mon, 15 Aug 2022 19:57:27 +0200
Message-Id: <20220815180459.271656380@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index b808c9a80d1b..eba704b9ce1e 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -2506,3 +2506,9 @@ void *bpf_arch_text_copy(void *dst, void *src, size_t len)
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
index e7961508a47d..6e3fe4b7230b 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2716,6 +2716,12 @@ bool __weak bpf_jit_needs_zext(void)
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
index 0efbac0fd126..602366bc230f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6143,7 +6143,8 @@ static bool may_update_sockmap(struct bpf_verifier_env *env, int func_id)
 
 static bool allow_tail_call_in_subprogs(struct bpf_verifier_env *env)
 {
-	return env->prog->jit_requested && IS_ENABLED(CONFIG_X86_64);
+	return env->prog->jit_requested &&
+	       bpf_jit_supports_subprog_tailcalls();
 }
 
 static int check_map_func_compatibility(struct bpf_verifier_env *env,
-- 
2.35.1



