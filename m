Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD14C586933
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbiHAL6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbiHAL6G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:58:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7C63ED5C;
        Mon,  1 Aug 2022 04:52:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D34AFB8116D;
        Mon,  1 Aug 2022 11:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AE5C433D6;
        Mon,  1 Aug 2022 11:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354729;
        bh=vvi4yrRPlGWNNvZyIkXGXx0YG8WMn0P1dxQEno0hga4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LwxfhW3P8uxs9C4eQUYdqPbh1TiKgvDz7+s+kqarWHx047MA/r/D5KUNklU3M28Vg
         8Jlf8g3lBvvcsAHxuMjZg598sFfCmOSd3ZPua38uODwCJm4k326q0L/nyxLlUf1qxm
         pUzU2gFnB6rJ3AsNFuRBtMTGNpyRYBZD+f1CKhEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Tianchen Ding <dtcccc@linux.alibaba.com>
Subject: [PATCH 5.10 64/65] bpf: Add PROG_TEST_RUN support for sk_lookup programs
Date:   Mon,  1 Aug 2022 13:47:21 +0200
Message-Id: <20220801114136.291055490@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
References: <20220801114133.641770326@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianchen Ding <dtcccc@linux.alibaba.com>

From: Lorenz Bauer <lmb@cloudflare.com>

commit 7c32e8f8bc33a5f4b113a630857e46634e3e143b upstream.

Allow to pass sk_lookup programs to PROG_TEST_RUN. User space
provides the full bpf_sk_lookup struct as context. Since the
context includes a socket pointer that can't be exposed
to user space we define that PROG_TEST_RUN returns the cookie
of the selected socket or zero in place of the socket pointer.

We don't support testing programs that select a reuseport socket,
since this would mean running another (unrelated) BPF program
from the sk_lookup test handler.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210303101816.36774-3-lmb@cloudflare.com
Signed-off-by: Tianchen Ding <dtcccc@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf.h            |   10 +++
 include/uapi/linux/bpf.h       |    5 +
 net/bpf/test_run.c             |  105 +++++++++++++++++++++++++++++++++++++++++
 net/core/filter.c              |    1 
 tools/include/uapi/linux/bpf.h |    5 +
 5 files changed, 124 insertions(+), 2 deletions(-)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1457,6 +1457,9 @@ int bpf_prog_test_run_flow_dissector(str
 int bpf_prog_test_run_raw_tp(struct bpf_prog *prog,
 			     const union bpf_attr *kattr,
 			     union bpf_attr __user *uattr);
+int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog,
+				const union bpf_attr *kattr,
+				union bpf_attr __user *uattr);
 bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		    const struct bpf_prog *prog,
 		    struct bpf_insn_access_aux *info);
@@ -1670,6 +1673,13 @@ static inline int bpf_prog_test_run_flow
 {
 	return -ENOTSUPP;
 }
+
+static inline int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog,
+					      const union bpf_attr *kattr,
+					      union bpf_attr __user *uattr)
+{
+	return -ENOTSUPP;
+}
 
 static inline void bpf_map_put(struct bpf_map *map)
 {
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5007,7 +5007,10 @@ struct bpf_pidns_info {
 
 /* User accessible data for SK_LOOKUP programs. Add new fields at the end. */
 struct bpf_sk_lookup {
-	__bpf_md_ptr(struct bpf_sock *, sk); /* Selected socket */
+	union {
+		__bpf_md_ptr(struct bpf_sock *, sk); /* Selected socket */
+		__u64 cookie; /* Non-zero if socket was selected in PROG_TEST_RUN */
+	};
 
 	__u32 family;		/* Protocol family (AF_INET, AF_INET6) */
 	__u32 protocol;		/* IP protocol (IPPROTO_TCP, IPPROTO_UDP) */
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -10,8 +10,10 @@
 #include <net/bpf_sk_storage.h>
 #include <net/sock.h>
 #include <net/tcp.h>
+#include <net/net_namespace.h>
 #include <linux/error-injection.h>
 #include <linux/smp.h>
+#include <linux/sock_diag.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/bpf_test_run.h>
@@ -796,3 +798,106 @@ out:
 	kfree(data);
 	return ret;
 }
+
+int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog, const union bpf_attr *kattr,
+				union bpf_attr __user *uattr)
+{
+	struct bpf_test_timer t = { NO_PREEMPT };
+	struct bpf_prog_array *progs = NULL;
+	struct bpf_sk_lookup_kern ctx = {};
+	u32 repeat = kattr->test.repeat;
+	struct bpf_sk_lookup *user_ctx;
+	u32 retval, duration;
+	int ret = -EINVAL;
+
+	if (prog->type != BPF_PROG_TYPE_SK_LOOKUP)
+		return -EINVAL;
+
+	if (kattr->test.flags || kattr->test.cpu)
+		return -EINVAL;
+
+	if (kattr->test.data_in || kattr->test.data_size_in || kattr->test.data_out ||
+	    kattr->test.data_size_out)
+		return -EINVAL;
+
+	if (!repeat)
+		repeat = 1;
+
+	user_ctx = bpf_ctx_init(kattr, sizeof(*user_ctx));
+	if (IS_ERR(user_ctx))
+		return PTR_ERR(user_ctx);
+
+	if (!user_ctx)
+		return -EINVAL;
+
+	if (user_ctx->sk)
+		goto out;
+
+	if (!range_is_zero(user_ctx, offsetofend(typeof(*user_ctx), local_port), sizeof(*user_ctx)))
+		goto out;
+
+	if (user_ctx->local_port > U16_MAX || user_ctx->remote_port > U16_MAX) {
+		ret = -ERANGE;
+		goto out;
+	}
+
+	ctx.family = (u16)user_ctx->family;
+	ctx.protocol = (u16)user_ctx->protocol;
+	ctx.dport = (u16)user_ctx->local_port;
+	ctx.sport = (__force __be16)user_ctx->remote_port;
+
+	switch (ctx.family) {
+	case AF_INET:
+		ctx.v4.daddr = (__force __be32)user_ctx->local_ip4;
+		ctx.v4.saddr = (__force __be32)user_ctx->remote_ip4;
+		break;
+
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+		ctx.v6.daddr = (struct in6_addr *)user_ctx->local_ip6;
+		ctx.v6.saddr = (struct in6_addr *)user_ctx->remote_ip6;
+		break;
+#endif
+
+	default:
+		ret = -EAFNOSUPPORT;
+		goto out;
+	}
+
+	progs = bpf_prog_array_alloc(1, GFP_KERNEL);
+	if (!progs) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	progs->items[0].prog = prog;
+
+	bpf_test_timer_enter(&t);
+	do {
+		ctx.selected_sk = NULL;
+		retval = BPF_PROG_SK_LOOKUP_RUN_ARRAY(progs, ctx, BPF_PROG_RUN);
+	} while (bpf_test_timer_continue(&t, repeat, &ret, &duration));
+	bpf_test_timer_leave(&t);
+
+	if (ret < 0)
+		goto out;
+
+	user_ctx->cookie = 0;
+	if (ctx.selected_sk) {
+		if (ctx.selected_sk->sk_reuseport && !ctx.no_reuseport) {
+			ret = -EOPNOTSUPP;
+			goto out;
+		}
+
+		user_ctx->cookie = sock_gen_cookie(ctx.selected_sk);
+	}
+
+	ret = bpf_test_finish(kattr, uattr, NULL, 0, retval, duration);
+	if (!ret)
+		ret = bpf_ctx_finish(kattr, uattr, user_ctx, sizeof(*user_ctx));
+
+out:
+	bpf_prog_array_free(progs);
+	kfree(user_ctx);
+	return ret;
+}
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10334,6 +10334,7 @@ static u32 sk_lookup_convert_ctx_access(
 }
 
 const struct bpf_prog_ops sk_lookup_prog_ops = {
+	.test_run = bpf_prog_test_run_sk_lookup,
 };
 
 const struct bpf_verifier_ops sk_lookup_verifier_ops = {
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5006,7 +5006,10 @@ struct bpf_pidns_info {
 
 /* User accessible data for SK_LOOKUP programs. Add new fields at the end. */
 struct bpf_sk_lookup {
-	__bpf_md_ptr(struct bpf_sock *, sk); /* Selected socket */
+	union {
+		__bpf_md_ptr(struct bpf_sock *, sk); /* Selected socket */
+		__u64 cookie; /* Non-zero if socket was selected in PROG_TEST_RUN */
+	};
 
 	__u32 family;		/* Protocol family (AF_INET, AF_INET6) */
 	__u32 protocol;		/* IP protocol (IPPROTO_TCP, IPPROTO_UDP) */


