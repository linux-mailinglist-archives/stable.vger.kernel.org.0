Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9174200E76
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391655AbgFSPH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:07:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391663AbgFSPH5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:07:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EB0E20776;
        Fri, 19 Jun 2020 15:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579277;
        bh=p1wM2NM1idP8WzPTc5gRJuze3vYXKEUCpSW95/QBnjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n6onlDLLUqx0pY57LutYpLeDryMYn7V/ona64cGuWaGPRpcml8rLnUAbqyNlS+YAn
         sHSTUFJGCM30/Ibxl9Qt2HWauZaBo7SB5psyyVyWfFkElLKMEz64A6m+N1fkciPoVb
         1HOVuZRFbV27Hy3wnAjc9U9nuNasN/mn6zjZQ9oo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 075/261] dpaa2-eth: fix return codes used in ndo_setup_tc
Date:   Fri, 19 Jun 2020 16:31:26 +0200
Message-Id: <20200619141653.490453111@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

[ Upstream commit b89c1e6bdc73f5775e118eb2ab778e75b262b30c ]

Drivers ndo_setup_tc call should return -EOPNOTSUPP, when it cannot
support the qdisc type. Other return values will result in failing the
qdisc setup.  This lead to qdisc noop getting assigned, which will
drop all TX packets on the interface.

Fixes: ab1e6de2bd49 ("dpaa2-eth: Add mqprio support")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index a935b20effa3..3177dd8ede8e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1981,7 +1981,7 @@ static int dpaa2_eth_setup_tc(struct net_device *net_dev,
 	int i;
 
 	if (type != TC_SETUP_QDISC_MQPRIO)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	mqprio->hw = TC_MQPRIO_HW_OFFLOAD_TCS;
 	num_queues = dpaa2_eth_queue_count(priv);
@@ -1993,7 +1993,7 @@ static int dpaa2_eth_setup_tc(struct net_device *net_dev,
 	if (num_tc  > dpaa2_eth_tc_count(priv)) {
 		netdev_err(net_dev, "Max %d traffic classes supported\n",
 			   dpaa2_eth_tc_count(priv));
-		return -EINVAL;
+		return -EOPNOTSUPP;
 	}
 
 	if (!num_tc) {
-- 
2.25.1



