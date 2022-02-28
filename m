Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A98204C7685
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233391AbiB1SE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240230AbiB1SDT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:03:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008AD57490;
        Mon, 28 Feb 2022 09:46:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 73B5BCE17D1;
        Mon, 28 Feb 2022 17:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47202C340E7;
        Mon, 28 Feb 2022 17:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070374;
        bh=akJ9BNSMLrkTuZdNgGnq3DXFdrq53gMNLhFQRyzT/CI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VRUroKlhmhwHPGWXSg3cIKSzEgwKpWNwq4d8D3IC4Ucda4R0X4u3midlda+uMgRdu
         KEe3eEM9GylPyoeHt0xsusCHDZkykJ6uW9MDkCP7OhilXW8muVlR4AkYbkG1pBIi6f
         WlExjhHqGik8v4aRAhVKLLM8Xmk/OjHcJmJSWHtE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+4f322a6d84e991c38775@syzkaller.appspotmail.com,
        Tony Lu <tonylu@linux.alibaba.com>
Subject: [PATCH 5.16 085/164] net/smc: Use a mutex for locking "struct smc_pnettable"
Date:   Mon, 28 Feb 2022 18:24:07 +0100
Message-Id: <20220228172407.627246809@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio M. De Francesco <fmdefrancesco@gmail.com>

commit 7ff57e98fb78ad94edafbdc7435f2d745e9e6bb5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc_pnet.c |   42 +++++++++++++++++++++---------------------
 net/smc/smc_pnet.h |    2 +-
 2 files changed, 22 insertions(+), 22 deletions(-)

--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -112,7 +112,7 @@ static int smc_pnet_remove_by_pnetid(str
 	pnettable = &sn->pnettable;
 
 	/* remove table entry */
-	write_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry_safe(pnetelem, tmp_pe, &pnettable->pnetlist,
 				 list) {
 		if (!pnet_name ||
@@ -130,7 +130,7 @@ static int smc_pnet_remove_by_pnetid(str
 			rc = 0;
 		}
 	}
-	write_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 
 	/* if this is not the initial namespace, stop here */
 	if (net != &init_net)
@@ -191,7 +191,7 @@ static int smc_pnet_add_by_ndev(struct n
 	sn = net_generic(net, smc_net_id);
 	pnettable = &sn->pnettable;
 
-	write_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry_safe(pnetelem, tmp_pe, &pnettable->pnetlist, list) {
 		if (pnetelem->type == SMC_PNET_ETH && !pnetelem->ndev &&
 		    !strncmp(pnetelem->eth_name, ndev->name, IFNAMSIZ)) {
@@ -205,7 +205,7 @@ static int smc_pnet_add_by_ndev(struct n
 			break;
 		}
 	}
-	write_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 	return rc;
 }
 
@@ -223,7 +223,7 @@ static int smc_pnet_remove_by_ndev(struc
 	sn = net_generic(net, smc_net_id);
 	pnettable = &sn->pnettable;
 
-	write_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry_safe(pnetelem, tmp_pe, &pnettable->pnetlist, list) {
 		if (pnetelem->type == SMC_PNET_ETH && pnetelem->ndev == ndev) {
 			dev_put(pnetelem->ndev);
@@ -236,7 +236,7 @@ static int smc_pnet_remove_by_ndev(struc
 			break;
 		}
 	}
-	write_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 	return rc;
 }
 
@@ -371,7 +371,7 @@ static int smc_pnet_add_eth(struct smc_p
 
 	rc = -EEXIST;
 	new_netdev = true;
-	write_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(tmp_pe, &pnettable->pnetlist, list) {
 		if (tmp_pe->type == SMC_PNET_ETH &&
 		    !strncmp(tmp_pe->eth_name, eth_name, IFNAMSIZ)) {
@@ -381,9 +381,9 @@ static int smc_pnet_add_eth(struct smc_p
 	}
 	if (new_netdev) {
 		list_add_tail(&new_pe->list, &pnettable->pnetlist);
-		write_unlock(&pnettable->lock);
+		mutex_unlock(&pnettable->lock);
 	} else {
-		write_unlock(&pnettable->lock);
+		mutex_unlock(&pnettable->lock);
 		kfree(new_pe);
 		goto out_put;
 	}
@@ -444,7 +444,7 @@ static int smc_pnet_add_ib(struct smc_pn
 	new_pe->ib_port = ib_port;
 
 	new_ibdev = true;
-	write_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(tmp_pe, &pnettable->pnetlist, list) {
 		if (tmp_pe->type == SMC_PNET_IB &&
 		    !strncmp(tmp_pe->ib_name, ib_name, IB_DEVICE_NAME_MAX)) {
@@ -454,9 +454,9 @@ static int smc_pnet_add_ib(struct smc_pn
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
@@ -601,7 +601,7 @@ static int _smc_pnet_dump(struct net *ne
 	pnettable = &sn->pnettable;
 
 	/* dump pnettable entries */
-	read_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(pnetelem, &pnettable->pnetlist, list) {
 		if (pnetid && !smc_pnet_match(pnetelem->pnet_name, pnetid))
 			continue;
@@ -616,7 +616,7 @@ static int _smc_pnet_dump(struct net *ne
 			break;
 		}
 	}
-	read_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 	return idx;
 }
 
@@ -860,7 +860,7 @@ int smc_pnet_net_init(struct net *net)
 	struct smc_pnetids_ndev *pnetids_ndev = &sn->pnetids_ndev;
 
 	INIT_LIST_HEAD(&pnettable->pnetlist);
-	rwlock_init(&pnettable->lock);
+	mutex_init(&pnettable->lock);
 	INIT_LIST_HEAD(&pnetids_ndev->list);
 	rwlock_init(&pnetids_ndev->lock);
 
@@ -940,7 +940,7 @@ static int smc_pnet_find_ndev_pnetid_by_
 	sn = net_generic(net, smc_net_id);
 	pnettable = &sn->pnettable;
 
-	read_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(pnetelem, &pnettable->pnetlist, list) {
 		if (pnetelem->type == SMC_PNET_ETH && ndev == pnetelem->ndev) {
 			/* get pnetid of netdev device */
@@ -949,7 +949,7 @@ static int smc_pnet_find_ndev_pnetid_by_
 			break;
 		}
 	}
-	read_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 	return rc;
 }
 
@@ -1141,7 +1141,7 @@ int smc_pnetid_by_table_ib(struct smc_ib
 	sn = net_generic(&init_net, smc_net_id);
 	pnettable = &sn->pnettable;
 
-	read_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(tmp_pe, &pnettable->pnetlist, list) {
 		if (tmp_pe->type == SMC_PNET_IB &&
 		    !strncmp(tmp_pe->ib_name, ib_name, IB_DEVICE_NAME_MAX) &&
@@ -1151,7 +1151,7 @@ int smc_pnetid_by_table_ib(struct smc_ib
 			break;
 		}
 	}
-	read_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 
 	return rc;
 }
@@ -1170,7 +1170,7 @@ int smc_pnetid_by_table_smcd(struct smcd
 	sn = net_generic(&init_net, smc_net_id);
 	pnettable = &sn->pnettable;
 
-	read_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(tmp_pe, &pnettable->pnetlist, list) {
 		if (tmp_pe->type == SMC_PNET_IB &&
 		    !strncmp(tmp_pe->ib_name, ib_name, IB_DEVICE_NAME_MAX)) {
@@ -1179,7 +1179,7 @@ int smc_pnetid_by_table_smcd(struct smcd
 			break;
 		}
 	}
-	read_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 
 	return rc;
 }
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
 


