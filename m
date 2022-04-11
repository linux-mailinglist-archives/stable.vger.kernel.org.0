Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27A54FBAD0
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 13:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240424AbiDKLY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 07:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbiDKLY6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 07:24:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660B34550A
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 04:22:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BEEBB811F0
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 11:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394F9C385A5;
        Mon, 11 Apr 2022 11:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649676161;
        bh=CIJOpx6u/QTvYKujv63MVkr98w0pvdxZMO7gKic9Vqw=;
        h=Subject:To:Cc:From:Date:From;
        b=RHI0rKIHwQGMxGVWlJbmxiTar3RpLkWwqXDXL1ZHISmG+fO7kgtvfHEfsQjy+NUEN
         7qknr5XInLbyZlSJ99/54ZIs5FNPq72gM3P52kAcpc99LlpDgFL3pRtDsuBh864RN7
         Rq3r+jyrI4UY+2/rx7HR1NWIJUNnUZV3J5uO4c4o=
Subject: FAILED: patch "[PATCH] bpf: Make remote_port field in struct bpf_sk_lookup 16-bit" failed to apply to 5.10-stable tree
To:     jakub@cloudflare.com, ast@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Apr 2022 13:22:38 +0200
Message-ID: <16496761587595@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9a69e2b385f443f244a7e8b8bcafe5ccfb0866b4 Mon Sep 17 00:00:00 2001
From: Jakub Sitnicki <jakub@cloudflare.com>
Date: Wed, 9 Feb 2022 19:43:32 +0100
Subject: [PATCH] bpf: Make remote_port field in struct bpf_sk_lookup 16-bit
 wide

remote_port is another case of a BPF context field documented as a 32-bit
value in network byte order for which the BPF context access converter
generates a load of a zero-padded 16-bit integer in network byte order.

First such case was dst_port in bpf_sock which got addressed in commit
4421a582718a ("bpf: Make dst_port field in struct bpf_sock 16-bit wide").

Loading 4-bytes from the remote_port offset and converting the value with
bpf_ntohl() leads to surprising results, as the expected value is shifted
by 16 bits.

Reduce the confusion by splitting the field in two - a 16-bit field holding
a big-endian integer, and a 16-bit zero-padding anonymous field that
follows it.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20220209184333.654927-2-jakub@cloudflare.com

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a7f0ddedac1f..afe3d0d7f5f2 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -6453,7 +6453,8 @@ struct bpf_sk_lookup {
 	__u32 protocol;		/* IP protocol (IPPROTO_TCP, IPPROTO_UDP) */
 	__u32 remote_ip4;	/* Network byte order */
 	__u32 remote_ip6[4];	/* Network byte order */
-	__u32 remote_port;	/* Network byte order */
+	__be16 remote_port;	/* Network byte order */
+	__u16 :16;		/* Zero padding */
 	__u32 local_ip4;	/* Network byte order */
 	__u32 local_ip6[4];	/* Network byte order */
 	__u32 local_port;	/* Host byte order */
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index cb150f756f3d..f08034500813 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1147,7 +1147,7 @@ int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog, const union bpf_attr *kat
 	if (!range_is_zero(user_ctx, offsetofend(typeof(*user_ctx), local_port), sizeof(*user_ctx)))
 		goto out;
 
-	if (user_ctx->local_port > U16_MAX || user_ctx->remote_port > U16_MAX) {
+	if (user_ctx->local_port > U16_MAX) {
 		ret = -ERANGE;
 		goto out;
 	}
@@ -1155,7 +1155,7 @@ int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog, const union bpf_attr *kat
 	ctx.family = (u16)user_ctx->family;
 	ctx.protocol = (u16)user_ctx->protocol;
 	ctx.dport = (u16)user_ctx->local_port;
-	ctx.sport = (__force __be16)user_ctx->remote_port;
+	ctx.sport = user_ctx->remote_port;
 
 	switch (ctx.family) {
 	case AF_INET:
diff --git a/net/core/filter.c b/net/core/filter.c
index 99a05199a806..83f06d3b2c52 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10843,7 +10843,8 @@ static bool sk_lookup_is_valid_access(int off, int size,
 	case bpf_ctx_range(struct bpf_sk_lookup, local_ip4):
 	case bpf_ctx_range_till(struct bpf_sk_lookup, remote_ip6[0], remote_ip6[3]):
 	case bpf_ctx_range_till(struct bpf_sk_lookup, local_ip6[0], local_ip6[3]):
-	case bpf_ctx_range(struct bpf_sk_lookup, remote_port):
+	case offsetof(struct bpf_sk_lookup, remote_port) ...
+	     offsetof(struct bpf_sk_lookup, local_ip4) - 1:
 	case bpf_ctx_range(struct bpf_sk_lookup, local_port):
 	case bpf_ctx_range(struct bpf_sk_lookup, ingress_ifindex):
 		bpf_ctx_record_field_size(info, sizeof(__u32));

