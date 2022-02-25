Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337D24C497B
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 16:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242152AbiBYPrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 10:47:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242178AbiBYPrQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 10:47:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539EC1FCD8
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 07:46:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D22946192C
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 15:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD72FC340E7;
        Fri, 25 Feb 2022 15:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645804003;
        bh=fs802bqjPDA0FQacyUaOPZqyW4ArTa5dOM/kFHPFD8A=;
        h=Subject:To:Cc:From:Date:From;
        b=xiNU9ZHvqeouFDHMFUYXavCMAORN9mXvDkPxvWlT7oIvsd+Rl/L0Q4j/oyb89eFkv
         Z0sNN8jYf2IlOWgggsoadI6RKfihnxkBAD5EogyZIbrYqVyUFa1Q3amlIgbq1A2hYW
         JolQn/yCAU7I+90Eo+ksxP+As+qtCKfL+iNqYCm4=
Subject: FAILED: patch "[PATCH] net/smc: Use a mutex for locking "struct smc_pnettable"" failed to apply to 5.4-stable tree
To:     fmdefrancesco@gmail.com, kgraul@linux.ibm.com, kuba@kernel.org,
        tonylu@linux.alibaba.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Feb 2022 16:46:40 +0100
Message-ID: <164580400025315@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7ff57e98fb78ad94edafbdc7435f2d745e9e6bb5 Mon Sep 17 00:00:00 2001
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Date: Wed, 23 Feb 2022 11:02:52 +0100
Subject: [PATCH] net/smc: Use a mutex for locking "struct smc_pnettable"

smc_pnetid_by_table_ib() uses read_lock() and then it calls smc_pnet_apply_ib()
which, in turn, calls mutex_lock(&smc_ib_devices.mutex).

read_lock() disables preemption. Therefore, the code acquires a mutex while in
atomic context and it leads to a SAC bug.

Fix this bug by replacing the rwlock with a mutex.

Reported-and-tested-by: syzbot+4f322a6d84e991c38775@syzkaller.appspotmail.com
Fixes: 64e28b52c7a6 ("net/smc: add pnet table namespace support")
Confirmed-by: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Acked-by: Karsten Graul <kgraul@linux.ibm.com>
Link: https://lore.kernel.org/r/20220223100252.22562-1-fmdefrancesco@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 0599246c0376..29f0a559d884 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -113,7 +113,7 @@ static int smc_pnet_remove_by_pnetid(struct net *net, char *pnet_name)
 	pnettable = &sn->pnettable;
 
 	/* remove table entry */
-	write_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry_safe(pnetelem, tmp_pe, &pnettable->pnetlist,
 				 list) {
 		if (!pnet_name ||
@@ -131,7 +131,7 @@ static int smc_pnet_remove_by_pnetid(struct net *net, char *pnet_name)
 			rc = 0;
 		}
 	}
-	write_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 
 	/* if this is not the initial namespace, stop here */
 	if (net != &init_net)
@@ -192,7 +192,7 @@ static int smc_pnet_add_by_ndev(struct net_device *ndev)
 	sn = net_generic(net, smc_net_id);
 	pnettable = &sn->pnettable;
 
-	write_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry_safe(pnetelem, tmp_pe, &pnettable->pnetlist, list) {
 		if (pnetelem->type == SMC_PNET_ETH && !pnetelem->ndev &&
 		    !strncmp(pnetelem->eth_name, ndev->name, IFNAMSIZ)) {
@@ -206,7 +206,7 @@ static int smc_pnet_add_by_ndev(struct net_device *ndev)
 			break;
 		}
 	}
-	write_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 	return rc;
 }
 
@@ -224,7 +224,7 @@ static int smc_pnet_remove_by_ndev(struct net_device *ndev)
 	sn = net_generic(net, smc_net_id);
 	pnettable = &sn->pnettable;
 
-	write_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry_safe(pnetelem, tmp_pe, &pnettable->pnetlist, list) {
 		if (pnetelem->type == SMC_PNET_ETH && pnetelem->ndev == ndev) {
 			dev_put_track(pnetelem->ndev, &pnetelem->dev_tracker);
@@ -237,7 +237,7 @@ static int smc_pnet_remove_by_ndev(struct net_device *ndev)
 			break;
 		}
 	}
-	write_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 	return rc;
 }
 
@@ -370,7 +370,7 @@ static int smc_pnet_add_eth(struct smc_pnettable *pnettable, struct net *net,
 	strncpy(new_pe->eth_name, eth_name, IFNAMSIZ);
 	rc = -EEXIST;
 	new_netdev = true;
-	write_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(tmp_pe, &pnettable->pnetlist, list) {
 		if (tmp_pe->type == SMC_PNET_ETH &&
 		    !strncmp(tmp_pe->eth_name, eth_name, IFNAMSIZ)) {
@@ -385,9 +385,9 @@ static int smc_pnet_add_eth(struct smc_pnettable *pnettable, struct net *net,
 					     GFP_ATOMIC);
 		}
 		list_add_tail(&new_pe->list, &pnettable->pnetlist);
-		write_unlock(&pnettable->lock);
+		mutex_unlock(&pnettable->lock);
 	} else {
-		write_unlock(&pnettable->lock);
+		mutex_unlock(&pnettable->lock);
 		kfree(new_pe);
 		goto out_put;
 	}
@@ -448,7 +448,7 @@ static int smc_pnet_add_ib(struct smc_pnettable *pnettable, char *ib_name,
 	new_pe->ib_port = ib_port;
 
 	new_ibdev = true;
-	write_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(tmp_pe, &pnettable->pnetlist, list) {
 		if (tmp_pe->type == SMC_PNET_IB &&
 		    !strncmp(tmp_pe->ib_name, ib_name, IB_DEVICE_NAME_MAX)) {
@@ -458,9 +458,9 @@ static int smc_pnet_add_ib(struct smc_pnettable *pnettable, char *ib_name,
 	}
 	if (new_ibdev) {
 		list_add_tail(&new_pe->list, &pnettable->pnetlist);
-		write_unlock(&pnettable->lock);
+		mutex_unlock(&pnettable->lock);
 	} else {
-		write_unlock(&pnettable->lock);
+		mutex_unlock(&pnettable->lock);
 		kfree(new_pe);
 	}
 	return (new_ibdev) ? 0 : -EEXIST;
@@ -605,7 +605,7 @@ static int _smc_pnet_dump(struct net *net, struct sk_buff *skb, u32 portid,
 	pnettable = &sn->pnettable;
 
 	/* dump pnettable entries */
-	read_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(pnetelem, &pnettable->pnetlist, list) {
 		if (pnetid && !smc_pnet_match(pnetelem->pnet_name, pnetid))
 			continue;
@@ -620,7 +620,7 @@ static int _smc_pnet_dump(struct net *net, struct sk_buff *skb, u32 portid,
 			break;
 		}
 	}
-	read_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 	return idx;
 }
 
@@ -864,7 +864,7 @@ int smc_pnet_net_init(struct net *net)
 	struct smc_pnetids_ndev *pnetids_ndev = &sn->pnetids_ndev;
 
 	INIT_LIST_HEAD(&pnettable->pnetlist);
-	rwlock_init(&pnettable->lock);
+	mutex_init(&pnettable->lock);
 	INIT_LIST_HEAD(&pnetids_ndev->list);
 	rwlock_init(&pnetids_ndev->lock);
 
@@ -944,7 +944,7 @@ static int smc_pnet_find_ndev_pnetid_by_table(struct net_device *ndev,
 	sn = net_generic(net, smc_net_id);
 	pnettable = &sn->pnettable;
 
-	read_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(pnetelem, &pnettable->pnetlist, list) {
 		if (pnetelem->type == SMC_PNET_ETH && ndev == pnetelem->ndev) {
 			/* get pnetid of netdev device */
@@ -953,7 +953,7 @@ static int smc_pnet_find_ndev_pnetid_by_table(struct net_device *ndev,
 			break;
 		}
 	}
-	read_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 	return rc;
 }
 
@@ -1156,7 +1156,7 @@ int smc_pnetid_by_table_ib(struct smc_ib_device *smcibdev, u8 ib_port)
 	sn = net_generic(&init_net, smc_net_id);
 	pnettable = &sn->pnettable;
 
-	read_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(tmp_pe, &pnettable->pnetlist, list) {
 		if (tmp_pe->type == SMC_PNET_IB &&
 		    !strncmp(tmp_pe->ib_name, ib_name, IB_DEVICE_NAME_MAX) &&
@@ -1166,7 +1166,7 @@ int smc_pnetid_by_table_ib(struct smc_ib_device *smcibdev, u8 ib_port)
 			break;
 		}
 	}
-	read_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 
 	return rc;
 }
@@ -1185,7 +1185,7 @@ int smc_pnetid_by_table_smcd(struct smcd_dev *smcddev)
 	sn = net_generic(&init_net, smc_net_id);
 	pnettable = &sn->pnettable;
 
-	read_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(tmp_pe, &pnettable->pnetlist, list) {
 		if (tmp_pe->type == SMC_PNET_IB &&
 		    !strncmp(tmp_pe->ib_name, ib_name, IB_DEVICE_NAME_MAX)) {
@@ -1194,7 +1194,7 @@ int smc_pnetid_by_table_smcd(struct smcd_dev *smcddev)
 			break;
 		}
 	}
-	read_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 
 	return rc;
 }
diff --git a/net/smc/smc_pnet.h b/net/smc/smc_pnet.h
index 14039272f7e4..80a88eea4949 100644
--- a/net/smc/smc_pnet.h
+++ b/net/smc/smc_pnet.h
@@ -29,7 +29,7 @@ struct smc_link_group;
  * @pnetlist: List of PNETIDs
  */
 struct smc_pnettable {
-	rwlock_t lock;
+	struct mutex lock;
 	struct list_head pnetlist;
 };
 

