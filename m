Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDB2A3917B
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 18:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729761AbfFGQAE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 12:00:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730127AbfFGPku (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:40:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8388D21473;
        Fri,  7 Jun 2019 15:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922050;
        bh=o0F+UEmMzpFIUL4hfhU/dW7tl6mKsAmLq9rLyqohHfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ykHTIRKgI25vyZyVNNEcL/N4Q1bnSm5bM/M0VAvyByuUrvaIv6k9gnIx7+QauU21+
         rhRoC3JNvQQXwtNOl4HJmihfDQsvtszK38SHwTERTV/3SpglR07VuRL/qIU5O2q+fg
         rf/TfCgwLA9oV2wcPFnczDqspBvWEwa+0UICdszQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 19/69] Revert "tipc: fix modprobe tipc failed after switch order of device registration"
Date:   Fri,  7 Jun 2019 17:39:00 +0200
Message-Id: <20190607153850.709176380@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.271562617@linuxfoundation.org>
References: <20190607153848.271562617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David S. Miller <davem@davemloft.net>

commit 5593530e56943182ebb6d81eca8a3be6db6dbba4 upstream.

This reverts commit 532b0f7ece4cb2ffd24dc723ddf55242d1188e5e.

More revisions coming up.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/tipc/core.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -62,10 +62,6 @@ static int __net_init tipc_init_net(stru
 	INIT_LIST_HEAD(&tn->node_list);
 	spin_lock_init(&tn->node_list_lock);
 
-	err = tipc_socket_init();
-	if (err)
-		goto out_socket;
-
 	err = tipc_sk_rht_init(net);
 	if (err)
 		goto out_sk_rht;
@@ -92,8 +88,6 @@ out_subscr:
 out_nametbl:
 	tipc_sk_rht_destroy(net);
 out_sk_rht:
-	tipc_socket_stop();
-out_socket:
 	return err;
 }
 
@@ -104,7 +98,6 @@ static void __net_exit tipc_exit_net(str
 	tipc_bcast_stop(net);
 	tipc_nametbl_stop(net);
 	tipc_sk_rht_destroy(net);
-	tipc_socket_stop();
 }
 
 static struct pernet_operations tipc_net_ops = {
@@ -140,6 +133,10 @@ static int __init tipc_init(void)
 	if (err)
 		goto out_pernet;
 
+	err = tipc_socket_init();
+	if (err)
+		goto out_socket;
+
 	err = tipc_bearer_setup();
 	if (err)
 		goto out_bearer;
@@ -147,6 +144,8 @@ static int __init tipc_init(void)
 	pr_info("Started in single node mode\n");
 	return 0;
 out_bearer:
+	tipc_socket_stop();
+out_socket:
 	unregister_pernet_subsys(&tipc_net_ops);
 out_pernet:
 	tipc_unregister_sysctl();
@@ -162,6 +161,7 @@ out_netlink:
 static void __exit tipc_exit(void)
 {
 	tipc_bearer_cleanup();
+	tipc_socket_stop();
 	unregister_pernet_subsys(&tipc_net_ops);
 	tipc_netlink_stop();
 	tipc_netlink_compat_stop();


