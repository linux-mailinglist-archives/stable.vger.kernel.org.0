Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1DE247568
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730639AbgHQTXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:23:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730292AbgHQPfT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:35:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7BC622D2A;
        Mon, 17 Aug 2020 15:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678519;
        bh=lPwaDgqodgo5PJ/CLW43a1CyO2NVrcWLZMq9KWFqots=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pd37abP5m2mzvHYoFi25xckuVys5J6fmSHl8VFGz1ed1DeY3yrccOZrL80z4OJs/8
         +qHKyLsJ2zdBybkwq7Ub3OvRAVooXe/louwAa29k9u2r4jNg5VgB8w0kSkWhv4uxCV
         Z4CJLwQAD0WLfpngn3aBxiZvSZbOCY+lqMVt5eI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 363/464] fsl/fman: check dereferencing null pointer
Date:   Mon, 17 Aug 2020 17:15:16 +0200
Message-Id: <20200817143851.160868338@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florinel Iordache <florinel.iordache@nxp.com>

[ Upstream commit cc5d229a122106733a85c279d89d7703f21e4d4f ]

Add a safe check to avoid dereferencing null pointer

Fixes: 57ba4c9b56d8 ("fsl/fman: Add FMan MAC support")
Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fman/fman_dtsec.c | 4 ++--
 drivers/net/ethernet/freescale/fman/fman_memac.c | 2 +-
 drivers/net/ethernet/freescale/fman/fman_tgec.c  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 004c266802a87..bce3c9398887c 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -1200,7 +1200,7 @@ int dtsec_del_hash_mac_address(struct fman_mac *dtsec, enet_addr_t *eth_addr)
 		list_for_each(pos,
 			      &dtsec->multicast_addr_hash->lsts[bucket]) {
 			hash_entry = ETH_HASH_ENTRY_OBJ(pos);
-			if (hash_entry->addr == addr) {
+			if (hash_entry && hash_entry->addr == addr) {
 				list_del_init(&hash_entry->node);
 				kfree(hash_entry);
 				break;
@@ -1213,7 +1213,7 @@ int dtsec_del_hash_mac_address(struct fman_mac *dtsec, enet_addr_t *eth_addr)
 		list_for_each(pos,
 			      &dtsec->unicast_addr_hash->lsts[bucket]) {
 			hash_entry = ETH_HASH_ENTRY_OBJ(pos);
-			if (hash_entry->addr == addr) {
+			if (hash_entry && hash_entry->addr == addr) {
 				list_del_init(&hash_entry->node);
 				kfree(hash_entry);
 				break;
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index bb02b37422cc2..645764abdaae5 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -981,7 +981,7 @@ int memac_del_hash_mac_address(struct fman_mac *memac, enet_addr_t *eth_addr)
 
 	list_for_each(pos, &memac->multicast_addr_hash->lsts[hash]) {
 		hash_entry = ETH_HASH_ENTRY_OBJ(pos);
-		if (hash_entry->addr == addr) {
+		if (hash_entry && hash_entry->addr == addr) {
 			list_del_init(&hash_entry->node);
 			kfree(hash_entry);
 			break;
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index 8c7eb878d5b43..41946b16f6c72 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -626,7 +626,7 @@ int tgec_del_hash_mac_address(struct fman_mac *tgec, enet_addr_t *eth_addr)
 
 	list_for_each(pos, &tgec->multicast_addr_hash->lsts[hash]) {
 		hash_entry = ETH_HASH_ENTRY_OBJ(pos);
-		if (hash_entry->addr == addr) {
+		if (hash_entry && hash_entry->addr == addr) {
 			list_del_init(&hash_entry->node);
 			kfree(hash_entry);
 			break;
-- 
2.25.1



