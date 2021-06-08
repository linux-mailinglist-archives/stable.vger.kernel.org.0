Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5163939FFF3
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234199AbhFHShr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:37:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234326AbhFHSfo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:35:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDE3E613BD;
        Tue,  8 Jun 2021 18:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177144;
        bh=21cFPKG5Z22ciNHkdyXVuM7fbTV+39eSZSfDG/W38F8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e5folEwUPHQFtUXG8L72eqkpvxnmSzxLGIdY+kf48OlPoQtfr6NmN97hlTbVXWYe8
         SxVfiIGms0ecbspUyokpa9iDzVMuAxnQ3itOhawc1r05W3SgbA7XGUPrkZdWz6iev5
         ZF/pHvh1swjTuqV787r4JqI5vuRVRS3Tc6H23FBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 16/47] net: caif: add proper error handling
Date:   Tue,  8 Jun 2021 20:26:59 +0200
Message-Id: <20210608175931.014250942@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175930.477274100@linuxfoundation.org>
References: <20210608175930.477274100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit a2805dca5107d5603f4bbc027e81e20d93476e96 upstream.

caif_enroll_dev() can fail in some cases. Ingnoring
these cases can lead to memory leak due to not assigning
link_support pointer to anywhere.

Fixes: 7c18d2205ea7 ("caif: Restructure how link caif link layer enroll")
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/caif/caif_dev.h |    2 +-
 include/net/caif/cfcnfg.h   |    2 +-
 net/caif/caif_dev.c         |    8 +++++---
 net/caif/cfcnfg.c           |   16 +++++++++++-----
 4 files changed, 18 insertions(+), 10 deletions(-)

--- a/include/net/caif/caif_dev.h
+++ b/include/net/caif/caif_dev.h
@@ -119,7 +119,7 @@ void caif_free_client(struct cflayer *ad
  * The link_support layer is used to add any Link Layer specific
  * framing.
  */
-void caif_enroll_dev(struct net_device *dev, struct caif_dev_common *caifdev,
+int caif_enroll_dev(struct net_device *dev, struct caif_dev_common *caifdev,
 			struct cflayer *link_support, int head_room,
 			struct cflayer **layer, int (**rcv_func)(
 				struct sk_buff *, struct net_device *,
--- a/include/net/caif/cfcnfg.h
+++ b/include/net/caif/cfcnfg.h
@@ -62,7 +62,7 @@ void cfcnfg_remove(struct cfcnfg *cfg);
  * @fcs:	Specify if checksum is used in CAIF Framing Layer.
  * @head_room:	Head space needed by link specific protocol.
  */
-void
+int
 cfcnfg_add_phy_layer(struct cfcnfg *cnfg,
 		     struct net_device *dev, struct cflayer *phy_layer,
 		     enum cfcnfg_phy_preference pref,
--- a/net/caif/caif_dev.c
+++ b/net/caif/caif_dev.c
@@ -303,7 +303,7 @@ static void dev_flowctrl(struct net_devi
 	caifd_put(caifd);
 }
 
-void caif_enroll_dev(struct net_device *dev, struct caif_dev_common *caifdev,
+int caif_enroll_dev(struct net_device *dev, struct caif_dev_common *caifdev,
 		     struct cflayer *link_support, int head_room,
 		     struct cflayer **layer,
 		     int (**rcv_func)(struct sk_buff *, struct net_device *,
@@ -314,11 +314,12 @@ void caif_enroll_dev(struct net_device *
 	enum cfcnfg_phy_preference pref;
 	struct cfcnfg *cfg = get_cfcnfg(dev_net(dev));
 	struct caif_device_entry_list *caifdevs;
+	int res;
 
 	caifdevs = caif_device_list(dev_net(dev));
 	caifd = caif_device_alloc(dev);
 	if (!caifd)
-		return;
+		return -ENOMEM;
 	*layer = &caifd->layer;
 	spin_lock_init(&caifd->flow_lock);
 
@@ -340,7 +341,7 @@ void caif_enroll_dev(struct net_device *
 		sizeof(caifd->layer.name) - 1);
 	caifd->layer.name[sizeof(caifd->layer.name) - 1] = 0;
 	caifd->layer.transmit = transmit;
-	cfcnfg_add_phy_layer(cfg,
+	res = cfcnfg_add_phy_layer(cfg,
 				dev,
 				&caifd->layer,
 				pref,
@@ -350,6 +351,7 @@ void caif_enroll_dev(struct net_device *
 	mutex_unlock(&caifdevs->lock);
 	if (rcv_func)
 		*rcv_func = receive;
+	return res;
 }
 EXPORT_SYMBOL(caif_enroll_dev);
 
--- a/net/caif/cfcnfg.c
+++ b/net/caif/cfcnfg.c
@@ -452,7 +452,7 @@ unlock:
 	rcu_read_unlock();
 }
 
-void
+int
 cfcnfg_add_phy_layer(struct cfcnfg *cnfg,
 		     struct net_device *dev, struct cflayer *phy_layer,
 		     enum cfcnfg_phy_preference pref,
@@ -461,7 +461,7 @@ cfcnfg_add_phy_layer(struct cfcnfg *cnfg
 {
 	struct cflayer *frml;
 	struct cfcnfg_phyinfo *phyinfo = NULL;
-	int i;
+	int i, res = 0;
 	u8 phyid;
 
 	mutex_lock(&cnfg->lock);
@@ -475,12 +475,15 @@ cfcnfg_add_phy_layer(struct cfcnfg *cnfg
 			goto got_phyid;
 	}
 	pr_warn("Too many CAIF Link Layers (max 6)\n");
+	res = -EEXIST;
 	goto out;
 
 got_phyid:
 	phyinfo = kzalloc(sizeof(struct cfcnfg_phyinfo), GFP_ATOMIC);
-	if (!phyinfo)
+	if (!phyinfo) {
+		res = -ENOMEM;
 		goto out_err;
+	}
 
 	phy_layer->id = phyid;
 	phyinfo->pref = pref;
@@ -494,8 +497,10 @@ got_phyid:
 
 	frml = cffrml_create(phyid, fcs);
 
-	if (!frml)
+	if (!frml) {
+		res = -ENOMEM;
 		goto out_err;
+	}
 	phyinfo->frm_layer = frml;
 	layer_set_up(frml, cnfg->mux);
 
@@ -513,11 +518,12 @@ got_phyid:
 	list_add_rcu(&phyinfo->node, &cnfg->phys);
 out:
 	mutex_unlock(&cnfg->lock);
-	return;
+	return res;
 
 out_err:
 	kfree(phyinfo);
 	mutex_unlock(&cnfg->lock);
+	return res;
 }
 EXPORT_SYMBOL(cfcnfg_add_phy_layer);
 


