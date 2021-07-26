Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1447A3D61E7
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234287AbhGZPdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233126AbhGZPcU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:32:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0293A60F9F;
        Mon, 26 Jul 2021 16:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315957;
        bh=o+SLf9Ls0HdjLW1mh6856lRkkBgvRFiABTZNTIl3Cco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xa6Z2y8kVKyMROcc/2rSpr7qWlYGiiGKQWRM4TQ2Z89K11uFPZIhm73xMJT2S4iGx
         HzmklByUW73c6SG5Ik+tnOStbtDbhq/6/h7A2gbHZ1zv0iV/mQ8OPSzbYb4Pkl6tQW
         c/rTXTrdTIpeQH81FdzxBIiCL7mzI+0Pq3R/R5/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 132/223] ibmvnic: Remove the proper scrq flush
Date:   Mon, 26 Jul 2021 17:38:44 +0200
Message-Id: <20210726153850.567283764@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

[ Upstream commit bb55362bd6976631b662ca712779b6532d8de0a6 ]

Commit 65d6470d139a ("ibmvnic: clean pending indirect buffs during reset")
intended to remove the call to ibmvnic_tx_scrq_flush() when the
->resetting flag is true and was tested that way. But during the final
rebase to net-next, the hunk got applied to a block few lines below
(which happened to have the same diff context) and the wrong call to
ibmvnic_tx_scrq_flush() got removed.

Fix that by removing the correct ibmvnic_tx_scrq_flush() and restoring
the one that was incorrectly removed.

Fixes: 65d6470d139a ("ibmvnic: clean pending indirect buffs during reset")
Reported-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index efc98903c0b7..5b4a7ef7dffa 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1707,7 +1707,6 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		tx_send_failed++;
 		tx_dropped++;
 		ret = NETDEV_TX_OK;
-		ibmvnic_tx_scrq_flush(adapter, tx_scrq);
 		goto out;
 	}
 
@@ -1729,6 +1728,7 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		dev_kfree_skb_any(skb);
 		tx_send_failed++;
 		tx_dropped++;
+		ibmvnic_tx_scrq_flush(adapter, tx_scrq);
 		ret = NETDEV_TX_OK;
 		goto out;
 	}
-- 
2.30.2



