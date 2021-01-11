Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46BC82F14F3
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732754AbhAKNdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:33:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:33212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732175AbhAKNOr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:14:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC0A822795;
        Mon, 11 Jan 2021 13:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370846;
        bh=b2aFZwB7c+VlmFwX/jWK33StTuT3ZsOhVZmmE+WkzEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s8YKI4xooeYxAvu4ZjrH+XWXwx1SIW1H31AAqPpEE8Dni9pll7PbPdphZ71iIEDjw
         qiD4oG47R5DxQKMdpwJXv4AhQmIIUAim08qLkFB2EffuKRbSTXoKr+nDIMDNl+AO8k
         8Cf6XCoVJ97HHFHfKPeQu7taL6a6UBQynzvU3wS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 006/145] net: systemport: set dev->max_mtu to UMAC_MAX_MTU_SIZE
Date:   Mon, 11 Jan 2021 14:00:30 +0100
Message-Id: <20210111130048.818019855@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
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
@@ -2577,6 +2577,7 @@ static int bcm_sysport_probe(struct plat
 			 NETIF_F_HW_VLAN_CTAG_TX;
 	dev->hw_features |= dev->features;
 	dev->vlan_features |= dev->features;
+	dev->max_mtu = UMAC_MAX_MTU_SIZE;
 
 	/* Request the WOL interrupt and advertise suspend if available */
 	priv->wol_irq_disabled = 1;


