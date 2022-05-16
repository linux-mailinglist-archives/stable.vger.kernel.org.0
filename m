Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB43529042
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346632AbiEPULm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351076AbiEPUB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:01:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3769E403E4;
        Mon, 16 May 2022 12:58:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA01860A50;
        Mon, 16 May 2022 19:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9BDC34100;
        Mon, 16 May 2022 19:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652731104;
        bh=QAcOIk4Fvam+dBlc/Az4mJSYq265WNe8nSHCtWmlbNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HhesQE4rHHl0fjtY/GyBKYMo8Bj3q2xm21JHLTyfNyFglPlYy3KqMh4h8HTNT7xq/
         IhJdFDhl5+GixRr02yrKjHMDDVbglNeE2M1MvyaVxHpEYOmrM0dx9trZx67AabKQ3i
         HhRCixEkASfGkl9dnOcZqPnqQi1zfL7ueRZQUspU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.17 103/114] ping: fix address binding wrt vrf
Date:   Mon, 16 May 2022 21:37:17 +0200
Message-Id: <20220516193628.432204488@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit e1a7ac6f3ba6e157adcd0ca94d92a401f1943f56 upstream.

When ping_group_range is updated, 'ping' uses the DGRAM ICMP socket,
instead of an IP raw socket. In this case, 'ping' is unable to bind its
socket to a local address owned by a vrflite.

Before the patch:
$ sysctl -w net.ipv4.ping_group_range='0  2147483647'
$ ip link add blue type vrf table 10
$ ip link add foo type dummy
$ ip link set foo master blue
$ ip link set foo up
$ ip addr add 192.168.1.1/24 dev foo
$ ip addr add 2001::1/64 dev foo
$ ip vrf exec blue ping -c1 -I 192.168.1.1 192.168.1.2
ping: bind: Cannot assign requested address
$ ip vrf exec blue ping6 -c1 -I 2001::1 2001::2
ping6: bind icmp socket: Cannot assign requested address

CC: stable@vger.kernel.org
Fixes: 1b69c6d0ae90 ("net: Introduce L3 Master device abstraction")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ping.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -305,6 +305,7 @@ static int ping_check_bind_addr(struct s
 	struct net *net = sock_net(sk);
 	if (sk->sk_family == AF_INET) {
 		struct sockaddr_in *addr = (struct sockaddr_in *) uaddr;
+		u32 tb_id = RT_TABLE_LOCAL;
 		int chk_addr_ret;
 
 		if (addr_len < sizeof(*addr))
@@ -318,7 +319,8 @@ static int ping_check_bind_addr(struct s
 		pr_debug("ping_check_bind_addr(sk=%p,addr=%pI4,port=%d)\n",
 			 sk, &addr->sin_addr.s_addr, ntohs(addr->sin_port));
 
-		chk_addr_ret = inet_addr_type(net, addr->sin_addr.s_addr);
+		tb_id = l3mdev_fib_table_by_index(net, sk->sk_bound_dev_if) ? : tb_id;
+		chk_addr_ret = inet_addr_type_table(net, addr->sin_addr.s_addr, tb_id);
 
 		if (!inet_addr_valid_or_nonlocal(net, inet_sk(sk),
 					         addr->sin_addr.s_addr,
@@ -353,6 +355,14 @@ static int ping_check_bind_addr(struct s
 			if (!dev) {
 				rcu_read_unlock();
 				return -ENODEV;
+			}
+		}
+
+		if (!dev && sk->sk_bound_dev_if) {
+			dev = dev_get_by_index_rcu(net, sk->sk_bound_dev_if);
+			if (!dev) {
+				rcu_read_unlock();
+				return -ENODEV;
 			}
 		}
 		has_addr = pingv6_ops.ipv6_chk_addr(net, &addr->sin6_addr, dev,


