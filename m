Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C85DB5D2D
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbfIRGWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:22:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728577AbfIRGWO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:22:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DABE21906;
        Wed, 18 Sep 2019 06:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787733;
        bh=t4/okchjdpKlRU/MYDClNG7aW9vnIOxVOLWC/yfh+UU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BTMyC7mOOyZK8IJUgrh6sI7LRSzeQa4xFYKH46oq3zXipy0gGPW49prv7jpuO4wFU
         Y93wtCpp9Xp25FFrfkdlttSKXmc+NQL5kwKcQ8Yj85e7E5pQK+kvDupelCF5OATUtA
         u0Ac8NEp1mEJ5wlGjL+JyQkfQrJHnKtLZcKw1TY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Shuang <shuali@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 14/50] tipc: add NULL pointer check before calling kfree_rcu
Date:   Wed, 18 Sep 2019 08:18:57 +0200
Message-Id: <20190918061224.581287367@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061223.116178343@linuxfoundation.org>
References: <20190918061223.116178343@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 42dec1dbe38239cf91cc1f4df7830c66276ced37 ]

Unlike kfree(p), kfree_rcu(p, rcu) won't do NULL pointer check. When
tipc_nametbl_remove_publ returns NULL, the panic below happens:

   BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
   RIP: 0010:__call_rcu+0x1d/0x290
   Call Trace:
    <IRQ>
    tipc_publ_notify+0xa9/0x170 [tipc]
    tipc_node_write_unlock+0x8d/0x100 [tipc]
    tipc_node_link_down+0xae/0x1d0 [tipc]
    tipc_node_check_dest+0x3ea/0x8f0 [tipc]
    ? tipc_disc_rcv+0x2c7/0x430 [tipc]
    tipc_disc_rcv+0x2c7/0x430 [tipc]
    ? tipc_rcv+0x6bb/0xf20 [tipc]
    tipc_rcv+0x6bb/0xf20 [tipc]
    ? ip_route_input_slow+0x9cf/0xb10
    tipc_udp_recv+0x195/0x1e0 [tipc]
    ? tipc_udp_is_known_peer+0x80/0x80 [tipc]
    udp_queue_rcv_skb+0x180/0x460
    udp_unicast_rcv_skb.isra.56+0x75/0x90
    __udp4_lib_rcv+0x4ce/0xb90
    ip_local_deliver_finish+0x11c/0x210
    ip_local_deliver+0x6b/0xe0
    ? ip_rcv_finish+0xa9/0x410
    ip_rcv+0x273/0x362

Fixes: 97ede29e80ee ("tipc: convert name table read-write lock to RCU")
Reported-by: Li Shuang <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/name_distr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/tipc/name_distr.c
+++ b/net/tipc/name_distr.c
@@ -221,7 +221,8 @@ static void tipc_publ_purge(struct net *
 		       publ->key);
 	}
 
-	kfree_rcu(p, rcu);
+	if (p)
+		kfree_rcu(p, rcu);
 }
 
 /**


