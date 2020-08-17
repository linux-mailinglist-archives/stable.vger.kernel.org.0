Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D54C24706A
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390247AbgHQSIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:08:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388434AbgHQQIM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:08:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C581820888;
        Mon, 17 Aug 2020 16:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680488;
        bh=Fwo0FDK2/w9SWFeNDQy6dcWQ1EaURSRHtoIZWGQM2A4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XlGz7FABQH8uMsim3xjRbCU2hLOK77aftJe19CjguRFHBrbW9YWZd1T0xz47teWQ+
         UoJqvZBmGUbCVYolozsPcUuEdgjS5CgubgOa6gn91tCUoY2+LYdGpLABcR+RMDaT9g
         k6shoiSnxmnuxOo+mzHu6VkL8zXKkAEY2rtgMXgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 207/270] fsl/fman: check dereferencing null pointer
Date:   Mon, 17 Aug 2020 17:16:48 +0200
Message-Id: <20200817143806.100230362@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
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
index 1ca543ac8f2cd..d2de9ea80c43f 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -1205,7 +1205,7 @@ int dtsec_del_hash_mac_address(struct fman_mac *dtsec, enet_addr_t *eth_addr)
 		list_for_each(pos,
 			      &dtsec->multicast_addr_hash->lsts[bucket]) {
 			hash_entry = ETH_HASH_ENTRY_OBJ(pos);
-			if (hash_entry->addr == addr) {
+			if (hash_entry && hash_entry->addr == addr) {
 				list_del_init(&hash_entry->node);
 				kfree(hash_entry);
 				break;
@@ -1218,7 +1218,7 @@ int dtsec_del_hash_mac_address(struct fman_mac *dtsec, enet_addr_t *eth_addr)
 		list_for_each(pos,
 			      &dtsec->unicast_addr_hash->lsts[bucket]) {
 			hash_entry = ETH_HASH_ENTRY_OBJ(pos);
-			if (hash_entry->addr == addr) {
+			if (hash_entry && hash_entry->addr == addr) {
 				list_del_init(&hash_entry->node);
 				kfree(hash_entry);
 				break;
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 08f8b36779ea4..9088b4f4b4b87 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -985,7 +985,7 @@ int memac_del_hash_mac_address(struct fman_mac *memac, enet_addr_t *eth_addr)
 
 	list_for_each(pos, &memac->multicast_addr_hash->lsts[hash]) {
 		hash_entry = ETH_HASH_ENTRY_OBJ(pos);
-		if (hash_entry->addr == addr) {
+		if (hash_entry && hash_entry->addr == addr) {
 			list_del_init(&hash_entry->node);
 			kfree(hash_entry);
 			break;
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index f75b9c11b2d29..ac5a281e0ec3b 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -630,7 +630,7 @@ int tgec_del_hash_mac_address(struct fman_mac *tgec, enet_addr_t *eth_addr)
 
 	list_for_each(pos, &tgec->multicast_addr_hash->lsts[hash]) {
 		hash_entry = ETH_HASH_ENTRY_OBJ(pos);
-		if (hash_entry->addr == addr) {
+		if (hash_entry && hash_entry->addr == addr) {
 			list_del_init(&hash_entry->node);
 			kfree(hash_entry);
 			break;
-- 
2.25.1



