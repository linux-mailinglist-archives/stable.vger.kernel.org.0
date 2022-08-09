Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75F958DDC2
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344678AbiHISFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344546AbiHISEJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:04:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0858827142;
        Tue,  9 Aug 2022 11:02:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61CB061070;
        Tue,  9 Aug 2022 18:02:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCCAFC433D7;
        Tue,  9 Aug 2022 18:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068136;
        bh=9htbukA8UGUM9CUPIOvsSUS7+HBVOsmT534H4uIYboM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DBhAA342xbT2IDz5y6ABvN9hFjl3ewKGQZ7Ru+twRm1X0rs/6Tl3H1VMIl+D+GHeh
         rCYwhteavf+cOu5N+O16bTxodHkILa4lEEIs7alE+SUDieFrvDxYjditsK4p9Msyhz
         sx3gTCEfVGnX6ApQce3smUai9+4mmNhMVTXczu7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 14/32] tcp: Fix a data-race around sysctl_tcp_min_tso_segs.
Date:   Tue,  9 Aug 2022 20:00:05 +0200
Message-Id: <20220809175513.541606468@linuxfoundation.org>
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

[ Upstream commit e0bb4ab9dfddd872622239f49fb2bd403b70853b ]

While reading sysctl_tcp_min_tso_segs, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 95bd09eb2750 ("tcp: TSO packets automatic sizing")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 13d9e8570ce5..3090b61e4edd 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1745,7 +1745,7 @@ static u32 tcp_tso_segs(struct sock *sk, unsigned int mss_now)
 
 	min_tso = ca_ops->min_tso_segs ?
 			ca_ops->min_tso_segs(sk) :
-			sock_net(sk)->ipv4.sysctl_tcp_min_tso_segs;
+			READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_min_tso_segs);
 
 	tso_segs = tcp_tso_autosize(sk, mss_now, min_tso);
 	return min_t(u32, tso_segs, sk->sk_gso_max_segs);
-- 
2.35.1



