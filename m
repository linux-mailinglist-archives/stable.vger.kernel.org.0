Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 056983A925
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388971AbfFIRGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:06:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388966AbfFIRGK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:06:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04E81206C3;
        Sun,  9 Jun 2019 17:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099969;
        bh=NLnvptziKAVZuk6uzcgGO5PsE1kFu57e/1dpLuPkxJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gL83iQAbaBRCwvzQ3DnPXeu2VFkY2KWUlzPlw3aVvRZS1JChx1acjt0k7plcBZFJd
         B9rcVyvBRJzhMBJQzjiezcAelF/xLUGrCapr12KYktRvsOA4a8/67aUSBXaeo89Myz
         DOGHMn6+4vXM10Axe3aW/s2cu1LFN8RgxNvbX9PE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junwei Hu <hujunwei4@huawei.com>,
        Wang Wang <wangwang2@huawei.com>,
        syzbot+1e8114b61079bfe9cbc5@syzkaller.appspotmail.com,
        Kang Zhou <zhoukang7@huawei.com>,
        Suanming Mou <mousuanming@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 191/241] tipc: fix modprobe tipc failed after switch order of device registration -v2
Date:   Sun,  9 Jun 2019 18:42:13 +0200
Message-Id: <20190609164153.444441687@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junwei Hu <hujunwei4@huawei.com>

commit 526f5b851a96566803ee4bee60d0a34df56c77f8 upstream.

Error message printed:
modprobe: ERROR: could not insert 'tipc': Address family not
supported by protocol.
when modprobe tipc after the following patch: switch order of
device registration, commit 7e27e8d6130c
("tipc: switch order of device registration to fix a crash")

Because sock_create_kern(net, AF_TIPC, ...) called by
tipc_topsrv_create_listener() in the initialization process
of tipc_init_net(), so tipc_socket_init() must be execute before that.
Meanwhile, tipc_net_id need to be initialized when sock_create()
called, and tipc_socket_init() is no need to be called for each namespace.

I add a variable tipc_topsrv_net_ops, and split the
register_pernet_subsys() of tipc into two parts, and split
tipc_socket_init() with initialization of pernet params.

By the way, I fixed resources rollback error when tipc_bcast_init()
failed in tipc_init_net().

Fixes: 7e27e8d6130c ("tipc: switch order of device registration to fix a crash")
Signed-off-by: Junwei Hu <hujunwei4@huawei.com>
Reported-by: Wang Wang <wangwang2@huawei.com>
Reported-by: syzbot+1e8114b61079bfe9cbc5@syzkaller.appspotmail.com
Reviewed-by: Kang Zhou <zhoukang7@huawei.com>
Reviewed-by: Suanming Mou <mousuanming@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/tipc/core.c   |   18 ++++++++++++------
 net/tipc/subscr.c |   14 ++++++++++++--
 net/tipc/subscr.h |    5 +++--
 3 files changed, 27 insertions(+), 10 deletions(-)

--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -70,9 +70,6 @@ static int __net_init tipc_init_net(stru
 		goto out_nametbl;
 
 	INIT_LIST_HEAD(&tn->dist_queue);
-	err = tipc_topsrv_start(net);
-	if (err)
-		goto out_subscr;
 
 	err = tipc_bcast_init(net);
 	if (err)
@@ -81,8 +78,6 @@ static int __net_init tipc_init_net(stru
 	return 0;
 
 out_bclink:
-	tipc_bcast_stop(net);
-out_subscr:
 	tipc_nametbl_stop(net);
 out_nametbl:
 	tipc_sk_rht_destroy(net);
@@ -92,7 +87,6 @@ out_sk_rht:
 
 static void __net_exit tipc_exit_net(struct net *net)
 {
-	tipc_topsrv_stop(net);
 	tipc_net_stop(net);
 	tipc_bcast_stop(net);
 	tipc_nametbl_stop(net);
@@ -106,6 +100,11 @@ static struct pernet_operations tipc_net
 	.size = sizeof(struct tipc_net),
 };
 
+static struct pernet_operations tipc_topsrv_net_ops = {
+	.init = tipc_topsrv_init_net,
+	.exit = tipc_topsrv_exit_net,
+};
+
 static int __init tipc_init(void)
 {
 	int err;
@@ -138,6 +137,10 @@ static int __init tipc_init(void)
 	if (err)
 		goto out_socket;
 
+	err = register_pernet_subsys(&tipc_topsrv_net_ops);
+	if (err)
+		goto out_pernet_topsrv;
+
 	err = tipc_bearer_setup();
 	if (err)
 		goto out_bearer;
@@ -145,6 +148,8 @@ static int __init tipc_init(void)
 	pr_info("Started in single node mode\n");
 	return 0;
 out_bearer:
+	unregister_pernet_subsys(&tipc_topsrv_net_ops);
+out_pernet_topsrv:
 	tipc_socket_stop();
 out_socket:
 	unregister_pernet_subsys(&tipc_net_ops);
@@ -162,6 +167,7 @@ out_netlink:
 static void __exit tipc_exit(void)
 {
 	tipc_bearer_cleanup();
+	unregister_pernet_subsys(&tipc_topsrv_net_ops);
 	tipc_socket_stop();
 	unregister_pernet_subsys(&tipc_net_ops);
 	tipc_netlink_stop();
--- a/net/tipc/subscr.c
+++ b/net/tipc/subscr.c
@@ -306,7 +306,7 @@ static void *tipc_subscrb_connect_cb(int
 	return (void *)tipc_subscrb_create(conid);
 }
 
-int tipc_topsrv_start(struct net *net)
+static int tipc_topsrv_start(struct net *net)
 {
 	struct tipc_net *tn = net_generic(net, tipc_net_id);
 	const char name[] = "topology_server";
@@ -344,7 +344,7 @@ int tipc_topsrv_start(struct net *net)
 	return tipc_server_start(topsrv);
 }
 
-void tipc_topsrv_stop(struct net *net)
+static void tipc_topsrv_stop(struct net *net)
 {
 	struct tipc_net *tn = net_generic(net, tipc_net_id);
 	struct tipc_server *topsrv = tn->topsrv;
@@ -353,3 +353,13 @@ void tipc_topsrv_stop(struct net *net)
 	kfree(topsrv->saddr);
 	kfree(topsrv);
 }
+
+int __net_init tipc_topsrv_init_net(struct net *net)
+{
+	return tipc_topsrv_start(net);
+}
+
+void __net_exit tipc_topsrv_exit_net(struct net *net)
+{
+	tipc_topsrv_stop(net);
+}
--- a/net/tipc/subscr.h
+++ b/net/tipc/subscr.h
@@ -77,7 +77,8 @@ int tipc_subscrp_check_overlap(struct ti
 void tipc_subscrp_report_overlap(struct tipc_subscription *sub,
 				 u32 found_lower, u32 found_upper, u32 event,
 				 u32 port_ref, u32 node, int must);
-int tipc_topsrv_start(struct net *net);
-void tipc_topsrv_stop(struct net *net);
+
+int __net_init tipc_topsrv_init_net(struct net *net);
+void __net_exit tipc_topsrv_exit_net(struct net *net);
 
 #endif


