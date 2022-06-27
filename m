Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1F255CEBA
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236642AbiF0LjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236734AbiF0Lh6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:37:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B895B872;
        Mon, 27 Jun 2022 04:34:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E37F608D4;
        Mon, 27 Jun 2022 11:34:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F7CC36AE2;
        Mon, 27 Jun 2022 11:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329687;
        bh=BSJlvBFdy/e0RCK5SfWTezagWQO6kyZsTjQ8XMx/Jas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mP1wWFe4HM+5GOhTIsvGAsEKG87OtoUcyEU2HdKIQtxXmHsTaMhsFPrT2BKiW/xva
         MX2lQByHD55wN0RIoG983FLDBKD0wrtG9PX+w+KOSd/XAHUYsqBcCYb3lb2woOw0wj
         v1UNP51AN58LGzVeOZl8iMViVvr4z9nXFuFRKp04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
        Jon Maxwell <jmaxwell37@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Curtis Taylor <cutaylor-pub@yahoo.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 041/135] bpf: Fix request_sock leak in sk lookup helpers
Date:   Mon, 27 Jun 2022 13:20:48 +0200
Message-Id: <20220627111939.350158588@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
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
index 0816468c545c..d1e2ef77ce4c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6209,10 +6209,21 @@ __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
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
 
@@ -6246,10 +6257,21 @@ bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
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



