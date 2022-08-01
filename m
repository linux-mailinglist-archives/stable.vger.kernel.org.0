Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68625586A47
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbiHAMOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233921AbiHAMNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:13:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E34947BB7;
        Mon,  1 Aug 2022 04:57:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A478601C5;
        Mon,  1 Aug 2022 11:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3280AC433C1;
        Mon,  1 Aug 2022 11:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355058;
        bh=bHumqSMh+NEFc3LDZg3MdzJZC6wjGvYc0zi13rK9kLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sLEtU/0UWl86kM/d7HPCnbQv9pQtZhtm+O5rpWnAb3nh4+Ggu2Lvv2lXFAuz9kJGz
         xatRmi3ffITX7Rs/+7nzvx4QFW4iIifQFVga9VTq6ACAr8Cn4jQtfqn0yB3IxAemZ4
         quBX1ujMbf6YKqFnKFpT0rl8tjtsSJMjQ5SUBvjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 47/88] tcp: Fix a data-race around sysctl_tcp_tso_rtt_log.
Date:   Mon,  1 Aug 2022 13:47:01 +0200
Message-Id: <20220801114140.192782036@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
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

[ Upstream commit 2455e61b85e9c99af38cd889a7101f1d48b33cb4 ]

While reading sysctl_tcp_tso_rtt_log, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 65466904b015 ("tcp: adjust TSO packet sizes based on min_rtt")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 08466421e7e0..60c9f7f444e0 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1971,7 +1971,7 @@ static u32 tcp_tso_autosize(const struct sock *sk, unsigned int mss_now,
 
 	bytes = sk->sk_pacing_rate >> READ_ONCE(sk->sk_pacing_shift);
 
-	r = tcp_min_rtt(tcp_sk(sk)) >> sock_net(sk)->ipv4.sysctl_tcp_tso_rtt_log;
+	r = tcp_min_rtt(tcp_sk(sk)) >> READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_tso_rtt_log);
 	if (r < BITS_PER_TYPE(sk->sk_gso_max_size))
 		bytes += sk->sk_gso_max_size >> r;
 
-- 
2.35.1



