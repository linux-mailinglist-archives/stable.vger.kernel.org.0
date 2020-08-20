Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD7D24B9DC
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729418AbgHTLz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:55:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730512AbgHTKCf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:02:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E4D422CA1;
        Thu, 20 Aug 2020 10:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917753;
        bh=8Sj51AvsfBxeWfiLa+pHm5SG/E6h69trsHWfM+rqyc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RFbhSJNOxbCSDKC1H/x5YC/1rpUwujtcKRIZVzQ8ZIF83dN7T9TSgvb+rBe+iAhQB
         wX5lKKNcvy3VnLDDcIBhg22D5igBLNHWekti9eLxYKuK+U21T3D5uOiTjJXWJbEHSq
         YUXP2iw03sy90jyUEqsL0EF6pPbGMh/7WriEEMaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 146/212] fsl/fman: check dereferencing null pointer
Date:   Thu, 20 Aug 2020 11:21:59 +0200
Message-Id: <20200820091609.759129707@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
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
index 641b916f122ba..332b60f03d225 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -1095,7 +1095,7 @@ int dtsec_del_hash_mac_address(struct fman_mac *dtsec, enet_addr_t *eth_addr)
 		list_for_each(pos,
 			      &dtsec->multicast_addr_hash->lsts[bucket]) {
 			hash_entry = ETH_HASH_ENTRY_OBJ(pos);
-			if (hash_entry->addr == addr) {
+			if (hash_entry && hash_entry->addr == addr) {
 				list_del_init(&hash_entry->node);
 				kfree(hash_entry);
 				break;
@@ -1108,7 +1108,7 @@ int dtsec_del_hash_mac_address(struct fman_mac *dtsec, enet_addr_t *eth_addr)
 		list_for_each(pos,
 			      &dtsec->unicast_addr_hash->lsts[bucket]) {
 			hash_entry = ETH_HASH_ENTRY_OBJ(pos);
-			if (hash_entry->addr == addr) {
+			if (hash_entry && hash_entry->addr == addr) {
 				list_del_init(&hash_entry->node);
 				kfree(hash_entry);
 				break;
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 3e5b40c831558..4b0be0cebd199 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -952,7 +952,7 @@ int memac_del_hash_mac_address(struct fman_mac *memac, enet_addr_t *eth_addr)
 
 	list_for_each(pos, &memac->multicast_addr_hash->lsts[hash]) {
 		hash_entry = ETH_HASH_ENTRY_OBJ(pos);
-		if (hash_entry->addr == addr) {
+		if (hash_entry && hash_entry->addr == addr) {
 			list_del_init(&hash_entry->node);
 			kfree(hash_entry);
 			break;
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index e575259d20f40..c8ad9b8a75f8e 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -585,7 +585,7 @@ int tgec_del_hash_mac_address(struct fman_mac *tgec, enet_addr_t *eth_addr)
 
 	list_for_each(pos, &tgec->multicast_addr_hash->lsts[hash]) {
 		hash_entry = ETH_HASH_ENTRY_OBJ(pos);
-		if (hash_entry->addr == addr) {
+		if (hash_entry && hash_entry->addr == addr) {
 			list_del_init(&hash_entry->node);
 			kfree(hash_entry);
 			break;
-- 
2.25.1



