Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954EB3CDCC6
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243529AbhGSOxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:53:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241433AbhGSOmM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:42:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB70961249;
        Mon, 19 Jul 2021 15:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708100;
        bh=SdPqtHsz19qd6vEQl6mP9t0imBjtcCvyCeisfpLHgi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f8JmILcj6f+3Nm0Dyv4VYl2TrbdGPYL26UfoK8YnAaQ3wTmt1yOp+B85j5RqU5AsG
         mV7qBKibInqr58CULlpJljTTVjMUZGdoaGqmTKI2fPFpWdVjHWrqVmtRkpM/ezcSXO
         jQxzXjhjiWMCUy/zU1cxO9BgsNx6CztlRzjI+aKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 146/315] staging: gdm724x: check for overflow in gdm_lte_netif_rx()
Date:   Mon, 19 Jul 2021 16:50:35 +0200
Message-Id: <20210719144947.683213491@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
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
index 8dd510137c90..ed0c5fd2d640 100644
--- a/drivers/staging/gdm724x/gdm_lte.c
+++ b/drivers/staging/gdm724x/gdm_lte.c
@@ -614,10 +614,12 @@ static void gdm_lte_netif_rx(struct net_device *dev, char *buf,
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



