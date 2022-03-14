Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A091F4D8313
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240812AbiCNMMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240968AbiCNMIK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:08:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 013652AE02;
        Mon, 14 Mar 2022 05:04:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45D1D6130D;
        Mon, 14 Mar 2022 12:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DD0C340E9;
        Mon, 14 Mar 2022 12:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259451;
        bh=bqsgv4wYRlRAXFN2jwy/To0VbWXSYoahODxLG/Pqnl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p3SH04pEZK0e+deVykMjji5sJ7xu/ZK+fgy//QqpUgt+kqOVUgtveDv6sFjYPLYra
         ss+hUYAhFxbFaNxYoJvi2sPKWAgkkDGjUz8Ly30MqUqr2inwaPaZR+jjm/EstijnFY
         oHc0/4XuJvu97STG/Rk839hy0arp0sIT7GEQcj0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuang Li <shuali@redhat.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Tung Nguyen <tung.q.nguyen@dektech.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 010/110] tipc: fix kernel panic when enabling bearer
Date:   Mon, 14 Mar 2022 12:53:12 +0100
Message-Id: <20220314112743.320738039@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tung Nguyen <tung.q.nguyen@dektech.com.au>

[ Upstream commit be4977b847f5d5cedb64d50eaaf2218c3a55a3a3 ]

When enabling a bearer on a node, a kernel panic is observed:

[    4.498085] RIP: 0010:tipc_mon_prep+0x4e/0x130 [tipc]
...
[    4.520030] Call Trace:
[    4.520689]  <IRQ>
[    4.521236]  tipc_link_build_proto_msg+0x375/0x750 [tipc]
[    4.522654]  tipc_link_build_state_msg+0x48/0xc0 [tipc]
[    4.524034]  __tipc_node_link_up+0xd7/0x290 [tipc]
[    4.525292]  tipc_rcv+0x5da/0x730 [tipc]
[    4.526346]  ? __netif_receive_skb_core+0xb7/0xfc0
[    4.527601]  tipc_l2_rcv_msg+0x5e/0x90 [tipc]
[    4.528737]  __netif_receive_skb_list_core+0x20b/0x260
[    4.530068]  netif_receive_skb_list_internal+0x1bf/0x2e0
[    4.531450]  ? dev_gro_receive+0x4c2/0x680
[    4.532512]  napi_complete_done+0x6f/0x180
[    4.533570]  virtnet_poll+0x29c/0x42e [virtio_net]
...

The node in question is receiving activate messages in another
thread after changing bearer status to allow message sending/
receiving in current thread:

         thread 1           |              thread 2
         --------           |              --------
                            |
tipc_enable_bearer()        |
  test_and_set_bit_lock()   |
    tipc_bearer_xmit_skb()  |
                            | tipc_l2_rcv_msg()
                            |   tipc_rcv()
                            |     __tipc_node_link_up()
                            |       tipc_link_build_state_msg()
                            |         tipc_link_build_proto_msg()
                            |           tipc_mon_prep()
                            |           {
                            |             ...
                            |             // null-pointer dereference
                            |             u16 gen = mon->dom_gen;
                            |             ...
                            |           }
  // Not being executed yet |
  tipc_mon_create()         |
  {                         |
    ...                     |
    // allocate             |
    mon = kzalloc();        |
    ...                     |
  }                         |

Monitoring pointer in thread 2 is dereferenced before monitoring data
is allocated in thread 1. This causes kernel panic.

This commit fixes it by allocating the monitoring data before enabling
the bearer to receive messages.

Fixes: 35c55c9877f8 ("tipc: add neighbor monitoring framework")
Reported-by: Shuang Li <shuali@redhat.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/bearer.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index 443f8e5b9477..36b466cfd9e1 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -352,16 +352,18 @@ static int tipc_enable_bearer(struct net *net, const char *name,
 		goto rejected;
 	}
 
-	test_and_set_bit_lock(0, &b->up);
-	rcu_assign_pointer(tn->bearer_list[bearer_id], b);
-	if (skb)
-		tipc_bearer_xmit_skb(net, bearer_id, skb, &b->bcast_addr);
-
+	/* Create monitoring data before accepting activate messages */
 	if (tipc_mon_create(net, bearer_id)) {
 		bearer_disable(net, b);
+		kfree_skb(skb);
 		return -ENOMEM;
 	}
 
+	test_and_set_bit_lock(0, &b->up);
+	rcu_assign_pointer(tn->bearer_list[bearer_id], b);
+	if (skb)
+		tipc_bearer_xmit_skb(net, bearer_id, skb, &b->bcast_addr);
+
 	pr_info("Enabled bearer <%s>, priority %u\n", name, prio);
 
 	return res;
-- 
2.34.1



