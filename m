Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24FE13C541F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345817AbhGLH5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:57:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243006AbhGLHwr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:52:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8732960200;
        Mon, 12 Jul 2021 07:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076198;
        bh=LSsML+qzbF1/RX6SUZAS8YjF4K/KOhywRNIJuKiEklo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V+drDrvmsONBzUANwQpYqXRan5AYEy/6vhXEvFdwm1C7rmqNxUQTcAhc9fcV9yTxk
         LCLhHf/gA4uYlqrO5DYzUbXBEkPHFWR4fgFssiNk3gzBaeb9gAKn/IynEji7w7rkAZ
         1BPMw9POU7XGb5DWTwMLMeCJrDKV0+s9aCF9Rsc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 540/800] net: broadcom: bcm4908_enet: reset DMA rings sw indexes properly
Date:   Mon, 12 Jul 2021 08:09:23 +0200
Message-Id: <20210712061024.824400895@linuxfoundation.org>
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

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit ddeacc4f6494e07cbb6f033627926623f3e7a9d0 ]

Resetting software indexes in bcm4908_dma_alloc_buf_descs() is not
enough as it's called during device probe only. Driver resets DMA on
every .ndo_open callback and it's required to reset indexes then.

This fixes inconsistent rings state and stalled traffic after interface
down & up sequence.

Fixes: 4feffeadbcb2 ("net: broadcom: bcm4908enet: add BCM4908 controller driver")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bcm4908_enet.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index 60d908507f51..02a569500234 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -174,9 +174,6 @@ static int bcm4908_dma_alloc_buf_descs(struct bcm4908_enet *enet,
 	if (!ring->slots)
 		goto err_free_buf_descs;
 
-	ring->read_idx = 0;
-	ring->write_idx = 0;
-
 	return 0;
 
 err_free_buf_descs:
@@ -304,6 +301,9 @@ static void bcm4908_enet_dma_ring_init(struct bcm4908_enet *enet,
 
 	enet_write(enet, ring->st_ram_block + ENET_DMA_CH_STATE_RAM_BASE_DESC_PTR,
 		   (uint32_t)ring->dma_addr);
+
+	ring->read_idx = 0;
+	ring->write_idx = 0;
 }
 
 static void bcm4908_enet_dma_uninit(struct bcm4908_enet *enet)
-- 
2.30.2



