Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4876157898
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730839AbgBJNI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:08:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:36988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728580AbgBJMjZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:25 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D723E20838;
        Mon, 10 Feb 2020 12:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338364;
        bh=xtSZXCFnBGOlSBUbv4suGCVpm9DZOtQ7P7M7K11ClNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BQBzCyTH7i83v57NdVxNtlvuXstO1n2eglw8N6PuN6qL5skqdn9kT6fnSCPYFXE/b
         KA1TQCkRQANHF7sac0rmxRWwJPlHyTWSIEj6hCTfSpafqedvQqRNBefGgCrZ5iZnbu
         O3PeOfVsS6dPelgbpHndEOtXxD/cGOeNpcXjrR38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Auhagen <sven.auhagen@voleatech.de>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 008/367] net: mvneta: fix XDP support if sw bm is used as fallback
Date:   Mon, 10 Feb 2020 04:28:41 -0800
Message-Id: <20200210122424.603705667@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 44efc78d0e464ce70b45b165c005f8bedc17952e ]

In order to fix XDP support if sw buffer management is used as fallback
for hw bm devices, define MVNETA_SKB_HEADROOM as maximum between
XDP_PACKET_HEADROOM and NET_SKB_PAD and let the hw aligns the IP header
to 4-byte boundary.
Fix rx_offset_correction initialization if mvneta_bm_port_init fails in
mvneta_resume routine

Fixes: 0db51da7a8e9 ("net: mvneta: add basic XDP support")
Tested-by: Sven Auhagen <sven.auhagen@voleatech.de>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvneta.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -324,8 +324,7 @@
 	      ETH_HLEN + ETH_FCS_LEN,			     \
 	      cache_line_size())
 
-#define MVNETA_SKB_HEADROOM	(max(XDP_PACKET_HEADROOM, NET_SKB_PAD) + \
-				 NET_IP_ALIGN)
+#define MVNETA_SKB_HEADROOM	max(XDP_PACKET_HEADROOM, NET_SKB_PAD)
 #define MVNETA_SKB_PAD	(SKB_DATA_ALIGN(sizeof(struct skb_shared_info) + \
 			 MVNETA_SKB_HEADROOM))
 #define MVNETA_SKB_SIZE(len)	(SKB_DATA_ALIGN(len) + MVNETA_SKB_PAD)
@@ -1167,6 +1166,7 @@ bm_mtu_err:
 	mvneta_bm_pool_destroy(pp->bm_priv, pp->pool_short, 1 << pp->id);
 
 	pp->bm_priv = NULL;
+	pp->rx_offset_correction = MVNETA_SKB_HEADROOM;
 	mvreg_write(pp, MVNETA_ACC_MODE, MVNETA_ACC_MODE_EXT1);
 	netdev_info(pp->dev, "fail to update MTU, fall back to software BM\n");
 }
@@ -4948,7 +4948,6 @@ static int mvneta_probe(struct platform_
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	pp->id = global_port_id++;
-	pp->rx_offset_correction = MVNETA_SKB_HEADROOM;
 
 	/* Obtain access to BM resources if enabled and already initialized */
 	bm_node = of_parse_phandle(dn, "buffer-manager", 0);
@@ -4973,6 +4972,10 @@ static int mvneta_probe(struct platform_
 	}
 	of_node_put(bm_node);
 
+	/* sw buffer management */
+	if (!pp->bm_priv)
+		pp->rx_offset_correction = MVNETA_SKB_HEADROOM;
+
 	err = mvneta_init(&pdev->dev, pp);
 	if (err < 0)
 		goto err_netdev;
@@ -5130,6 +5133,7 @@ static int mvneta_resume(struct device *
 		err = mvneta_bm_port_init(pdev, pp);
 		if (err < 0) {
 			dev_info(&pdev->dev, "use SW buffer management\n");
+			pp->rx_offset_correction = MVNETA_SKB_HEADROOM;
 			pp->bm_priv = NULL;
 		}
 	}


