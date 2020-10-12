Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D89528B6BB
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730916AbgJLNgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:36:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730716AbgJLNfs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:35:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 894FD20678;
        Mon, 12 Oct 2020 13:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509748;
        bh=b5En8k/O97exEZDQzUfNz3XNs7S2smboU+rFFPz3PpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XLauxr6zXtNNBXzwU0Vmg6c7aU0Szw+wVgqVJe2gxg63XovLTJXq3qjyuXtqyFU3e
         en56V4yY50hOp1s8X7KS2+nNP7seCbyuGOk2gK7XgyDTfbYbx4yeSGTTk/z0KosHE0
         KuH5lex/0ooOVs187xA7NUF2YDoeaidwNDolvjUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>,
        Xie He <xie.he.0141@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 13/70] drivers/net/wan/lapbether: Make skb->protocol consistent with the header
Date:   Mon, 12 Oct 2020 15:26:29 +0200
Message-Id: <20201012132630.856875552@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132630.201442517@linuxfoundation.org>
References: <20201012132630.201442517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 83f9a9c8c1edc222846dc1bde6e3479703e8e5a3 ]

This driver is a virtual driver stacked on top of Ethernet interfaces.

When this driver transmits data on the Ethernet device, the skb->protocol
setting is inconsistent with the Ethernet header prepended to the skb.

This causes a user listening on the Ethernet interface with an AF_PACKET
socket, to see different sll_protocol values for incoming and outgoing
frames, because incoming frames would have this value set by parsing the
Ethernet header.

This patch changes the skb->protocol value for outgoing Ethernet frames,
making it consistent with the Ethernet header prepended. This makes a
user listening on the Ethernet device with an AF_PACKET socket, to see
the same sll_protocol value for incoming and outgoing frames.

Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/lapbether.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 15177a54b17d7..e5fc1b95cea6a 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -201,8 +201,6 @@ static void lapbeth_data_transmit(struct net_device *ndev, struct sk_buff *skb)
 	struct net_device *dev;
 	int size = skb->len;
 
-	skb->protocol = htons(ETH_P_X25);
-
 	ptr = skb_push(skb, 2);
 
 	*ptr++ = size % 256;
@@ -213,6 +211,8 @@ static void lapbeth_data_transmit(struct net_device *ndev, struct sk_buff *skb)
 
 	skb->dev = dev = lapbeth->ethdev;
 
+	skb->protocol = htons(ETH_P_DEC);
+
 	skb_reset_network_header(skb);
 
 	dev_hard_header(skb, dev, ETH_P_DEC, bcast_addr, NULL, 0);
-- 
2.25.1



