Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59CC22E41E8
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438117AbgL1OGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:06:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:40964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438030AbgL1OGZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:06:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6140020791;
        Mon, 28 Dec 2020 14:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164345;
        bh=JbWe6qSVwitlPQ+Pm52RIbChupxTdkNohd7NcGW6PJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pCBbsqw8FXXPPvOy1KfW/YMsZ3979mRvOYloiP7bWMum6BeU1b+UAFBQ+DCKAZAec
         EVYKGNg74nIACNedbjfOrWWdYzLJytl+h7onEQvnDq4/kmX/poTdeaFyQZp/dy8mEm
         CyAqjKywCsYw2VH0DyPoDAdGFBrJ2+S/NM4Ta8wM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/717] ionic: flatten calls to ionic_lif_rx_mode
Date:   Mon, 28 Dec 2020 13:41:54 +0100
Message-Id: <20201228125026.520493831@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit e94f76bb206333efcd0c02da5dbb142518c941a2 ]

The _ionic_lif_rx_mode() is only used once and really doesn't
need to be broken out.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 38 ++++++++-----------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 724df18400165..7ad9f0cc1af66 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1129,29 +1129,10 @@ static void ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode)
 		lif->rx_mode = rx_mode;
 }
 
-static void _ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode,
-			       bool from_ndo)
-{
-	struct ionic_deferred_work *work;
-
-	if (from_ndo) {
-		work = kzalloc(sizeof(*work), GFP_ATOMIC);
-		if (!work) {
-			netdev_err(lif->netdev, "%s OOM\n", __func__);
-			return;
-		}
-		work->type = IONIC_DW_TYPE_RX_MODE;
-		work->rx_mode = rx_mode;
-		netdev_dbg(lif->netdev, "deferred: rx_mode\n");
-		ionic_lif_deferred_enqueue(&lif->deferred, work);
-	} else {
-		ionic_lif_rx_mode(lif, rx_mode);
-	}
-}
-
 static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic_deferred_work *work;
 	unsigned int nfilters;
 	unsigned int rx_mode;
 
@@ -1197,8 +1178,21 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 			rx_mode &= ~IONIC_RX_MODE_F_ALLMULTI;
 	}
 
-	if (lif->rx_mode != rx_mode)
-		_ionic_lif_rx_mode(lif, rx_mode, from_ndo);
+	if (lif->rx_mode != rx_mode) {
+		if (from_ndo) {
+			work = kzalloc(sizeof(*work), GFP_ATOMIC);
+			if (!work) {
+				netdev_err(lif->netdev, "%s OOM\n", __func__);
+				return;
+			}
+			work->type = IONIC_DW_TYPE_RX_MODE;
+			work->rx_mode = rx_mode;
+			netdev_dbg(lif->netdev, "deferred: rx_mode\n");
+			ionic_lif_deferred_enqueue(&lif->deferred, work);
+		} else {
+			ionic_lif_rx_mode(lif, rx_mode);
+		}
+	}
 }
 
 static void ionic_ndo_set_rx_mode(struct net_device *netdev)
-- 
2.27.0



