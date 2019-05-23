Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15EE228A3A
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388079AbfEWTLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:11:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388098AbfEWTLN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:11:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 172C62133D;
        Thu, 23 May 2019 19:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638672;
        bh=xdvvcA62MbAZMW3ffzFO2CIubH9bOSXjrHE8RuAPcdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sXUmVAKnMAt+9hi3qqE5RZurF9GckW1KnL3m1SnTgRCPNukFs2zEdjqfKrdUtC40b
         cBLxH8h38pXKqILvKLvEnhvoGSf9LXMxDDpG8ImF0p02ZurM9OXv5wI2pSx+J00gxi
         Se7R58UlcHf4x/uXJtzAg7KWbv6KvZ423L+XJlyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junwei Hu <hujunwei4@huawei.com>,
        Wang Wang <wangwang2@huawei.com>,
        Kang Zhou <zhoukang7@huawei.com>,
        Suanming Mou <mousuanming@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 08/77] tipc: fix modprobe tipc failed after switch order of device registration
Date:   Thu, 23 May 2019 21:05:26 +0200
Message-Id: <20190523181721.240480012@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181719.982121681@linuxfoundation.org>
References: <20190523181719.982121681@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junwei Hu <hujunwei4@huawei.com>

[ Upstream commit 532b0f7ece4cb2ffd24dc723ddf55242d1188e5e ]

Error message printed:
modprobe: ERROR: could not insert 'tipc': Address family not
supported by protocol.
when modprobe tipc after the following patch: switch order of
device registration, commit 7e27e8d6130c
("tipc: switch order of device registration to fix a crash")

Because sock_create_kern(net, AF_TIPC, ...) is called by
tipc_topsrv_create_listener() in the initialization process
of tipc_net_ops, tipc_socket_init() must be execute before that.

I move tipc_socket_init() into function tipc_init_net().

Fixes: 7e27e8d6130c
("tipc: switch order of device registration to fix a crash")
Signed-off-by: Junwei Hu <hujunwei4@huawei.com>
Reported-by: Wang Wang <wangwang2@huawei.com>
Reviewed-by: Kang Zhou <zhoukang7@huawei.com>
Reviewed-by: Suanming Mou <mousuanming@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/core.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -62,6 +62,10 @@ static int __net_init tipc_init_net(stru
 	INIT_LIST_HEAD(&tn->node_list);
 	spin_lock_init(&tn->node_list_lock);
 
+	err = tipc_socket_init();
+	if (err)
+		goto out_socket;
+
 	err = tipc_sk_rht_init(net);
 	if (err)
 		goto out_sk_rht;
@@ -88,6 +92,8 @@ out_subscr:
 out_nametbl:
 	tipc_sk_rht_destroy(net);
 out_sk_rht:
+	tipc_socket_stop();
+out_socket:
 	return err;
 }
 
@@ -98,6 +104,7 @@ static void __net_exit tipc_exit_net(str
 	tipc_bcast_stop(net);
 	tipc_nametbl_stop(net);
 	tipc_sk_rht_destroy(net);
+	tipc_socket_stop();
 }
 
 static struct pernet_operations tipc_net_ops = {
@@ -133,10 +140,6 @@ static int __init tipc_init(void)
 	if (err)
 		goto out_pernet;
 
-	err = tipc_socket_init();
-	if (err)
-		goto out_socket;
-
 	err = tipc_bearer_setup();
 	if (err)
 		goto out_bearer;
@@ -144,8 +147,6 @@ static int __init tipc_init(void)
 	pr_info("Started in single node mode\n");
 	return 0;
 out_bearer:
-	tipc_socket_stop();
-out_socket:
 	unregister_pernet_subsys(&tipc_net_ops);
 out_pernet:
 	tipc_unregister_sysctl();
@@ -161,7 +162,6 @@ out_netlink:
 static void __exit tipc_exit(void)
 {
 	tipc_bearer_cleanup();
-	tipc_socket_stop();
 	unregister_pernet_subsys(&tipc_net_ops);
 	tipc_netlink_stop();
 	tipc_netlink_compat_stop();


