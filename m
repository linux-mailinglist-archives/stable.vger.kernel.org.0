Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3A1A28882
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389810AbfEWT0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:26:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390226AbfEWT0y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:26:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4427A2184E;
        Thu, 23 May 2019 19:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639613;
        bh=7CsxQZnR9OEYV73h7mR3bBrUUkWb0cqJ/BNieI70RKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QnaNYW7rZ5A+uuwI8zDO8GqCap5RjFYv/82AxtaMJGybxKptLC0oIxhqJnEaPlYSD
         yfqktehxqwtRuS6xpET8ykcYL+dkhR8hIhZsIQSxJi7L3KwycP+42gsWIl9LV3lfDw
         JgpH9m+TbgmfryByE4JL9SSD+2pnOh1I7F8hgqW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junwei Hu <hujunwei4@huawei.com>,
        Wang Wang <wangwang2@huawei.com>,
        Kang Zhou <zhoukang7@huawei.com>,
        Suanming Mou <mousuanming@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 013/122] tipc: fix modprobe tipc failed after switch order of device registration
Date:   Thu, 23 May 2019 21:05:35 +0200
Message-Id: <20190523181706.694989620@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
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
@@ -66,6 +66,10 @@ static int __net_init tipc_init_net(stru
 	INIT_LIST_HEAD(&tn->node_list);
 	spin_lock_init(&tn->node_list_lock);
 
+	err = tipc_socket_init();
+	if (err)
+		goto out_socket;
+
 	err = tipc_sk_rht_init(net);
 	if (err)
 		goto out_sk_rht;
@@ -92,6 +96,8 @@ out_subscr:
 out_nametbl:
 	tipc_sk_rht_destroy(net);
 out_sk_rht:
+	tipc_socket_stop();
+out_socket:
 	return err;
 }
 
@@ -102,6 +108,7 @@ static void __net_exit tipc_exit_net(str
 	tipc_bcast_stop(net);
 	tipc_nametbl_stop(net);
 	tipc_sk_rht_destroy(net);
+	tipc_socket_stop();
 }
 
 static struct pernet_operations tipc_net_ops = {
@@ -137,10 +144,6 @@ static int __init tipc_init(void)
 	if (err)
 		goto out_pernet;
 
-	err = tipc_socket_init();
-	if (err)
-		goto out_socket;
-
 	err = tipc_bearer_setup();
 	if (err)
 		goto out_bearer;
@@ -148,8 +151,6 @@ static int __init tipc_init(void)
 	pr_info("Started in single node mode\n");
 	return 0;
 out_bearer:
-	tipc_socket_stop();
-out_socket:
 	unregister_pernet_subsys(&tipc_net_ops);
 out_pernet:
 	tipc_unregister_sysctl();
@@ -165,7 +166,6 @@ out_netlink:
 static void __exit tipc_exit(void)
 {
 	tipc_bearer_cleanup();
-	tipc_socket_stop();
 	unregister_pernet_subsys(&tipc_net_ops);
 	tipc_netlink_stop();
 	tipc_netlink_compat_stop();


