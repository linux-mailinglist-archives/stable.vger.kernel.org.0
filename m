Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF35A26141A
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 18:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731222AbgIHQFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 12:05:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731171AbgIHQEj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:04:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2B07229F0;
        Tue,  8 Sep 2020 15:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579351;
        bh=5P0hcenspg1C1KXF6xTEF80JoHY/H6bE/siOpbWumH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MHhRiU4ZPlb8psz5DePE4p506K8K8M0BUiHI9wHbxsyElf4jg1td7ikk0pwUxgvOR
         jGMZ9YXEbEIgb0r4o1+69GtpBUJ5EyO+ZJkaXYF0Ubgr4I8rQNUEiK5rnm5X9SFHI7
         p7vlVc1woYv8X6Y60XrMKWfNYobNy8Ig4b/2CZnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ab16e463b903f5a37036@syzkaller.appspotmail.com,
        Sven Eckelmann <sven@narfation.org>,
        Antonio Quartulli <a@unstable.cc>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 040/186] batman-adv: Avoid uninitialized chaddr when handling DHCP
Date:   Tue,  8 Sep 2020 17:23:02 +0200
Message-Id: <20200908152243.615263848@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit 303216e76dcab6049c9d42390b1032f0649a8206 ]

The gateway client code can try to optimize the delivery of DHCP packets to
avoid broadcasting them through the whole mesh. But also transmissions to
the client can be optimized by looking up the destination via the chaddr of
the DHCP packet.

But the chaddr is currently only done when chaddr is fully inside the
non-paged area of the skbuff. Otherwise it will not be initialized and the
unoptimized path should have been taken.

But the implementation didn't handle this correctly. It didn't retrieve the
correct chaddr but still tried to perform the TT lookup with this
uninitialized memory.

Reported-by: syzbot+ab16e463b903f5a37036@syzkaller.appspotmail.com
Fixes: 6c413b1c22a2 ("batman-adv: send every DHCP packet as bat-unicast")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Acked-by: Antonio Quartulli <a@unstable.cc>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/gateway_client.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/gateway_client.c b/net/batman-adv/gateway_client.c
index a18dcc686dc31..ef3f85b576c4c 100644
--- a/net/batman-adv/gateway_client.c
+++ b/net/batman-adv/gateway_client.c
@@ -703,8 +703,10 @@ batadv_gw_dhcp_recipient_get(struct sk_buff *skb, unsigned int *header_len,
 
 	chaddr_offset = *header_len + BATADV_DHCP_CHADDR_OFFSET;
 	/* store the client address if the message is going to a client */
-	if (ret == BATADV_DHCP_TO_CLIENT &&
-	    pskb_may_pull(skb, chaddr_offset + ETH_ALEN)) {
+	if (ret == BATADV_DHCP_TO_CLIENT) {
+		if (!pskb_may_pull(skb, chaddr_offset + ETH_ALEN))
+			return BATADV_DHCP_NO;
+
 		/* check if the DHCP packet carries an Ethernet DHCP */
 		p = skb->data + *header_len + BATADV_DHCP_HTYPE_OFFSET;
 		if (*p != BATADV_DHCP_HTYPE_ETHERNET)
-- 
2.25.1



