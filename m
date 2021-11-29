Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD99E461F57
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380282AbhK2SqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:46:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49164 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377578AbhK2SoM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:44:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6D18B815DE;
        Mon, 29 Nov 2021 18:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B62C53FAD;
        Mon, 29 Nov 2021 18:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211250;
        bh=EYni/KGcNn2nwydUAjEjq+zq5lXC/2K6du7S4wX6Uw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xHsYkLT3TzOPTyqLrBSmK+KF04FHDy32ukLT4v1AItxBvCGfVZZZAreKpaLlBJm7r
         4cQ2+LSZ5P7M68efXc/yPAQ3esza3WASnY8xftjEmNsTV9i9D0nWEANgVeRp9E1bu8
         +jGcZ0zYEQSI5EcrIx2JC39oS22Qcn7QKGJYsEzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 124/179] net: marvell: mvpp2: increase MTU limit when XDP enabled
Date:   Mon, 29 Nov 2021 19:18:38 +0100
Message-Id: <20211129181723.041469914@linuxfoundation.org>
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

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 7b1b62bc1e6a7b2fd5ee7a4296268eb291d23aeb ]

Currently mvpp2_xdp_setup won't allow attaching XDP program if
  mtu > ETH_DATA_LEN (1500).

The mvpp2_change_mtu on the other hand checks whether
  MVPP2_RX_PKT_SIZE(mtu) > MVPP2_BM_LONG_PKT_SIZE.

These two checks are semantically different.

Moreover this limit can be increased to MVPP2_MAX_RX_BUF_SIZE, since in
mvpp2_rx we have
  xdp.data = data + MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM;
  xdp.frame_sz = PAGE_SIZE;

Change the checks to check whether
  mtu > MVPP2_MAX_RX_BUF_SIZE

Fixes: 07dd0a7aae7f ("mvpp2: add basic XDP support")
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index d74d4966b13fc..ed6d0c019573b 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5017,11 +5017,13 @@ static int mvpp2_change_mtu(struct net_device *dev, int mtu)
 		mtu = ALIGN(MVPP2_RX_PKT_SIZE(mtu), 8);
 	}
 
+	if (port->xdp_prog && mtu > MVPP2_MAX_RX_BUF_SIZE) {
+		netdev_err(dev, "Illegal MTU value %d (> %d) for XDP mode\n",
+			   mtu, (int)MVPP2_MAX_RX_BUF_SIZE);
+		return -EINVAL;
+	}
+
 	if (MVPP2_RX_PKT_SIZE(mtu) > MVPP2_BM_LONG_PKT_SIZE) {
-		if (port->xdp_prog) {
-			netdev_err(dev, "Jumbo frames are not supported with XDP\n");
-			return -EINVAL;
-		}
 		if (priv->percpu_pools) {
 			netdev_warn(dev, "mtu %d too high, switching to shared buffers", mtu);
 			mvpp2_bm_switch_buffers(priv, false);
@@ -5307,8 +5309,8 @@ static int mvpp2_xdp_setup(struct mvpp2_port *port, struct netdev_bpf *bpf)
 	bool running = netif_running(port->dev);
 	bool reset = !prog != !port->xdp_prog;
 
-	if (port->dev->mtu > ETH_DATA_LEN) {
-		NL_SET_ERR_MSG_MOD(bpf->extack, "XDP is not supported with jumbo frames enabled");
+	if (port->dev->mtu > MVPP2_MAX_RX_BUF_SIZE) {
+		NL_SET_ERR_MSG_MOD(bpf->extack, "MTU too large for XDP");
 		return -EOPNOTSUPP;
 	}
 
-- 
2.33.0



