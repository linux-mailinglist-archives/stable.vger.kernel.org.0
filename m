Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DA046272F
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236461AbhK2XBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235963AbhK2XAE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:00:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7333C043CDA;
        Mon, 29 Nov 2021 10:40:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F41F9CE13F9;
        Mon, 29 Nov 2021 18:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4521C53FC7;
        Mon, 29 Nov 2021 18:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211222;
        bh=lMbWWBc13E2rIdPuownEN+xQLe2IewK+u8aXzdagp1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b7dltKhbY1nvw7GUN8z/5ng8xrqyt6BQbLyaO9Qh2VUB9wDNONoriRcpXcwCcw+Mq
         KtlW1K5kysHyXSSwer6JigKAPgkE7tY/ZceuR2Mczuj6D3X4Ww0YzhF1/X9aadqcVZ
         2ij5mKKKAeLj5FpbwL6I3hDoj47Pp59HOR0GO04E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yannick Vignon <yannick.vignon@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 146/179] net: stmmac: Disable Tx queues when reconfiguring the interface
Date:   Mon, 29 Nov 2021 19:19:00 +0100
Message-Id: <20211129181723.756455199@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yannick Vignon <yannick.vignon@nxp.com>

[ Upstream commit b270bfe697367776eca2e6759a71d700fb8d82a2 ]

The Tx queues were not disabled in situations where the driver needed to
stop the interface to apply a new configuration. This could result in a
kernel panic when doing any of the 3 following actions:
* reconfiguring the number of queues (ethtool -L)
* reconfiguring the size of the ring buffers (ethtool -G)
* installing/removing an XDP program (ip l set dev ethX xdp)

Prevent the panic by making sure netif_tx_disable is called when stopping
an interface.

Without this patch, the following kernel panic can be observed when doing
any of the actions above:

Unable to handle kernel paging request at virtual address ffff80001238d040
[....]
 Call trace:
  dwmac4_set_addr+0x8/0x10
  dev_hard_start_xmit+0xe4/0x1ac
  sch_direct_xmit+0xe8/0x39c
  __dev_queue_xmit+0x3ec/0xaf0
  dev_queue_xmit+0x14/0x20
[...]
[ end trace 0000000000000002 ]---

Fixes: 5fabb01207a2d ("net: stmmac: Add initial XDP support")
Fixes: aa042f60e4961 ("net: stmmac: Add support to Ethtool get/set ring parameters")
Fixes: 0366f7e06a6be ("net: stmmac: add ethtool support for get/set channels")
Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
Link: https://lore.kernel.org/r/20211124154731.1676949-1-yannick.vignon@oss.nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c18c05f78c208..1cf94248c2217 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3794,6 +3794,8 @@ int stmmac_release(struct net_device *dev)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 chan;
 
+	netif_tx_disable(dev);
+
 	if (device_may_wakeup(priv->device))
 		phylink_speed_down(priv->phylink, false);
 	/* Stop and disconnect the PHY */
-- 
2.33.0



