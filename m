Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1A13CDE30
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245593AbhGSPCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245028AbhGSO6m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:58:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E6E9613F2;
        Mon, 19 Jul 2021 15:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708972;
        bh=rv5wJgsI5olTIrs7SqnhuzNQlrh1CGwFdFh4mvk71II=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fpIDo7OORTkB9zZLc2vlMw0IT67sk40/oAcfT4xU0X8MiawPkRhgpDW1K35AoHSlh
         3SPhyvoTENN3SN+66RvTuF+fPfToK70VRAK0oIsk/+2ks1hOLCi6dC+nFbAsj+j0Wu
         6uOr/kgz4rUTOhQMhT8LHggpUxOGVz4+Dwizffhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 203/421] staging: gdm724x: check for overflow in gdm_lte_netif_rx()
Date:   Mon, 19 Jul 2021 16:50:14 +0200
Message-Id: <20210719144953.405117510@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
index 25135980349a..3c537807f4d1 100644
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



