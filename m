Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69E6360D31
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234066AbhDOO6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:58:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234078AbhDOO4e (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:56:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F15DF613D0;
        Thu, 15 Apr 2021 14:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498446;
        bh=h4lmgAHA0CuvDoNy6MO9l6Q09Z73rANk/o6HNNkTQlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IOnB/IyeuFemrZg+RZLht8RlCv8jzX06KtOEEqLbM6+m59aT0vhCS6nqgT3I7oPKO
         pEW+5FZDA4eXlFgIcEInFKYom0r3JqGRg91drQuZkecrt9b0JfL+zRybd+g0hCjYa4
         hw0isIyDTiJp+z8ah7bLbIro26JtL1erNdEoz8Is=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 42/68] net/ncsi: Add generic netlink family
Date:   Thu, 15 Apr 2021 16:47:23 +0200
Message-Id: <20210415144415.847462900@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144414.464797272@linuxfoundation.org>
References: <20210415144414.464797272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Mendoza-Jonas <sam@mendozajonas.com>

commit 955dc68cb9b23b42999cafe6df3684309bc686c6 upstream.

Add a generic netlink family for NCSI. This supports three commands;
NCSI_CMD_PKG_INFO which returns information on packages and their
associated channels, NCSI_CMD_SET_INTERFACE which allows a specific
package or package/channel combination to be set as the preferred
choice, and NCSI_CMD_CLEAR_INTERFACE which clears any preferred setting.

Signed-off-by: Samuel Mendoza-Jonas <sam@mendozajonas.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/ncsi.h |  115 ++++++++++++
 net/ncsi/Makefile         |    2 
 net/ncsi/internal.h       |    3 
 net/ncsi/ncsi-manage.c    |   30 ++-
 net/ncsi/ncsi-netlink.c   |  421 ++++++++++++++++++++++++++++++++++++++++++++++
 net/ncsi/ncsi-netlink.h   |   20 ++
 6 files changed, 586 insertions(+), 5 deletions(-)
 create mode 100644 include/uapi/linux/ncsi.h
 create mode 100644 net/ncsi/ncsi-netlink.c
 create mode 100644 net/ncsi/ncsi-netlink.h

--- /dev/null
+++ b/include/uapi/linux/ncsi.h
@@ -0,0 +1,115 @@
+/*
+ * Copyright Samuel Mendoza-Jonas, IBM Corporation 2018.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __UAPI_NCSI_NETLINK_H__
+#define __UAPI_NCSI_NETLINK_H__
+
+/**
+ * enum ncsi_nl_commands - supported NCSI commands
+ *
+ * @NCSI_CMD_UNSPEC: unspecified command to catch errors
+ * @NCSI_CMD_PKG_INFO: list package and channel attributes. Requires
+ *	NCSI_ATTR_IFINDEX. If NCSI_ATTR_PACKAGE_ID is specified returns the
+ *	specific package and its channels - otherwise a dump request returns
+ *	all packages and their associated channels.
+ * @NCSI_CMD_SET_INTERFACE: set preferred package and channel combination.
+ *	Requires NCSI_ATTR_IFINDEX and the preferred NCSI_ATTR_PACKAGE_ID and
+ *	optionally the preferred NCSI_ATTR_CHANNEL_ID.
+ * @NCSI_CMD_CLEAR_INTERFACE: clear any preferred package/channel combination.
+ *	Requires NCSI_ATTR_IFINDEX.
+ * @NCSI_CMD_MAX: highest command number
+ */
+enum ncsi_nl_commands {
+	NCSI_CMD_UNSPEC,
+	NCSI_CMD_PKG_INFO,
+	NCSI_CMD_SET_INTERFACE,
+	NCSI_CMD_CLEAR_INTERFACE,
+
+	__NCSI_CMD_AFTER_LAST,
+	NCSI_CMD_MAX = __NCSI_CMD_AFTER_LAST - 1
+};
+
+/**
+ * enum ncsi_nl_attrs - General NCSI netlink attributes
+ *
+ * @NCSI_ATTR_UNSPEC: unspecified attributes to catch errors
+ * @NCSI_ATTR_IFINDEX: ifindex of network device using NCSI
+ * @NCSI_ATTR_PACKAGE_LIST: nested array of NCSI_PKG_ATTR attributes
+ * @NCSI_ATTR_PACKAGE_ID: package ID
+ * @NCSI_ATTR_CHANNEL_ID: channel ID
+ * @NCSI_ATTR_MAX: highest attribute number
+ */
+enum ncsi_nl_attrs {
+	NCSI_ATTR_UNSPEC,
+	NCSI_ATTR_IFINDEX,
+	NCSI_ATTR_PACKAGE_LIST,
+	NCSI_ATTR_PACKAGE_ID,
+	NCSI_ATTR_CHANNEL_ID,
+
+	__NCSI_ATTR_AFTER_LAST,
+	NCSI_ATTR_MAX = __NCSI_ATTR_AFTER_LAST - 1
+};
+
+/**
+ * enum ncsi_nl_pkg_attrs - NCSI netlink package-specific attributes
+ *
+ * @NCSI_PKG_ATTR_UNSPEC: unspecified attributes to catch errors
+ * @NCSI_PKG_ATTR: nested array of package attributes
+ * @NCSI_PKG_ATTR_ID: package ID
+ * @NCSI_PKG_ATTR_FORCED: flag signifying a package has been set as preferred
+ * @NCSI_PKG_ATTR_CHANNEL_LIST: nested array of NCSI_CHANNEL_ATTR attributes
+ * @NCSI_PKG_ATTR_MAX: highest attribute number
+ */
+enum ncsi_nl_pkg_attrs {
+	NCSI_PKG_ATTR_UNSPEC,
+	NCSI_PKG_ATTR,
+	NCSI_PKG_ATTR_ID,
+	NCSI_PKG_ATTR_FORCED,
+	NCSI_PKG_ATTR_CHANNEL_LIST,
+
+	__NCSI_PKG_ATTR_AFTER_LAST,
+	NCSI_PKG_ATTR_MAX = __NCSI_PKG_ATTR_AFTER_LAST - 1
+};
+
+/**
+ * enum ncsi_nl_channel_attrs - NCSI netlink channel-specific attributes
+ *
+ * @NCSI_CHANNEL_ATTR_UNSPEC: unspecified attributes to catch errors
+ * @NCSI_CHANNEL_ATTR: nested array of channel attributes
+ * @NCSI_CHANNEL_ATTR_ID: channel ID
+ * @NCSI_CHANNEL_ATTR_VERSION_MAJOR: channel major version number
+ * @NCSI_CHANNEL_ATTR_VERSION_MINOR: channel minor version number
+ * @NCSI_CHANNEL_ATTR_VERSION_STR: channel version string
+ * @NCSI_CHANNEL_ATTR_LINK_STATE: channel link state flags
+ * @NCSI_CHANNEL_ATTR_ACTIVE: channels with this flag are in
+ *	NCSI_CHANNEL_ACTIVE state
+ * @NCSI_CHANNEL_ATTR_FORCED: flag signifying a channel has been set as
+ *	preferred
+ * @NCSI_CHANNEL_ATTR_VLAN_LIST: nested array of NCSI_CHANNEL_ATTR_VLAN_IDs
+ * @NCSI_CHANNEL_ATTR_VLAN_ID: VLAN ID being filtered on this channel
+ * @NCSI_CHANNEL_ATTR_MAX: highest attribute number
+ */
+enum ncsi_nl_channel_attrs {
+	NCSI_CHANNEL_ATTR_UNSPEC,
+	NCSI_CHANNEL_ATTR,
+	NCSI_CHANNEL_ATTR_ID,
+	NCSI_CHANNEL_ATTR_VERSION_MAJOR,
+	NCSI_CHANNEL_ATTR_VERSION_MINOR,
+	NCSI_CHANNEL_ATTR_VERSION_STR,
+	NCSI_CHANNEL_ATTR_LINK_STATE,
+	NCSI_CHANNEL_ATTR_ACTIVE,
+	NCSI_CHANNEL_ATTR_FORCED,
+	NCSI_CHANNEL_ATTR_VLAN_LIST,
+	NCSI_CHANNEL_ATTR_VLAN_ID,
+
+	__NCSI_CHANNEL_ATTR_AFTER_LAST,
+	NCSI_CHANNEL_ATTR_MAX = __NCSI_CHANNEL_ATTR_AFTER_LAST - 1
+};
+
+#endif /* __UAPI_NCSI_NETLINK_H__ */
--- a/net/ncsi/Makefile
+++ b/net/ncsi/Makefile
@@ -1,4 +1,4 @@
 #
 # Makefile for NCSI API
 #
-obj-$(CONFIG_NET_NCSI) += ncsi-cmd.o ncsi-rsp.o ncsi-aen.o ncsi-manage.o
+obj-$(CONFIG_NET_NCSI) += ncsi-cmd.o ncsi-rsp.o ncsi-aen.o ncsi-manage.o ncsi-netlink.o
--- a/net/ncsi/internal.h
+++ b/net/ncsi/internal.h
@@ -276,6 +276,8 @@ struct ncsi_dev_priv {
 	unsigned int        package_num;     /* Number of packages         */
 	struct list_head    packages;        /* List of packages           */
 	struct ncsi_channel *hot_channel;    /* Channel was ever active    */
+	struct ncsi_package *force_package;  /* Force a specific package   */
+	struct ncsi_channel *force_channel;  /* Force a specific channel   */
 	struct ncsi_request requests[256];   /* Request table              */
 	unsigned int        request_id;      /* Last used request ID       */
 #define NCSI_REQ_START_IDX	1
@@ -318,6 +320,7 @@ extern spinlock_t ncsi_dev_lock;
 	list_for_each_entry_rcu(nc, &np->channels, node)
 
 /* Resources */
+u32 *ncsi_get_filter(struct ncsi_channel *nc, int table, int index);
 int ncsi_find_filter(struct ncsi_channel *nc, int table, void *data);
 int ncsi_add_filter(struct ncsi_channel *nc, int table, void *data);
 int ncsi_remove_filter(struct ncsi_channel *nc, int table, int index);
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -12,7 +12,6 @@
 #include <linux/init.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
-#include <linux/netlink.h>
 
 #include <net/ncsi.h>
 #include <net/net_namespace.h>
@@ -23,6 +22,7 @@
 
 #include "internal.h"
 #include "ncsi-pkt.h"
+#include "ncsi-netlink.h"
 
 LIST_HEAD(ncsi_dev_list);
 DEFINE_SPINLOCK(ncsi_dev_lock);
@@ -38,7 +38,7 @@ static inline int ncsi_filter_size(int t
 	return sizes[table];
 }
 
-static u32 *ncsi_get_filter(struct ncsi_channel *nc, int table, int index)
+u32 *ncsi_get_filter(struct ncsi_channel *nc, int table, int index)
 {
 	struct ncsi_channel_filter *ncf;
 	int size;
@@ -972,20 +972,37 @@ error:
 
 static int ncsi_choose_active_channel(struct ncsi_dev_priv *ndp)
 {
-	struct ncsi_package *np;
-	struct ncsi_channel *nc, *found, *hot_nc;
+	struct ncsi_package *np, *force_package;
+	struct ncsi_channel *nc, *found, *hot_nc, *force_channel;
 	struct ncsi_channel_mode *ncm;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ndp->lock, flags);
 	hot_nc = ndp->hot_channel;
+	force_channel = ndp->force_channel;
+	force_package = ndp->force_package;
 	spin_unlock_irqrestore(&ndp->lock, flags);
 
+	/* Force a specific channel whether or not it has link if we have been
+	 * configured to do so
+	 */
+	if (force_package && force_channel) {
+		found = force_channel;
+		ncm = &found->modes[NCSI_MODE_LINK];
+		if (!(ncm->data[2] & 0x1))
+			netdev_info(ndp->ndev.dev,
+				    "NCSI: Channel %u forced, but it is link down\n",
+				    found->id);
+		goto out;
+	}
+
 	/* The search is done once an inactive channel with up
 	 * link is found.
 	 */
 	found = NULL;
 	NCSI_FOR_EACH_PACKAGE(ndp, np) {
+		if (ndp->force_package && np != ndp->force_package)
+			continue;
 		NCSI_FOR_EACH_CHANNEL(np, nc) {
 			spin_lock_irqsave(&nc->lock, flags);
 
@@ -1603,6 +1620,9 @@ struct ncsi_dev *ncsi_register_dev(struc
 	ndp->ptype.dev = dev;
 	dev_add_pack(&ndp->ptype);
 
+	/* Set up generic netlink interface */
+	ncsi_init_netlink(dev);
+
 	return nd;
 }
 EXPORT_SYMBOL_GPL(ncsi_register_dev);
@@ -1682,6 +1702,8 @@ void ncsi_unregister_dev(struct ncsi_dev
 #endif
 	spin_unlock_irqrestore(&ncsi_dev_lock, flags);
 
+	ncsi_unregister_netlink(nd->dev);
+
 	kfree(ndp);
 }
 EXPORT_SYMBOL_GPL(ncsi_unregister_dev);
--- /dev/null
+++ b/net/ncsi/ncsi-netlink.c
@@ -0,0 +1,421 @@
+/*
+ * Copyright Samuel Mendoza-Jonas, IBM Corporation 2018.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/if_arp.h>
+#include <linux/rtnetlink.h>
+#include <linux/etherdevice.h>
+#include <linux/module.h>
+#include <net/genetlink.h>
+#include <net/ncsi.h>
+#include <linux/skbuff.h>
+#include <net/sock.h>
+#include <uapi/linux/ncsi.h>
+
+#include "internal.h"
+#include "ncsi-netlink.h"
+
+static struct genl_family ncsi_genl_family;
+
+static const struct nla_policy ncsi_genl_policy[NCSI_ATTR_MAX + 1] = {
+	[NCSI_ATTR_IFINDEX] =		{ .type = NLA_U32 },
+	[NCSI_ATTR_PACKAGE_LIST] =	{ .type = NLA_NESTED },
+	[NCSI_ATTR_PACKAGE_ID] =	{ .type = NLA_U32 },
+	[NCSI_ATTR_CHANNEL_ID] =	{ .type = NLA_U32 },
+};
+
+static struct ncsi_dev_priv *ndp_from_ifindex(struct net *net, u32 ifindex)
+{
+	struct ncsi_dev_priv *ndp;
+	struct net_device *dev;
+	struct ncsi_dev *nd;
+	struct ncsi_dev;
+
+	if (!net)
+		return NULL;
+
+	dev = dev_get_by_index(net, ifindex);
+	if (!dev) {
+		pr_err("NCSI netlink: No device for ifindex %u\n", ifindex);
+		return NULL;
+	}
+
+	nd = ncsi_find_dev(dev);
+	ndp = nd ? TO_NCSI_DEV_PRIV(nd) : NULL;
+
+	dev_put(dev);
+	return ndp;
+}
+
+static int ncsi_write_channel_info(struct sk_buff *skb,
+				   struct ncsi_dev_priv *ndp,
+				   struct ncsi_channel *nc)
+{
+	struct nlattr *vid_nest;
+	struct ncsi_channel_filter *ncf;
+	struct ncsi_channel_mode *m;
+	u32 *data;
+	int i;
+
+	nla_put_u32(skb, NCSI_CHANNEL_ATTR_ID, nc->id);
+	m = &nc->modes[NCSI_MODE_LINK];
+	nla_put_u32(skb, NCSI_CHANNEL_ATTR_LINK_STATE, m->data[2]);
+	if (nc->state == NCSI_CHANNEL_ACTIVE)
+		nla_put_flag(skb, NCSI_CHANNEL_ATTR_ACTIVE);
+	if (ndp->force_channel == nc)
+		nla_put_flag(skb, NCSI_CHANNEL_ATTR_FORCED);
+
+	nla_put_u32(skb, NCSI_CHANNEL_ATTR_VERSION_MAJOR, nc->version.version);
+	nla_put_u32(skb, NCSI_CHANNEL_ATTR_VERSION_MINOR, nc->version.alpha2);
+	nla_put_string(skb, NCSI_CHANNEL_ATTR_VERSION_STR, nc->version.fw_name);
+
+	vid_nest = nla_nest_start(skb, NCSI_CHANNEL_ATTR_VLAN_LIST);
+	if (!vid_nest)
+		return -ENOMEM;
+	ncf = nc->filters[NCSI_FILTER_VLAN];
+	i = -1;
+	if (ncf) {
+		while ((i = find_next_bit((void *)&ncf->bitmap, ncf->total,
+					  i + 1)) < ncf->total) {
+			data = ncsi_get_filter(nc, NCSI_FILTER_VLAN, i);
+			/* Uninitialised channels will have 'zero' vlan ids */
+			if (!data || !*data)
+				continue;
+			nla_put_u16(skb, NCSI_CHANNEL_ATTR_VLAN_ID,
+				    *(u16 *)data);
+		}
+	}
+	nla_nest_end(skb, vid_nest);
+
+	return 0;
+}
+
+static int ncsi_write_package_info(struct sk_buff *skb,
+				   struct ncsi_dev_priv *ndp, unsigned int id)
+{
+	struct nlattr *pnest, *cnest, *nest;
+	struct ncsi_package *np;
+	struct ncsi_channel *nc;
+	bool found;
+	int rc;
+
+	if (id > ndp->package_num) {
+		netdev_info(ndp->ndev.dev, "NCSI: No package with id %u\n", id);
+		return -ENODEV;
+	}
+
+	found = false;
+	NCSI_FOR_EACH_PACKAGE(ndp, np) {
+		if (np->id != id)
+			continue;
+		pnest = nla_nest_start(skb, NCSI_PKG_ATTR);
+		if (!pnest)
+			return -ENOMEM;
+		nla_put_u32(skb, NCSI_PKG_ATTR_ID, np->id);
+		if (ndp->force_package == np)
+			nla_put_flag(skb, NCSI_PKG_ATTR_FORCED);
+		cnest = nla_nest_start(skb, NCSI_PKG_ATTR_CHANNEL_LIST);
+		if (!cnest) {
+			nla_nest_cancel(skb, pnest);
+			return -ENOMEM;
+		}
+		NCSI_FOR_EACH_CHANNEL(np, nc) {
+			nest = nla_nest_start(skb, NCSI_CHANNEL_ATTR);
+			if (!nest) {
+				nla_nest_cancel(skb, cnest);
+				nla_nest_cancel(skb, pnest);
+				return -ENOMEM;
+			}
+			rc = ncsi_write_channel_info(skb, ndp, nc);
+			if (rc) {
+				nla_nest_cancel(skb, nest);
+				nla_nest_cancel(skb, cnest);
+				nla_nest_cancel(skb, pnest);
+				return rc;
+			}
+			nla_nest_end(skb, nest);
+		}
+		nla_nest_end(skb, cnest);
+		nla_nest_end(skb, pnest);
+		found = true;
+	}
+
+	if (!found)
+		return -ENODEV;
+
+	return 0;
+}
+
+static int ncsi_pkg_info_nl(struct sk_buff *msg, struct genl_info *info)
+{
+	struct ncsi_dev_priv *ndp;
+	unsigned int package_id;
+	struct sk_buff *skb;
+	struct nlattr *attr;
+	void *hdr;
+	int rc;
+
+	if (!info || !info->attrs)
+		return -EINVAL;
+
+	if (!info->attrs[NCSI_ATTR_IFINDEX])
+		return -EINVAL;
+
+	if (!info->attrs[NCSI_ATTR_PACKAGE_ID])
+		return -EINVAL;
+
+	ndp = ndp_from_ifindex(genl_info_net(info),
+			       nla_get_u32(info->attrs[NCSI_ATTR_IFINDEX]));
+	if (!ndp)
+		return -ENODEV;
+
+	skb = genlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	hdr = genlmsg_put(skb, info->snd_portid, info->snd_seq,
+			  &ncsi_genl_family, 0, NCSI_CMD_PKG_INFO);
+	if (!hdr) {
+		kfree(skb);
+		return -EMSGSIZE;
+	}
+
+	package_id = nla_get_u32(info->attrs[NCSI_ATTR_PACKAGE_ID]);
+
+	attr = nla_nest_start(skb, NCSI_ATTR_PACKAGE_LIST);
+	rc = ncsi_write_package_info(skb, ndp, package_id);
+
+	if (rc) {
+		nla_nest_cancel(skb, attr);
+		goto err;
+	}
+
+	nla_nest_end(skb, attr);
+
+	genlmsg_end(skb, hdr);
+	return genlmsg_reply(skb, info);
+
+err:
+	genlmsg_cancel(skb, hdr);
+	kfree(skb);
+	return rc;
+}
+
+static int ncsi_pkg_info_all_nl(struct sk_buff *skb,
+				struct netlink_callback *cb)
+{
+	struct nlattr *attrs[NCSI_ATTR_MAX];
+	struct ncsi_package *np, *package;
+	struct ncsi_dev_priv *ndp;
+	unsigned int package_id;
+	struct nlattr *attr;
+	void *hdr;
+	int rc;
+
+	rc = genlmsg_parse(cb->nlh, &ncsi_genl_family, attrs, NCSI_ATTR_MAX,
+			   ncsi_genl_policy, NULL);
+	if (rc)
+		return rc;
+
+	if (!attrs[NCSI_ATTR_IFINDEX])
+		return -EINVAL;
+
+	ndp = ndp_from_ifindex(get_net(sock_net(skb->sk)),
+			       nla_get_u32(attrs[NCSI_ATTR_IFINDEX]));
+
+	if (!ndp)
+		return -ENODEV;
+
+	package_id = cb->args[0];
+	package = NULL;
+	NCSI_FOR_EACH_PACKAGE(ndp, np)
+		if (np->id == package_id)
+			package = np;
+
+	if (!package)
+		return 0; /* done */
+
+	hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			  &ncsi_genl_family, 0,  NCSI_CMD_PKG_INFO);
+	if (!hdr) {
+		rc = -EMSGSIZE;
+		goto err;
+	}
+
+	attr = nla_nest_start(skb, NCSI_ATTR_PACKAGE_LIST);
+	rc = ncsi_write_package_info(skb, ndp, package->id);
+	if (rc) {
+		nla_nest_cancel(skb, attr);
+		goto err;
+	}
+
+	nla_nest_end(skb, attr);
+	genlmsg_end(skb, hdr);
+
+	cb->args[0] = package_id + 1;
+
+	return skb->len;
+err:
+	genlmsg_cancel(skb, hdr);
+	return rc;
+}
+
+static int ncsi_set_interface_nl(struct sk_buff *msg, struct genl_info *info)
+{
+	struct ncsi_package *np, *package;
+	struct ncsi_channel *nc, *channel;
+	u32 package_id, channel_id;
+	struct ncsi_dev_priv *ndp;
+	unsigned long flags;
+
+	if (!info || !info->attrs)
+		return -EINVAL;
+
+	if (!info->attrs[NCSI_ATTR_IFINDEX])
+		return -EINVAL;
+
+	if (!info->attrs[NCSI_ATTR_PACKAGE_ID])
+		return -EINVAL;
+
+	ndp = ndp_from_ifindex(get_net(sock_net(msg->sk)),
+			       nla_get_u32(info->attrs[NCSI_ATTR_IFINDEX]));
+	if (!ndp)
+		return -ENODEV;
+
+	package_id = nla_get_u32(info->attrs[NCSI_ATTR_PACKAGE_ID]);
+	package = NULL;
+
+	spin_lock_irqsave(&ndp->lock, flags);
+
+	NCSI_FOR_EACH_PACKAGE(ndp, np)
+		if (np->id == package_id)
+			package = np;
+	if (!package) {
+		/* The user has set a package that does not exist */
+		return -ERANGE;
+	}
+
+	channel = NULL;
+	if (!info->attrs[NCSI_ATTR_CHANNEL_ID]) {
+		/* Allow any channel */
+		channel_id = NCSI_RESERVED_CHANNEL;
+	} else {
+		channel_id = nla_get_u32(info->attrs[NCSI_ATTR_CHANNEL_ID]);
+		NCSI_FOR_EACH_CHANNEL(package, nc)
+			if (nc->id == channel_id)
+				channel = nc;
+	}
+
+	if (channel_id != NCSI_RESERVED_CHANNEL && !channel) {
+		/* The user has set a channel that does not exist on this
+		 * package
+		 */
+		netdev_info(ndp->ndev.dev, "NCSI: Channel %u does not exist!\n",
+			    channel_id);
+		return -ERANGE;
+	}
+
+	ndp->force_package = package;
+	ndp->force_channel = channel;
+	spin_unlock_irqrestore(&ndp->lock, flags);
+
+	netdev_info(ndp->ndev.dev, "Set package 0x%x, channel 0x%x%s as preferred\n",
+		    package_id, channel_id,
+		    channel_id == NCSI_RESERVED_CHANNEL ? " (any)" : "");
+
+	/* Bounce the NCSI channel to set changes */
+	ncsi_stop_dev(&ndp->ndev);
+	ncsi_start_dev(&ndp->ndev);
+
+	return 0;
+}
+
+static int ncsi_clear_interface_nl(struct sk_buff *msg, struct genl_info *info)
+{
+	struct ncsi_dev_priv *ndp;
+	unsigned long flags;
+
+	if (!info || !info->attrs)
+		return -EINVAL;
+
+	if (!info->attrs[NCSI_ATTR_IFINDEX])
+		return -EINVAL;
+
+	ndp = ndp_from_ifindex(get_net(sock_net(msg->sk)),
+			       nla_get_u32(info->attrs[NCSI_ATTR_IFINDEX]));
+	if (!ndp)
+		return -ENODEV;
+
+	/* Clear any override */
+	spin_lock_irqsave(&ndp->lock, flags);
+	ndp->force_package = NULL;
+	ndp->force_channel = NULL;
+	spin_unlock_irqrestore(&ndp->lock, flags);
+	netdev_info(ndp->ndev.dev, "NCSI: Cleared preferred package/channel\n");
+
+	/* Bounce the NCSI channel to set changes */
+	ncsi_stop_dev(&ndp->ndev);
+	ncsi_start_dev(&ndp->ndev);
+
+	return 0;
+}
+
+static const struct genl_ops ncsi_ops[] = {
+	{
+		.cmd = NCSI_CMD_PKG_INFO,
+		.policy = ncsi_genl_policy,
+		.doit = ncsi_pkg_info_nl,
+		.dumpit = ncsi_pkg_info_all_nl,
+		.flags = 0,
+	},
+	{
+		.cmd = NCSI_CMD_SET_INTERFACE,
+		.policy = ncsi_genl_policy,
+		.doit = ncsi_set_interface_nl,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NCSI_CMD_CLEAR_INTERFACE,
+		.policy = ncsi_genl_policy,
+		.doit = ncsi_clear_interface_nl,
+		.flags = GENL_ADMIN_PERM,
+	},
+};
+
+static struct genl_family ncsi_genl_family __ro_after_init = {
+	.name = "NCSI",
+	.version = 0,
+	.maxattr = NCSI_ATTR_MAX,
+	.module = THIS_MODULE,
+	.ops = ncsi_ops,
+	.n_ops = ARRAY_SIZE(ncsi_ops),
+};
+
+int ncsi_init_netlink(struct net_device *dev)
+{
+	int rc;
+
+	rc = genl_register_family(&ncsi_genl_family);
+	if (rc)
+		netdev_err(dev, "ncsi: failed to register netlink family\n");
+
+	return rc;
+}
+
+int ncsi_unregister_netlink(struct net_device *dev)
+{
+	int rc;
+
+	rc = genl_unregister_family(&ncsi_genl_family);
+	if (rc)
+		netdev_err(dev, "ncsi: failed to unregister netlink family\n");
+
+	return rc;
+}
--- /dev/null
+++ b/net/ncsi/ncsi-netlink.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright Samuel Mendoza-Jonas, IBM Corporation 2018.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __NCSI_NETLINK_H__
+#define __NCSI_NETLINK_H__
+
+#include <linux/netdevice.h>
+
+#include "internal.h"
+
+int ncsi_init_netlink(struct net_device *dev);
+int ncsi_unregister_netlink(struct net_device *dev);
+
+#endif /* __NCSI_NETLINK_H__ */


