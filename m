Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5BED17FC3B
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbgCJNTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:19:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731106AbgCJNIY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:08:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE0EC20873;
        Tue, 10 Mar 2020 13:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845704;
        bh=bfH3LqJFC1+23k0uM5uGIrT6OrqHoOk2N8QP4RwTUa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oiraTnM7fn88qLHvwcsDTxXGBjAX0RNI51Da7+B1EbsQs49UuTqSVHBdNFBE/jwID
         H89Lu91kEG9HOSDMSftCEoR71JP+yZxjGh0gSEC6cqUb/bTjMr5DJLP0ABbHNkxBbn
         uoTOuBhdq6ulhm/WEeD414NWx9Cc7iMgQ6wB+Dbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 070/126] net: dsa: bcm_sf2: Forcibly configure IMP port for 1Gb/sec
Date:   Tue, 10 Mar 2020 13:41:31 +0100
Message-Id: <20200310124208.500302545@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
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
index 747062f04bb5e..6bca42e34a53d 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -138,8 +138,7 @@ static void bcm_sf2_imp_setup(struct dsa_switch *ds, int port)
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



