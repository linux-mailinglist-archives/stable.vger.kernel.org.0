Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38ED1BCBC2
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 21:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgD1S1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:27:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729064AbgD1S1q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:27:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0DF220B80;
        Tue, 28 Apr 2020 18:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098466;
        bh=DNcOpV0szsSX9D/2oFZXTbFZXuuiDI8hhGvLaGfA/B0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KYj6RS+Ug2SU+H6JXZndqp9v+zoV0Nkxg5x3jo7CzzYi1K7oxm4EsRib3Hc9Tloz0
         +qTH7nSNq9TaT9YmcrEa9FfyuYDXhuYfDTaEZR+7xooHr7Qzx2ASpVex7qRJrYT29h
         o9opzHW4yxiTtUApqie9+ewkfm4PT1NNEUj9QgRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 052/167] net: bcmgenet: correct per TX/RX ring statistics
Date:   Tue, 28 Apr 2020 20:23:48 +0200
Message-Id: <20200428182231.597256260@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit a6d0b83f25073bdf08b8547aeff961a62c6ab229 ]

The change to track net_device_stats per ring to better support SMP
missed updating the rx_dropped member.

The ndo_get_stats method is also needed to combine the results for
ethtool statistics (-S) before filling in the ethtool structure.

Fixes: 37a30b435b92 ("net: bcmgenet: Track per TX/RX rings statistics")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -938,6 +938,8 @@ static void bcmgenet_get_ethtool_stats(s
 	if (netif_running(dev))
 		bcmgenet_update_mib_counters(priv);
 
+	dev->netdev_ops->ndo_get_stats(dev);
+
 	for (i = 0; i < BCMGENET_STATS_LEN; i++) {
 		const struct bcmgenet_stats *s;
 		char *p;
@@ -3142,6 +3144,7 @@ static struct net_device_stats *bcmgenet
 	dev->stats.rx_packets = rx_packets;
 	dev->stats.rx_errors = rx_errors;
 	dev->stats.rx_missed_errors = rx_errors;
+	dev->stats.rx_dropped = rx_dropped;
 	return &dev->stats;
 }
 


