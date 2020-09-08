Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304DA261C15
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731031AbgIHTOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:14:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:51456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731150AbgIHQEw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:04:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B61D23CD1;
        Tue,  8 Sep 2020 15:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579410;
        bh=m0EkC3LB0nRS7zzMWOb9uc6wlsQbXOdrGQV5pLwvbfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uOYAPPSqkyIJVzB+J0XM6dSXQ657Ow9LWeAHOCWlwGdAxkFdMY9lhXKXWCHeM22BC
         rUddlY/VHnIhqORmV/zT0yrmnnX9PQMmLzO4aYL7b51/TEYbCU8QDfuENa8uifr+xz
         YrGzsS1os4lHUmudVCiQBAepkG/EknYcIAXyKxS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Murali Karicheri <m-karicheri2@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 066/186] net: ethernet: ti: cpsw_new: fix clean up of vlan mc entries for host port
Date:   Tue,  8 Sep 2020 17:23:28 +0200
Message-Id: <20200908152244.858006008@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Murali Karicheri <m-karicheri2@ti.com>

[ Upstream commit 2c6500e82e5190b038f0b79f85a20da55bdd4b86 ]

To flush the vid + mc entries from ALE, which is required when a VLAN
interface is removed, driver needs to call cpsw_ale_flush_multicast()
with ALE_PORT_HOST for port mask as these entries are added only for
host port. Without this, these entries remain in the ALE table even
after removing the VLAN interface. cpsw_ale_flush_multicast() calls
cpsw_ale_flush_mcast which expects a port mask to do the job.

Fixes: ed3525eda4c4 ("net: ethernet: ti: introduce cpsw switchdev based driver part 1 - dual-emac")
Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/cpsw_new.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 1247d35d42ef3..8d0a2bc7128d4 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1044,7 +1044,7 @@ static int cpsw_ndo_vlan_rx_kill_vid(struct net_device *ndev,
 			   HOST_PORT_NUM, ALE_VLAN, vid);
 	cpsw_ale_del_mcast(cpsw->ale, priv->ndev->broadcast,
 			   0, ALE_VLAN, vid);
-	cpsw_ale_flush_multicast(cpsw->ale, 0, vid);
+	cpsw_ale_flush_multicast(cpsw->ale, ALE_PORT_HOST, vid);
 err:
 	pm_runtime_put(cpsw->dev);
 	return ret;
-- 
2.25.1



