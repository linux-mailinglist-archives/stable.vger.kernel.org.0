Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D36300C48
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 20:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730040AbhAVSn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:43:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:40016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728536AbhAVOWO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:22:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AACC23B44;
        Fri, 22 Jan 2021 14:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324943;
        bh=emZyV+w6Pyo04tbdFelWtIQdvAqMn8EpXL0VU455U44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cHoqlc7V2gkPhJ1PRrrhrccpcj0fM9FyuFCXjPNIAf3YvlRLFc6KwblYFaraIAC6v
         ODszIaY+uvfp0gthDcC8Sco0sXRLtoaeGJHlawd8hOjdCDh/F2+5G1uCSt+QLRd/7V
         g8hACGvQ1OtlCrnRLD0Wmob6miq1nUs6j4aT17Zw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Wu <david.wu@rock-chips.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 14/22] net: stmmac: Fixed mtu channged by cache aligned
Date:   Fri, 22 Jan 2021 15:12:32 +0100
Message-Id: <20210122135732.476825547@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135731.921636245@linuxfoundation.org>
References: <20210122135731.921636245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Wu <david.wu@rock-chips.com>

[ Upstream commit 5b55299eed78538cc4746e50ee97103a1643249c ]

Since the original mtu is not used when the mtu is updated,
the mtu is aligned with cache, this will get an incorrect.
For example, if you want to configure the mtu to be 1500,
but mtu 1536 is configured in fact.

Fixed: eaf4fac478077 ("net: stmmac: Do not accept invalid MTU values")
Signed-off-by: David Wu <david.wu@rock-chips.com>
Link: https://lore.kernel.org/r/20210113034109.27865-1-david.wu@rock-chips.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3596,6 +3596,7 @@ static int stmmac_change_mtu(struct net_
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int txfifosz = priv->plat->tx_fifo_size;
+	const int mtu = new_mtu;
 
 	if (txfifosz == 0)
 		txfifosz = priv->dma_cap.tx_fifo_size;
@@ -3613,7 +3614,7 @@ static int stmmac_change_mtu(struct net_
 	if ((txfifosz < new_mtu) || (new_mtu > BUF_SIZE_16KiB))
 		return -EINVAL;
 
-	dev->mtu = new_mtu;
+	dev->mtu = mtu;
 
 	netdev_update_features(dev);
 


