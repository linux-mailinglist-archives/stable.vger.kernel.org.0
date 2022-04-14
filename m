Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0FFC501137
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345560AbiDNNxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345106AbiDNNpI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:45:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFAAA1471;
        Thu, 14 Apr 2022 06:42:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC0B561D68;
        Thu, 14 Apr 2022 13:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D57C385A1;
        Thu, 14 Apr 2022 13:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943737;
        bh=Uq+0cdcekQOR/pdnfRW63ql+oED0RlzyJiLVZwIRhOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tPF1lPJfiBpwr0NAyB5m/IvGMyPNa+c/PttNe06cUrd034QCXRMupgZrqWYuFW9+A
         yNrjJeS1IfRDVhYOfCZWbu6xJnv8qhmtQnMXwjJ+L74zKKQdUvuQY4oY9IwJ72HD9P
         KncxbkiJkIxLl0UQFA3FLgKln3RskeuR08LDupjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Nash <alnash@fb.com>,
        Neil Spring <ntspring@fb.com>, Wei Wang <weiwan@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 223/475] tcp: ensure PMTU updates are processed during fastopen
Date:   Thu, 14 Apr 2022 15:10:08 +0200
Message-Id: <20220414110901.362708534@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit ed0c99dc0f499ff8b6e75b5ae6092ab42be1ad39 ]

tp->rx_opt.mss_clamp is not populated, yet, during TFO send so we
rise it to the local MSS. tp->mss_cache is not updated, however:

tcp_v6_connect():
  tp->rx_opt.mss_clamp = IPV6_MIN_MTU - headers;
  tcp_connect():
     tcp_connect_init():
       tp->mss_cache = min(mtu, tp->rx_opt.mss_clamp)
     tcp_send_syn_data():
       tp->rx_opt.mss_clamp = tp->advmss

After recent fixes to ICMPv6 PTB handling we started dropping
PMTU updates higher than tp->mss_cache. Because of the stale
tp->mss_cache value PMTU updates during TFO are always dropped.

Thanks to Wei for helping zero in on the problem and the fix!

Fixes: c7bb4b89033b ("ipv6: tcp: drop silly ICMPv6 packet too big messages")
Reported-by: Andre Nash <alnash@fb.com>
Reported-by: Neil Spring <ntspring@fb.com>
Reviewed-by: Wei Wang <weiwan@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20220321165957.1769954-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_output.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 638d7b49ad71..139e962d1aef 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3492,6 +3492,7 @@ static void tcp_connect_queue_skb(struct sock *sk, struct sk_buff *skb)
  */
 static int tcp_send_syn_data(struct sock *sk, struct sk_buff *syn)
 {
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_fastopen_request *fo = tp->fastopen_req;
 	int space, err = 0;
@@ -3506,8 +3507,10 @@ static int tcp_send_syn_data(struct sock *sk, struct sk_buff *syn)
 	 * private TCP options. The cost is reduced data space in SYN :(
 	 */
 	tp->rx_opt.mss_clamp = tcp_mss_clamp(tp, tp->rx_opt.mss_clamp);
+	/* Sync mss_cache after updating the mss_clamp */
+	tcp_sync_mss(sk, icsk->icsk_pmtu_cookie);
 
-	space = __tcp_mtu_to_mss(sk, inet_csk(sk)->icsk_pmtu_cookie) -
+	space = __tcp_mtu_to_mss(sk, icsk->icsk_pmtu_cookie) -
 		MAX_TCP_OPTION_SPACE;
 
 	space = min_t(size_t, space, fo->size);
-- 
2.34.1



