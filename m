Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C654FD3B4
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 11:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351544AbiDLHUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351777AbiDLHM4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:12:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72EB7E55;
        Mon, 11 Apr 2022 23:52:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FF0D6149D;
        Tue, 12 Apr 2022 06:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2004DC385A6;
        Tue, 12 Apr 2022 06:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746350;
        bh=FCi1zb4GbbR20Yat8e/QaOYMtXuyUyOOWTtWNybjKNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xdiPfj9+JfMjOutM6L8E+cJwvRqdkSZVixdBes+lycCx/E7spR3fTemcto6arxBV3
         c0lOzTHmS3LPYn90p0lP5DBwpnELiYCjGSRoP7MJpgo3pnZvco9mAWDwZxcUDOUUuj
         ZUNGL/cGmELXcRG/b+tyQn4dQ+511QnC7irKE+us=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [PATCH 5.15 251/277] bpf: Make remote_port field in struct bpf_sk_lookup 16-bit wide
Date:   Tue, 12 Apr 2022 08:30:54 +0200
Message-Id: <20220412062949.306806264@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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
@@ -6223,7 +6223,8 @@ struct bpf_sk_lookup {
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
@@ -954,7 +954,7 @@ int bpf_prog_test_run_sk_lookup(struct b
 	if (!range_is_zero(user_ctx, offsetofend(typeof(*user_ctx), local_port), sizeof(*user_ctx)))
 		goto out;
 
-	if (user_ctx->local_port > U16_MAX || user_ctx->remote_port > U16_MAX) {
+	if (user_ctx->local_port > U16_MAX) {
 		ret = -ERANGE;
 		goto out;
 	}
@@ -962,7 +962,7 @@ int bpf_prog_test_run_sk_lookup(struct b
 	ctx.family = (u16)user_ctx->family;
 	ctx.protocol = (u16)user_ctx->protocol;
 	ctx.dport = (u16)user_ctx->local_port;
-	ctx.sport = (__force __be16)user_ctx->remote_port;
+	ctx.sport = user_ctx->remote_port;
 
 	switch (ctx.family) {
 	case AF_INET:
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10540,7 +10540,8 @@ static bool sk_lookup_is_valid_access(in
 	case bpf_ctx_range(struct bpf_sk_lookup, local_ip4):
 	case bpf_ctx_range_till(struct bpf_sk_lookup, remote_ip6[0], remote_ip6[3]):
 	case bpf_ctx_range_till(struct bpf_sk_lookup, local_ip6[0], local_ip6[3]):
-	case bpf_ctx_range(struct bpf_sk_lookup, remote_port):
+	case offsetof(struct bpf_sk_lookup, remote_port) ...
+	     offsetof(struct bpf_sk_lookup, local_ip4) - 1:
 	case bpf_ctx_range(struct bpf_sk_lookup, local_port):
 		bpf_ctx_record_field_size(info, sizeof(__u32));
 		return bpf_ctx_narrow_access_ok(off, size, sizeof(__u32));


