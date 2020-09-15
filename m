Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89BC26B4DA
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbgIOXcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727074AbgIOOhi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:37:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B45422400;
        Tue, 15 Sep 2020 14:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180012;
        bh=gUUgEPZqAoLipWidzmgdXudjOM+qFVqVAfA4HqFwDbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S1OFXRJr7Zn6lDbfdoDTRTG4h4yW94OXUXuZsYPtwUO3eIozeOt89YsD/DFwrjiks
         fwko+OQ/HmOn5hC+AFhHy7tqMZQd6gMuKZ8hQJtMneb6b6SFCZxYDPIn2tgqE8LJh1
         iVditPnxyvJrXU2mlC60i6voM5L46Tk5pqA/2LLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Bing <libing@winhong.com>,
        Yi Li <yili@winhong.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 073/177] net: hns3: Fix for geneve tx checksum bug
Date:   Tue, 15 Sep 2020 16:12:24 +0200
Message-Id: <20200915140657.134363844@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yi Li <yili@winhong.com>

[ Upstream commit a156998fc92d3859c8e820f1583f6d0541d643c3 ]

when skb->encapsulation is 0, skb->ip_summed is CHECKSUM_PARTIAL
and it is udp packet, which has a dest port as the IANA assigned.
the hardware is expected to do the checksum offload, but the
hardware will not do the checksum offload when udp dest port is
6081.

This patch fixes it by doing the checksum in software.

Reported-by: Li Bing <libing@winhong.com>
Signed-off-by: Yi Li <yili@winhong.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 71ed4c54f6d5d..eaadcc7043349 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -20,6 +20,7 @@
 #include <net/pkt_cls.h>
 #include <net/tcp.h>
 #include <net/vxlan.h>
+#include <net/geneve.h>
 
 #include "hnae3.h"
 #include "hns3_enet.h"
@@ -780,7 +781,7 @@ static int hns3_get_l4_protocol(struct sk_buff *skb, u8 *ol4_proto,
  * and it is udp packet, which has a dest port as the IANA assigned.
  * the hardware is expected to do the checksum offload, but the
  * hardware will not do the checksum offload when udp dest port is
- * 4789.
+ * 4789 or 6081.
  */
 static bool hns3_tunnel_csum_bug(struct sk_buff *skb)
 {
@@ -789,7 +790,8 @@ static bool hns3_tunnel_csum_bug(struct sk_buff *skb)
 	l4.hdr = skb_transport_header(skb);
 
 	if (!(!skb->encapsulation &&
-	      l4.udp->dest == htons(IANA_VXLAN_UDP_PORT)))
+	      (l4.udp->dest == htons(IANA_VXLAN_UDP_PORT) ||
+	      l4.udp->dest == htons(GENEVE_UDP_PORT))))
 		return false;
 
 	skb_checksum_help(skb);
-- 
2.25.1



