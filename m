Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8134E99A06
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390769AbfHVRJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:09:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:59648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390751AbfHVRJY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:09:24 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 899EF23404;
        Thu, 22 Aug 2019 17:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493762;
        bh=EfyA2qFNkpeNh1Z+aPLWgh7ySTdRly8BB4OcTMGyg54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vpskTVaEwPgDRQw3CtV6d5doMGw81cYC4ENoTEHb+DCs6PU391oWwMnTIocEJP7Cr
         mwnRmuYWJqUsbFbmHzHXuYPUYdEye0OInQrxq8GmH63qWyFfUkfuAnAGtju5MZHrIa
         MlXaJfSbAVcn38JMf3FIwb3ee1APDkubv76VqpZo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 127/135] netdevsim: Restore per-network namespace accounting for fib entries
Date:   Thu, 22 Aug 2019 13:08:03 -0400
Message-Id: <20190822170811.13303-128-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

[ Upstream commit 59c84b9fcf42c99a945d5fdc49220d854e539690 ]

Prior to the commit in the fixes tag, the resource controller in netdevsim
tracked fib entries and rules per network namespace. Restore that behavior.

Fixes: 5fc494225c1e ("netdevsim: create devlink instance per netdevsim instance")
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/netdevsim/dev.c       |  63 ++++++++----------
 drivers/net/netdevsim/fib.c       | 102 ++++++++++++++++++------------
 drivers/net/netdevsim/netdev.c    |   9 ++-
 drivers/net/netdevsim/netdevsim.h |  10 ++-
 4 files changed, 98 insertions(+), 86 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index b509b941d5cab..6825254eb8822 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -71,46 +71,47 @@ static void nsim_dev_port_debugfs_exit(struct nsim_dev_port *nsim_dev_port)
 	debugfs_remove_recursive(nsim_dev_port->ddir);
 }
 
+static struct net *nsim_devlink_net(struct devlink *devlink)
+{
+	return &init_net;
+}
+
 static u64 nsim_dev_ipv4_fib_resource_occ_get(void *priv)
 {
-	struct nsim_dev *nsim_dev = priv;
+	struct net *net = priv;
 
-	return nsim_fib_get_val(nsim_dev->fib_data,
-				NSIM_RESOURCE_IPV4_FIB, false);
+	return nsim_fib_get_val(net, NSIM_RESOURCE_IPV4_FIB, false);
 }
 
 static u64 nsim_dev_ipv4_fib_rules_res_occ_get(void *priv)
 {
-	struct nsim_dev *nsim_dev = priv;
+	struct net *net = priv;
 
-	return nsim_fib_get_val(nsim_dev->fib_data,
-				NSIM_RESOURCE_IPV4_FIB_RULES, false);
+	return nsim_fib_get_val(net, NSIM_RESOURCE_IPV4_FIB_RULES, false);
 }
 
 static u64 nsim_dev_ipv6_fib_resource_occ_get(void *priv)
 {
-	struct nsim_dev *nsim_dev = priv;
+	struct net *net = priv;
 
-	return nsim_fib_get_val(nsim_dev->fib_data,
-				NSIM_RESOURCE_IPV6_FIB, false);
+	return nsim_fib_get_val(net, NSIM_RESOURCE_IPV6_FIB, false);
 }
 
 static u64 nsim_dev_ipv6_fib_rules_res_occ_get(void *priv)
 {
-	struct nsim_dev *nsim_dev = priv;
+	struct net *net = priv;
 
-	return nsim_fib_get_val(nsim_dev->fib_data,
-				NSIM_RESOURCE_IPV6_FIB_RULES, false);
+	return nsim_fib_get_val(net, NSIM_RESOURCE_IPV6_FIB_RULES, false);
 }
 
 static int nsim_dev_resources_register(struct devlink *devlink)
 {
-	struct nsim_dev *nsim_dev = devlink_priv(devlink);
 	struct devlink_resource_size_params params = {
 		.size_max = (u64)-1,
 		.size_granularity = 1,
 		.unit = DEVLINK_RESOURCE_UNIT_ENTRY
 	};
+	struct net *net = nsim_devlink_net(devlink);
 	int err;
 	u64 n;
 
@@ -124,8 +125,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 		goto out;
 	}
 
-	n = nsim_fib_get_val(nsim_dev->fib_data,
-			     NSIM_RESOURCE_IPV4_FIB, true);
+	n = nsim_fib_get_val(net, NSIM_RESOURCE_IPV4_FIB, true);
 	err = devlink_resource_register(devlink, "fib", n,
 					NSIM_RESOURCE_IPV4_FIB,
 					NSIM_RESOURCE_IPV4, &params);
@@ -134,8 +134,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 		return err;
 	}
 
-	n = nsim_fib_get_val(nsim_dev->fib_data,
-			     NSIM_RESOURCE_IPV4_FIB_RULES, true);
+	n = nsim_fib_get_val(net, NSIM_RESOURCE_IPV4_FIB_RULES, true);
 	err = devlink_resource_register(devlink, "fib-rules", n,
 					NSIM_RESOURCE_IPV4_FIB_RULES,
 					NSIM_RESOURCE_IPV4, &params);
@@ -154,8 +153,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 		goto out;
 	}
 
-	n = nsim_fib_get_val(nsim_dev->fib_data,
-			     NSIM_RESOURCE_IPV6_FIB, true);
+	n = nsim_fib_get_val(net, NSIM_RESOURCE_IPV6_FIB, true);
 	err = devlink_resource_register(devlink, "fib", n,
 					NSIM_RESOURCE_IPV6_FIB,
 					NSIM_RESOURCE_IPV6, &params);
@@ -164,8 +162,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 		return err;
 	}
 
-	n = nsim_fib_get_val(nsim_dev->fib_data,
-			     NSIM_RESOURCE_IPV6_FIB_RULES, true);
+	n = nsim_fib_get_val(net, NSIM_RESOURCE_IPV6_FIB_RULES, true);
 	err = devlink_resource_register(devlink, "fib-rules", n,
 					NSIM_RESOURCE_IPV6_FIB_RULES,
 					NSIM_RESOURCE_IPV6, &params);
@@ -177,19 +174,19 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 	devlink_resource_occ_get_register(devlink,
 					  NSIM_RESOURCE_IPV4_FIB,
 					  nsim_dev_ipv4_fib_resource_occ_get,
-					  nsim_dev);
+					  net);
 	devlink_resource_occ_get_register(devlink,
 					  NSIM_RESOURCE_IPV4_FIB_RULES,
 					  nsim_dev_ipv4_fib_rules_res_occ_get,
-					  nsim_dev);
+					  net);
 	devlink_resource_occ_get_register(devlink,
 					  NSIM_RESOURCE_IPV6_FIB,
 					  nsim_dev_ipv6_fib_resource_occ_get,
-					  nsim_dev);
+					  net);
 	devlink_resource_occ_get_register(devlink,
 					  NSIM_RESOURCE_IPV6_FIB_RULES,
 					  nsim_dev_ipv6_fib_rules_res_occ_get,
-					  nsim_dev);
+					  net);
 out:
 	return err;
 }
@@ -197,11 +194,11 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 static int nsim_dev_reload(struct devlink *devlink,
 			   struct netlink_ext_ack *extack)
 {
-	struct nsim_dev *nsim_dev = devlink_priv(devlink);
 	enum nsim_resource_id res_ids[] = {
 		NSIM_RESOURCE_IPV4_FIB, NSIM_RESOURCE_IPV4_FIB_RULES,
 		NSIM_RESOURCE_IPV6_FIB, NSIM_RESOURCE_IPV6_FIB_RULES
 	};
+	struct net *net = nsim_devlink_net(devlink);
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(res_ids); ++i) {
@@ -210,8 +207,7 @@ static int nsim_dev_reload(struct devlink *devlink,
 
 		err = devlink_resource_size_get(devlink, res_ids[i], &val);
 		if (!err) {
-			err = nsim_fib_set_max(nsim_dev->fib_data,
-					       res_ids[i], val, extack);
+			err = nsim_fib_set_max(net, res_ids[i], val, extack);
 			if (err)
 				return err;
 		}
@@ -241,15 +237,9 @@ nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev, unsigned int port_count)
 	INIT_LIST_HEAD(&nsim_dev->port_list);
 	mutex_init(&nsim_dev->port_list_lock);
 
-	nsim_dev->fib_data = nsim_fib_create();
-	if (IS_ERR(nsim_dev->fib_data)) {
-		err = PTR_ERR(nsim_dev->fib_data);
-		goto err_devlink_free;
-	}
-
 	err = nsim_dev_resources_register(devlink);
 	if (err)
-		goto err_fib_destroy;
+		goto err_devlink_free;
 
 	err = devlink_register(devlink, &nsim_bus_dev->dev);
 	if (err)
@@ -271,8 +261,6 @@ nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev, unsigned int port_count)
 	devlink_unregister(devlink);
 err_resources_unregister:
 	devlink_resources_unregister(devlink, NULL);
-err_fib_destroy:
-	nsim_fib_destroy(nsim_dev->fib_data);
 err_devlink_free:
 	devlink_free(devlink);
 	return ERR_PTR(err);
@@ -286,7 +274,6 @@ static void nsim_dev_destroy(struct nsim_dev *nsim_dev)
 	nsim_dev_debugfs_exit(nsim_dev);
 	devlink_unregister(devlink);
 	devlink_resources_unregister(devlink, NULL);
-	nsim_fib_destroy(nsim_dev->fib_data);
 	mutex_destroy(&nsim_dev->port_list_lock);
 	devlink_free(devlink);
 }
diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 8c57ba7477726..f61d094746c06 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -18,6 +18,7 @@
 #include <net/ip_fib.h>
 #include <net/ip6_fib.h>
 #include <net/fib_rules.h>
+#include <net/netns/generic.h>
 
 #include "netdevsim.h"
 
@@ -32,14 +33,15 @@ struct nsim_per_fib_data {
 };
 
 struct nsim_fib_data {
-	struct notifier_block fib_nb;
 	struct nsim_per_fib_data ipv4;
 	struct nsim_per_fib_data ipv6;
 };
 
-u64 nsim_fib_get_val(struct nsim_fib_data *fib_data,
-		     enum nsim_resource_id res_id, bool max)
+static unsigned int nsim_fib_net_id;
+
+u64 nsim_fib_get_val(struct net *net, enum nsim_resource_id res_id, bool max)
 {
+	struct nsim_fib_data *fib_data = net_generic(net, nsim_fib_net_id);
 	struct nsim_fib_entry *entry;
 
 	switch (res_id) {
@@ -62,10 +64,10 @@ u64 nsim_fib_get_val(struct nsim_fib_data *fib_data,
 	return max ? entry->max : entry->num;
 }
 
-int nsim_fib_set_max(struct nsim_fib_data *fib_data,
-		     enum nsim_resource_id res_id, u64 val,
+int nsim_fib_set_max(struct net *net, enum nsim_resource_id res_id, u64 val,
 		     struct netlink_ext_ack *extack)
 {
+	struct nsim_fib_data *fib_data = net_generic(net, nsim_fib_net_id);
 	struct nsim_fib_entry *entry;
 	int err = 0;
 
@@ -118,9 +120,9 @@ static int nsim_fib_rule_account(struct nsim_fib_entry *entry, bool add,
 	return err;
 }
 
-static int nsim_fib_rule_event(struct nsim_fib_data *data,
-			       struct fib_notifier_info *info, bool add)
+static int nsim_fib_rule_event(struct fib_notifier_info *info, bool add)
 {
+	struct nsim_fib_data *data = net_generic(info->net, nsim_fib_net_id);
 	struct netlink_ext_ack *extack = info->extack;
 	int err = 0;
 
@@ -155,9 +157,9 @@ static int nsim_fib_account(struct nsim_fib_entry *entry, bool add,
 	return err;
 }
 
-static int nsim_fib_event(struct nsim_fib_data *data,
-			  struct fib_notifier_info *info, bool add)
+static int nsim_fib_event(struct fib_notifier_info *info, bool add)
 {
+	struct nsim_fib_data *data = net_generic(info->net, nsim_fib_net_id);
 	struct netlink_ext_ack *extack = info->extack;
 	int err = 0;
 
@@ -176,22 +178,18 @@ static int nsim_fib_event(struct nsim_fib_data *data,
 static int nsim_fib_event_nb(struct notifier_block *nb, unsigned long event,
 			     void *ptr)
 {
-	struct nsim_fib_data *data = container_of(nb, struct nsim_fib_data,
-						  fib_nb);
 	struct fib_notifier_info *info = ptr;
 	int err = 0;
 
 	switch (event) {
 	case FIB_EVENT_RULE_ADD: /* fall through */
 	case FIB_EVENT_RULE_DEL:
-		err = nsim_fib_rule_event(data, info,
-					  event == FIB_EVENT_RULE_ADD);
+		err = nsim_fib_rule_event(info, event == FIB_EVENT_RULE_ADD);
 		break;
 
 	case FIB_EVENT_ENTRY_ADD:  /* fall through */
 	case FIB_EVENT_ENTRY_DEL:
-		err = nsim_fib_event(data, info,
-				     event == FIB_EVENT_ENTRY_ADD);
+		err = nsim_fib_event(info, event == FIB_EVENT_ENTRY_ADD);
 		break;
 	}
 
@@ -201,23 +199,30 @@ static int nsim_fib_event_nb(struct notifier_block *nb, unsigned long event,
 /* inconsistent dump, trying again */
 static void nsim_fib_dump_inconsistent(struct notifier_block *nb)
 {
-	struct nsim_fib_data *data = container_of(nb, struct nsim_fib_data,
-						  fib_nb);
+	struct nsim_fib_data *data;
+	struct net *net;
+
+	rcu_read_lock();
+	for_each_net_rcu(net) {
+		data = net_generic(net, nsim_fib_net_id);
+
+		data->ipv4.fib.num = 0ULL;
+		data->ipv4.rules.num = 0ULL;
 
-	data->ipv4.fib.num = 0ULL;
-	data->ipv4.rules.num = 0ULL;
-	data->ipv6.fib.num = 0ULL;
-	data->ipv6.rules.num = 0ULL;
+		data->ipv6.fib.num = 0ULL;
+		data->ipv6.rules.num = 0ULL;
+	}
+	rcu_read_unlock();
 }
 
-struct nsim_fib_data *nsim_fib_create(void)
-{
-	struct nsim_fib_data *data;
-	int err;
+static struct notifier_block nsim_fib_nb = {
+	.notifier_call = nsim_fib_event_nb,
+};
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return ERR_PTR(-ENOMEM);
+/* Initialize per network namespace state */
+static int __net_init nsim_fib_netns_init(struct net *net)
+{
+	struct nsim_fib_data *data = net_generic(net, nsim_fib_net_id);
 
 	data->ipv4.fib.max = (u64)-1;
 	data->ipv4.rules.max = (u64)-1;
@@ -225,22 +230,37 @@ struct nsim_fib_data *nsim_fib_create(void)
 	data->ipv6.fib.max = (u64)-1;
 	data->ipv6.rules.max = (u64)-1;
 
-	data->fib_nb.notifier_call = nsim_fib_event_nb;
-	err = register_fib_notifier(&data->fib_nb, nsim_fib_dump_inconsistent);
-	if (err) {
-		pr_err("Failed to register fib notifier\n");
-		goto err_out;
-	}
+	return 0;
+}
 
-	return data;
+static struct pernet_operations nsim_fib_net_ops = {
+	.init = nsim_fib_netns_init,
+	.id   = &nsim_fib_net_id,
+	.size = sizeof(struct nsim_fib_data),
+};
 
-err_out:
-	kfree(data);
-	return ERR_PTR(err);
+void nsim_fib_exit(void)
+{
+	unregister_pernet_subsys(&nsim_fib_net_ops);
+	unregister_fib_notifier(&nsim_fib_nb);
 }
 
-void nsim_fib_destroy(struct nsim_fib_data *data)
+int nsim_fib_init(void)
 {
-	unregister_fib_notifier(&data->fib_nb);
-	kfree(data);
+	int err;
+
+	err = register_pernet_subsys(&nsim_fib_net_ops);
+	if (err < 0) {
+		pr_err("Failed to register pernet subsystem\n");
+		goto err_out;
+	}
+
+	err = register_fib_notifier(&nsim_fib_nb, nsim_fib_dump_inconsistent);
+	if (err < 0) {
+		pr_err("Failed to register fib notifier\n");
+		goto err_out;
+	}
+
+err_out:
+	return err;
 }
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index e5c8aa08e1cd4..533a182eefcaf 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -370,12 +370,18 @@ static int __init nsim_module_init(void)
 	if (err)
 		goto err_dev_exit;
 
-	err = rtnl_link_register(&nsim_link_ops);
+	err = nsim_fib_init();
 	if (err)
 		goto err_bus_exit;
 
+	err = rtnl_link_register(&nsim_link_ops);
+	if (err)
+		goto err_fib_exit;
+
 	return 0;
 
+err_fib_exit:
+	nsim_fib_exit();
 err_bus_exit:
 	nsim_bus_exit();
 err_dev_exit:
@@ -386,6 +392,7 @@ static int __init nsim_module_init(void)
 static void __exit nsim_module_exit(void)
 {
 	rtnl_link_unregister(&nsim_link_ops);
+	nsim_fib_exit();
 	nsim_bus_exit();
 	nsim_dev_exit();
 }
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 3f398797c2bc7..f9253fe68c31f 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -168,12 +168,10 @@ int nsim_dev_port_add(struct nsim_bus_dev *nsim_bus_dev,
 int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev,
 		      unsigned int port_index);
 
-struct nsim_fib_data *nsim_fib_create(void);
-void nsim_fib_destroy(struct nsim_fib_data *fib_data);
-u64 nsim_fib_get_val(struct nsim_fib_data *fib_data,
-		     enum nsim_resource_id res_id, bool max);
-int nsim_fib_set_max(struct nsim_fib_data *fib_data,
-		     enum nsim_resource_id res_id, u64 val,
+int nsim_fib_init(void);
+void nsim_fib_exit(void);
+u64 nsim_fib_get_val(struct net *net, enum nsim_resource_id res_id, bool max);
+int nsim_fib_set_max(struct net *net, enum nsim_resource_id res_id, u64 val,
 		     struct netlink_ext_ack *extack);
 
 #if IS_ENABLED(CONFIG_XFRM_OFFLOAD)
-- 
2.20.1

