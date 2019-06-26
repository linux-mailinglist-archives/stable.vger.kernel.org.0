Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10CBD564D4
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 10:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbfFZIpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 04:45:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727005AbfFZIpq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 04:45:46 -0400
Received: from localhost (unknown [116.247.127.123])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E255A208E3;
        Wed, 26 Jun 2019 08:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561538745;
        bh=3JwA4yrbPtdlyNARL29BOmB3wlnDHGk5OrcLu1cofeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mX5IaQ8WV8tgLKgMXQxdD6QpzMGQJwS96K3g5BuvFcQyiouDkNkROn99DKLL3Uv6K
         pi54D889rWMH7mumsRXQK7NzeW7rDAnqc3Av3ECPAeercO7hvLnT231E/uLQo2Vtms
         lX/sT0RWPa86xBCmENu27RE4DFoaaJXt+LiTkr80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Christoph Paasch <cpaasch@apple.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 1/1] tcp: refine memory limit test in tcp_fragment()
Date:   Wed, 26 Jun 2019 16:45:13 +0800
Message-Id: <20190626083606.407433249@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190626083606.302057200@linuxfoundation.org>
References: <20190626083606.302057200@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit b6653b3629e5b88202be3c9abc44713973f5c4b4 upstream.

tcp_fragment() might be called for skbs in the write queue.

Memory limits might have been exceeded because tcp_sendmsg() only
checks limits at full skb (64KB) boundaries.

Therefore, we need to make sure tcp_fragment() wont punish applications
that might have setup very low SO_SNDBUF values.

Fixes: f070ef2ac667 ("tcp: tcp_fragment() should apply sane memory limits")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Christoph Paasch <cpaasch@apple.com>
Tested-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/tcp_output.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1185,7 +1185,7 @@ int tcp_fragment(struct sock *sk, struct
 	if (nsize < 0)
 		nsize = 0;
 
-	if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf)) {
+	if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf + 0x20000)) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPWQUEUETOOBIG);
 		return -ENOMEM;
 	}


