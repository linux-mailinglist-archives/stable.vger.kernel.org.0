Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E48920DA82
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729607AbgF2T6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:58:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387596AbgF2TkS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 192FF248AA;
        Mon, 29 Jun 2020 15:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444402;
        bh=XZMZvUdksZcKNHGwiJfs3BqbDlrqQIOsxe64/ux010k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aa8hJ/LPx1yxENUAxXyUGRbxug3tu+c4jUWfcgePuCa2LawyqGS23Y2CwtvQDO+2u
         pv1/0qyqA5gnF8jKib8y8jr04cI9hXRDXshCg9vpZQls1dDsw1BzPwn+XkcRpHwDIL
         f60BjzzFcsfTy3arKymrCTfotMRuM1mMsF2AjuLA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/178] bpf: Don't return EINVAL from {get,set}sockopt when optlen > PAGE_SIZE
Date:   Mon, 29 Jun 2020 11:23:45 -0400
Message-Id: <20200629152523.2494198-81-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit d8fe449a9c51a37d844ab607e14e2f5c657d3cf2 ]

Attaching to these hooks can break iptables because its optval is
usually quite big, or at least bigger than the current PAGE_SIZE limit.
David also mentioned some SCTP options can be big (around 256k).

For such optvals we expose only the first PAGE_SIZE bytes to
the BPF program. BPF program has two options:
1. Set ctx->optlen to 0 to indicate that the BPF's optval
   should be ignored and the kernel should use original userspace
   value.
2. Set ctx->optlen to something that's smaller than the PAGE_SIZE.

v5:
* use ctx->optlen == 0 with trimmed buffer (Alexei Starovoitov)
* update the docs accordingly

v4:
* use temporary buffer to avoid optval == optval_end == NULL;
  this removes the corner case in the verifier that might assume
  non-zero PTR_TO_PACKET/PTR_TO_PACKET_END.

v3:
* don't increase the limit, bypass the argument

v2:
* proper comments formatting (Jakub Kicinski)

Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Cc: David Laight <David.Laight@ACULAB.COM>
Link: https://lore.kernel.org/bpf/20200617010416.93086-1-sdf@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cgroup.c | 53 ++++++++++++++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 20 deletions(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 869e2e1860e84..b701af27a7799 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -966,16 +966,23 @@ static bool __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
 
 static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
 {
-	if (unlikely(max_optlen > PAGE_SIZE) || max_optlen < 0)
+	if (unlikely(max_optlen < 0))
 		return -EINVAL;
 
+	if (unlikely(max_optlen > PAGE_SIZE)) {
+		/* We don't expose optvals that are greater than PAGE_SIZE
+		 * to the BPF program.
+		 */
+		max_optlen = PAGE_SIZE;
+	}
+
 	ctx->optval = kzalloc(max_optlen, GFP_USER);
 	if (!ctx->optval)
 		return -ENOMEM;
 
 	ctx->optval_end = ctx->optval + max_optlen;
 
-	return 0;
+	return max_optlen;
 }
 
 static void sockopt_free_buf(struct bpf_sockopt_kern *ctx)
@@ -1009,13 +1016,13 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 	 */
 	max_optlen = max_t(int, 16, *optlen);
 
-	ret = sockopt_alloc_buf(&ctx, max_optlen);
-	if (ret)
-		return ret;
+	max_optlen = sockopt_alloc_buf(&ctx, max_optlen);
+	if (max_optlen < 0)
+		return max_optlen;
 
 	ctx.optlen = *optlen;
 
-	if (copy_from_user(ctx.optval, optval, *optlen) != 0) {
+	if (copy_from_user(ctx.optval, optval, min(*optlen, max_optlen)) != 0) {
 		ret = -EFAULT;
 		goto out;
 	}
@@ -1043,8 +1050,14 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 		/* export any potential modifications */
 		*level = ctx.level;
 		*optname = ctx.optname;
-		*optlen = ctx.optlen;
-		*kernel_optval = ctx.optval;
+
+		/* optlen == 0 from BPF indicates that we should
+		 * use original userspace data.
+		 */
+		if (ctx.optlen != 0) {
+			*optlen = ctx.optlen;
+			*kernel_optval = ctx.optval;
+		}
 	}
 
 out:
@@ -1076,12 +1089,12 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 	    __cgroup_bpf_prog_array_is_empty(cgrp, BPF_CGROUP_GETSOCKOPT))
 		return retval;
 
-	ret = sockopt_alloc_buf(&ctx, max_optlen);
-	if (ret)
-		return ret;
-
 	ctx.optlen = max_optlen;
 
+	max_optlen = sockopt_alloc_buf(&ctx, max_optlen);
+	if (max_optlen < 0)
+		return max_optlen;
+
 	if (!retval) {
 		/* If kernel getsockopt finished successfully,
 		 * copy whatever was returned to the user back
@@ -1095,10 +1108,8 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 			goto out;
 		}
 
-		if (ctx.optlen > max_optlen)
-			ctx.optlen = max_optlen;
-
-		if (copy_from_user(ctx.optval, optval, ctx.optlen) != 0) {
+		if (copy_from_user(ctx.optval, optval,
+				   min(ctx.optlen, max_optlen)) != 0) {
 			ret = -EFAULT;
 			goto out;
 		}
@@ -1127,10 +1138,12 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 		goto out;
 	}
 
-	if (copy_to_user(optval, ctx.optval, ctx.optlen) ||
-	    put_user(ctx.optlen, optlen)) {
-		ret = -EFAULT;
-		goto out;
+	if (ctx.optlen != 0) {
+		if (copy_to_user(optval, ctx.optval, ctx.optlen) ||
+		    put_user(ctx.optlen, optlen)) {
+			ret = -EFAULT;
+			goto out;
+		}
 	}
 
 	ret = ctx.retval;
-- 
2.25.1

