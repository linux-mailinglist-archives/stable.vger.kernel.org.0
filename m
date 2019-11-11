Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34409F7E45
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730163AbfKKSrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:47:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:40674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730165AbfKKSrq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:47:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E38AD20674;
        Mon, 11 Nov 2019 18:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498065;
        bh=Jqt1Gi9SzAMnpm04RMBrV0CAWrrPaBXApozrHbehwBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ij7hOsLMltP5FR2/0W/GQSzxgtx8Zjypx1BYvd8bSsx5sbDV+qLhQZm4vSdwZFeCZ
         9IP9b2zRNRvOMUuIiJ///YE2SkgXzhZ4czpSLwlpAK+dtF/S5AvNM3GqX9bAK1J67R
         lIIf2VSCv8dFaCa8wQOSEvV1BXJ1VYpBY4pQb+fU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 013/193] net: mscc: ocelot: dont handle netdev events for other netdevs
Date:   Mon, 11 Nov 2019 19:26:35 +0100
Message-Id: <20191111181500.925510047@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>

[ Upstream commit 7afb3e575e5aa9f5a200a3eb3f45d8130f6d6601 ]

The check that the event is actually for this device should be moved
from the "port" handler to the net device handler.

Otherwise the port handler will deny bonding configuration for other
net devices in the same system (like enetc in the LS1028A) that don't
have the lag_upper_info->tx_type restriction that ocelot has.

Fixes: dc96ee3730fc ("net: mscc: ocelot: add bonding support")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mscc/ocelot.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1499,9 +1499,6 @@ static int ocelot_netdevice_port_event(s
 	struct ocelot_port *ocelot_port = netdev_priv(dev);
 	int err = 0;
 
-	if (!ocelot_netdevice_dev_check(dev))
-		return 0;
-
 	switch (event) {
 	case NETDEV_CHANGEUPPER:
 		if (netif_is_bridge_master(info->upper_dev)) {
@@ -1538,6 +1535,9 @@ static int ocelot_netdevice_event(struct
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	int ret = 0;
 
+	if (!ocelot_netdevice_dev_check(dev))
+		return 0;
+
 	if (event == NETDEV_PRECHANGEUPPER &&
 	    netif_is_lag_master(info->upper_dev)) {
 		struct netdev_lag_upper_info *lag_upper_info = info->upper_info;


