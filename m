Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3501236BD
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbfLQULU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:11:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:37814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728685AbfLQULR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:11:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27164206D7;
        Tue, 17 Dec 2019 20:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576613476;
        bh=JhLQk5eB6cGLnd5VD/bDqYe5M3ZgaacSg/f5ubenojc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iWBwS7MLZhd5cyxt/dYpDWWO66Y4bnYjw3JoPeWi8CGCJK/gj1m2kiPjsEQFxOlS1
         CWqCxb7Seuwx/NQ3NXmsjutKfNnXQnAMb/SGfPjCF7Ni/bdp0Z5YvEZlFTqb75IA6D
         YX0vextFuCUuMdZD9gtyiQv0e2oZpoIp2j5taXT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 35/37] ionic: keep users rss hash across lif reset
Date:   Tue, 17 Dec 2019 21:09:56 +0100
Message-Id: <20191217200735.306626253@linuxfoundation.org>
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

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit ffac2027e18f006f42630f2e01a8a9bd8dc664b5 ]

If the user has specified their own RSS hash key, don't
lose it across queue resets such as DOWN/UP, MTU change,
and number of channels change.  This is fixed by moving
the key initialization to a little earlier in the lif
creation.

Also, let's clean up the RSS config a little better on
the way down by setting it all to 0.

Fixes: aa3198819bea ("ionic: Add RSS support")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1364,12 +1364,9 @@ int ionic_lif_rss_config(struct ionic_li
 
 static int ionic_lif_rss_init(struct ionic_lif *lif)
 {
-	u8 rss_key[IONIC_RSS_HASH_KEY_SIZE];
 	unsigned int tbl_sz;
 	unsigned int i;
 
-	netdev_rss_key_fill(rss_key, IONIC_RSS_HASH_KEY_SIZE);
-
 	lif->rss_types = IONIC_RSS_TYPE_IPV4     |
 			 IONIC_RSS_TYPE_IPV4_TCP |
 			 IONIC_RSS_TYPE_IPV4_UDP |
@@ -1382,12 +1379,18 @@ static int ionic_lif_rss_init(struct ion
 	for (i = 0; i < tbl_sz; i++)
 		lif->rss_ind_tbl[i] = ethtool_rxfh_indir_default(i, lif->nxqs);
 
-	return ionic_lif_rss_config(lif, lif->rss_types, rss_key, NULL);
+	return ionic_lif_rss_config(lif, lif->rss_types, NULL, NULL);
 }
 
-static int ionic_lif_rss_deinit(struct ionic_lif *lif)
+static void ionic_lif_rss_deinit(struct ionic_lif *lif)
 {
-	return ionic_lif_rss_config(lif, 0x0, NULL, NULL);
+	int tbl_sz;
+
+	tbl_sz = le16_to_cpu(lif->ionic->ident.lif.eth.rss_ind_tbl_sz);
+	memset(lif->rss_ind_tbl, 0, tbl_sz);
+	memset(lif->rss_hash_key, 0, IONIC_RSS_HASH_KEY_SIZE);
+
+	ionic_lif_rss_config(lif, 0x0, NULL, NULL);
 }
 
 static void ionic_txrx_disable(struct ionic_lif *lif)
@@ -1710,6 +1713,7 @@ static struct ionic_lif *ionic_lif_alloc
 		dev_err(dev, "Failed to allocate rss indirection table, aborting\n");
 		goto err_out_free_qcqs;
 	}
+	netdev_rss_key_fill(lif->rss_hash_key, IONIC_RSS_HASH_KEY_SIZE);
 
 	list_add_tail(&lif->list, &ionic->lifs);
 


