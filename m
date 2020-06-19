Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5922320173E
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395259AbgFSQgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:36:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389184AbgFSOtT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:49:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DBBA2158C;
        Fri, 19 Jun 2020 14:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578159;
        bh=pYNQcSSA8JE5e7nUhFvhxl8tYDixqAuawiEefCQhtHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q2LWXevVaPLWvn0Gnyp20dbgiURiwdV+Evp4UOlQT5hf9TPZnyWrLRnkK9TLaqHDT
         5qU0TO8/iKzg3NZXRWutKp5nVww9ki29ai2GgHxuGsmOThOPsksIBoLjOvVTrU/0b0
         gyYdBvoGz2Ck+9CMVa2/AMhlfoKiDuETIBzFwITs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 106/190] net: bcmgenet: set Rx mode before starting netif
Date:   Fri, 19 Jun 2020 16:32:31 +0200
Message-Id: <20200619141638.888122406@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit 72f96347628e73dbb61b307f18dd19293cc6792a ]

This commit explicitly calls the bcmgenet_set_rx_mode() function when
the network interface is started. This function is normally called by
ndo_set_rx_mode when the flags are changed, but apparently not when
the driver is suspended and resumed.

This change ensures that address filtering or promiscuous mode are
properly restored by the driver after the MAC may have been reset.

Fixes: b6e978e50444 ("net: bcmgenet: add suspend/resume callbacks")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 38391230ca86..7d3cbbd88a00 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -72,6 +72,9 @@
 #define GENET_RDMA_REG_OFF	(priv->hw_params->rdma_offset + \
 				TOTAL_DESC * DMA_DESC_SIZE)
 
+/* Forward declarations */
+static void bcmgenet_set_rx_mode(struct net_device *dev);
+
 static inline void bcmgenet_writel(u32 value, void __iomem *offset)
 {
 	/* MIPS chips strapped for BE will automagically configure the
@@ -2858,6 +2861,7 @@ static void bcmgenet_netif_start(struct net_device *dev)
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 
 	/* Start the network engine */
+	bcmgenet_set_rx_mode(dev);
 	bcmgenet_enable_rx_napi(priv);
 	bcmgenet_enable_tx_napi(priv);
 
-- 
2.25.1



