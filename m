Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB8E582CDE
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240766AbiG0Qvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240654AbiG0QvD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:51:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618884E84C;
        Wed, 27 Jul 2022 09:33:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE18E61A24;
        Wed, 27 Jul 2022 16:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA214C433C1;
        Wed, 27 Jul 2022 16:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939601;
        bh=kUoyaHAhXD0DPJJ42Ry5JTe19vdwlhVeeiKUvFiTuv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mU67ohh2FCTlKjlFFSMbVFDm39zklfvr2DOf9bvF2QhWz+TqeBhO7nG4whZAVBGKX
         WG6jiiKfb8nqfZzAZPuiHHU1qtkpDn+k2SBlFu9CQYtGUbTA0HC5UMXkfv6RurvljS
         HKBgJOugak3dKVs37kjVgLfe2tVnIsEQyFgFuzJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/105] tcp: Fix a data-race around sysctl_tcp_mtu_probe_floor.
Date:   Wed, 27 Jul 2022 18:10:24 +0200
Message-Id: <20220727161013.625305448@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
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

[ Upstream commit 8e92d4423615a5257d0d871fc067aa561f597deb ]

While reading sysctl_tcp_mtu_probe_floor, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: c04b79b6cfd7 ("tcp: add new tcp_mtu_probe_floor sysctl")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 953f36868369..da92c5d70b70 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -172,7 +172,7 @@ static void tcp_mtu_probing(struct inet_connection_sock *icsk, struct sock *sk)
 	} else {
 		mss = tcp_mtu_to_mss(sk, icsk->icsk_mtup.search_low) >> 1;
 		mss = min(READ_ONCE(net->ipv4.sysctl_tcp_base_mss), mss);
-		mss = max(mss, net->ipv4.sysctl_tcp_mtu_probe_floor);
+		mss = max(mss, READ_ONCE(net->ipv4.sysctl_tcp_mtu_probe_floor));
 		mss = max(mss, READ_ONCE(net->ipv4.sysctl_tcp_min_snd_mss));
 		icsk->icsk_mtup.search_low = tcp_mss_to_mtu(sk, mss);
 	}
-- 
2.35.1



