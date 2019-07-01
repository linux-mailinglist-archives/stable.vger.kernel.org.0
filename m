Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85B052F038
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727203AbfE3EB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:01:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729885AbfE3DSF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:05 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F3EE24692;
        Thu, 30 May 2019 03:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186285;
        bh=MaBLhtL6E6bUVr5rhOE4B8vqyi8z5Rle9ZtDG1taMb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZiyAVZzW9KjOmeshYVcWbe4bGKXbhx1uJ5tAHcpjgX80Xze8wMWG+WrcvqSYUQba
         cOeCPovUkbxaRvfhmPaTcnlq4ZLOp4edDQhRJt+P3vUUDfvKd26hrpzGbvgpFp98y8
         5prt2bfG6ex/XNzDF03Zzo+ySeU8ZWgIpPxKwcZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Antonio Quartulli <a@unstable.cc>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 239/276] batman-adv: allow updating DAT entry timeouts on incoming ARP Replies
Date:   Wed, 29 May 2019 20:06:37 -0700
Message-Id: <20190530030540.077757453@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 099e6cc1582dc2903fecb898bbeae8f7cf4262c7 ]

Currently incoming ARP Replies, for example via a DHT-PUT message, do
not update the timeout for an already existing DAT entry. These ARP
Replies are dropped instead.

This however defeats the purpose of the DHCPACK snooping, for instance.
Right now, a DAT entry in the DHT will be purged every five minutes,
likely leading to a mesh-wide ARP Request broadcast after this timeout.
Which then recreates the entry. The idea of the DHCPACK snooping is to
be able to update an entry before a timeout happens, to avoid ARP Request
flooding.

This patch fixes this issue by updating a DAT entry on incoming
ARP Replies even if a matching DAT entry already exists. While still
filtering the ARP Reply towards the soft-interface, to avoid duplicate
messages on the client device side.

Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Acked-by: Antonio Quartulli <a@unstable.cc>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/distributed-arp-table.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/distributed-arp-table.c b/net/batman-adv/distributed-arp-table.c
index a60bacf7120be..2895e3b26e930 100644
--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -1394,7 +1394,6 @@ bool batadv_dat_snoop_incoming_arp_reply(struct batadv_priv *bat_priv,
 			   hw_src, &ip_src, hw_dst, &ip_dst,
 			   dat_entry->mac_addr,	&dat_entry->ip);
 		dropped = true;
-		goto out;
 	}
 
 	/* Update our internal cache with both the IP addresses the node got
@@ -1403,6 +1402,9 @@ bool batadv_dat_snoop_incoming_arp_reply(struct batadv_priv *bat_priv,
 	batadv_dat_entry_add(bat_priv, ip_src, hw_src, vid);
 	batadv_dat_entry_add(bat_priv, ip_dst, hw_dst, vid);
 
+	if (dropped)
+		goto out;
+
 	/* If BLA is enabled, only forward ARP replies if we have claimed the
 	 * source of the ARP reply or if no one else of the same backbone has
 	 * already claimed that client. This prevents that different gateways
-- 
2.20.1



