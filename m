Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC2A579E74
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242667AbiGSNBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242849AbiGSM7m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:59:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727E42F02C;
        Tue, 19 Jul 2022 05:25:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 914E7618F1;
        Tue, 19 Jul 2022 12:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6494DC341D0;
        Tue, 19 Jul 2022 12:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233512;
        bh=9Dpr3W6uGf7xets34ZXk9jwqgVe8iCvMPbxopTKleiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=scH9DiSYPGwEhvZ6TDf1Zy7t3bJNv2wVaD4zUUUcpxGqwO9Wq9tvZtfTav0PJf8QU
         wfLyw6gdcBh5k1pmDXspxpxcYwXgVYaxSLZCK7/K8s8uMCKscwueTGTwXTX1wjJGuv
         pbTuiKFokyYkWTcCKk3g+/CzVnCWA14ViED7mto4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 120/231] tcp: Fix data-races around sysctl_tcp_ecn.
Date:   Tue, 19 Jul 2022 13:53:25 +0200
Message-Id: <20220719114724.545069902@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index f33c31dd7366..b387c4835155 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -273,7 +273,7 @@ bool cookie_ecn_ok(const struct tcp_options_received *tcp_opt,
 	if (!ecn_ok)
 		return false;
 
-	if (net->ipv4.sysctl_tcp_ecn)
+	if (READ_ONCE(net->ipv4.sysctl_tcp_ecn))
 		return true;
 
 	return dst_feature(dst, RTAX_FEATURE_ECN);
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 33e65e79e46e..11add5214713 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -680,6 +680,8 @@ static struct ctl_table ipv4_net_table[] = {
 		.maxlen		= sizeof(u8),
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_TWO,
 	},
 	{
 		.procname	= "tcp_ecn_fallback",
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 6b8fcf79688b..2d71bcfcc759 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6712,7 +6712,7 @@ static void tcp_ecn_create_request(struct request_sock *req,
 
 	ect = !INET_ECN_is_not_ect(TCP_SKB_CB(skb)->ip_dsfield);
 	ecn_ok_dst = dst_feature(dst, DST_FEATURE_ECN_MASK);
-	ecn_ok = net->ipv4.sysctl_tcp_ecn || ecn_ok_dst;
+	ecn_ok = READ_ONCE(net->ipv4.sysctl_tcp_ecn) || ecn_ok_dst;
 
 	if (((!ect || th->res1) && ecn_ok) || tcp_ca_needs_ecn(listen_sk) ||
 	    (ecn_ok_dst & DST_FEATURE_ECN_CA) ||
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 6b00c17c72aa..9eefe7f6370f 100644
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



