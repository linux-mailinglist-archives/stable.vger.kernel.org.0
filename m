Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E57582E12
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236070AbiG0RHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235916AbiG0RGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:06:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9DA5A2D5;
        Wed, 27 Jul 2022 09:39:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1750B601D6;
        Wed, 27 Jul 2022 16:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C7CC433D7;
        Wed, 27 Jul 2022 16:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939987;
        bh=TATulhQ6PDV7T1GG9tmYc92+FXrrd4JzmDN+m3hLabw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xWYgKCfLFwq1FB2j7QmwGQUSD+r1VTWyaiS7N4TzzphsyM5kcXE6iL33NKKYemnda
         NFZKbJTTU+HWZvcg+luTKU8b1jO5UH379jlEVxCRndOBQ8RbRvTxjUjhO40NZCtRp5
         irRZxqrBn3eayapk0CmQajbdNcAB2rFXZis2u3kg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 065/201] tcp: Fix data-races around sysctl_tcp_min_snd_mss.
Date:   Wed, 27 Jul 2022 18:09:29 +0200
Message-Id: <20220727161029.616497689@linuxfoundation.org>
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

[ Upstream commit 78eb166cdefcc3221c8c7c1e2d514e91a2eb5014 ]

While reading sysctl_tcp_min_snd_mss, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 5f3e2bf008c2 ("tcp: add tcp_min_snd_mss sysctl")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_output.c | 3 ++-
 net/ipv4/tcp_timer.c  | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 53277a9a2300..b4a8a5b9350f 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1722,7 +1722,8 @@ static inline int __tcp_mtu_to_mss(struct sock *sk, int pmtu)
 	mss_now -= icsk->icsk_ext_hdr_len;
 
 	/* Then reserve room for full set of TCP options and 8 bytes of data */
-	mss_now = max(mss_now, sock_net(sk)->ipv4.sysctl_tcp_min_snd_mss);
+	mss_now = max(mss_now,
+		      READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_min_snd_mss));
 	return mss_now;
 }
 
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 04063c7e33ba..39107bb730b0 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -173,7 +173,7 @@ static void tcp_mtu_probing(struct inet_connection_sock *icsk, struct sock *sk)
 		mss = tcp_mtu_to_mss(sk, icsk->icsk_mtup.search_low) >> 1;
 		mss = min(READ_ONCE(net->ipv4.sysctl_tcp_base_mss), mss);
 		mss = max(mss, net->ipv4.sysctl_tcp_mtu_probe_floor);
-		mss = max(mss, net->ipv4.sysctl_tcp_min_snd_mss);
+		mss = max(mss, READ_ONCE(net->ipv4.sysctl_tcp_min_snd_mss));
 		icsk->icsk_mtup.search_low = tcp_mss_to_mtu(sk, mss);
 	}
 	tcp_sync_mss(sk, icsk->icsk_pmtu_cookie);
-- 
2.35.1



