Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10FAD603F50
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbiJSJbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233489AbiJSJ2c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:28:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC90E6F47;
        Wed, 19 Oct 2022 02:12:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CDCF617E4;
        Wed, 19 Oct 2022 09:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D54C433D6;
        Wed, 19 Oct 2022 09:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170587;
        bh=NmkV02RavlMQ+igL7eQ1dCawCYrpnBKKw3h9lmSN8yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNF178qwxVM43I0cd7rJVOe3uzHCnPkL3LhqruwY7oETJ9oHBHtYxlTrhAEz6k4XX
         9HNM8Tx7SixgJttcBkH96xK/+CuPZSxSWsBs1flod+CwNpiEUDyGRmked1kEe1qr60
         CdL1cYydFotd+VvMU85u2W/nDhTfBRTN2jzjSpNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Hilliard <james.hilliard1@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 679/862] libbpf: Ensure functions with always_inline attribute are inline
Date:   Wed, 19 Oct 2022 10:32:46 +0200
Message-Id: <20221019083319.983036570@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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



