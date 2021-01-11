Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECDD2F138B
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731218AbhAKNKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:10:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:57756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731214AbhAKNKg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:10:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB8BA2225E;
        Mon, 11 Jan 2021 13:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370595;
        bh=QPD51QQzmq1Ndu3cdqBmSJ550XTYsxvY9PsNYMyh/RU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wcXRWa4a+Lhur4D6P1SLs63mgE02e1Zs2spgUUYS2P8L3Ae5JMPkeS7dt2VMD/lkg
         oqo9HWuINFh5yiJWGuWezuvTbsBeAoruJHpJv5utGcSV0ibbih6oDi5Au6+f1BLYYq
         ZUR37124Uw1noEcmxqXhcSvIyZUckiy42WkH/CwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 14/92] net: systemport: set dev->max_mtu to UMAC_MAX_MTU_SIZE
Date:   Mon, 11 Jan 2021 14:01:18 +0100
Message-Id: <20210111130039.843849493@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 54ddbdb024882e226055cc4c3c246592ddde2ee5 ]

The driver is already allocating receive buffers of 2KiB and the
Ethernet MAC is configured to accept frames up to UMAC_MAX_MTU_SIZE.

Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20201218173843.141046-1-f.fainelli@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2520,6 +2520,7 @@ static int bcm_sysport_probe(struct plat
 			 NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
 	dev->hw_features |= dev->features;
 	dev->vlan_features |= dev->features;
+	dev->max_mtu = UMAC_MAX_MTU_SIZE;
 
 	/* Request the WOL interrupt and advertise suspend if available */
 	priv->wol_irq_disabled = 1;


