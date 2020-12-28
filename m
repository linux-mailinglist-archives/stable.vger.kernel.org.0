Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B012E6640
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389740AbgL1QKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:10:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:50680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388377AbgL1NW7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:22:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61B3520719;
        Mon, 28 Dec 2020 13:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161764;
        bh=YfF/d+HGctlPVV+WGQC+NlYt1gEwYjQAwDNW5Y63Sl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R2mknbmreuhFdYou4vdaVeqmEsAZlvTUIY1RRCfVQ5j9qOtF8XEOHYuENM0aEj0SO
         Vgwu3GzpRv1LLrwJwqRQHmEjsoS1mioRy7S1/0UEYO0ihihDVTv1jpyJJmn8oPpPNG
         8WeYi+9zAZv52b5I2WrVLnGKTvsMWPGGJdMZGED4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Annika Wickert <annika.wickert@exaring.de>,
        Sven Eckelmann <sven@narfation.org>,
        Annika Wickert <aw@awlnx.space>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 073/346] vxlan: Add needed_headroom for lower device
Date:   Mon, 28 Dec 2020 13:46:32 +0100
Message-Id: <20201228124923.326278307@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit 0a35dc41fea67ac4495ce7584406bf9557a6e7d0 ]

It was observed that sending data via batadv over vxlan (on top of
wireguard) reduced the performance massively compared to raw ethernet or
batadv on raw ethernet. A check of perf data showed that the
vxlan_build_skb was calling all the time pskb_expand_head to allocate
enough headroom for:

  min_headroom = LL_RESERVED_SPACE(dst->dev) + dst->header_len
  		+ VXLAN_HLEN + iphdr_len;

But the vxlan_config_apply only requested needed headroom for:

  lowerdev->hard_header_len + VXLAN6_HEADROOM or VXLAN_HEADROOM

So it completely ignored the needed_headroom of the lower device. The first
caller of net_dev_xmit could therefore never make sure that enough headroom
was allocated for the rest of the transmit path.

Cc: Annika Wickert <annika.wickert@exaring.de>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Tested-by: Annika Wickert <aw@awlnx.space>
Link: https://lore.kernel.org/r/20201126125247.1047977-1-sven@narfation.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index abf85f0ab72fc..8481a21fe7afb 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3180,6 +3180,7 @@ static void vxlan_config_apply(struct net_device *dev,
 		dev->gso_max_segs = lowerdev->gso_max_segs;
 
 		needed_headroom = lowerdev->hard_header_len;
+		needed_headroom += lowerdev->needed_headroom;
 
 		max_mtu = lowerdev->mtu - (use_ipv6 ? VXLAN6_HEADROOM :
 					   VXLAN_HEADROOM);
-- 
2.27.0



