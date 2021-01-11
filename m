Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8712F136A
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbhAKNIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:08:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:55254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730758AbhAKNIJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:08:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2188D2250F;
        Mon, 11 Jan 2021 13:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370473;
        bh=fMvEGgNJiH3fN5VWU5fVlLjxkoXawqbWiqvbbcugPIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ql5JlvLA/sHVyUVyzUi9NTeO89qNjtWXzSuDV6g62FVFCDNd8cd7LBvwxuumYR4gW
         DiUxFGK+KJAf0BCG/OG4mSd4invoEcfP2b1fPQhx4I/s4Kq9TxY44uTkdJCh9wG/FW
         ayOsSjxaf2ISzCqlE//ccoYxKYV0LqPh2cQFN+bQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 38/77] net: systemport: set dev->max_mtu to UMAC_MAX_MTU_SIZE
Date:   Mon, 11 Jan 2021 14:01:47 +0100
Message-Id: <20210111130038.242053796@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130036.414620026@linuxfoundation.org>
References: <20210111130036.414620026@linuxfoundation.org>
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
@@ -2507,6 +2507,7 @@ static int bcm_sysport_probe(struct plat
 	/* HW supported features, none enabled by default */
 	dev->hw_features |= NETIF_F_RXCSUM | NETIF_F_HIGHDMA |
 				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+	dev->max_mtu = UMAC_MAX_MTU_SIZE;
 
 	/* Request the WOL interrupt and advertise suspend if available */
 	priv->wol_irq_disabled = 1;


