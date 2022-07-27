Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9176582E1E
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241357AbiG0RHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241419AbiG0RHP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:07:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB18BD1;
        Wed, 27 Jul 2022 09:40:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BC67B821A6;
        Wed, 27 Jul 2022 16:40:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32F9C433C1;
        Wed, 27 Jul 2022 16:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940004;
        bh=UVdnEHSMp5ExBeMfrrQ5QNvyN24fpRBs4MST/dzI4vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lPDprHZlni39s+m+ccupZogOBuU86QfcGgjVojOwXe9/SEyzd4BZ+awCMpQ7/gy/j
         rnlFthvzQ4vxMzAbHiY3OhScUslWZdQYIe/GGRe7gRIPumL9gsWkmokCGTT64lPh9k
         Gt1dRyNirCM/SezGopl88rHtH6P2crwi4+lSJXuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 041/201] tcp: Fix data-races around sysctl_tcp_ecn.
Date:   Wed, 27 Jul 2022 18:09:05 +0200
Message-Id: <20220727161028.582019415@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 4785a66702f086cf2ea84bdbe6ec921f274bd9f2 ]

While reading sysctl_tcp_ecn, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c | 2 +-
 net/ipv4/syncookies.c                                       | 2 +-
 net/ipv4/sysctl_net_ipv4.c                                  | 2 ++
 net/ipv4/tcp_input.c                                        | 2 +-
 net/ipv4/tcp_output.c                                       | 2 +-
 5 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index 4af5561cbfc5..7c760aa65540 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -1392,7 +1392,7 @@ static void chtls_pass_accept_request(struct sock *sk,
 	th_ecn = tcph->ece && tcph->cwr;
 	if (th_ecn) {
 		ect = !INET_ECN_is_not_ect(ip_dsfield);
-		ecn_ok = sock_net(sk)->ipv4.sysctl_tcp_ecn;
+		ecn_ok = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_ecn);
 		if ((!ect && ecn_ok) || tcp_ca_needs_ecn(sk))
 			inet_rsk(oreq)->ecn_ok = 1;
 	}
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 10b469aee492..fd1dc86ba512 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -275,7 +275,7 @@ bool cookie_ecn_ok(const struct tcp_options_received *tcp_opt,
 	if (!ecn_ok)
 		return false;
 
-	if (net->ipv4.sysctl_tcp_ecn)
+	if (READ_ONCE(net->ipv4.sysctl_tcp_ecn))
 		return true;
 
 	return dst_feature(dst, RTAX_FEATURE_ECN);
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 616658e7c796..ead5db7e24ea 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -689,6 +689,8 @@ static struct ctl_table ipv4_net_table[] = {
 		.maxlen		= sizeof(u8),
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_TWO,
 	},
 	{
 		.procname	= "tcp_ecn_fallback",
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 0ff2f620f8e4..ae06923fe8d0 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6669,7 +6669,7 @@ static void tcp_ecn_create_request(struct request_sock *req,
 
 	ect = !INET_ECN_is_not_ect(TCP_SKB_CB(skb)->ip_dsfield);
 	ecn_ok_dst = dst_feature(dst, DST_FEATURE_ECN_MASK);
-	ecn_ok = net->ipv4.sysctl_tcp_ecn || ecn_ok_dst;
+	ecn_ok = READ_ONCE(net->ipv4.sysctl_tcp_ecn) || ecn_ok_dst;
 
 	if (((!ect || th->res1) && ecn_ok) || tcp_ca_needs_ecn(listen_sk) ||
 	    (ecn_ok_dst & DST_FEATURE_ECN_CA) ||
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 509aab1b7ac9..0bd5c334ccce 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -324,7 +324,7 @@ static void tcp_ecn_send_syn(struct sock *sk, struct sk_buff *skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	bool bpf_needs_ecn = tcp_bpf_ca_needs_ecn(sk);
-	bool use_ecn = sock_net(sk)->ipv4.sysctl_tcp_ecn == 1 ||
+	bool use_ecn = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_ecn) == 1 ||
 		tcp_ca_needs_ecn(sk) || bpf_needs_ecn;
 
 	if (!use_ecn) {
-- 
2.35.1



