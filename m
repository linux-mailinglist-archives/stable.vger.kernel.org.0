Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076F31E2E7D
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389980AbgEZTB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:01:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391017AbgEZTB5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:01:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E89B020849;
        Tue, 26 May 2020 19:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519716;
        bh=QerE36CISrCUueRSxCUY/hNwSK8W+jL8bcRw33Mi5pY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fY0yXwzoCDP18UZUCFzSjwiUkWCAGWkDB6Bi/yeWSUVCxLt4wkmDlf8anv1oMSS/X
         OB7yv9dbymKADB8Gc8Y2u2ZfudNB4fq8/8NUSQBUmjH8153IHm67de2cMaaw+37YyR
         UzwtpZP3bYIEzXSHmvN6miGu+mn9gFzYZbGvCDqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arjun Vynipadath <arjun@chelsio.com>,
        Casey Leedom <leedom@chelsio.com>,
        Ganesh Goudar <ganeshgr@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 48/59] cxgb4/cxgb4vf: Fix mac_hlist initialization and free
Date:   Tue, 26 May 2020 20:53:33 +0200
Message-Id: <20200526183922.214934912@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183907.123822792@linuxfoundation.org>
References: <20200526183907.123822792@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arjun Vynipadath <arjun@chelsio.com>

[ Upstream commit b539ea60f5043b9acd7562f04fa2117f18776cbb ]

Null pointer dereference seen when cxgb4vf driver is unloaded
without bringing up any interfaces, moving mac_hlist initialization
to driver probe and free the mac_hlist in remove to fix the issue.

Fixes: 24357e06ba51 ("cxgb4vf: fix memleak in mac_hlist initialization")
Signed-off-by: Arjun Vynipadath <arjun@chelsio.com>
Signed-off-by: Casey Leedom <leedom@chelsio.com>
Signed-off-by: Ganesh Goudar <ganeshgr@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 19 ++++++++++---------
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |  6 +++---
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 9d1438c3c3ca..6eb65b870da7 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -2241,8 +2241,6 @@ static int cxgb_up(struct adapter *adap)
 #if IS_ENABLED(CONFIG_IPV6)
 	update_clip(adap);
 #endif
-	/* Initialize hash mac addr list*/
-	INIT_LIST_HEAD(&adap->mac_hlist);
 	return err;
 
  irq_err:
@@ -2256,8 +2254,6 @@ static int cxgb_up(struct adapter *adap)
 
 static void cxgb_down(struct adapter *adapter)
 {
-	struct hash_mac_addr *entry, *tmp;
-
 	cancel_work_sync(&adapter->tid_release_task);
 	cancel_work_sync(&adapter->db_full_task);
 	cancel_work_sync(&adapter->db_drop_task);
@@ -2267,11 +2263,6 @@ static void cxgb_down(struct adapter *adapter)
 	t4_sge_stop(adapter);
 	t4_free_sge_resources(adapter);
 
-	list_for_each_entry_safe(entry, tmp, &adapter->mac_hlist, list) {
-		list_del(&entry->list);
-		kfree(entry);
-	}
-
 	adapter->flags &= ~FULL_INIT_DONE;
 }
 
@@ -4970,6 +4961,9 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			     (is_t5(adapter->params.chip) ? STATMODE_V(0) :
 			      T6_STATMODE_V(0)));
 
+	/* Initialize hash mac addr list */
+	INIT_LIST_HEAD(&adapter->mac_hlist);
+
 	for_each_port(adapter, i) {
 		netdev = alloc_etherdev_mq(sizeof(struct port_info),
 					   MAX_ETH_QSETS);
@@ -5260,6 +5254,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 static void remove_one(struct pci_dev *pdev)
 {
 	struct adapter *adapter = pci_get_drvdata(pdev);
+	struct hash_mac_addr *entry, *tmp;
 
 	if (!adapter) {
 		pci_release_regions(pdev);
@@ -5303,6 +5298,12 @@ static void remove_one(struct pci_dev *pdev)
 		if (adapter->num_uld || adapter->num_ofld_uld)
 			t4_uld_mem_free(adapter);
 		free_some_resources(adapter);
+		list_for_each_entry_safe(entry, tmp, &adapter->mac_hlist,
+					 list) {
+			list_del(&entry->list);
+			kfree(entry);
+		}
+
 #if IS_ENABLED(CONFIG_IPV6)
 		t4_cleanup_clip_tbl(adapter);
 #endif
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 26ba18ea08c6..fa116f0a107d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -715,9 +715,6 @@ static int adapter_up(struct adapter *adapter)
 		if (adapter->flags & USING_MSIX)
 			name_msix_vecs(adapter);
 
-		/* Initialize hash mac addr list*/
-		INIT_LIST_HEAD(&adapter->mac_hlist);
-
 		adapter->flags |= FULL_INIT_DONE;
 	}
 
@@ -2936,6 +2933,9 @@ static int cxgb4vf_pci_probe(struct pci_dev *pdev,
 	if (err)
 		goto err_unmap_bar;
 
+	/* Initialize hash mac addr list */
+	INIT_LIST_HEAD(&adapter->mac_hlist);
+
 	/*
 	 * Allocate our "adapter ports" and stitch everything together.
 	 */
-- 
2.25.1



