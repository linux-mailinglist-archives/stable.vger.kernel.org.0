Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843D55F8F5A
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 00:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiJIWIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 18:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiJIWH7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 18:07:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB78B275D5;
        Sun,  9 Oct 2022 15:07:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54E5860C93;
        Sun,  9 Oct 2022 22:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC13EC433D6;
        Sun,  9 Oct 2022 22:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353277;
        bh=NmkV02RavlMQ+igL7eQ1dCawCYrpnBKKw3h9lmSN8yo=;
        h=From:To:Cc:Subject:Date:From;
        b=ZbKCiH7q/Arpq6dajG/Smd79zWOTmn+8p/ENk+XCv6ETgGQqSgaMiD9ZcgJVUNftI
         +EfRXGXlwozzo74aZHFr5rI+PIEC/GoChKIR4vMY++APJAPgWi0uGYJDcEidOtsnps
         hiWkzmdYO0lK2zpfRgTtuNo+e19tKPpvHEhl0uK0XypYg1HlRfMhpbnmV5fq2fndpv
         PsA6JJKBHerujTtxdZ2ojYaG5AFNawA6bVviAznaST2/3rzNncKXpwOdUaO0nN6+uB
         i0S7B8zowtQoRsMCNCzAixhhquOfbOtc04+wJPUq8wANcMuJlu0uJsBUYdbjoF/7WR
         8Gwj7SbHSWChw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Hilliard <james.hilliard1@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 01/77] libbpf: Ensure functions with always_inline attribute are inline
Date:   Sun,  9 Oct 2022 18:06:38 -0400
Message-Id: <20221009220754.1214186-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FILL_THIS_FORM,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Hilliard <james.hilliard1@gmail.com>

[ Upstream commit d25f40ff68aa61c838947bb9adee6c6b36e77453 ]

GCC expects the always_inline attribute to only be set on inline
functions, as such we should make all functions with this attribute
use the __always_inline macro which makes the function inline and
sets the attribute.

Fixes errors like:
/home/buildroot/bpf-next/tools/testing/selftests/bpf/tools/include/bpf/bpf_tracing.h:439:1: error: ‘always_inline’ function might not be inlinable [-Werror=attributes]
  439 | ____##name(unsigned long long *ctx, ##args)
      | ^~~~

Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/bpf/20220803151403.793024-1-james.hilliard1@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/bpf_tracing.h | 14 +++++++-------
 tools/lib/bpf/usdt.bpf.h    |  4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index 43ca3aff2292..5fdb93da423b 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -426,7 +426,7 @@ struct pt_regs;
  */
 #define BPF_PROG(name, args...)						    \
 name(unsigned long long *ctx);						    \
-static __attribute__((always_inline)) typeof(name(0))			    \
+static __always_inline typeof(name(0))					    \
 ____##name(unsigned long long *ctx, ##args);				    \
 typeof(name(0)) name(unsigned long long *ctx)				    \
 {									    \
@@ -435,7 +435,7 @@ typeof(name(0)) name(unsigned long long *ctx)				    \
 	return ____##name(___bpf_ctx_cast(args));			    \
 	_Pragma("GCC diagnostic pop")					    \
 }									    \
-static __attribute__((always_inline)) typeof(name(0))			    \
+static __always_inline typeof(name(0))					    \
 ____##name(unsigned long long *ctx, ##args)
 
 struct pt_regs;
@@ -460,7 +460,7 @@ struct pt_regs;
  */
 #define BPF_KPROBE(name, args...)					    \
 name(struct pt_regs *ctx);						    \
-static __attribute__((always_inline)) typeof(name(0))			    \
+static __always_inline typeof(name(0))					    \
 ____##name(struct pt_regs *ctx, ##args);				    \
 typeof(name(0)) name(struct pt_regs *ctx)				    \
 {									    \
@@ -469,7 +469,7 @@ typeof(name(0)) name(struct pt_regs *ctx)				    \
 	return ____##name(___bpf_kprobe_args(args));			    \
 	_Pragma("GCC diagnostic pop")					    \
 }									    \
-static __attribute__((always_inline)) typeof(name(0))			    \
+static __always_inline typeof(name(0))					    \
 ____##name(struct pt_regs *ctx, ##args)
 
 #define ___bpf_kretprobe_args0()       ctx
@@ -484,7 +484,7 @@ ____##name(struct pt_regs *ctx, ##args)
  */
 #define BPF_KRETPROBE(name, args...)					    \
 name(struct pt_regs *ctx);						    \
-static __attribute__((always_inline)) typeof(name(0))			    \
+static __always_inline typeof(name(0))					    \
 ____##name(struct pt_regs *ctx, ##args);				    \
 typeof(name(0)) name(struct pt_regs *ctx)				    \
 {									    \
@@ -540,7 +540,7 @@ static __always_inline typeof(name(0)) ____##name(struct pt_regs *ctx, ##args)
 #define BPF_KSYSCALL(name, args...)					    \
 name(struct pt_regs *ctx);						    \
 extern _Bool LINUX_HAS_SYSCALL_WRAPPER __kconfig;			    \
-static __attribute__((always_inline)) typeof(name(0))			    \
+static __always_inline typeof(name(0))					    \
 ____##name(struct pt_regs *ctx, ##args);				    \
 typeof(name(0)) name(struct pt_regs *ctx)				    \
 {									    \
@@ -555,7 +555,7 @@ typeof(name(0)) name(struct pt_regs *ctx)				    \
 		return ____##name(___bpf_syscall_args(args));		    \
 	_Pragma("GCC diagnostic pop")					    \
 }									    \
-static __attribute__((always_inline)) typeof(name(0))			    \
+static __always_inline typeof(name(0))					    \
 ____##name(struct pt_regs *ctx, ##args)
 
 #define BPF_KPROBE_SYSCALL BPF_KSYSCALL
diff --git a/tools/lib/bpf/usdt.bpf.h b/tools/lib/bpf/usdt.bpf.h
index 4f2adc0bd6ca..fdfd235e52c4 100644
--- a/tools/lib/bpf/usdt.bpf.h
+++ b/tools/lib/bpf/usdt.bpf.h
@@ -232,7 +232,7 @@ long bpf_usdt_cookie(struct pt_regs *ctx)
  */
 #define BPF_USDT(name, args...)						    \
 name(struct pt_regs *ctx);						    \
-static __attribute__((always_inline)) typeof(name(0))			    \
+static __always_inline typeof(name(0))					    \
 ____##name(struct pt_regs *ctx, ##args);				    \
 typeof(name(0)) name(struct pt_regs *ctx)				    \
 {									    \
@@ -241,7 +241,7 @@ typeof(name(0)) name(struct pt_regs *ctx)				    \
         return ____##name(___bpf_usdt_args(args));			    \
         _Pragma("GCC diagnostic pop")					    \
 }									    \
-static __attribute__((always_inline)) typeof(name(0))			    \
+static __always_inline typeof(name(0))					    \
 ____##name(struct pt_regs *ctx, ##args)
 
 #endif /* __USDT_BPF_H__ */
-- 
2.35.1

