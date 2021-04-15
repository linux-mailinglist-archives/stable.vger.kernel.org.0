Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CFC360D33
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbhDOO6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:58:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233974AbhDOO4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:56:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1267613EA;
        Thu, 15 Apr 2021 14:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498449;
        bh=hM/DTsRA/yVZcsN0w8pwauI3VlAiFVj3RYBMeiFQWJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XAjRURWlcTSnBlYgegLijhY7JMcqjb4OkA8y//8w3r6db1ais79UribXlgfUtxuTR
         h3UZKPn1TXfMr1jJC+cSgWTmxI0BGGyXg3xeJbdk1QK13iz6PIvMRmhnVSZD6ZKm9U
         NmySwLKUNLusxfMs/3y4TAPvAgS/tQzP7sy7uHEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 43/68] net/ncsi: Refactor MAC, VLAN filters
Date:   Thu, 15 Apr 2021 16:47:24 +0200
Message-Id: <20210415144415.880305121@linuxfoundation.org>
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

commit 062b3e1b6d4f2a33c1d0fd7ae9b4550da5cf7e4b upstream.

The NCSI driver defines a generic ncsi_channel_filter struct that can be
used to store arbitrarily formatted filters, and several generic methods
of accessing data stored in such a filter.
However in both the driver and as defined in the NCSI specification
there are only two actual filters: VLAN ID filters and MAC address
filters. The splitting of the MAC filter into unicast, multicast, and
mixed is also technically not necessary as these are stored in the same
location in hardware.

To save complexity, particularly in the set up and accessing of these
generic filters, remove them in favour of two specific structs. These
can be acted on directly and do not need several generic helper
functions to use.

This also fixes a memory error found by KASAN on ARM32 (which is not
upstream yet), where response handlers accessing a filter's data field
could write past allocated memory.

[  114.926512] ==================================================================
[  114.933861] BUG: KASAN: slab-out-of-bounds in ncsi_configure_channel+0x4b8/0xc58
[  114.941304] Read of size 2 at addr 94888558 by task kworker/0:2/546
[  114.947593]
[  114.949146] CPU: 0 PID: 546 Comm: kworker/0:2 Not tainted 4.16.0-rc6-00119-ge156398bfcad #13
...
[  115.170233] The buggy address belongs to the object at 94888540
[  115.170233]  which belongs to the cache kmalloc-32 of size 32
[  115.181917] The buggy address is located 24 bytes inside of
[  115.181917]  32-byte region [94888540, 94888560)
[  115.192115] The buggy address belongs to the page:
[  115.196943] page:9eeac100 count:1 mapcount:0 mapping:94888000 index:0x94888fc1
[  115.204200] flags: 0x100(slab)
[  115.207330] raw: 00000100 94888000 94888fc1 0000003f 00000001 9eea2014 9eecaa74 96c003e0
[  115.215444] page dumped because: kasan: bad access detected
[  115.221036]
[  115.222544] Memory state around the buggy address:
[  115.227384]  94888400: fb fb fb fb fc fc fc fc 04 fc fc fc fc fc fc fc
[  115.233959]  94888480: 00 00 00 fc fc fc fc fc 00 04 fc fc fc fc fc fc
[  115.240529] >94888500: 00 00 04 fc fc fc fc fc 00 00 04 fc fc fc fc fc
[  115.247077]                                             ^
[  115.252523]  94888580: 00 04 fc fc fc fc fc fc 06 fc fc fc fc fc fc fc
[  115.259093]  94888600: 00 00 06 fc fc fc fc fc 00 00 04 fc fc fc fc fc
[  115.265639] ==================================================================

Reported-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Samuel Mendoza-Jonas <sam@mendozajonas.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ncsi/internal.h     |   34 +++----
 net/ncsi/ncsi-manage.c  |  226 +++++++++++-------------------------------------
 net/ncsi/ncsi-netlink.c |   20 +---
 net/ncsi/ncsi-rsp.c     |  178 +++++++++++++++----------------------
 4 files changed, 147 insertions(+), 311 deletions(-)

--- a/net/ncsi/internal.h
+++ b/net/ncsi/internal.h
@@ -68,15 +68,6 @@ enum {
 	NCSI_MODE_MAX
 };
 
-enum {
-	NCSI_FILTER_BASE	= 0,
-	NCSI_FILTER_VLAN	= 0,
-	NCSI_FILTER_UC,
-	NCSI_FILTER_MC,
-	NCSI_FILTER_MIXED,
-	NCSI_FILTER_MAX
-};
-
 struct ncsi_channel_version {
 	u32 version;		/* Supported BCD encoded NCSI version */
 	u32 alpha2;		/* Supported BCD encoded NCSI version */
@@ -98,11 +89,18 @@ struct ncsi_channel_mode {
 	u32 data[8];	/* Data entries                */
 };
 
-struct ncsi_channel_filter {
-	u32 index;	/* Index of channel filters          */
-	u32 total;	/* Total entries in the filter table */
-	u64 bitmap;	/* Bitmap of valid entries           */
-	u32 data[];	/* Data for the valid entries        */
+struct ncsi_channel_mac_filter {
+	u8	n_uc;
+	u8	n_mc;
+	u8	n_mixed;
+	u64	bitmap;
+	unsigned char	*addrs;
+};
+
+struct ncsi_channel_vlan_filter {
+	u8	n_vids;
+	u64	bitmap;
+	u16	*vids;
 };
 
 struct ncsi_channel_stats {
@@ -186,7 +184,9 @@ struct ncsi_channel {
 	struct ncsi_channel_version version;
 	struct ncsi_channel_cap	    caps[NCSI_CAP_MAX];
 	struct ncsi_channel_mode    modes[NCSI_MODE_MAX];
-	struct ncsi_channel_filter  *filters[NCSI_FILTER_MAX];
+	/* Filtering Settings */
+	struct ncsi_channel_mac_filter	mac_filter;
+	struct ncsi_channel_vlan_filter	vlan_filter;
 	struct ncsi_channel_stats   stats;
 	struct {
 		struct timer_list   timer;
@@ -320,10 +320,6 @@ extern spinlock_t ncsi_dev_lock;
 	list_for_each_entry_rcu(nc, &np->channels, node)
 
 /* Resources */
-u32 *ncsi_get_filter(struct ncsi_channel *nc, int table, int index);
-int ncsi_find_filter(struct ncsi_channel *nc, int table, void *data);
-int ncsi_add_filter(struct ncsi_channel *nc, int table, void *data);
-int ncsi_remove_filter(struct ncsi_channel *nc, int table, int index);
 void ncsi_start_channel_monitor(struct ncsi_channel *nc);
 void ncsi_stop_channel_monitor(struct ncsi_channel *nc);
 struct ncsi_channel *ncsi_find_channel(struct ncsi_package *np,
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -27,125 +27,6 @@
 LIST_HEAD(ncsi_dev_list);
 DEFINE_SPINLOCK(ncsi_dev_lock);
 
-static inline int ncsi_filter_size(int table)
-{
-	int sizes[] = { 2, 6, 6, 6 };
-
-	BUILD_BUG_ON(ARRAY_SIZE(sizes) != NCSI_FILTER_MAX);
-	if (table < NCSI_FILTER_BASE || table >= NCSI_FILTER_MAX)
-		return -EINVAL;
-
-	return sizes[table];
-}
-
-u32 *ncsi_get_filter(struct ncsi_channel *nc, int table, int index)
-{
-	struct ncsi_channel_filter *ncf;
-	int size;
-
-	ncf = nc->filters[table];
-	if (!ncf)
-		return NULL;
-
-	size = ncsi_filter_size(table);
-	if (size < 0)
-		return NULL;
-
-	return ncf->data + size * index;
-}
-
-/* Find the first active filter in a filter table that matches the given
- * data parameter. If data is NULL, this returns the first active filter.
- */
-int ncsi_find_filter(struct ncsi_channel *nc, int table, void *data)
-{
-	struct ncsi_channel_filter *ncf;
-	void *bitmap;
-	int index, size;
-	unsigned long flags;
-
-	ncf = nc->filters[table];
-	if (!ncf)
-		return -ENXIO;
-
-	size = ncsi_filter_size(table);
-	if (size < 0)
-		return size;
-
-	spin_lock_irqsave(&nc->lock, flags);
-	bitmap = (void *)&ncf->bitmap;
-	index = -1;
-	while ((index = find_next_bit(bitmap, ncf->total, index + 1))
-	       < ncf->total) {
-		if (!data || !memcmp(ncf->data + size * index, data, size)) {
-			spin_unlock_irqrestore(&nc->lock, flags);
-			return index;
-		}
-	}
-	spin_unlock_irqrestore(&nc->lock, flags);
-
-	return -ENOENT;
-}
-
-int ncsi_add_filter(struct ncsi_channel *nc, int table, void *data)
-{
-	struct ncsi_channel_filter *ncf;
-	int index, size;
-	void *bitmap;
-	unsigned long flags;
-
-	size = ncsi_filter_size(table);
-	if (size < 0)
-		return size;
-
-	index = ncsi_find_filter(nc, table, data);
-	if (index >= 0)
-		return index;
-
-	ncf = nc->filters[table];
-	if (!ncf)
-		return -ENODEV;
-
-	spin_lock_irqsave(&nc->lock, flags);
-	bitmap = (void *)&ncf->bitmap;
-	do {
-		index = find_next_zero_bit(bitmap, ncf->total, 0);
-		if (index >= ncf->total) {
-			spin_unlock_irqrestore(&nc->lock, flags);
-			return -ENOSPC;
-		}
-	} while (test_and_set_bit(index, bitmap));
-
-	memcpy(ncf->data + size * index, data, size);
-	spin_unlock_irqrestore(&nc->lock, flags);
-
-	return index;
-}
-
-int ncsi_remove_filter(struct ncsi_channel *nc, int table, int index)
-{
-	struct ncsi_channel_filter *ncf;
-	int size;
-	void *bitmap;
-	unsigned long flags;
-
-	size = ncsi_filter_size(table);
-	if (size < 0)
-		return size;
-
-	ncf = nc->filters[table];
-	if (!ncf || index >= ncf->total)
-		return -ENODEV;
-
-	spin_lock_irqsave(&nc->lock, flags);
-	bitmap = (void *)&ncf->bitmap;
-	if (test_and_clear_bit(index, bitmap))
-		memset(ncf->data + size * index, 0, size);
-	spin_unlock_irqrestore(&nc->lock, flags);
-
-	return 0;
-}
-
 static void ncsi_report_link(struct ncsi_dev_priv *ndp, bool force_down)
 {
 	struct ncsi_dev *nd = &ndp->ndev;
@@ -346,20 +227,13 @@ struct ncsi_channel *ncsi_add_channel(st
 static void ncsi_remove_channel(struct ncsi_channel *nc)
 {
 	struct ncsi_package *np = nc->package;
-	struct ncsi_channel_filter *ncf;
 	unsigned long flags;
-	int i;
 
-	/* Release filters */
 	spin_lock_irqsave(&nc->lock, flags);
-	for (i = 0; i < NCSI_FILTER_MAX; i++) {
-		ncf = nc->filters[i];
-		if (!ncf)
-			continue;
 
-		nc->filters[i] = NULL;
-		kfree(ncf);
-	}
+	/* Release filters */
+	kfree(nc->mac_filter.addrs);
+	kfree(nc->vlan_filter.vids);
 
 	nc->state = NCSI_CHANNEL_INACTIVE;
 	spin_unlock_irqrestore(&nc->lock, flags);
@@ -677,32 +551,26 @@ error:
 static int clear_one_vid(struct ncsi_dev_priv *ndp, struct ncsi_channel *nc,
 			 struct ncsi_cmd_arg *nca)
 {
+	struct ncsi_channel_vlan_filter *ncf;
+	unsigned long flags;
+	void *bitmap;
 	int index;
-	u32 *data;
 	u16 vid;
 
-	index = ncsi_find_filter(nc, NCSI_FILTER_VLAN, NULL);
-	if (index < 0) {
-		/* Filter table empty */
-		return -1;
-	}
+	ncf = &nc->vlan_filter;
+	bitmap = &ncf->bitmap;
 
-	data = ncsi_get_filter(nc, NCSI_FILTER_VLAN, index);
-	if (!data) {
-		netdev_err(ndp->ndev.dev,
-			   "NCSI: failed to retrieve filter %d\n", index);
-		/* Set the VLAN id to 0 - this will still disable the entry in
-		 * the filter table, but we won't know what it was.
-		 */
-		vid = 0;
-	} else {
-		vid = *(u16 *)data;
+	spin_lock_irqsave(&nc->lock, flags);
+	index = find_next_bit(bitmap, ncf->n_vids, 0);
+	if (index >= ncf->n_vids) {
+		spin_unlock_irqrestore(&nc->lock, flags);
+		return -1;
 	}
+	vid = ncf->vids[index];
 
-	netdev_printk(KERN_DEBUG, ndp->ndev.dev,
-		      "NCSI: removed vlan tag %u at index %d\n",
-		      vid, index + 1);
-	ncsi_remove_filter(nc, NCSI_FILTER_VLAN, index);
+	clear_bit(index, bitmap);
+	ncf->vids[index] = 0;
+	spin_unlock_irqrestore(&nc->lock, flags);
 
 	nca->type = NCSI_PKT_CMD_SVF;
 	nca->words[1] = vid;
@@ -718,45 +586,55 @@ static int clear_one_vid(struct ncsi_dev
 static int set_one_vid(struct ncsi_dev_priv *ndp, struct ncsi_channel *nc,
 		       struct ncsi_cmd_arg *nca)
 {
+	struct ncsi_channel_vlan_filter *ncf;
 	struct vlan_vid *vlan = NULL;
-	int index = 0;
+	unsigned long flags;
+	int i, index;
+	void *bitmap;
+	u16 vid;
+
+	if (list_empty(&ndp->vlan_vids))
+		return -1;
+
+	ncf = &nc->vlan_filter;
+	bitmap = &ncf->bitmap;
 
+	spin_lock_irqsave(&nc->lock, flags);
+
+	rcu_read_lock();
 	list_for_each_entry_rcu(vlan, &ndp->vlan_vids, list) {
-		index = ncsi_find_filter(nc, NCSI_FILTER_VLAN, &vlan->vid);
-		if (index < 0) {
-			/* New tag to add */
-			netdev_printk(KERN_DEBUG, ndp->ndev.dev,
-				      "NCSI: new vlan id to set: %u\n",
-				      vlan->vid);
+		vid = vlan->vid;
+		for (i = 0; i < ncf->n_vids; i++)
+			if (ncf->vids[i] == vid) {
+				vid = 0;
+				break;
+			}
+		if (vid)
 			break;
-		}
-		netdev_printk(KERN_DEBUG, ndp->ndev.dev,
-			      "vid %u already at filter pos %d\n",
-			      vlan->vid, index);
 	}
+	rcu_read_unlock();
 
-	if (!vlan || index >= 0) {
-		netdev_printk(KERN_DEBUG, ndp->ndev.dev,
-			      "no vlan ids left to set\n");
+	if (!vid) {
+		/* No VLAN ID is not set */
+		spin_unlock_irqrestore(&nc->lock, flags);
 		return -1;
 	}
 
-	index = ncsi_add_filter(nc, NCSI_FILTER_VLAN, &vlan->vid);
-	if (index < 0) {
+	index = find_next_zero_bit(bitmap, ncf->n_vids, 0);
+	if (index < 0 || index >= ncf->n_vids) {
 		netdev_err(ndp->ndev.dev,
-			   "Failed to add new VLAN tag, error %d\n", index);
-		if (index == -ENOSPC)
-			netdev_err(ndp->ndev.dev,
-				   "Channel %u already has all VLAN filters set\n",
-				   nc->id);
+			   "Channel %u already has all VLAN filters set\n",
+			   nc->id);
+		spin_unlock_irqrestore(&nc->lock, flags);
 		return -1;
 	}
 
-	netdev_printk(KERN_DEBUG, ndp->ndev.dev,
-		      "NCSI: set vid %u in packet, index %u\n",
-		      vlan->vid, index + 1);
+	ncf->vids[index] = vid;
+	set_bit(index, bitmap);
+	spin_unlock_irqrestore(&nc->lock, flags);
+
 	nca->type = NCSI_PKT_CMD_SVF;
-	nca->words[1] = vlan->vid;
+	nca->words[1] = vid;
 	/* HW filter index starts at 1 */
 	nca->bytes[6] = index + 1;
 	nca->bytes[7] = 0x01;
--- a/net/ncsi/ncsi-netlink.c
+++ b/net/ncsi/ncsi-netlink.c
@@ -58,10 +58,9 @@ static int ncsi_write_channel_info(struc
 				   struct ncsi_dev_priv *ndp,
 				   struct ncsi_channel *nc)
 {
-	struct nlattr *vid_nest;
-	struct ncsi_channel_filter *ncf;
+	struct ncsi_channel_vlan_filter *ncf;
 	struct ncsi_channel_mode *m;
-	u32 *data;
+	struct nlattr *vid_nest;
 	int i;
 
 	nla_put_u32(skb, NCSI_CHANNEL_ATTR_ID, nc->id);
@@ -79,18 +78,13 @@ static int ncsi_write_channel_info(struc
 	vid_nest = nla_nest_start(skb, NCSI_CHANNEL_ATTR_VLAN_LIST);
 	if (!vid_nest)
 		return -ENOMEM;
-	ncf = nc->filters[NCSI_FILTER_VLAN];
+	ncf = &nc->vlan_filter;
 	i = -1;
-	if (ncf) {
-		while ((i = find_next_bit((void *)&ncf->bitmap, ncf->total,
-					  i + 1)) < ncf->total) {
-			data = ncsi_get_filter(nc, NCSI_FILTER_VLAN, i);
-			/* Uninitialised channels will have 'zero' vlan ids */
-			if (!data || !*data)
-				continue;
+	while ((i = find_next_bit((void *)&ncf->bitmap, ncf->n_vids,
+				  i + 1)) < ncf->n_vids) {
+		if (ncf->vids[i])
 			nla_put_u16(skb, NCSI_CHANNEL_ATTR_VLAN_ID,
-				    *(u16 *)data);
-		}
+				    ncf->vids[i]);
 	}
 	nla_nest_end(skb, vid_nest);
 
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -334,9 +334,9 @@ static int ncsi_rsp_handler_svf(struct n
 	struct ncsi_rsp_pkt *rsp;
 	struct ncsi_dev_priv *ndp = nr->ndp;
 	struct ncsi_channel *nc;
-	struct ncsi_channel_filter *ncf;
-	unsigned short vlan;
-	int ret;
+	struct ncsi_channel_vlan_filter *ncf;
+	unsigned long flags;
+	void *bitmap;
 
 	/* Find the package and channel */
 	rsp = (struct ncsi_rsp_pkt *)skb_network_header(nr->rsp);
@@ -346,22 +346,23 @@ static int ncsi_rsp_handler_svf(struct n
 		return -ENODEV;
 
 	cmd = (struct ncsi_cmd_svf_pkt *)skb_network_header(nr->cmd);
-	ncf = nc->filters[NCSI_FILTER_VLAN];
-	if (!ncf)
-		return -ENOENT;
-	if (cmd->index >= ncf->total)
+	ncf = &nc->vlan_filter;
+	if (cmd->index > ncf->n_vids)
 		return -ERANGE;
 
-	/* Add or remove the VLAN filter */
+	/* Add or remove the VLAN filter. Remember HW indexes from 1 */
+	spin_lock_irqsave(&nc->lock, flags);
+	bitmap = &ncf->bitmap;
 	if (!(cmd->enable & 0x1)) {
-		/* HW indexes from 1 */
-		ret = ncsi_remove_filter(nc, NCSI_FILTER_VLAN, cmd->index - 1);
+		if (test_and_clear_bit(cmd->index - 1, bitmap))
+			ncf->vids[cmd->index - 1] = 0;
 	} else {
-		vlan = ntohs(cmd->vlan);
-		ret = ncsi_add_filter(nc, NCSI_FILTER_VLAN, &vlan);
+		set_bit(cmd->index - 1, bitmap);
+		ncf->vids[cmd->index - 1] = ntohs(cmd->vlan);
 	}
+	spin_unlock_irqrestore(&nc->lock, flags);
 
-	return ret;
+	return 0;
 }
 
 static int ncsi_rsp_handler_ev(struct ncsi_request *nr)
@@ -422,8 +423,12 @@ static int ncsi_rsp_handler_sma(struct n
 	struct ncsi_rsp_pkt *rsp;
 	struct ncsi_dev_priv *ndp = nr->ndp;
 	struct ncsi_channel *nc;
-	struct ncsi_channel_filter *ncf;
+	struct ncsi_channel_mac_filter *ncf;
+	unsigned long flags;
 	void *bitmap;
+	bool enabled;
+	int index;
+
 
 	/* Find the package and channel */
 	rsp = (struct ncsi_rsp_pkt *)skb_network_header(nr->rsp);
@@ -436,31 +441,23 @@ static int ncsi_rsp_handler_sma(struct n
 	 * isn't supported yet.
 	 */
 	cmd = (struct ncsi_cmd_sma_pkt *)skb_network_header(nr->cmd);
-	switch (cmd->at_e >> 5) {
-	case 0x0:	/* UC address */
-		ncf = nc->filters[NCSI_FILTER_UC];
-		break;
-	case 0x1:	/* MC address */
-		ncf = nc->filters[NCSI_FILTER_MC];
-		break;
-	default:
-		return -EINVAL;
-	}
+	enabled = cmd->at_e & 0x1;
+	ncf = &nc->mac_filter;
+	bitmap = &ncf->bitmap;
 
-	/* Sanity check on the filter */
-	if (!ncf)
-		return -ENOENT;
-	else if (cmd->index >= ncf->total)
+	if (cmd->index > ncf->n_uc + ncf->n_mc + ncf->n_mixed)
 		return -ERANGE;
 
-	bitmap = &ncf->bitmap;
-	if (cmd->at_e & 0x1) {
-		set_bit(cmd->index, bitmap);
-		memcpy(ncf->data + 6 * cmd->index, cmd->mac, 6);
+	index = (cmd->index - 1) * ETH_ALEN;
+	spin_lock_irqsave(&nc->lock, flags);
+	if (enabled) {
+		set_bit(cmd->index - 1, bitmap);
+		memcpy(&ncf->addrs[index], cmd->mac, ETH_ALEN);
 	} else {
-		clear_bit(cmd->index, bitmap);
-		memset(ncf->data + 6 * cmd->index, 0, 6);
+		clear_bit(cmd->index - 1, bitmap);
+		memset(&ncf->addrs[index], 0, ETH_ALEN);
 	}
+	spin_unlock_irqrestore(&nc->lock, flags);
 
 	return 0;
 }
@@ -631,9 +628,7 @@ static int ncsi_rsp_handler_gc(struct nc
 	struct ncsi_rsp_gc_pkt *rsp;
 	struct ncsi_dev_priv *ndp = nr->ndp;
 	struct ncsi_channel *nc;
-	struct ncsi_channel_filter *ncf;
-	size_t size, entry_size;
-	int cnt, i;
+	size_t size;
 
 	/* Find the channel */
 	rsp = (struct ncsi_rsp_gc_pkt *)skb_network_header(nr->rsp);
@@ -655,64 +650,40 @@ static int ncsi_rsp_handler_gc(struct nc
 	nc->caps[NCSI_CAP_VLAN].cap = rsp->vlan_mode &
 				      NCSI_CAP_VLAN_MASK;
 
-	/* Build filters */
-	for (i = 0; i < NCSI_FILTER_MAX; i++) {
-		switch (i) {
-		case NCSI_FILTER_VLAN:
-			cnt = rsp->vlan_cnt;
-			entry_size = 2;
-			break;
-		case NCSI_FILTER_MIXED:
-			cnt = rsp->mixed_cnt;
-			entry_size = 6;
-			break;
-		case NCSI_FILTER_MC:
-			cnt = rsp->mc_cnt;
-			entry_size = 6;
-			break;
-		case NCSI_FILTER_UC:
-			cnt = rsp->uc_cnt;
-			entry_size = 6;
-			break;
-		default:
-			continue;
-		}
-
-		if (!cnt || nc->filters[i])
-			continue;
-
-		size = sizeof(*ncf) + cnt * entry_size;
-		ncf = kzalloc(size, GFP_ATOMIC);
-		if (!ncf) {
-			pr_warn("%s: Cannot alloc filter table (%d)\n",
-				__func__, i);
-			return -ENOMEM;
-		}
-
-		ncf->index = i;
-		ncf->total = cnt;
-		if (i == NCSI_FILTER_VLAN) {
-			/* Set VLAN filters active so they are cleared in
-			 * first configuration state
-			 */
-			ncf->bitmap = U64_MAX;
-		} else {
-			ncf->bitmap = 0x0ul;
-		}
-		nc->filters[i] = ncf;
-	}
+	size = (rsp->uc_cnt + rsp->mc_cnt + rsp->mixed_cnt) * ETH_ALEN;
+	nc->mac_filter.addrs = kzalloc(size, GFP_KERNEL);
+	if (!nc->mac_filter.addrs)
+		return -ENOMEM;
+	nc->mac_filter.n_uc = rsp->uc_cnt;
+	nc->mac_filter.n_mc = rsp->mc_cnt;
+	nc->mac_filter.n_mixed = rsp->mixed_cnt;
+
+	nc->vlan_filter.vids = kcalloc(rsp->vlan_cnt,
+				       sizeof(*nc->vlan_filter.vids),
+				       GFP_KERNEL);
+	if (!nc->vlan_filter.vids)
+		return -ENOMEM;
+	/* Set VLAN filters active so they are cleared in the first
+	 * configuration state
+	 */
+	nc->vlan_filter.bitmap = U64_MAX;
+	nc->vlan_filter.n_vids = rsp->vlan_cnt;
 
 	return 0;
 }
 
 static int ncsi_rsp_handler_gp(struct ncsi_request *nr)
 {
-	struct ncsi_rsp_gp_pkt *rsp;
+	struct ncsi_channel_vlan_filter *ncvf;
+	struct ncsi_channel_mac_filter *ncmf;
 	struct ncsi_dev_priv *ndp = nr->ndp;
+	struct ncsi_rsp_gp_pkt *rsp;
 	struct ncsi_channel *nc;
-	unsigned short enable, vlan;
+	unsigned short enable;
 	unsigned char *pdata;
-	int table, i;
+	unsigned long flags;
+	void *bitmap;
+	int i;
 
 	/* Find the channel */
 	rsp = (struct ncsi_rsp_gp_pkt *)skb_network_header(nr->rsp);
@@ -746,36 +717,33 @@ static int ncsi_rsp_handler_gp(struct nc
 	/* MAC addresses filter table */
 	pdata = (unsigned char *)rsp + 48;
 	enable = rsp->mac_enable;
+	ncmf = &nc->mac_filter;
+	spin_lock_irqsave(&nc->lock, flags);
+	bitmap = &ncmf->bitmap;
 	for (i = 0; i < rsp->mac_cnt; i++, pdata += 6) {
-		if (i >= (nc->filters[NCSI_FILTER_UC]->total +
-			  nc->filters[NCSI_FILTER_MC]->total))
-			table = NCSI_FILTER_MIXED;
-		else if (i >= nc->filters[NCSI_FILTER_UC]->total)
-			table = NCSI_FILTER_MC;
-		else
-			table = NCSI_FILTER_UC;
-
 		if (!(enable & (0x1 << i)))
-			continue;
-
-		if (ncsi_find_filter(nc, table, pdata) >= 0)
-			continue;
+			clear_bit(i, bitmap);
+		else
+			set_bit(i, bitmap);
 
-		ncsi_add_filter(nc, table, pdata);
+		memcpy(&ncmf->addrs[i * ETH_ALEN], pdata, ETH_ALEN);
 	}
+	spin_unlock_irqrestore(&nc->lock, flags);
 
 	/* VLAN filter table */
 	enable = ntohs(rsp->vlan_enable);
+	ncvf = &nc->vlan_filter;
+	bitmap = &ncvf->bitmap;
+	spin_lock_irqsave(&nc->lock, flags);
 	for (i = 0; i < rsp->vlan_cnt; i++, pdata += 2) {
 		if (!(enable & (0x1 << i)))
-			continue;
-
-		vlan = ntohs(*(__be16 *)pdata);
-		if (ncsi_find_filter(nc, NCSI_FILTER_VLAN, &vlan) >= 0)
-			continue;
+			clear_bit(i, bitmap);
+		else
+			set_bit(i, bitmap);
 
-		ncsi_add_filter(nc, NCSI_FILTER_VLAN, &vlan);
+		ncvf->vids[i] = ntohs(*(__be16 *)pdata);
 	}
+	spin_unlock_irqrestore(&nc->lock, flags);
 
 	return 0;
 }


