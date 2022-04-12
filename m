Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C854FD5DB
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377525AbiDLHuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359292AbiDLHmy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:42:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7FAA2CC89;
        Tue, 12 Apr 2022 00:21:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40FB26177C;
        Tue, 12 Apr 2022 07:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD3BC385A5;
        Tue, 12 Apr 2022 07:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748096;
        bh=ScQ0rtqc2sYsCyzqgZl710MjEEg7+tnFQD+SEYvELSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+ZPoPbcRwsA10Tg3/J1cdl+eFb5PoO4Qesa9tiz709kDbU1dOCnSrLvlDk6SfMIz
         JBsRF9e1Vwjqu+PgYSWANNwilQcGyYx6LKc6RKWtai8ecBU/KZvMCBaE5ZXTFDLioB
         Jz00wWS8HmsV6xbsX2UOIb8hct+cm+G3a7gxIYgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [PATCH 5.17 317/343] bpf: Make remote_port field in struct bpf_sk_lookup 16-bit wide
Date:   Tue, 12 Apr 2022 08:32:15 +0200
Message-Id: <20220412063000.471614898@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

From: Jakub Sitnicki <jakub@cloudflare.com>

commit 9a69e2b385f443f244a7e8b8bcafe5ccfb0866b4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/bpf.h |    3 ++-
 net/bpf/test_run.c       |    4 ++--
 net/core/filter.c        |    3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -6379,7 +6379,8 @@ struct bpf_sk_lookup {
 	__u32 protocol;		/* IP protocol (IPPROTO_TCP, IPPROTO_UDP) */
 	__u32 remote_ip4;	/* Network byte order */
 	__u32 remote_ip6[4];	/* Network byte order */
-	__u32 remote_port;	/* Network byte order */
+	__be16 remote_port;	/* Network byte order */
+	__u16 :16;		/* Zero padding */
 	__u32 local_ip4;	/* Network byte order */
 	__u32 local_ip6[4];	/* Network byte order */
 	__u32 local_port;	/* Host byte order */
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -960,7 +960,7 @@ int bpf_prog_test_run_sk_lookup(struct b
 	if (!range_is_zero(user_ctx, offsetofend(typeof(*user_ctx), local_port), sizeof(*user_ctx)))
 		goto out;
 
-	if (user_ctx->local_port > U16_MAX || user_ctx->remote_port > U16_MAX) {
+	if (user_ctx->local_port > U16_MAX) {
 		ret = -ERANGE;
 		goto out;
 	}
@@ -968,7 +968,7 @@ int bpf_prog_test_run_sk_lookup(struct b
 	ctx.family = (u16)user_ctx->family;
 	ctx.protocol = (u16)user_ctx->protocol;
 	ctx.dport = (u16)user_ctx->local_port;
-	ctx.sport = (__force __be16)user_ctx->remote_port;
+	ctx.sport = user_ctx->remote_port;
 
 	switch (ctx.family) {
 	case AF_INET:
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10621,7 +10621,8 @@ static bool sk_lookup_is_valid_access(in
 	case bpf_ctx_range(struct bpf_sk_lookup, local_ip4):
 	case bpf_ctx_range_till(struct bpf_sk_lookup, remote_ip6[0], remote_ip6[3]):
 	case bpf_ctx_range_till(struct bpf_sk_lookup, local_ip6[0], local_ip6[3]):
-	case bpf_ctx_range(struct bpf_sk_lookup, remote_port):
+	case offsetof(struct bpf_sk_lookup, remote_port) ...
+	     offsetof(struct bpf_sk_lookup, local_ip4) - 1:
 	case bpf_ctx_range(struct bpf_sk_lookup, local_port):
 	case bpf_ctx_range(struct bpf_sk_lookup, ingress_ifindex):
 		bpf_ctx_record_field_size(info, sizeof(__u32));


