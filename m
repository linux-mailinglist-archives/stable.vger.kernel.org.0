Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9DE3CA88A
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240780AbhGOTB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:01:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241484AbhGOTAY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:00:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B649610C7;
        Thu, 15 Jul 2021 18:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375449;
        bh=F8SCln3H5NJmbHRZxsNE5Xd1u4tOGt+zaQc9RTcTxI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LRtyLVVqwkjVqMj0IOWFHbLYHJDHWthQ6OyfTtLeDT7yUnrmnZrPGpsCQ4A1ej6nk
         tl0/JoyXdU9KjjzNq4dB/28+d3MiearoeDIgs2j35PluerRk7oM51gSIPwTM6Mc2fV
         n3hxMsmbzmQIdudzqsy3sUYWv2r8Bjdv+GK678dc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 092/242] net: hsr: dont check sequence number if tag removal is offloaded
Date:   Thu, 15 Jul 2021 20:37:34 +0200
Message-Id: <20210715182609.261915869@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George McCollister <george.mccollister@gmail.com>

[ Upstream commit c2ae34a7deaff463ecafb7db627b77faaca8e159 ]

Don't check the sequence number when deciding when to update time_in in
the node table if tag removal is offloaded since the sequence number is
part of the tag. This fixes a problem where the times in the node table
wouldn't update when 0 appeared to be before or equal to seq_out when
tag removal was offloaded.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_framereg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index bb1351c38397..e31949479305 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -397,7 +397,8 @@ void hsr_register_frame_in(struct hsr_node *node, struct hsr_port *port,
 	 * ensures entries of restarted nodes gets pruned so that they can
 	 * re-register and resume communications.
 	 */
-	if (seq_nr_before(sequence_nr, node->seq_out[port->type]))
+	if (!(port->dev->features & NETIF_F_HW_HSR_TAG_RM) &&
+	    seq_nr_before(sequence_nr, node->seq_out[port->type]))
 		return;
 
 	node->time_in[port->type] = jiffies;
-- 
2.30.2



