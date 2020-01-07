Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6713F13322C
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbgAGVIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:08:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:59762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729615AbgAGVIA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:08:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DA2B2087F;
        Tue,  7 Jan 2020 21:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431279;
        bh=S8oyQmk2bK3fShqP7uWuNeqnWu8CI95aGAD1RHdmMjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lnPcIvz+kpDpHv7Svq/sFZAi+AVzXjaxatXWHd1BZz86ZRGK0VVxBZQQ3LIyq7uER
         yXFQiijEbcklNEI8xoa0bjZ/CqGen89Lklt9xmSOBQUvJylCXXE4Gqt1guxkK8O22z
         ffZ1gU+rDl6F29vu+oX93XsgxVVfQ/SmGOSlv5ts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 107/115] net: core: limit nested device depth
Date:   Tue,  7 Jan 2020 21:55:17 +0100
Message-Id: <20200107205309.009025767@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 5343da4c17429efaa5fb1594ea96aee1a283e694 ]

Current code doesn't limit the number of nested devices.
Nested devices would be handled recursively and this needs huge stack
memory. So, unlimited nested devices could make stack overflow.

This patch adds upper_level and lower_level, they are common variables
and represent maximum lower/upper depth.
When upper/lower device is attached or dettached,
{lower/upper}_level are updated. and if maximum depth is bigger than 8,
attach routine fails and returns -EMLINK.

In addition, this patch converts recursive routine of
netdev_walk_all_{lower/upper} to iterator routine.

Test commands:
    ip link add dummy0 type dummy
    ip link add link dummy0 name vlan1 type vlan id 1
    ip link set vlan1 up

    for i in {2..55}
    do
	    let A=$i-1

	    ip link add vlan$i link vlan$A type vlan id $i
    done
    ip link del dummy0

Splat looks like:
[  155.513226][  T908] BUG: KASAN: use-after-free in __unwind_start+0x71/0x850
[  155.514162][  T908] Write of size 88 at addr ffff8880608a6cc0 by task ip/908
[  155.515048][  T908]
[  155.515333][  T908] CPU: 0 PID: 908 Comm: ip Not tainted 5.4.0-rc3+ #96
[  155.516147][  T908] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  155.517233][  T908] Call Trace:
[  155.517627][  T908]
[  155.517918][  T908] Allocated by task 0:
[  155.518412][  T908] (stack is not available)
[  155.518955][  T908]
[  155.519228][  T908] Freed by task 0:
[  155.519885][  T908] (stack is not available)
[  155.520452][  T908]
[  155.520729][  T908] The buggy address belongs to the object at ffff8880608a6ac0
[  155.520729][  T908]  which belongs to the cache names_cache of size 4096
[  155.522387][  T908] The buggy address is located 512 bytes inside of
[  155.522387][  T908]  4096-byte region [ffff8880608a6ac0, ffff8880608a7ac0)
[  155.523920][  T908] The buggy address belongs to the page:
[  155.524552][  T908] page:ffffea0001822800 refcount:1 mapcount:0 mapping:ffff88806c657cc0 index:0x0 compound_mapcount:0
[  155.525836][  T908] flags: 0x100000000010200(slab|head)
[  155.526445][  T908] raw: 0100000000010200 ffffea0001813808 ffffea0001a26c08 ffff88806c657cc0
[  155.527424][  T908] raw: 0000000000000000 0000000000070007 00000001ffffffff 0000000000000000
[  155.528429][  T908] page dumped because: kasan: bad access detected
[  155.529158][  T908]
[  155.529410][  T908] Memory state around the buggy address:
[  155.530060][  T908]  ffff8880608a6b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  155.530971][  T908]  ffff8880608a6c00: fb fb fb fb fb f1 f1 f1 f1 00 f2 f2 f2 f3 f3 f3
[  155.531889][  T908] >ffff8880608a6c80: f3 fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  155.532806][  T908]                                            ^
[  155.533509][  T908]  ffff8880608a6d00: fb fb fb fb fb fb fb fb fb f1 f1 f1 f1 00 00 00
[  155.534436][  T908]  ffff8880608a6d80: f2 f3 f3 f3 f3 fb fb fb 00 00 00 00 00 00 00 00
[ ... ]

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h |   4 +
 net/core/dev.c            | 272 +++++++++++++++++++++++++++++++-------
 2 files changed, 231 insertions(+), 45 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9dfa0ae173ac..d5527e3828d1 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1619,6 +1619,8 @@ enum netdev_priv_flags {
  * 	@perm_addr:		Permanent hw address
  * 	@addr_assign_type:	Hw address assignment type
  * 	@addr_len:		Hardware address length
+ *	@upper_level:		Maximum depth level of upper devices.
+ *	@lower_level:		Maximum depth level of lower devices.
  *	@neigh_priv_len:	Used in neigh_alloc()
  * 	@dev_id:		Used to differentiate devices that share
  * 				the same link layer address
@@ -1853,6 +1855,8 @@ struct net_device {
 	unsigned char		perm_addr[MAX_ADDR_LEN];
 	unsigned char		addr_assign_type;
 	unsigned char		addr_len;
+	unsigned char		upper_level;
+	unsigned char		lower_level;
 	unsigned short		neigh_priv_len;
 	unsigned short          dev_id;
 	unsigned short          dev_port;
diff --git a/net/core/dev.c b/net/core/dev.c
index 8ff21d461f08..a26d87073f71 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -149,6 +149,7 @@
 #include "net-sysfs.h"
 
 #define MAX_GRO_SKBS 8
+#define MAX_NEST_DEV 8
 
 /* This should be increased if a protocol with a bigger head is added. */
 #define GRO_MAX_HEAD (MAX_HEADER + 128)
@@ -6542,6 +6543,21 @@ struct net_device *netdev_upper_get_next_dev_rcu(struct net_device *dev,
 }
 EXPORT_SYMBOL(netdev_upper_get_next_dev_rcu);
 
+static struct net_device *netdev_next_upper_dev(struct net_device *dev,
+						struct list_head **iter)
+{
+	struct netdev_adjacent *upper;
+
+	upper = list_entry((*iter)->next, struct netdev_adjacent, list);
+
+	if (&upper->list == &dev->adj_list.upper)
+		return NULL;
+
+	*iter = &upper->list;
+
+	return upper->dev;
+}
+
 static struct net_device *netdev_next_upper_dev_rcu(struct net_device *dev,
 						    struct list_head **iter)
 {
@@ -6559,28 +6575,93 @@ static struct net_device *netdev_next_upper_dev_rcu(struct net_device *dev,
 	return upper->dev;
 }
 
+static int netdev_walk_all_upper_dev(struct net_device *dev,
+				     int (*fn)(struct net_device *dev,
+					       void *data),
+				     void *data)
+{
+	struct net_device *udev, *next, *now, *dev_stack[MAX_NEST_DEV + 1];
+	struct list_head *niter, *iter, *iter_stack[MAX_NEST_DEV + 1];
+	int ret, cur = 0;
+
+	now = dev;
+	iter = &dev->adj_list.upper;
+
+	while (1) {
+		if (now != dev) {
+			ret = fn(now, data);
+			if (ret)
+				return ret;
+		}
+
+		next = NULL;
+		while (1) {
+			udev = netdev_next_upper_dev(now, &iter);
+			if (!udev)
+				break;
+
+			next = udev;
+			niter = &udev->adj_list.upper;
+			dev_stack[cur] = now;
+			iter_stack[cur++] = iter;
+			break;
+		}
+
+		if (!next) {
+			if (!cur)
+				return 0;
+			next = dev_stack[--cur];
+			niter = iter_stack[cur];
+		}
+
+		now = next;
+		iter = niter;
+	}
+
+	return 0;
+}
+
 int netdev_walk_all_upper_dev_rcu(struct net_device *dev,
 				  int (*fn)(struct net_device *dev,
 					    void *data),
 				  void *data)
 {
-	struct net_device *udev;
-	struct list_head *iter;
-	int ret;
+	struct net_device *udev, *next, *now, *dev_stack[MAX_NEST_DEV + 1];
+	struct list_head *niter, *iter, *iter_stack[MAX_NEST_DEV + 1];
+	int ret, cur = 0;
 
-	for (iter = &dev->adj_list.upper,
-	     udev = netdev_next_upper_dev_rcu(dev, &iter);
-	     udev;
-	     udev = netdev_next_upper_dev_rcu(dev, &iter)) {
-		/* first is the upper device itself */
-		ret = fn(udev, data);
-		if (ret)
-			return ret;
+	now = dev;
+	iter = &dev->adj_list.upper;
 
-		/* then look at all of its upper devices */
-		ret = netdev_walk_all_upper_dev_rcu(udev, fn, data);
-		if (ret)
-			return ret;
+	while (1) {
+		if (now != dev) {
+			ret = fn(now, data);
+			if (ret)
+				return ret;
+		}
+
+		next = NULL;
+		while (1) {
+			udev = netdev_next_upper_dev_rcu(now, &iter);
+			if (!udev)
+				break;
+
+			next = udev;
+			niter = &udev->adj_list.upper;
+			dev_stack[cur] = now;
+			iter_stack[cur++] = iter;
+			break;
+		}
+
+		if (!next) {
+			if (!cur)
+				return 0;
+			next = dev_stack[--cur];
+			niter = iter_stack[cur];
+		}
+
+		now = next;
+		iter = niter;
 	}
 
 	return 0;
@@ -6688,23 +6769,42 @@ int netdev_walk_all_lower_dev(struct net_device *dev,
 					void *data),
 			      void *data)
 {
-	struct net_device *ldev;
-	struct list_head *iter;
-	int ret;
+	struct net_device *ldev, *next, *now, *dev_stack[MAX_NEST_DEV + 1];
+	struct list_head *niter, *iter, *iter_stack[MAX_NEST_DEV + 1];
+	int ret, cur = 0;
 
-	for (iter = &dev->adj_list.lower,
-	     ldev = netdev_next_lower_dev(dev, &iter);
-	     ldev;
-	     ldev = netdev_next_lower_dev(dev, &iter)) {
-		/* first is the lower device itself */
-		ret = fn(ldev, data);
-		if (ret)
-			return ret;
+	now = dev;
+	iter = &dev->adj_list.lower;
 
-		/* then look at all of its lower devices */
-		ret = netdev_walk_all_lower_dev(ldev, fn, data);
-		if (ret)
-			return ret;
+	while (1) {
+		if (now != dev) {
+			ret = fn(now, data);
+			if (ret)
+				return ret;
+		}
+
+		next = NULL;
+		while (1) {
+			ldev = netdev_next_lower_dev(now, &iter);
+			if (!ldev)
+				break;
+
+			next = ldev;
+			niter = &ldev->adj_list.lower;
+			dev_stack[cur] = now;
+			iter_stack[cur++] = iter;
+			break;
+		}
+
+		if (!next) {
+			if (!cur)
+				return 0;
+			next = dev_stack[--cur];
+			niter = iter_stack[cur];
+		}
+
+		now = next;
+		iter = niter;
 	}
 
 	return 0;
@@ -6725,28 +6825,93 @@ static struct net_device *netdev_next_lower_dev_rcu(struct net_device *dev,
 	return lower->dev;
 }
 
-int netdev_walk_all_lower_dev_rcu(struct net_device *dev,
-				  int (*fn)(struct net_device *dev,
-					    void *data),
-				  void *data)
+static u8 __netdev_upper_depth(struct net_device *dev)
+{
+	struct net_device *udev;
+	struct list_head *iter;
+	u8 max_depth = 0;
+
+	for (iter = &dev->adj_list.upper,
+	     udev = netdev_next_upper_dev(dev, &iter);
+	     udev;
+	     udev = netdev_next_upper_dev(dev, &iter)) {
+		if (max_depth < udev->upper_level)
+			max_depth = udev->upper_level;
+	}
+
+	return max_depth;
+}
+
+static u8 __netdev_lower_depth(struct net_device *dev)
 {
 	struct net_device *ldev;
 	struct list_head *iter;
-	int ret;
+	u8 max_depth = 0;
 
 	for (iter = &dev->adj_list.lower,
-	     ldev = netdev_next_lower_dev_rcu(dev, &iter);
+	     ldev = netdev_next_lower_dev(dev, &iter);
 	     ldev;
-	     ldev = netdev_next_lower_dev_rcu(dev, &iter)) {
-		/* first is the lower device itself */
-		ret = fn(ldev, data);
-		if (ret)
-			return ret;
+	     ldev = netdev_next_lower_dev(dev, &iter)) {
+		if (max_depth < ldev->lower_level)
+			max_depth = ldev->lower_level;
+	}
 
-		/* then look at all of its lower devices */
-		ret = netdev_walk_all_lower_dev_rcu(ldev, fn, data);
-		if (ret)
-			return ret;
+	return max_depth;
+}
+
+static int __netdev_update_upper_level(struct net_device *dev, void *data)
+{
+	dev->upper_level = __netdev_upper_depth(dev) + 1;
+	return 0;
+}
+
+static int __netdev_update_lower_level(struct net_device *dev, void *data)
+{
+	dev->lower_level = __netdev_lower_depth(dev) + 1;
+	return 0;
+}
+
+int netdev_walk_all_lower_dev_rcu(struct net_device *dev,
+				  int (*fn)(struct net_device *dev,
+					    void *data),
+				  void *data)
+{
+	struct net_device *ldev, *next, *now, *dev_stack[MAX_NEST_DEV + 1];
+	struct list_head *niter, *iter, *iter_stack[MAX_NEST_DEV + 1];
+	int ret, cur = 0;
+
+	now = dev;
+	iter = &dev->adj_list.lower;
+
+	while (1) {
+		if (now != dev) {
+			ret = fn(now, data);
+			if (ret)
+				return ret;
+		}
+
+		next = NULL;
+		while (1) {
+			ldev = netdev_next_lower_dev_rcu(now, &iter);
+			if (!ldev)
+				break;
+
+			next = ldev;
+			niter = &ldev->adj_list.lower;
+			dev_stack[cur] = now;
+			iter_stack[cur++] = iter;
+			break;
+		}
+
+		if (!next) {
+			if (!cur)
+				return 0;
+			next = dev_stack[--cur];
+			niter = iter_stack[cur];
+		}
+
+		now = next;
+		iter = niter;
 	}
 
 	return 0;
@@ -7003,6 +7168,9 @@ static int __netdev_upper_dev_link(struct net_device *dev,
 	if (netdev_has_upper_dev(upper_dev, dev))
 		return -EBUSY;
 
+	if ((dev->lower_level + upper_dev->upper_level) > MAX_NEST_DEV)
+		return -EMLINK;
+
 	if (!master) {
 		if (netdev_has_upper_dev(dev, upper_dev))
 			return -EEXIST;
@@ -7029,6 +7197,12 @@ static int __netdev_upper_dev_link(struct net_device *dev,
 	if (ret)
 		goto rollback;
 
+	__netdev_update_upper_level(dev, NULL);
+	netdev_walk_all_lower_dev(dev, __netdev_update_upper_level, NULL);
+
+	__netdev_update_lower_level(upper_dev, NULL);
+	netdev_walk_all_upper_dev(upper_dev, __netdev_update_lower_level, NULL);
+
 	return 0;
 
 rollback:
@@ -7111,6 +7285,12 @@ void netdev_upper_dev_unlink(struct net_device *dev,
 
 	call_netdevice_notifiers_info(NETDEV_CHANGEUPPER,
 				      &changeupper_info.info);
+
+	__netdev_update_upper_level(dev, NULL);
+	netdev_walk_all_lower_dev(dev, __netdev_update_upper_level, NULL);
+
+	__netdev_update_lower_level(upper_dev, NULL);
+	netdev_walk_all_upper_dev(upper_dev, __netdev_update_lower_level, NULL);
 }
 EXPORT_SYMBOL(netdev_upper_dev_unlink);
 
@@ -8978,6 +9158,8 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 
 	dev->gso_max_size = GSO_MAX_SIZE;
 	dev->gso_max_segs = GSO_MAX_SEGS;
+	dev->upper_level = 1;
+	dev->lower_level = 1;
 
 	INIT_LIST_HEAD(&dev->napi_list);
 	INIT_LIST_HEAD(&dev->unreg_list);
-- 
2.20.1



