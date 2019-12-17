Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD3B1236A3
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728457AbfLQUKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:10:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728374AbfLQUKk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:10:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18F16206D7;
        Tue, 17 Dec 2019 20:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576613439;
        bh=Sl37bTeWYWkugBVwREuoFxZ4F1JQBaL7waCvyGX2FDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iosABYcfePELfaq1NxxlX4fpdyfCgM/Z3FzssW1ovKhLY/fq7xEAVINtxV/ZIYy1f
         7kYT+k3WlhnaAbGMAfIszzg142cc6Ns6GGkiSlnx73StlUrQgUTlM/vjkG0pR+2ftF
         mFvIQyVjcFnSvlOsdfo6iPf+lHVfzMRPLyZhjlBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Hurley <john.hurley@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 21/37] net: sched: allow indirect blocks to bind to clsact in TC
Date:   Tue, 17 Dec 2019 21:09:42 +0100
Message-Id: <20191217200728.574407139@linuxfoundation.org>
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

[ Upstream commit 25a443f74bcff2c4d506a39eae62fc15ad7c618a ]

When a device is bound to a clsact qdisc, bind events are triggered to
registered drivers for both ingress and egress. However, if a driver
registers to such a device using the indirect block routines then it is
assumed that it is only interested in ingress offload and so only replays
ingress bind/unbind messages.

The NFP driver supports the offload of some egress filters when
registering to a block with qdisc of type clsact. However, on unregister,
if the block is still active, it will not receive an unbind egress
notification which can prevent proper cleanup of other registered
callbacks.

Modify the indirect block callback command in TC to send messages of
ingress and/or egress bind depending on the qdisc in use. NFP currently
supports egress offload for TC flower offload so the changes are only
added to TC.

Fixes: 4d12ba42787b ("nfp: flower: allow offloading of matches on 'internal' ports")
Signed-off-by: John Hurley <john.hurley@netronome.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_api.c |   52 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 19 deletions(-)

--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -626,15 +626,15 @@ static void tcf_chain_flush(struct tcf_c
 static int tcf_block_setup(struct tcf_block *block,
 			   struct flow_block_offload *bo);
 
-static void tc_indr_block_ing_cmd(struct net_device *dev,
-				  struct tcf_block *block,
-				  flow_indr_block_bind_cb_t *cb,
-				  void *cb_priv,
-				  enum flow_block_command command)
+static void tc_indr_block_cmd(struct net_device *dev, struct tcf_block *block,
+			      flow_indr_block_bind_cb_t *cb, void *cb_priv,
+			      enum flow_block_command command, bool ingress)
 {
 	struct flow_block_offload bo = {
 		.command	= command,
-		.binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
+		.binder_type	= ingress ?
+				  FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS :
+				  FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS,
 		.net		= dev_net(dev),
 		.block_shared	= tcf_block_non_null_shared(block),
 	};
@@ -652,9 +652,10 @@ static void tc_indr_block_ing_cmd(struct
 	up_write(&block->cb_lock);
 }
 
-static struct tcf_block *tc_dev_ingress_block(struct net_device *dev)
+static struct tcf_block *tc_dev_block(struct net_device *dev, bool ingress)
 {
 	const struct Qdisc_class_ops *cops;
+	const struct Qdisc_ops *ops;
 	struct Qdisc *qdisc;
 
 	if (!dev_ingress_queue(dev))
@@ -664,24 +665,37 @@ static struct tcf_block *tc_dev_ingress_
 	if (!qdisc)
 		return NULL;
 
-	cops = qdisc->ops->cl_ops;
+	ops = qdisc->ops;
+	if (!ops)
+		return NULL;
+
+	if (!ingress && !strcmp("ingress", ops->id))
+		return NULL;
+
+	cops = ops->cl_ops;
 	if (!cops)
 		return NULL;
 
 	if (!cops->tcf_block)
 		return NULL;
 
-	return cops->tcf_block(qdisc, TC_H_MIN_INGRESS, NULL);
+	return cops->tcf_block(qdisc,
+			       ingress ? TC_H_MIN_INGRESS : TC_H_MIN_EGRESS,
+			       NULL);
 }
 
-static void tc_indr_block_get_and_ing_cmd(struct net_device *dev,
-					  flow_indr_block_bind_cb_t *cb,
-					  void *cb_priv,
-					  enum flow_block_command command)
+static void tc_indr_block_get_and_cmd(struct net_device *dev,
+				      flow_indr_block_bind_cb_t *cb,
+				      void *cb_priv,
+				      enum flow_block_command command)
 {
-	struct tcf_block *block = tc_dev_ingress_block(dev);
+	struct tcf_block *block;
+
+	block = tc_dev_block(dev, true);
+	tc_indr_block_cmd(dev, block, cb, cb_priv, command, true);
 
-	tc_indr_block_ing_cmd(dev, block, cb, cb_priv, command);
+	block = tc_dev_block(dev, false);
+	tc_indr_block_cmd(dev, block, cb, cb_priv, command, false);
 }
 
 static void tc_indr_block_call(struct tcf_block *block,
@@ -3632,9 +3646,9 @@ static struct pernet_operations tcf_net_
 	.size = sizeof(struct tcf_net),
 };
 
-static struct flow_indr_block_entry block_ing_entry = {
-	.cb = tc_indr_block_get_and_ing_cmd,
-	.list = LIST_HEAD_INIT(block_ing_entry.list),
+static struct flow_indr_block_entry block_entry = {
+	.cb = tc_indr_block_get_and_cmd,
+	.list = LIST_HEAD_INIT(block_entry.list),
 };
 
 static int __init tc_filter_init(void)
@@ -3649,7 +3663,7 @@ static int __init tc_filter_init(void)
 	if (err)
 		goto err_register_pernet_subsys;
 
-	flow_indr_add_block_cb(&block_ing_entry);
+	flow_indr_add_block_cb(&block_entry);
 
 	rtnl_register(PF_UNSPEC, RTM_NEWTFILTER, tc_new_tfilter, NULL,
 		      RTNL_FLAG_DOIT_UNLOCKED);


