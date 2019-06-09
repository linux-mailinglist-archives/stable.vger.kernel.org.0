Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 389E43AA60
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730341AbfFIQwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:52:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732083AbfFIQwA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:52:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91CF12083D;
        Sun,  9 Jun 2019 16:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099120;
        bh=Hj8boPAwBiHRtRkaPozDXELHkF59jdmwMCgUSbmtd7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yIjuHUQdTmM4JOQxjq5A22fnDepAZsfFEj8n2z2rikXw9ppOud9+ZiwzwCvaH/KTx
         Zs7P1rapTcOPnxjLZII2IVdQen+VEfSI+Ikrj6J7tYSNAQWhdWAHXitqnNfwsxOdRD
         xoqCrlrgRo0UQmx6J8pQ50XaY7lL96tB3WRgxkak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junwei Hu <hujunwei4@huawei.com>,
        Wang Wang <wangwang2@huawei.com>,
        syzbot+1e8114b61079bfe9cbc5@syzkaller.appspotmail.com,
        Kang Zhou <zhoukang7@huawei.com>,
        Suanming Mou <mousuanming@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 17/83] tipc: fix modprobe tipc failed after switch order of device registration
Date:   Sun,  9 Jun 2019 18:41:47 +0200
Message-Id: <20190609164128.978966665@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
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
@@ -71,9 +71,6 @@ static int __net_init tipc_init_net(stru
 		goto out_nametbl;
 
 	INIT_LIST_HEAD(&tn->dist_queue);
-	err = tipc_topsrv_start(net);
-	if (err)
-		goto out_subscr;
 
 	err = tipc_bcast_init(net);
 	if (err)
@@ -82,8 +79,6 @@ static int __net_init tipc_init_net(stru
 	return 0;
 
 out_bclink:
-	tipc_bcast_stop(net);
-out_subscr:
 	tipc_nametbl_stop(net);
 out_nametbl:
 	tipc_sk_rht_destroy(net);
@@ -93,7 +88,6 @@ out_sk_rht:
 
 static void __net_exit tipc_exit_net(struct net *net)
 {
-	tipc_topsrv_stop(net);
 	tipc_net_stop(net);
 	tipc_bcast_stop(net);
 	tipc_nametbl_stop(net);
@@ -107,6 +101,11 @@ static struct pernet_operations tipc_net
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
@@ -137,6 +136,10 @@ static int __init tipc_init(void)
 	if (err)
 		goto out_socket;
 
+	err = register_pernet_subsys(&tipc_topsrv_net_ops);
+	if (err)
+		goto out_pernet_topsrv;
+
 	err = tipc_bearer_setup();
 	if (err)
 		goto out_bearer;
@@ -144,6 +147,8 @@ static int __init tipc_init(void)
 	pr_info("Started in single node mode\n");
 	return 0;
 out_bearer:
+	unregister_pernet_subsys(&tipc_topsrv_net_ops);
+out_pernet_topsrv:
 	tipc_socket_stop();
 out_socket:
 	unregister_pernet_subsys(&tipc_net_ops);
@@ -161,6 +166,7 @@ out_netlink:
 static void __exit tipc_exit(void)
 {
 	tipc_bearer_cleanup();
+	unregister_pernet_subsys(&tipc_topsrv_net_ops);
 	tipc_socket_stop();
 	unregister_pernet_subsys(&tipc_net_ops);
 	tipc_netlink_stop();
--- a/net/tipc/subscr.c
+++ b/net/tipc/subscr.c
@@ -358,7 +358,7 @@ static void *tipc_subscrb_connect_cb(int
 	return (void *)tipc_subscrb_create(conid);
 }
 
-int tipc_topsrv_start(struct net *net)
+static int tipc_topsrv_start(struct net *net)
 {
 	struct tipc_net *tn = net_generic(net, tipc_net_id);
 	const char name[] = "topology_server";
@@ -396,7 +396,7 @@ int tipc_topsrv_start(struct net *net)
 	return tipc_server_start(topsrv);
 }
 
-void tipc_topsrv_stop(struct net *net)
+static void tipc_topsrv_stop(struct net *net)
 {
 	struct tipc_net *tn = net_generic(net, tipc_net_id);
 	struct tipc_server *topsrv = tn->topsrv;
@@ -405,3 +405,13 @@ void tipc_topsrv_stop(struct net *net)
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
@@ -75,7 +75,8 @@ void tipc_subscrp_report_overlap(struct
 void tipc_subscrp_convert_seq(struct tipc_name_seq *in, int swap,
 			      struct tipc_name_seq *out);
 u32 tipc_subscrp_convert_seq_type(u32 type, int swap);
-int tipc_topsrv_start(struct net *net);
-void tipc_topsrv_stop(struct net *net);
+
+int __net_init tipc_topsrv_init_net(struct net *net);
+void __net_exit tipc_topsrv_exit_net(struct net *net);
 
 #endif


