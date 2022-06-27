Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E81A255C1B8
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234959AbiF0Lo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237443AbiF0Lmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:42:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A5AB57;
        Mon, 27 Jun 2022 04:38:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 253A6B8111B;
        Mon, 27 Jun 2022 11:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751CDC3411D;
        Mon, 27 Jun 2022 11:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329886;
        bh=9aZEGUQibBiqqRr/XjEunyBYaZq138HKoLBe9gy5Q0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0uu7Su1fWjNLQuQkE4ShKQu+JYVR9xuxM3p8r5pHjZh1Y3zalNhXsPxtaXf1oYjYZ
         KQt1/x6wQ+qSc3wYeNIswR0+O8wksiiQEjK0TPZ8G97yAbF18UA+XTwWKPYK1sPyXj
         k2aQms5eoABi60Qq28kkKV/xpW1S+ltS5DJ4OSdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Carlos Llamas <cmllamas@google.com>,
        Riccardo Paolo Bestetti <pbl@bestov.io>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.18 013/181] ipv4: ping: fix bind address validity check
Date:   Mon, 27 Jun 2022 13:19:46 +0200
Message-Id: <20220627111944.947533207@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Riccardo Paolo Bestetti <pbl@bestov.io>

commit b4a028c4d031c27704ad73b1195ca69a1206941e upstream.

Commit 8ff978b8b222 ("ipv4/raw: support binding to nonlocal addresses")
introduced a helper function to fold duplicated validity checks of bind
addresses into inet_addr_valid_or_nonlocal(). However, this caused an
unintended regression in ping_check_bind_addr(), which previously would
reject binding to multicast and broadcast addresses, but now these are
both incorrectly allowed as reported in [1].

This patch restores the original check. A simple reordering is done to
improve readability and make it evident that multicast and broadcast
addresses should not be allowed. Also, add an early exit for INADDR_ANY
which replaces lost behavior added by commit 0ce779a9f501 ("net: Avoid
unnecessary inet_addr_type() call when addr is INADDR_ANY").

Furthermore, this patch introduces regression selftests to catch these
specific cases.

[1] https://lore.kernel.org/netdev/CANP3RGdkAcDyAZoT1h8Gtuu0saq+eOrrTiWbxnOs+5zn+cpyKg@mail.gmail.com/

Fixes: 8ff978b8b222 ("ipv4/raw: support binding to nonlocal addresses")
Cc: Miaohe Lin <linmiaohe@huawei.com>
Reported-by: Maciej Żenczykowski <maze@google.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Riccardo Paolo Bestetti <pbl@bestov.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ping.c                           |   10 ++++++---
 tools/testing/selftests/net/fcnal-test.sh |   33 ++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 3 deletions(-)

--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -319,12 +319,16 @@ static int ping_check_bind_addr(struct s
 		pr_debug("ping_check_bind_addr(sk=%p,addr=%pI4,port=%d)\n",
 			 sk, &addr->sin_addr.s_addr, ntohs(addr->sin_port));
 
+		if (addr->sin_addr.s_addr == htonl(INADDR_ANY))
+			return 0;
+
 		tb_id = l3mdev_fib_table_by_index(net, sk->sk_bound_dev_if) ? : tb_id;
 		chk_addr_ret = inet_addr_type_table(net, addr->sin_addr.s_addr, tb_id);
 
-		if (!inet_addr_valid_or_nonlocal(net, inet_sk(sk),
-					         addr->sin_addr.s_addr,
-	                                         chk_addr_ret))
+		if (chk_addr_ret == RTN_MULTICAST ||
+		    chk_addr_ret == RTN_BROADCAST ||
+		    (chk_addr_ret != RTN_LOCAL &&
+		     !inet_can_nonlocal_bind(net, isk)))
 			return -EADDRNOTAVAIL;
 
 #if IS_ENABLED(CONFIG_IPV6)
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -70,6 +70,10 @@ NSB_LO_IP6=2001:db8:2::2
 NL_IP=172.17.1.1
 NL_IP6=2001:db8:4::1
 
+# multicast and broadcast addresses
+MCAST_IP=224.0.0.1
+BCAST_IP=255.255.255.255
+
 MD5_PW=abc123
 MD5_WRONG_PW=abc1234
 
@@ -308,6 +312,9 @@ addr2str()
 	127.0.0.1) echo "loopback";;
 	::1) echo "IPv6 loopback";;
 
+	${BCAST_IP}) echo "broadcast";;
+	${MCAST_IP}) echo "multicast";;
+
 	${NSA_IP})	echo "ns-A IP";;
 	${NSA_IP6})	echo "ns-A IPv6";;
 	${NSA_LO_IP})	echo "ns-A loopback IP";;
@@ -1801,6 +1808,19 @@ ipv4_addr_bind_novrf()
 	log_test_addr ${a} $? 0 "Raw socket bind to nonlocal address after device bind"
 
 	#
+	# check that ICMP sockets cannot bind to broadcast and multicast addresses
+	#
+	a=${BCAST_IP}
+	log_start
+	run_cmd nettest -s -R -P icmp -l ${a} -b
+	log_test_addr ${a} $? 1 "ICMP socket bind to broadcast address"
+
+	a=${MCAST_IP}
+	log_start
+	run_cmd nettest -s -R -P icmp -f -l ${a} -b
+	log_test_addr ${a} $? 1 "ICMP socket bind to multicast address"
+
+	#
 	# tcp sockets
 	#
 	a=${NSA_IP}
@@ -1858,6 +1878,19 @@ ipv4_addr_bind_vrf()
 	log_test_addr ${a} $? 0 "Raw socket bind to nonlocal address after VRF bind"
 
 	#
+	# check that ICMP sockets cannot bind to broadcast and multicast addresses
+	#
+	a=${BCAST_IP}
+	log_start
+	run_cmd nettest -s -R -P icmp -l ${a} -I ${VRF} -b
+	log_test_addr ${a} $? 1 "ICMP socket bind to broadcast address after VRF bind"
+
+	a=${MCAST_IP}
+	log_start
+	run_cmd nettest -s -R -P icmp -f -l ${a} -I ${VRF} -b
+	log_test_addr ${a} $? 1 "ICMP socket bind to multicast address after VRF bind"
+
+	#
 	# tcp sockets
 	#
 	for a in ${NSA_IP} ${VRF_IP}


