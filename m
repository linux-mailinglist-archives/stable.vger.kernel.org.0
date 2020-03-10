Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 606DA17FD0F
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729724AbgCJM5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729722AbgCJM5F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:57:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1FC02467D;
        Tue, 10 Mar 2020 12:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845025;
        bh=O8M0UxYEElgHRTmYYJTT3lqNTy9zE5COXglMi4UPNbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D9B1jDImhzhkSgUk/vv+gZwgErfLDTu6JOH5WTsE8u+LiRW6xc1JO/Yxsh1vUg0wd
         TM98GZBAfMFQVM9dEFIH6Haqj4iWRDWTG11ZV8CHsav0dQ/lWXj7fV10jyq7RNNQOz
         NsmdwgwcGJ35K5O+Nx+11fyyV3/5zJ2Z5p6Jgf9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 006/189] net: dsa: bcm_sf2: Forcibly configure IMP port for 1Gb/sec
Date:   Tue, 10 Mar 2020 13:37:23 +0100
Message-Id: <20200310123640.207910814@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 98c5f7d44fef309e692c24c6d71131ee0f0871fb ]

We are still experiencing some packet loss with the existing advanced
congestion buffering (ACB) settings with the IMP port configured for
2Gb/sec, so revert to conservative link speeds that do not produce
packet loss until this is resolved.

Fixes: 8f1880cbe8d0 ("net: dsa: bcm_sf2: Configure IMP port for 2Gb/sec")
Fixes: de34d7084edd ("net: dsa: bcm_sf2: Only 7278 supports 2Gb/sec IMP port")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/bcm_sf2.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index d1955543acd1d..b0f5280a83cb6 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -69,8 +69,7 @@ static void bcm_sf2_imp_setup(struct dsa_switch *ds, int port)
 		/* Force link status for IMP port */
 		reg = core_readl(priv, offset);
 		reg |= (MII_SW_OR | LINK_STS);
-		if (priv->type == BCM7278_DEVICE_ID)
-			reg |= GMII_SPEED_UP_2G;
+		reg &= ~GMII_SPEED_UP_2G;
 		core_writel(priv, reg, offset);
 
 		/* Enable Broadcast, Multicast, Unicast forwarding to IMP port */
-- 
2.20.1



