Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556A53FDBE8
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344685AbhIAMpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:45:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345276AbhIAMmz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:42:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2C7D61207;
        Wed,  1 Sep 2021 12:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499889;
        bh=dVkNF5RLoDqMfNKE7FzU+5N5tY8h+mel0CLlKqy+e6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K9NF6JNw6PLL1ff3fAhvIO94BV7DWI9bW7kCOYE1Hwjv3q84uosHyGnNbpZZwGRMO
         rpL6Wu9jsZdT6MYhqwd+mLPCzbV42y9s7jF0UFZCT55+IkeBAsYxvJm7ltv3COAPrB
         v5VXHARNcHaVuoj1uzb7QnTFANy36RFAwo78B/us=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>,
        Song Yoong Siang <yoong.siang.song@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.13 022/113] net: stmmac: fix kernel panic due to NULL pointer dereference of buf->xdp
Date:   Wed,  1 Sep 2021 14:27:37 +0200
Message-Id: <20210901122302.721001578@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Yoong Siang <yoong.siang.song@intel.com>

commit 2b9fff64f03219d78044d1ab40dde8e3d42e968a upstream.

Ensure a valid XSK buffer before proceed to free the xdp buffer.

The following kernel panic is observed without this patch:

RIP: 0010:xp_free+0x5/0x40
Call Trace:
stmmac_napi_poll_rxtx+0x332/0xb30 [stmmac]
? stmmac_tx_timer+0x3c/0xb0 [stmmac]
net_rx_action+0x13d/0x3d0
__do_softirq+0xfc/0x2fb
? smpboot_register_percpu_thread+0xe0/0xe0
run_ksoftirqd+0x32/0x70
smpboot_thread_fn+0x1d8/0x2c0
kthread+0x169/0x1a0
? kthread_park+0x90/0x90
ret_from_fork+0x1f/0x30
---[ end trace 0000000000000002 ]---

Fixes: bba2556efad6 ("net: stmmac: Enable RX via AF_XDP zero-copy")
Cc: <stable@vger.kernel.org> # 5.13.x
Suggested-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4925,6 +4925,10 @@ read_again:
 
 		prefetch(np);
 
+		/* Ensure a valid XSK buffer before proceed */
+		if (!buf->xdp)
+			break;
+
 		if (priv->extend_desc)
 			stmmac_rx_extended_status(priv, &priv->dev->stats,
 						  &priv->xstats,
@@ -4945,10 +4949,6 @@ read_again:
 			continue;
 		}
 
-		/* Ensure a valid XSK buffer before proceed */
-		if (!buf->xdp)
-			break;
-
 		/* XSK pool expects RX frame 1:1 mapped to XSK buffer */
 		if (likely(status & rx_not_ls)) {
 			xsk_buff_free(buf->xdp);


