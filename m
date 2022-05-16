Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5826D527F64
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 10:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241542AbiEPIQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 04:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241551AbiEPIQj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 04:16:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E692326E8
        for <stable@vger.kernel.org>; Mon, 16 May 2022 01:16:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C977DB80E8B
        for <stable@vger.kernel.org>; Mon, 16 May 2022 08:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CE7C385B8;
        Mon, 16 May 2022 08:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652688995;
        bh=1dFwstOLR42MS0Jt/Y6T04vc66rbzDkWH8GESAZERf8=;
        h=Subject:To:Cc:From:Date:From;
        b=Nb6A/+2onORfmq9pvoXqIYFuwEzLLZHHh3VP3sYZEtkinQ9gtxecol3+ym5ilD+H2
         I/wTWZkeZ79cEkQCUZBEhQOjVrVJn/u2oWIdZGYId+MTczJfLoyZ3ytmZhHA9ZdZqc
         QO5sQ+GtsrfZjMX89HRL/dDwk4AmrfVAqO0seFH8=
Subject: FAILED: patch "[PATCH] ping: fix address binding wrt vrf" failed to apply to 4.9-stable tree
To:     nicolas.dichtel@6wind.com, dsahern@kernel.org, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 May 2022 10:16:20 +0200
Message-ID: <16526889809944@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e1a7ac6f3ba6e157adcd0ca94d92a401f1943f56 Mon Sep 17 00:00:00 2001
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Wed, 4 May 2022 11:07:38 +0200
Subject: [PATCH] ping: fix address binding wrt vrf

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

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 3ee947557b88..aa9a11b20d18 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -305,6 +305,7 @@ static int ping_check_bind_addr(struct sock *sk, struct inet_sock *isk,
 	struct net *net = sock_net(sk);
 	if (sk->sk_family == AF_INET) {
 		struct sockaddr_in *addr = (struct sockaddr_in *) uaddr;
+		u32 tb_id = RT_TABLE_LOCAL;
 		int chk_addr_ret;
 
 		if (addr_len < sizeof(*addr))
@@ -318,7 +319,8 @@ static int ping_check_bind_addr(struct sock *sk, struct inet_sock *isk,
 		pr_debug("ping_check_bind_addr(sk=%p,addr=%pI4,port=%d)\n",
 			 sk, &addr->sin_addr.s_addr, ntohs(addr->sin_port));
 
-		chk_addr_ret = inet_addr_type(net, addr->sin_addr.s_addr);
+		tb_id = l3mdev_fib_table_by_index(net, sk->sk_bound_dev_if) ? : tb_id;
+		chk_addr_ret = inet_addr_type_table(net, addr->sin_addr.s_addr, tb_id);
 
 		if (!inet_addr_valid_or_nonlocal(net, inet_sk(sk),
 					         addr->sin_addr.s_addr,
@@ -355,6 +357,14 @@ static int ping_check_bind_addr(struct sock *sk, struct inet_sock *isk,
 				return -ENODEV;
 			}
 		}
+
+		if (!dev && sk->sk_bound_dev_if) {
+			dev = dev_get_by_index_rcu(net, sk->sk_bound_dev_if);
+			if (!dev) {
+				rcu_read_unlock();
+				return -ENODEV;
+			}
+		}
 		has_addr = pingv6_ops.ipv6_chk_addr(net, &addr->sin6_addr, dev,
 						    scoped);
 		rcu_read_unlock();

