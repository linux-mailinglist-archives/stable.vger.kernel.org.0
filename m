Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9AA4A430E
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359219AbiAaLQo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:16:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359252AbiAaLOp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:14:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFF3C061768;
        Mon, 31 Jan 2022 03:11:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4240B82A75;
        Mon, 31 Jan 2022 11:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D749FC340EF;
        Mon, 31 Jan 2022 11:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627461;
        bh=pprbZsg+C92F/5sdWdHZshcc/eOL9hMtUXknEI2V4gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JKxNDJ3xSe3UQbxdtcnBcjjGff46Ylcn1SdiQ69BR8YVLLGLl2fBD8zhShVsfbe+a
         qQzKF7khiq3P0eX2BBxuiXl8yL2M27d2eFtXALsxtvJ0+a27nFOnfCm0o63T7wMUSx
         H9rBXZOVBe6VSp519kHuOgWWDbE2nRtt2DIW143U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/171] ping: fix the sk_bound_dev_if match in ping_lookup
Date:   Mon, 31 Jan 2022 11:55:55 +0100
Message-Id: <20220131105233.081930249@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit 2afc3b5a31f9edf3ef0f374f5d70610c79c93a42 upstream.

When 'ping' changes to use PING socket instead of RAW socket by:

   # sysctl -w net.ipv4.ping_group_range="0 100"

the selftests 'router_broadcast.sh' will fail, as such command

  # ip vrf exec vrf-h1 ping -I veth0 198.51.100.255 -b

can't receive the response skb by the PING socket. It's caused by mismatch
of sk_bound_dev_if and dif in ping_rcv() when looking up the PING socket,
as dif is vrf-h1 if dif's master was set to vrf-h1.

This patch is to fix this regression by also checking the sk_bound_dev_if
against sdif so that the packets can stil be received even if the socket
is not bound to the vrf device but to the real iif.

Fixes: c319b4d76b9e ("net: ipv4: add IPPROTO_ICMP socket kind")
Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ping.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -220,7 +220,8 @@ static struct sock *ping_lookup(struct n
 			continue;
 		}
 
-		if (sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif)
+		if (sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif &&
+		    sk->sk_bound_dev_if != inet_sdif(skb))
 			continue;
 
 		sock_hold(sk);


