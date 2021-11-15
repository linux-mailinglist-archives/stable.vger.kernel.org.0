Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0472450FBB
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241881AbhKOSgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:36:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:42476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242241AbhKOSe7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:34:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6172063469;
        Mon, 15 Nov 2021 18:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999271;
        bh=HOgw2nna1IcTt56k1yWLpiLuN2uFcgNZ3Lwy++j4nXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qUjk0tzTk+M8OF7NYqRJpMC8EGQCmOEyJC9lLpKjQVL5icrEWT1Jp5p4dWlHf2HPs
         0atAPyVhmJYIHfM11DtPiVTrjHd21acZZUUApJ13tnl9xziCvS38fwF4YznB6hoyjS
         aB8aMPHoURornlfyKIczpvKLe1EqQ8QzdT+WV+c4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rakesh Babu <rsaladi2@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 237/849] octeontx2-pf: Enable promisc/allmulti match MCAM entries.
Date:   Mon, 15 Nov 2021 17:55:20 +0100
Message-Id: <20211115165428.213699407@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rakesh Babu <rsaladi2@marvell.com>

[ Upstream commit ffd2f89ad05cd620d822112a07b0c5669fa9e333 ]

Whenever the interface is brought up/down then set_rx_mode
function is called by the stack which enables promisc/allmulti
MCAM entries. But there are cases when driver brings
interface down and then up such as while changing number
of channels. In these cases promisc/allmulti MCAM entries
are left disabled as set_rx_mode callback is not called.
This patch enables these MCAM entries in all such cases.

Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  | 78 ++++++++++---------
 1 file changed, 43 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 2c24944a4dba2..105b32221d91b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1496,6 +1496,44 @@ static void otx2_free_hw_resources(struct otx2_nic *pf)
 	mutex_unlock(&mbox->lock);
 }
 
+static void otx2_do_set_rx_mode(struct otx2_nic *pf)
+{
+	struct net_device *netdev = pf->netdev;
+	struct nix_rx_mode *req;
+	bool promisc = false;
+
+	if (!(netdev->flags & IFF_UP))
+		return;
+
+	if ((netdev->flags & IFF_PROMISC) ||
+	    (netdev_uc_count(netdev) > OTX2_MAX_UNICAST_FLOWS)) {
+		promisc = true;
+	}
+
+	/* Write unicast address to mcam entries or del from mcam */
+	if (!promisc && netdev->priv_flags & IFF_UNICAST_FLT)
+		__dev_uc_sync(netdev, otx2_add_macfilter, otx2_del_macfilter);
+
+	mutex_lock(&pf->mbox.lock);
+	req = otx2_mbox_alloc_msg_nix_set_rx_mode(&pf->mbox);
+	if (!req) {
+		mutex_unlock(&pf->mbox.lock);
+		return;
+	}
+
+	req->mode = NIX_RX_MODE_UCAST;
+
+	if (promisc)
+		req->mode |= NIX_RX_MODE_PROMISC;
+	if (netdev->flags & (IFF_ALLMULTI | IFF_MULTICAST))
+		req->mode |= NIX_RX_MODE_ALLMULTI;
+
+	req->mode |= NIX_RX_MODE_USE_MCE;
+
+	otx2_sync_mbox_msg(&pf->mbox);
+	mutex_unlock(&pf->mbox.lock);
+}
+
 int otx2_open(struct net_device *netdev)
 {
 	struct otx2_nic *pf = netdev_priv(netdev);
@@ -1657,6 +1695,8 @@ int otx2_open(struct net_device *netdev)
 	if (err)
 		goto err_tx_stop_queues;
 
+	otx2_do_set_rx_mode(pf);
+
 	return 0;
 
 err_tx_stop_queues:
@@ -1809,43 +1849,11 @@ static void otx2_set_rx_mode(struct net_device *netdev)
 	queue_work(pf->otx2_wq, &pf->rx_mode_work);
 }
 
-static void otx2_do_set_rx_mode(struct work_struct *work)
+static void otx2_rx_mode_wrk_handler(struct work_struct *work)
 {
 	struct otx2_nic *pf = container_of(work, struct otx2_nic, rx_mode_work);
-	struct net_device *netdev = pf->netdev;
-	struct nix_rx_mode *req;
-	bool promisc = false;
-
-	if (!(netdev->flags & IFF_UP))
-		return;
-
-	if ((netdev->flags & IFF_PROMISC) ||
-	    (netdev_uc_count(netdev) > OTX2_MAX_UNICAST_FLOWS)) {
-		promisc = true;
-	}
 
-	/* Write unicast address to mcam entries or del from mcam */
-	if (!promisc && netdev->priv_flags & IFF_UNICAST_FLT)
-		__dev_uc_sync(netdev, otx2_add_macfilter, otx2_del_macfilter);
-
-	mutex_lock(&pf->mbox.lock);
-	req = otx2_mbox_alloc_msg_nix_set_rx_mode(&pf->mbox);
-	if (!req) {
-		mutex_unlock(&pf->mbox.lock);
-		return;
-	}
-
-	req->mode = NIX_RX_MODE_UCAST;
-
-	if (promisc)
-		req->mode |= NIX_RX_MODE_PROMISC;
-	if (netdev->flags & (IFF_ALLMULTI | IFF_MULTICAST))
-		req->mode |= NIX_RX_MODE_ALLMULTI;
-
-	req->mode |= NIX_RX_MODE_USE_MCE;
-
-	otx2_sync_mbox_msg(&pf->mbox);
-	mutex_unlock(&pf->mbox.lock);
+	otx2_do_set_rx_mode(pf);
 }
 
 static int otx2_set_features(struct net_device *netdev,
@@ -2345,7 +2353,7 @@ static int otx2_wq_init(struct otx2_nic *pf)
 	if (!pf->otx2_wq)
 		return -ENOMEM;
 
-	INIT_WORK(&pf->rx_mode_work, otx2_do_set_rx_mode);
+	INIT_WORK(&pf->rx_mode_work, otx2_rx_mode_wrk_handler);
 	INIT_WORK(&pf->reset_task, otx2_reset_task);
 	return 0;
 }
-- 
2.33.0



