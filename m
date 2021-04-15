Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48BE360D22
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234542AbhDOO5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:57:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234020AbhDOOzr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:55:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57907613CF;
        Thu, 15 Apr 2021 14:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498440;
        bh=xe8GaLc29d0OsBIMoGk+abwoTSQxbu2wXANXJklO/cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TeaL7Tk2Z4wcRT1hPs3uuKnoH5OLHb0EhNso8qXSVCR2C6O/8FOCBTLdL4iYbJFDZ
         y/S/g175IBeNXH8hH0now5A9lfwfx0jdoMJwTehHYl2I/US1BZnqP6PtmT1i//RNkY
         ZDNhVfsGlVkw9WGBbSpknjGWGfcgDoGtTTyKc6GQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 40/68] net/ncsi: Improve general state logging
Date:   Thu, 15 Apr 2021 16:47:21 +0200
Message-Id: <20210415144415.779828678@linuxfoundation.org>
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

commit 9ef8690be13d8ae3130749fbcc0cc21e4e3f738c upstream.

The NCSI driver is mostly silent which becomes a headache when trying to
determine what has occurred on the NCSI connection. This adds additional
logging in a few key areas such as state transitions and calling out
certain errors more visibly.

Signed-off-by: Samuel Mendoza-Jonas <sam@mendozajonas.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ncsi/ncsi-aen.c    |   15 +++++++++
 net/ncsi/ncsi-manage.c |   76 ++++++++++++++++++++++++++++++++++++-------------
 net/ncsi/ncsi-rsp.c    |   10 +++++-
 3 files changed, 80 insertions(+), 21 deletions(-)

--- a/net/ncsi/ncsi-aen.c
+++ b/net/ncsi/ncsi-aen.c
@@ -73,6 +73,9 @@ static int ncsi_aen_handler_lsc(struct n
 	ncm->data[2] = data;
 	ncm->data[4] = ntohl(lsc->oem_status);
 
+	netdev_info(ndp->ndev.dev, "NCSI: LSC AEN - channel %u state %s\n",
+		    nc->id, data & 0x1 ? "up" : "down");
+
 	chained = !list_empty(&nc->link);
 	state = nc->state;
 	spin_unlock_irqrestore(&nc->lock, flags);
@@ -145,6 +148,8 @@ static int ncsi_aen_handler_hncdsc(struc
 	ncm = &nc->modes[NCSI_MODE_LINK];
 	hncdsc = (struct ncsi_aen_hncdsc_pkt *)h;
 	ncm->data[3] = ntohl(hncdsc->status);
+	netdev_info(ndp->ndev.dev, "NCSI: HNCDSC AEN - channel %u state %s\n",
+		    nc->id, ncm->data[3] & 0x3 ? "up" : "down");
 	if (!list_empty(&nc->link) ||
 	    nc->state != NCSI_CHANNEL_ACTIVE) {
 		spin_unlock_irqrestore(&nc->lock, flags);
@@ -212,10 +217,18 @@ int ncsi_aen_handler(struct ncsi_dev_pri
 	}
 
 	ret = ncsi_validate_aen_pkt(h, nah->payload);
-	if (ret)
+	if (ret) {
+		netdev_warn(ndp->ndev.dev,
+			    "NCSI: 'bad' packet ignored for AEN type 0x%x\n",
+			    h->type);
 		goto out;
+	}
 
 	ret = nah->handler(ndp, h);
+	if (ret)
+		netdev_err(ndp->ndev.dev,
+			   "NCSI: Handler for AEN type 0x%x returned %d\n",
+			   h->type, ret);
 out:
 	consume_skb(skb);
 	return ret;
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -236,6 +236,8 @@ bad_state:
 	case NCSI_CHANNEL_MONITOR_WAIT ... NCSI_CHANNEL_MONITOR_WAIT_MAX:
 		break;
 	default:
+		netdev_err(ndp->ndev.dev, "NCSI Channel %d timed out!\n",
+			   nc->id);
 		if (!(ndp->flags & NCSI_DEV_HWA)) {
 			ncsi_report_link(ndp, true);
 			ndp->flags |= NCSI_DEV_RESHUFFLE;
@@ -688,7 +690,7 @@ static int clear_one_vid(struct ncsi_dev
 	data = ncsi_get_filter(nc, NCSI_FILTER_VLAN, index);
 	if (!data) {
 		netdev_err(ndp->ndev.dev,
-			   "ncsi: failed to retrieve filter %d\n", index);
+			   "NCSI: failed to retrieve filter %d\n", index);
 		/* Set the VLAN id to 0 - this will still disable the entry in
 		 * the filter table, but we won't know what it was.
 		 */
@@ -698,7 +700,7 @@ static int clear_one_vid(struct ncsi_dev
 	}
 
 	netdev_printk(KERN_DEBUG, ndp->ndev.dev,
-		      "ncsi: removed vlan tag %u at index %d\n",
+		      "NCSI: removed vlan tag %u at index %d\n",
 		      vid, index + 1);
 	ncsi_remove_filter(nc, NCSI_FILTER_VLAN, index);
 
@@ -724,7 +726,7 @@ static int set_one_vid(struct ncsi_dev_p
 		if (index < 0) {
 			/* New tag to add */
 			netdev_printk(KERN_DEBUG, ndp->ndev.dev,
-				      "ncsi: new vlan id to set: %u\n",
+				      "NCSI: new vlan id to set: %u\n",
 				      vlan->vid);
 			break;
 		}
@@ -751,7 +753,7 @@ static int set_one_vid(struct ncsi_dev_p
 	}
 
 	netdev_printk(KERN_DEBUG, ndp->ndev.dev,
-		      "ncsi: set vid %u in packet, index %u\n",
+		      "NCSI: set vid %u in packet, index %u\n",
 		      vlan->vid, index + 1);
 	nca->type = NCSI_PKT_CMD_SVF;
 	nca->words[1] = vlan->vid;
@@ -790,8 +792,11 @@ static void ncsi_configure_channel(struc
 		nca.package = np->id;
 		nca.channel = NCSI_RESERVED_CHANNEL;
 		ret = ncsi_xmit_cmd(&nca);
-		if (ret)
+		if (ret) {
+			netdev_err(ndp->ndev.dev,
+				   "NCSI: Failed to transmit CMD_SP\n");
 			goto error;
+		}
 
 		nd->state = ncsi_dev_state_config_cis;
 		break;
@@ -803,8 +808,11 @@ static void ncsi_configure_channel(struc
 		nca.package = np->id;
 		nca.channel = nc->id;
 		ret = ncsi_xmit_cmd(&nca);
-		if (ret)
+		if (ret) {
+			netdev_err(ndp->ndev.dev,
+				   "NCSI: Failed to transmit CMD_CIS\n");
 			goto error;
+		}
 
 		nd->state = ncsi_dev_state_config_clear_vids;
 		break;
@@ -901,10 +909,16 @@ static void ncsi_configure_channel(struc
 		}
 
 		ret = ncsi_xmit_cmd(&nca);
-		if (ret)
+		if (ret) {
+			netdev_err(ndp->ndev.dev,
+				   "NCSI: Failed to transmit CMD %x\n",
+				   nca.type);
 			goto error;
+		}
 		break;
 	case ncsi_dev_state_config_done:
+		netdev_printk(KERN_DEBUG, ndp->ndev.dev,
+			      "NCSI: channel %u config done\n", nc->id);
 		spin_lock_irqsave(&nc->lock, flags);
 		if (nc->reconfigure_needed) {
 			/* This channel's configuration has been updated
@@ -931,6 +945,9 @@ static void ncsi_configure_channel(struc
 		} else {
 			hot_nc = NULL;
 			nc->state = NCSI_CHANNEL_INACTIVE;
+			netdev_warn(ndp->ndev.dev,
+				    "NCSI: channel %u link down after config\n",
+				    nc->id);
 		}
 		spin_unlock_irqrestore(&nc->lock, flags);
 
@@ -943,8 +960,8 @@ static void ncsi_configure_channel(struc
 		ncsi_process_next_channel(ndp);
 		break;
 	default:
-		netdev_warn(dev, "Wrong NCSI state 0x%x in config\n",
-			    nd->state);
+		netdev_alert(dev, "Wrong NCSI state 0x%x in config\n",
+			     nd->state);
 	}
 
 	return;
@@ -996,10 +1013,17 @@ static int ncsi_choose_active_channel(st
 	}
 
 	if (!found) {
+		netdev_warn(ndp->ndev.dev,
+			    "NCSI: No channel found with link\n");
 		ncsi_report_link(ndp, true);
 		return -ENODEV;
 	}
 
+	ncm = &found->modes[NCSI_MODE_LINK];
+	netdev_printk(KERN_DEBUG, ndp->ndev.dev,
+		      "NCSI: Channel %u added to queue (link %s)\n",
+		      found->id, ncm->data[2] & 0x1 ? "up" : "down");
+
 out:
 	spin_lock_irqsave(&ndp->lock, flags);
 	list_add_tail_rcu(&found->link, &ndp->channel_queue);
@@ -1061,6 +1085,8 @@ static int ncsi_enable_hwa(struct ncsi_d
 
 	/* We can have no channels in extremely case */
 	if (list_empty(&ndp->channel_queue)) {
+		netdev_err(ndp->ndev.dev,
+			   "NCSI: No available channels for HWA\n");
 		ncsi_report_link(ndp, false);
 		return -ENOENT;
 	}
@@ -1229,6 +1255,9 @@ static void ncsi_probe_channel(struct nc
 
 	return;
 error:
+	netdev_err(ndp->ndev.dev,
+		   "NCSI: Failed to transmit cmd 0x%x during probe\n",
+		   nca.type);
 	ncsi_report_link(ndp, true);
 }
 
@@ -1282,10 +1311,14 @@ int ncsi_process_next_channel(struct ncs
 	switch (old_state) {
 	case NCSI_CHANNEL_INACTIVE:
 		ndp->ndev.state = ncsi_dev_state_config;
+		netdev_info(ndp->ndev.dev, "NCSI: configuring channel %u\n",
+			    nc->id);
 		ncsi_configure_channel(ndp);
 		break;
 	case NCSI_CHANNEL_ACTIVE:
 		ndp->ndev.state = ncsi_dev_state_suspend;
+		netdev_info(ndp->ndev.dev, "NCSI: suspending channel %u\n",
+			    nc->id);
 		ncsi_suspend_channel(ndp);
 		break;
 	default:
@@ -1305,6 +1338,8 @@ out:
 		return ncsi_choose_active_channel(ndp);
 	}
 
+	netdev_printk(KERN_DEBUG, ndp->ndev.dev,
+		      "NCSI: No more channels to process\n");
 	ncsi_report_link(ndp, false);
 	return -ENODEV;
 }
@@ -1396,7 +1431,7 @@ static int ncsi_kick_channels(struct ncs
 						ncsi_dev_state_config ||
 						!list_empty(&nc->link)) {
 					netdev_printk(KERN_DEBUG, nd->dev,
-						      "ncsi: channel %p marked dirty\n",
+						      "NCSI: channel %p marked dirty\n",
 						      nc);
 					nc->reconfigure_needed = true;
 				}
@@ -1416,7 +1451,7 @@ static int ncsi_kick_channels(struct ncs
 			spin_unlock_irqrestore(&ndp->lock, flags);
 
 			netdev_printk(KERN_DEBUG, nd->dev,
-				      "ncsi: kicked channel %p\n", nc);
+				      "NCSI: kicked channel %p\n", nc);
 			n++;
 		}
 	}
@@ -1437,7 +1472,7 @@ int ncsi_vlan_rx_add_vid(struct net_devi
 
 	nd = ncsi_find_dev(dev);
 	if (!nd) {
-		netdev_warn(dev, "ncsi: No net_device?\n");
+		netdev_warn(dev, "NCSI: No net_device?\n");
 		return 0;
 	}
 
@@ -1448,7 +1483,7 @@ int ncsi_vlan_rx_add_vid(struct net_devi
 		n_vids++;
 		if (vlan->vid == vid) {
 			netdev_printk(KERN_DEBUG, dev,
-				      "vid %u already registered\n", vid);
+				      "NCSI: vid %u already registered\n", vid);
 			return 0;
 		}
 	}
@@ -1467,7 +1502,7 @@ int ncsi_vlan_rx_add_vid(struct net_devi
 	vlan->vid = vid;
 	list_add_rcu(&vlan->list, &ndp->vlan_vids);
 
-	netdev_printk(KERN_DEBUG, dev, "Added new vid %u\n", vid);
+	netdev_printk(KERN_DEBUG, dev, "NCSI: Added new vid %u\n", vid);
 
 	found = ncsi_kick_channels(ndp) != 0;
 
@@ -1487,7 +1522,7 @@ int ncsi_vlan_rx_kill_vid(struct net_dev
 
 	nd = ncsi_find_dev(dev);
 	if (!nd) {
-		netdev_warn(dev, "ncsi: no net_device?\n");
+		netdev_warn(dev, "NCSI: no net_device?\n");
 		return 0;
 	}
 
@@ -1497,14 +1532,14 @@ int ncsi_vlan_rx_kill_vid(struct net_dev
 	list_for_each_entry_safe(vlan, tmp, &ndp->vlan_vids, list)
 		if (vlan->vid == vid) {
 			netdev_printk(KERN_DEBUG, dev,
-				      "vid %u found, removing\n", vid);
+				      "NCSI: vid %u found, removing\n", vid);
 			list_del_rcu(&vlan->list);
 			found = true;
 			kfree(vlan);
 		}
 
 	if (!found) {
-		netdev_err(dev, "ncsi: vid %u wasn't registered!\n", vid);
+		netdev_err(dev, "NCSI: vid %u wasn't registered!\n", vid);
 		return -EINVAL;
 	}
 
@@ -1587,10 +1622,12 @@ int ncsi_start_dev(struct ncsi_dev *nd)
 		return 0;
 	}
 
-	if (ndp->flags & NCSI_DEV_HWA)
+	if (ndp->flags & NCSI_DEV_HWA) {
+		netdev_info(ndp->ndev.dev, "NCSI: Enabling HWA mode\n");
 		ret = ncsi_enable_hwa(ndp);
-	else
+	} else {
 		ret = ncsi_choose_active_channel(ndp);
+	}
 
 	return ret;
 }
@@ -1621,6 +1658,7 @@ void ncsi_stop_dev(struct ncsi_dev *nd)
 		}
 	}
 
+	netdev_printk(KERN_DEBUG, ndp->ndev.dev, "NCSI: Stopping device\n");
 	ncsi_report_link(ndp, true);
 }
 EXPORT_SYMBOL_GPL(ncsi_stop_dev);
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -1032,11 +1032,19 @@ int ncsi_rcv_rsp(struct sk_buff *skb, st
 	if (payload < 0)
 		payload = ntohs(hdr->length);
 	ret = ncsi_validate_rsp_pkt(nr, payload);
-	if (ret)
+	if (ret) {
+		netdev_warn(ndp->ndev.dev,
+			    "NCSI: 'bad' packet ignored for type 0x%x\n",
+			    hdr->type);
 		goto out;
+	}
 
 	/* Process the packet */
 	ret = nrh->handler(nr);
+	if (ret)
+		netdev_err(ndp->ndev.dev,
+			   "NCSI: Handler for packet type 0x%x returned %d\n",
+			   hdr->type, ret);
 out:
 	ncsi_free_request(nr);
 	return ret;


