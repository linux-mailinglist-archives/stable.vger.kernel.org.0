Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14072451DE0
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348971AbhKPAe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:34:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:45222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343952AbhKOTWb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8E846335F;
        Mon, 15 Nov 2021 18:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002135;
        bh=u9gt9CJnEm43gyR55ojdDtosvvJeIsIgo7Ra38xxJoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E7II81YPz8y1PJtrNk7BzU6hxGHPZwdW2vYTLokwcpvA6qlTfwueO+D1e+jo4MvLA
         QbcEdh0weDaRPmE8Eco9YELEegA2V+SeGZmZDDmoAtMAeX/lpYmWc5/COYkwEa9xy+
         sKwT6WdCK9dQFEg5vgr7x5LchTvVAVOZg+ZIwSP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        Jeroen de Borst <jeroendb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 419/917] gve: Track RX buffer allocation failures
Date:   Mon, 15 Nov 2021 17:58:34 +0100
Message-Id: <20211115165443.005961803@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

[ Upstream commit 1b4d1c9bab091ac6e20a3ff80c30c5cefe192bf4 ]

The rx_buf_alloc_fail counter wasn't getting updated.

Fixes: 433e274b8f7b0 ("gve: Add stats for gve.")
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: Jeroen de Borst <jeroendb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_rx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 94941d4e47449..16169f291ad9f 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -514,8 +514,13 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
 
 				gve_rx_free_buffer(dev, page_info, data_slot);
 				page_info->page = NULL;
-				if (gve_rx_alloc_buffer(priv, dev, page_info, data_slot))
+				if (gve_rx_alloc_buffer(priv, dev, page_info,
+							data_slot)) {
+					u64_stats_update_begin(&rx->statss);
+					rx->rx_buf_alloc_fail++;
+					u64_stats_update_end(&rx->statss);
 					break;
+				}
 			}
 		}
 		fill_cnt++;
-- 
2.33.0



