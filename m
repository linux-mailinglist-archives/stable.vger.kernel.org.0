Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5249F123698
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbfLQUKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:10:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:36780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728374AbfLQUKg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:10:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36F11206D7;
        Tue, 17 Dec 2019 20:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576613434;
        bh=xxjUJkW/hOf/majrqTs7Du6EpN+J79XU4GKRoGLDDZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yi/dubpN6JxRBCJNfUAk9q2gs0h9HqATyzXEVBHSbS6YehoqrydPOW6mXFf4D+LdU
         MW6gClW2ITm5bnHXoS2qFY4EQjMVreECpUAb/CPm0V27yAeq1jtdIX8REAm8yktzQc
         5oCLRRUNrBwP/0kHl2tMNUvfuRWpq98SGpNxhSBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Hurley <john.hurley@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 20/37] net: core: rename indirect block ingress cb function
Date:   Tue, 17 Dec 2019 21:09:41 +0100
Message-Id: <20191217200727.937985896@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217200721.741054904@linuxfoundation.org>
References: <20191217200721.741054904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Hurley <john.hurley@netronome.com>

[ Upstream commit dbad3408896c3c5722ec9cda065468b3df16c5bf ]

With indirect blocks, a driver can register for callbacks from a device
that is does not 'own', for example, a tunnel device. When registering to
or unregistering from a new device, a callback is triggered to generate
a bind/unbind event. This, in turn, allows the driver to receive any
existing rules or to properly clean up installed rules.

When first added, it was assumed that all indirect block registrations
would be for ingress offloads. However, the NFP driver can, in some
instances, support clsact qdisc binds for egress offload.

Change the name of the indirect block callback command in flow_offload to
remove the 'ingress' identifier from it. While this does not change
functionality, a follow up patch will implement a more more generic
callback than just those currently just supporting ingress offload.

Fixes: 4d12ba42787b ("nfp: flower: allow offloading of matches on 'internal' ports")
Signed-off-by: John Hurley <john.hurley@netronome.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/flow_offload.h        |   15 +++++-------
 net/core/flow_offload.c           |   45 ++++++++++++++++++--------------------
 net/netfilter/nf_tables_offload.c |    6 ++---
 net/sched/cls_api.c               |    4 +--
 4 files changed, 34 insertions(+), 36 deletions(-)

--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -380,19 +380,18 @@ static inline void flow_block_init(struc
 typedef int flow_indr_block_bind_cb_t(struct net_device *dev, void *cb_priv,
 				      enum tc_setup_type type, void *type_data);
 
-typedef void flow_indr_block_ing_cmd_t(struct net_device *dev,
-					flow_indr_block_bind_cb_t *cb,
-					void *cb_priv,
-					enum flow_block_command command);
+typedef void flow_indr_block_cmd_t(struct net_device *dev,
+				   flow_indr_block_bind_cb_t *cb, void *cb_priv,
+				   enum flow_block_command command);
 
-struct flow_indr_block_ing_entry {
-	flow_indr_block_ing_cmd_t *cb;
+struct flow_indr_block_entry {
+	flow_indr_block_cmd_t *cb;
 	struct list_head	list;
 };
 
-void flow_indr_add_block_ing_cb(struct flow_indr_block_ing_entry *entry);
+void flow_indr_add_block_cb(struct flow_indr_block_entry *entry);
 
-void flow_indr_del_block_ing_cb(struct flow_indr_block_ing_entry *entry);
+void flow_indr_del_block_cb(struct flow_indr_block_entry *entry);
 
 int __flow_indr_block_cb_register(struct net_device *dev, void *cb_priv,
 				  flow_indr_block_bind_cb_t *cb,
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -283,7 +283,7 @@ int flow_block_cb_setup_simple(struct fl
 }
 EXPORT_SYMBOL(flow_block_cb_setup_simple);
 
-static LIST_HEAD(block_ing_cb_list);
+static LIST_HEAD(block_cb_list);
 
 static struct rhashtable indr_setup_block_ht;
 
@@ -391,20 +391,19 @@ static void flow_indr_block_cb_del(struc
 	kfree(indr_block_cb);
 }
 
-static DEFINE_MUTEX(flow_indr_block_ing_cb_lock);
+static DEFINE_MUTEX(flow_indr_block_cb_lock);
 
-static void flow_block_ing_cmd(struct net_device *dev,
-			       flow_indr_block_bind_cb_t *cb,
-			       void *cb_priv,
-			       enum flow_block_command command)
+static void flow_block_cmd(struct net_device *dev,
+			   flow_indr_block_bind_cb_t *cb, void *cb_priv,
+			   enum flow_block_command command)
 {
-	struct flow_indr_block_ing_entry *entry;
+	struct flow_indr_block_entry *entry;
 
-	mutex_lock(&flow_indr_block_ing_cb_lock);
-	list_for_each_entry(entry, &block_ing_cb_list, list) {
+	mutex_lock(&flow_indr_block_cb_lock);
+	list_for_each_entry(entry, &block_cb_list, list) {
 		entry->cb(dev, cb, cb_priv, command);
 	}
-	mutex_unlock(&flow_indr_block_ing_cb_lock);
+	mutex_unlock(&flow_indr_block_cb_lock);
 }
 
 int __flow_indr_block_cb_register(struct net_device *dev, void *cb_priv,
@@ -424,8 +423,8 @@ int __flow_indr_block_cb_register(struct
 	if (err)
 		goto err_dev_put;
 
-	flow_block_ing_cmd(dev, indr_block_cb->cb, indr_block_cb->cb_priv,
-			   FLOW_BLOCK_BIND);
+	flow_block_cmd(dev, indr_block_cb->cb, indr_block_cb->cb_priv,
+		       FLOW_BLOCK_BIND);
 
 	return 0;
 
@@ -464,8 +463,8 @@ void __flow_indr_block_cb_unregister(str
 	if (!indr_block_cb)
 		return;
 
-	flow_block_ing_cmd(dev, indr_block_cb->cb, indr_block_cb->cb_priv,
-			   FLOW_BLOCK_UNBIND);
+	flow_block_cmd(dev, indr_block_cb->cb, indr_block_cb->cb_priv,
+		       FLOW_BLOCK_UNBIND);
 
 	flow_indr_block_cb_del(indr_block_cb);
 	flow_indr_block_dev_put(indr_dev);
@@ -499,21 +498,21 @@ void flow_indr_block_call(struct net_dev
 }
 EXPORT_SYMBOL_GPL(flow_indr_block_call);
 
-void flow_indr_add_block_ing_cb(struct flow_indr_block_ing_entry *entry)
+void flow_indr_add_block_cb(struct flow_indr_block_entry *entry)
 {
-	mutex_lock(&flow_indr_block_ing_cb_lock);
-	list_add_tail(&entry->list, &block_ing_cb_list);
-	mutex_unlock(&flow_indr_block_ing_cb_lock);
+	mutex_lock(&flow_indr_block_cb_lock);
+	list_add_tail(&entry->list, &block_cb_list);
+	mutex_unlock(&flow_indr_block_cb_lock);
 }
-EXPORT_SYMBOL_GPL(flow_indr_add_block_ing_cb);
+EXPORT_SYMBOL_GPL(flow_indr_add_block_cb);
 
-void flow_indr_del_block_ing_cb(struct flow_indr_block_ing_entry *entry)
+void flow_indr_del_block_cb(struct flow_indr_block_entry *entry)
 {
-	mutex_lock(&flow_indr_block_ing_cb_lock);
+	mutex_lock(&flow_indr_block_cb_lock);
 	list_del(&entry->list);
-	mutex_unlock(&flow_indr_block_ing_cb_lock);
+	mutex_unlock(&flow_indr_block_cb_lock);
 }
-EXPORT_SYMBOL_GPL(flow_indr_del_block_ing_cb);
+EXPORT_SYMBOL_GPL(flow_indr_del_block_cb);
 
 static int __init init_flow_indr_rhashtable(void)
 {
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -455,7 +455,7 @@ static int nft_offload_netdev_event(stru
 	return NOTIFY_DONE;
 }
 
-static struct flow_indr_block_ing_entry block_ing_entry = {
+static struct flow_indr_block_entry block_ing_entry = {
 	.cb	= nft_indr_block_cb,
 	.list	= LIST_HEAD_INIT(block_ing_entry.list),
 };
@@ -472,13 +472,13 @@ int nft_offload_init(void)
 	if (err < 0)
 		return err;
 
-	flow_indr_add_block_ing_cb(&block_ing_entry);
+	flow_indr_add_block_cb(&block_ing_entry);
 
 	return 0;
 }
 
 void nft_offload_exit(void)
 {
-	flow_indr_del_block_ing_cb(&block_ing_entry);
+	flow_indr_del_block_cb(&block_ing_entry);
 	unregister_netdevice_notifier(&nft_offload_netdev_notifier);
 }
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3632,7 +3632,7 @@ static struct pernet_operations tcf_net_
 	.size = sizeof(struct tcf_net),
 };
 
-static struct flow_indr_block_ing_entry block_ing_entry = {
+static struct flow_indr_block_entry block_ing_entry = {
 	.cb = tc_indr_block_get_and_ing_cmd,
 	.list = LIST_HEAD_INIT(block_ing_entry.list),
 };
@@ -3649,7 +3649,7 @@ static int __init tc_filter_init(void)
 	if (err)
 		goto err_register_pernet_subsys;
 
-	flow_indr_add_block_ing_cb(&block_ing_entry);
+	flow_indr_add_block_cb(&block_ing_entry);
 
 	rtnl_register(PF_UNSPEC, RTM_NEWTFILTER, tc_new_tfilter, NULL,
 		      RTNL_FLAG_DOIT_UNLOCKED);


