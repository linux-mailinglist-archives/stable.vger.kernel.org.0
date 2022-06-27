Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA2555CF7B
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235598AbiF0LbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235505AbiF0L3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:29:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1114EB4B;
        Mon, 27 Jun 2022 04:28:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D933B8111A;
        Mon, 27 Jun 2022 11:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13DEDC3411D;
        Mon, 27 Jun 2022 11:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329309;
        bh=kDihq9Bw183BjtWkYgzYJBoXpL/l/VQicOl/orkDVZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ip3Wu/L2UQ2B083j7WzoB+2Qd74EIZWZyovq472gRumkgVb6OXD1mhgHEpQ2ueeJ
         mLRBUzfaZA/4xAHIei6YviqZvwvgS2zsZ4YIHiRpG6bQOjWUs+75EpoWY/DHxBMqT9
         3S9Ki85UqLQsf5w9jtYBKGYKaSqedhGhnlYwWmxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
        Jon Maxwell <jmaxwell37@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Curtis Taylor <cutaylor-pub@yahoo.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 17/60] bpf: Fix request_sock leak in sk lookup helpers
Date:   Mon, 27 Jun 2022 13:21:28 +0200
Message-Id: <20220627111928.168248168@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111927.641837068@linuxfoundation.org>
References: <20220627111927.641837068@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Maxwell <jmaxwell37@gmail.com>

[ Upstream commit 3046a827316c0e55fc563b4fb78c93b9ca5c7c37 ]

A customer reported a request_socket leak in a Calico cloud environment. We
found that a BPF program was doing a socket lookup with takes a refcnt on
the socket and that it was finding the request_socket but returning the parent
LISTEN socket via sk_to_full_sk() without decrementing the child request socket
1st, resulting in request_sock slab object leak. This patch retains the
existing behaviour of returning full socks to the caller but it also decrements
the child request_socket if one is present before doing so to prevent the leak.

Thanks to Curtis Taylor for all the help in diagnosing and testing this. And
thanks to Antoine Tenart for the reproducer and patch input.

v2 of this patch contains, refactor as per Daniel Borkmann's suggestions to
validate RCU flags on the listen socket so that it balances with bpf_sk_release()
and update comments as per Martin KaFai Lau's suggestion. One small change to
Daniels suggestion, put "sk = sk2" under "if (sk2 != sk)" to avoid an extra
instruction.

Fixes: f7355a6c0497 ("bpf: Check sk_fullsock() before returning from bpf_sk_lookup()")
Fixes: edbf8c01de5a ("bpf: add skc_lookup_tcp helper")
Co-developed-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Curtis Taylor <cutaylor-pub@yahoo.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/56d6f898-bde0-bb25-3427-12a330b29fb8@iogearbox.net
Link: https://lore.kernel.org/bpf/20220615011540.813025-1-jmaxwell37@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index b0df4ddbe30c..eba96343c7af 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5313,10 +5313,21 @@ __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 					   ifindex, proto, netns_id, flags);
 
 	if (sk) {
-		sk = sk_to_full_sk(sk);
-		if (!sk_fullsock(sk)) {
+		struct sock *sk2 = sk_to_full_sk(sk);
+
+		/* sk_to_full_sk() may return (sk)->rsk_listener, so make sure the original sk
+		 * sock refcnt is decremented to prevent a request_sock leak.
+		 */
+		if (!sk_fullsock(sk2))
+			sk2 = NULL;
+		if (sk2 != sk) {
 			sock_gen_put(sk);
-			return NULL;
+			/* Ensure there is no need to bump sk2 refcnt */
+			if (unlikely(sk2 && !sock_flag(sk2, SOCK_RCU_FREE))) {
+				WARN_ONCE(1, "Found non-RCU, unreferenced socket!");
+				return NULL;
+			}
+			sk = sk2;
 		}
 	}
 
@@ -5350,10 +5361,21 @@ bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 					 flags);
 
 	if (sk) {
-		sk = sk_to_full_sk(sk);
-		if (!sk_fullsock(sk)) {
+		struct sock *sk2 = sk_to_full_sk(sk);
+
+		/* sk_to_full_sk() may return (sk)->rsk_listener, so make sure the original sk
+		 * sock refcnt is decremented to prevent a request_sock leak.
+		 */
+		if (!sk_fullsock(sk2))
+			sk2 = NULL;
+		if (sk2 != sk) {
 			sock_gen_put(sk);
-			return NULL;
+			/* Ensure there is no need to bump sk2 refcnt */
+			if (unlikely(sk2 && !sock_flag(sk2, SOCK_RCU_FREE))) {
+				WARN_ONCE(1, "Found non-RCU, unreferenced socket!");
+				return NULL;
+			}
+			sk = sk2;
 		}
 	}
 
-- 
2.35.1



