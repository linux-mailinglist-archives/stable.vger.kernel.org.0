Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB725582B1F
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237116AbiG0Q2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237265AbiG0Q16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:27:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A0D4D81C;
        Wed, 27 Jul 2022 09:24:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FA61619CB;
        Wed, 27 Jul 2022 16:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B79C433D6;
        Wed, 27 Jul 2022 16:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939066;
        bh=jtUa7AvO9TaJ2mHrYY7bw60/L2QAFRLBddrWZxLjEp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ctws3NBzme6lOVaM1ewITO9emwVEzzQcI39CxpQZ8DvFqkgwOU0Yw78mP3hBsybcs
         weZ2O9mhA5EGuQuoc5IERIoIdcV+sZUSQtMKQHvX8xCjm9yE7iAZ8sG57hyeCRCjWD
         ToLjZhhi0qN++bCGD4LdIIjCRLwCaucEq334zAzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 13/37] tcp: Fix a data-race around sysctl_tcp_notsent_lowat.
Date:   Wed, 27 Jul 2022 18:10:39 +0200
Message-Id: <20220727161001.397057599@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161000.822869853@linuxfoundation.org>
References: <20220727161000.822869853@linuxfoundation.org>
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

[ Upstream commit 55be873695ed8912eb77ff46d1d1cadf028bd0f3 ]

While reading sysctl_tcp_notsent_lowat, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: c9bee3b7fdec ("tcp: TCP_NOTSENT_LOWAT socket option")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 181db7dab176..5e719f9d60fd 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1882,7 +1882,7 @@ void __tcp_v4_send_check(struct sk_buff *skb, __be32 saddr, __be32 daddr);
 static inline u32 tcp_notsent_lowat(const struct tcp_sock *tp)
 {
 	struct net *net = sock_net((struct sock *)tp);
-	return tp->notsent_lowat ?: net->ipv4.sysctl_tcp_notsent_lowat;
+	return tp->notsent_lowat ?: READ_ONCE(net->ipv4.sysctl_tcp_notsent_lowat);
 }
 
 static inline bool tcp_stream_memory_free(const struct sock *sk)
-- 
2.35.1



