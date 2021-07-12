Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185CC3C557F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhGLIKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:10:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353690AbhGLICq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D9096138C;
        Mon, 12 Jul 2021 07:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076608;
        bh=SUyU+GE1uT4cL5sO7tDyoPTBA/b+FFqdbKYcxb7qfm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OmQzUIxr4JkfDjG3pc5l1Sbc3pkaJ6NmV4S/sXK9N6GC22sU00rVWQALg5YAwuk6s
         +uCH18OOfrFY3/iPHK4pwfApa4Tum9oChG9ZHCEDe/GWCMrC0UJzy99UI33PbQ8JJY
         WBY/EcJmh0D391r7r5ElRuE8DxW3Kx5JBUMimkok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 717/800] staging: gdm724x: check for overflow in gdm_lte_netif_rx()
Date:   Mon, 12 Jul 2021 08:12:20 +0200
Message-Id: <20210712061043.036766312@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 7002b526f4ff1f6da34356e67085caafa6be383a ]

This code assumes that "len" is at least 62 bytes, but we need a check
to prevent a read overflow.

Fixes: 61e121047645 ("staging: gdm7240: adding LTE USB driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YMcoTPsCYlhh2TQo@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gdm724x/gdm_lte.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/gdm724x/gdm_lte.c b/drivers/staging/gdm724x/gdm_lte.c
index a41af7aa74ec..bd5f87433404 100644
--- a/drivers/staging/gdm724x/gdm_lte.c
+++ b/drivers/staging/gdm724x/gdm_lte.c
@@ -611,10 +611,12 @@ static void gdm_lte_netif_rx(struct net_device *dev, char *buf,
 						  * bytes (99,130,83,99 dec)
 						  */
 			} __packed;
-			void *addr = buf + sizeof(struct iphdr) +
-				sizeof(struct udphdr) +
-				offsetof(struct dhcp_packet, chaddr);
-			ether_addr_copy(nic->dest_mac_addr, addr);
+			int offset = sizeof(struct iphdr) +
+				     sizeof(struct udphdr) +
+				     offsetof(struct dhcp_packet, chaddr);
+			if (offset + ETH_ALEN > len)
+				return;
+			ether_addr_copy(nic->dest_mac_addr, buf + offset);
 		}
 	}
 
-- 
2.30.2



