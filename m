Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A8620133C
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392797AbgFSP7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:59:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392231AbgFSPTN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:19:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A402206DB;
        Fri, 19 Jun 2020 15:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579952;
        bh=gumFx8A5m9fNWLYnCaEu3mPXlkEB5qOQe53IV6HBUdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K1/EApPnkQCuD6aat2G/dz9EfYZ8Chg0FmpSyX5vVcvcpnB7RpooYl2Evm7OCWGCG
         UP5XUTc7OjuksVD8N1VM/gkm4RMTgcT/3qBug6bRnjq9yDAvNGScqE7mK67VKhddeq
         EC7apRz2TG6V+RhWS8FPUW+ZXaY6s8H1LA1m1MEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthias Schiffer <mschiffer@universe-factory.net>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 066/376] batman-adv: Revert "disable ethtool link speed detection when auto negotiation off"
Date:   Fri, 19 Jun 2020 16:29:44 +0200
Message-Id: <20200619141713.479391020@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit 9ad346c90509ebd983f60da7d082f261ad329507 ]

The commit 8c46fcd78308 ("batman-adv: disable ethtool link speed detection
when auto negotiation off") disabled the usage of ethtool's link_ksetting
when auto negotation was enabled due to invalid values when used with
tun/tap virtual net_devices. According to the patch, automatic measurements
should be used for these kind of interfaces.

But there are major flaws with this argumentation:

* automatic measurements are not implemented
* auto negotiation has nothing to do with the validity of the retrieved
  values

The first point has to be fixed by a longer patch series. The "validity"
part of the second point must be addressed in the same patch series by
dropping the usage of ethtool's link_ksetting (thus always doing automatic
measurements over ethernet).

Drop the patch again to have more default values for various net_device
types/configurations. The user can still overwrite them using the
batadv_hardif's BATADV_ATTR_THROUGHPUT_OVERRIDE.

Reported-by: Matthias Schiffer <mschiffer@universe-factory.net>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bat_v_elp.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/net/batman-adv/bat_v_elp.c b/net/batman-adv/bat_v_elp.c
index 1e3172db7492..955e0b8960d6 100644
--- a/net/batman-adv/bat_v_elp.c
+++ b/net/batman-adv/bat_v_elp.c
@@ -127,20 +127,7 @@ static u32 batadv_v_elp_get_throughput(struct batadv_hardif_neigh_node *neigh)
 	rtnl_lock();
 	ret = __ethtool_get_link_ksettings(hard_iface->net_dev, &link_settings);
 	rtnl_unlock();
-
-	/* Virtual interface drivers such as tun / tap interfaces, VLAN, etc
-	 * tend to initialize the interface throughput with some value for the
-	 * sake of having a throughput number to export via ethtool. This
-	 * exported throughput leaves batman-adv to conclude the interface
-	 * throughput is genuine (reflecting reality), thus no measurements
-	 * are necessary.
-	 *
-	 * Based on the observation that those interface types also tend to set
-	 * the link auto-negotiation to 'off', batman-adv shall check this
-	 * setting to differentiate between genuine link throughput information
-	 * and placeholders installed by virtual interfaces.
-	 */
-	if (ret == 0 && link_settings.base.autoneg == AUTONEG_ENABLE) {
+	if (ret == 0) {
 		/* link characteristics might change over time */
 		if (link_settings.base.duplex == DUPLEX_FULL)
 			hard_iface->bat_v.flags |= BATADV_FULL_DUPLEX;
-- 
2.25.1



