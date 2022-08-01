Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562AC586998
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbiHAMEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232844AbiHAMCb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:02:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888085508B;
        Mon,  1 Aug 2022 04:54:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9765861320;
        Mon,  1 Aug 2022 11:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0092C433C1;
        Mon,  1 Aug 2022 11:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354842;
        bh=Z8AqWcpFbAGXc/LWg9x7xP2xPEeolQbqmfWOLAhCe64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jEMIPovq7o2XjEqPsBCHlMHgJjErnohuNLgeZBcwaDiplP7JBUSyDQ6gYZVVMxKnT
         X7RnAapTlkIiD01NQCtMBlrOstgCdySYxT9+uguh9fmaYuAUTveEscOkUPNKd1RAyY
         oPE+QgRUXvj+anUy9U0Ku3B3DPVDxGTONWg3n3k8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 38/69] tcp: Fix a data-race around sysctl_tcp_autocorking.
Date:   Mon,  1 Aug 2022 13:47:02 +0200
Message-Id: <20220801114136.026144208@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
References: <20220801114134.468284027@linuxfoundation.org>
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

[ Upstream commit 85225e6f0a76e6745bc841c9f25169c509b573d8 ]

While reading sysctl_tcp_autocorking, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: f54b311142a9 ("tcp: auto corking")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 1abdb8712655..7ba9059c263a 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -694,7 +694,7 @@ static bool tcp_should_autocork(struct sock *sk, struct sk_buff *skb,
 				int size_goal)
 {
 	return skb->len < size_goal &&
-	       sock_net(sk)->ipv4.sysctl_tcp_autocorking &&
+	       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_autocorking) &&
 	       !tcp_rtx_queue_empty(sk) &&
 	       refcount_read(&sk->sk_wmem_alloc) > skb->truesize;
 }
-- 
2.35.1



