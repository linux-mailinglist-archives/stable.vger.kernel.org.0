Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50F9C4ABABB
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384032AbiBGLYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241733AbiBGLLT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:11:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7985BC0401C1;
        Mon,  7 Feb 2022 03:11:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AB91B80EE8;
        Mon,  7 Feb 2022 11:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F04AC004E1;
        Mon,  7 Feb 2022 11:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232276;
        bh=YsRx6WK12xvS86SkETnSzshMl+yodYOA2OdexcTU104=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jYLJH1HvHx9SBAG0Obw8aPv0Zyqxhc423jbEFR6Fbb/I8Lt6FhWI5pCW/guHGZnt9
         DpJrusd1vNthFOu/hzIGbWgwZnNYOJifWqa8yDGWg3hgPmfzJ6R9DP/PsfYnnrrigi
         5sW0McmizOOeQ8g3S8nWM8ifwCiUroMhwzs1X8fk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 26/69] ping: fix the sk_bound_dev_if match in ping_lookup
Date:   Mon,  7 Feb 2022 12:05:48 +0100
Message-Id: <20220207103756.484887582@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103755.604121441@linuxfoundation.org>
References: <20220207103755.604121441@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
@@ -225,7 +225,8 @@ static struct sock *ping_lookup(struct n
 			continue;
 		}
 
-		if (sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif)
+		if (sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif &&
+		    sk->sk_bound_dev_if != inet_sdif(skb))
 			continue;
 
 		sock_hold(sk);


