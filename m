Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708852E3877
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731432AbgL1NKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:10:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:37570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729679AbgL1NKk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:10:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D42422AAA;
        Mon, 28 Dec 2020 13:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161024;
        bh=eIeAnZ6izoxXlyAWa6UdwaNo4l0ahH+vpR/Z9cdwvp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C2YgrOSOufYyrcNXJOgvfvRQVSmj5YlkdcQsEOQsfpXIkPL7SkcDCv1JgBiScUX79
         hkY73Z5weoTsk8sJI8DhgmGtBDKrf5m8eusA8igRE8sIRyR7p/4VzDrDARy1sYZsn1
         5lM2TeaPOnGQ8o57nEe5KViU15BEOjRyKUsBcalU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Annika Wickert <annika.wickert@exaring.de>,
        Sven Eckelmann <sven@narfation.org>,
        Annika Wickert <aw@awlnx.space>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 044/242] vxlan: Add needed_headroom for lower device
Date:   Mon, 28 Dec 2020 13:47:29 +0100
Message-Id: <20201228124906.846772470@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
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
index 82efa5bbf568b..c21f28840f05b 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3184,6 +3184,7 @@ static void vxlan_config_apply(struct net_device *dev,
 		dev->gso_max_segs = lowerdev->gso_max_segs;
 
 		needed_headroom = lowerdev->hard_header_len;
+		needed_headroom += lowerdev->needed_headroom;
 
 		max_mtu = lowerdev->mtu - (use_ipv6 ? VXLAN6_HEADROOM :
 					   VXLAN_HEADROOM);
-- 
2.27.0



