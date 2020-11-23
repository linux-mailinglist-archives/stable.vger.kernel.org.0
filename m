Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1064E2C0A22
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388817AbgKWNQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:16:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:55976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733006AbgKWMnA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:43:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13BC820857;
        Mon, 23 Nov 2020 12:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135380;
        bh=/1FCgKbuSnLKriqYdbdBpvPvcyhUl91lV57quYa9R+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lJ79Fs0PCfxCVsxPTptX4R/2weBPft1cqWhKKnjcgUHuQG2sY3bS4Z0aNLzRvX+t/
         kvJCZUWjXugCECw3gpRvBqWOpCi2FC8miN4Ty9p83UMebhrQ6bdcF5Wxzg4oadA+aT
         qhNLCO3L7fHE8XLXVndvRAs+67okRibntbWXDmmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 017/252] net: ethernet: mtk-star-emac: return ok when xmit drops
Date:   Mon, 23 Nov 2020 13:19:27 +0100
Message-Id: <20201123121836.425335146@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Vincent Stehlé" <vincent.stehle@laposte.net>

[ Upstream commit e8aa6d520b448efc88670a98eccd196713639f2f ]

The ndo_start_xmit() method must return NETDEV_TX_OK if the DMA mapping
fails, after freeing the socket buffer.
Fix the mtk_star_netdev_start_xmit() function accordingly.

Fixes: 8c7bd5a454ff ("net: ethernet: mtk-star-emac: new driver")
Signed-off-by: Vincent StehlÃ© <vincent.stehle@laposte.net>
Acked-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Link: https://lore.kernel.org/r/20201112084833.21842-1-vincent.stehle@laposte.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1054,7 +1054,7 @@ static int mtk_star_netdev_start_xmit(st
 err_drop_packet:
 	dev_kfree_skb(skb);
 	ndev->stats.tx_dropped++;
-	return NETDEV_TX_BUSY;
+	return NETDEV_TX_OK;
 }
 
 /* Returns the number of bytes sent or a negative number on the first


