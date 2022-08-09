Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C334858DDC9
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343521AbiHISGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245729AbiHISF2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:05:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2447F27CF4;
        Tue,  9 Aug 2022 11:02:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6B4E61059;
        Tue,  9 Aug 2022 18:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDE6C43140;
        Tue,  9 Aug 2022 18:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068150;
        bh=RPpTH3ijHdIcyCKVdvgk0xcCqRlXftJTxWnJmnRkBSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mqghpZnKH2DL0I5pFYprP0kEkxcXh2eFCMXochGjmu8/zBpezqNchVVrlPjr88TtE
         2So7E9a5pfEpDa2YBhkIeR71fxNkcHlGghhm2lhHOlDvL+yTzqgHDs+rDApL9pkEB5
         VwdA6Ov57EvQraI9JdJ3mDfBZFdz9ity9t75QhaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 19/32] tcp: Fix a data-race around sysctl_tcp_comp_sack_delay_ns.
Date:   Tue,  9 Aug 2022 20:00:10 +0200
Message-Id: <20220809175513.692599259@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175513.082573955@linuxfoundation.org>
References: <20220809175513.082573955@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 4866b2b0f7672b6d760c4b8ece6fb56f965dcc8a ]

While reading sysctl_tcp_comp_sack_delay_ns, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its reader.

Fixes: 6d82aa242092 ("tcp: add tcp_comp_sack_delay_ns sysctl")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 38412d93400a..b71866aba426 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5262,7 +5262,8 @@ static void __tcp_ack_snd_check(struct sock *sk, int ofo_possible)
 	if (tp->srtt_us && tp->srtt_us < rtt)
 		rtt = tp->srtt_us;
 
-	delay = min_t(unsigned long, sock_net(sk)->ipv4.sysctl_tcp_comp_sack_delay_ns,
+	delay = min_t(unsigned long,
+		      READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_comp_sack_delay_ns),
 		      rtt * (NSEC_PER_USEC >> 3)/20);
 	sock_hold(sk);
 	hrtimer_start(&tp->compressed_ack_timer, ns_to_ktime(delay),
-- 
2.35.1



