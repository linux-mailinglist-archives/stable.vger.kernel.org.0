Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B3C4FD058
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbiDLGqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351595AbiDLGpX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:45:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466801E3ED;
        Mon, 11 Apr 2022 23:38:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD394B81B1F;
        Tue, 12 Apr 2022 06:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F0CC385A1;
        Tue, 12 Apr 2022 06:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745519;
        bh=y6oaYYIx9Y7lwbQ9BhHzvHnnJOBFGVQfpoF3q6Ik1q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=phdtLMSDnIFuv5teR/I2h+EgA48k0OmSms+6gDAyBstWw+d+V0tOI9+aOb2WUOFjE
         PQI2iEX7tSR42uGcNXw07yn5xSCn/eXJBfrPrRt8dOWIZUCUF9Noti5+v4gNNGPPl8
         WrGjsBp34UiVmcJLL1bUEjG/HmqEW7XGGNpm1jJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Arthur Fabre <afabre@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/171] bpf: Support dual-stack sockets in bpf_tcp_check_syncookie
Date:   Tue, 12 Apr 2022 08:30:15 +0200
Message-Id: <20220412062931.472728326@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
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

From: Maxim Mikityanskiy <maximmi@nvidia.com>

[ Upstream commit 2e8702cc0cfa1080f29fd64003c00a3e24ac38de ]

bpf_tcp_gen_syncookie looks at the IP version in the IP header and
validates the address family of the socket. It supports IPv4 packets in
AF_INET6 dual-stack sockets.

On the other hand, bpf_tcp_check_syncookie looks only at the address
family of the socket, ignoring the real IP version in headers, and
validates only the packet size. This implementation has some drawbacks:

1. Packets are not validated properly, allowing a BPF program to trick
   bpf_tcp_check_syncookie into handling an IPv6 packet on an IPv4
   socket.

2. Dual-stack sockets fail the checks on IPv4 packets. IPv4 clients end
   up receiving a SYNACK with the cookie, but the following ACK gets
   dropped.

This patch fixes these issues by changing the checks in
bpf_tcp_check_syncookie to match the ones in bpf_tcp_gen_syncookie. IP
version from the header is taken into account, and it is validated
properly with address family.

Fixes: 399040847084 ("bpf: add helper to check for a valid SYN cookie")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Acked-by: Arthur Fabre <afabre@cloudflare.com>
Link: https://lore.kernel.org/bpf/20220406124113.2795730-1-maximmi@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index fe5e0ec5cd3e..ddf9792c0cb2 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6492,24 +6492,33 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
 	if (!th->ack || th->rst || th->syn)
 		return -ENOENT;
 
+	if (unlikely(iph_len < sizeof(struct iphdr)))
+		return -EINVAL;
+
 	if (tcp_synq_no_recent_overflow(sk))
 		return -ENOENT;
 
 	cookie = ntohl(th->ack_seq) - 1;
 
-	switch (sk->sk_family) {
-	case AF_INET:
-		if (unlikely(iph_len < sizeof(struct iphdr)))
+	/* Both struct iphdr and struct ipv6hdr have the version field at the
+	 * same offset so we can cast to the shorter header (struct iphdr).
+	 */
+	switch (((struct iphdr *)iph)->version) {
+	case 4:
+		if (sk->sk_family == AF_INET6 && ipv6_only_sock(sk))
 			return -EINVAL;
 
 		ret = __cookie_v4_check((struct iphdr *)iph, th, cookie);
 		break;
 
 #if IS_BUILTIN(CONFIG_IPV6)
-	case AF_INET6:
+	case 6:
 		if (unlikely(iph_len < sizeof(struct ipv6hdr)))
 			return -EINVAL;
 
+		if (sk->sk_family != AF_INET6)
+			return -EINVAL;
+
 		ret = __cookie_v6_check((struct ipv6hdr *)iph, th, cookie);
 		break;
 #endif /* CONFIG_IPV6 */
-- 
2.35.1



