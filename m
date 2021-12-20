Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED2147AF2C
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239106AbhLTPKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:10:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238843AbhLTPJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:09:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FACEC0A8872;
        Mon, 20 Dec 2021 06:54:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A29AC611BB;
        Mon, 20 Dec 2021 14:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C45C36AE8;
        Mon, 20 Dec 2021 14:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012056;
        bh=L06h4TiPnEotPN64EPakpJLQoezTJhwzk2qaegn4ZBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FUniB9HMbtCZI+Ausjx2R8pc0CmKUHHftUzNw4KdLo8yv0qWWIEOYli7n/S9aHewl
         zQAToC3pfpRCzPjQF/c1WPACd32laA06ZTTBZdFCHiiWoI5kRdrdkAmDm3iQvavKgY
         OK9+6VCXLWJ6a92wZIHrvBs6gmmm2FK4MiOA8f3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filip Pokryvka <fpokryvk@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/177] netdevsim: dont overwrite read only ethtool parms
Date:   Mon, 20 Dec 2021 15:33:33 +0100
Message-Id: <20211220143042.225368719@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filip Pokryvka <fpokryvk@redhat.com>

[ Upstream commit ee60e626d536da4c710b3634afe68fe7c6d69b59 ]

Ethtool ring feature has _max_pending attributes read-only.
Set only read-write attributes in nsim_set_ringparam.

This patch is useful, if netdevsim device is set-up using NetworkManager,
because NetworkManager sends 0 as MAX values, as it is pointless to
retrieve them in extra call, because they should be read-only. Then,
the device is left in incosistent state (value > MAX).

Fixes: a7fc6db099b5 ("netdevsim: support ethtool ring and coalesce settings")
Signed-off-by: Filip Pokryvka <fpokryvk@redhat.com>
Link: https://lore.kernel.org/r/20211210175032.411872-1-fpokryvk@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/ethtool.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/ethtool.c b/drivers/net/netdevsim/ethtool.c
index b03a0513eb7e7..2e7c1cc16cb93 100644
--- a/drivers/net/netdevsim/ethtool.c
+++ b/drivers/net/netdevsim/ethtool.c
@@ -77,7 +77,10 @@ static int nsim_set_ringparam(struct net_device *dev,
 {
 	struct netdevsim *ns = netdev_priv(dev);
 
-	memcpy(&ns->ethtool.ring, ring, sizeof(ns->ethtool.ring));
+	ns->ethtool.ring.rx_pending = ring->rx_pending;
+	ns->ethtool.ring.rx_jumbo_pending = ring->rx_jumbo_pending;
+	ns->ethtool.ring.rx_mini_pending = ring->rx_mini_pending;
+	ns->ethtool.ring.tx_pending = ring->tx_pending;
 	return 0;
 }
 
-- 
2.33.0



