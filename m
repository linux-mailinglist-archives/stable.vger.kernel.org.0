Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5136303318
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbhAZEqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:46:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:59200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726841AbhAYSnZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:43:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 481D2224B8;
        Mon, 25 Jan 2021 18:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600168;
        bh=GbKiPl4FrLdmNGuDrJtuO/IkvXwmqiodDztJthqRBmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AfasrGnxryG746IxlO1ozZbK2LOxrD8DJc3p7ziSJLQhx2Uyxuq1LQQgOEslBldgo
         0gnijRnR/0ill/tSfBou28s/Ow5poK3GIuNp634HBRYA+FDbUiSNvK92C29N3ftPS5
         jeGav3UJsF6mSTIFhzSbFOdm9wsweGHQ5OQ9YpVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 56/58] net: mscc: ocelot: allow offloading of bridge on top of LAG
Date:   Mon, 25 Jan 2021 19:39:57 +0100
Message-Id: <20210125183159.100401355@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
References: <20210125183156.702907356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 79267ae22615496655feee2db0848f6786bcf67a upstream.

The blamed commit was too aggressive, and it made ocelot_netdevice_event
react only to network interface events emitted for the ocelot switch
ports.

In fact, only the PRECHANGEUPPER should have had that check.

When we ignore all events that are not for us, we miss the fact that the
upper of the LAG changes, and the bonding interface gets enslaved to a
bridge. This is an operation we could offload under certain conditions.

Fixes: 7afb3e575e5a ("net: mscc: ocelot: don't handle netdev events for other netdevs")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210118135210.2666246-1-olteanv@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mscc/ocelot.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1549,10 +1549,8 @@ static int ocelot_netdevice_event(struct
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	int ret = 0;
 
-	if (!ocelot_netdevice_dev_check(dev))
-		return 0;
-
 	if (event == NETDEV_PRECHANGEUPPER &&
+	    ocelot_netdevice_dev_check(dev) &&
 	    netif_is_lag_master(info->upper_dev)) {
 		struct netdev_lag_upper_info *lag_upper_info = info->upper_info;
 		struct netlink_ext_ack *extack;


