Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3F93C4E6C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244778AbhGLHSm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:18:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244551AbhGLHRk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:17:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C42A61153;
        Mon, 12 Jul 2021 07:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074092;
        bh=+KYDax4teL/bh8Ep/BFT1j9CoyAUqHmQulhR5ZHRf/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o9eFJbIyWoVTnrZApDM3Mwa1QCdQzdkC6sqXtvvFDa6TuO+4vw57IKrCx8+6MT2XA
         51ioljEOiZQIgG1hCIecX2I+T+YvkjX3WBD4Uv9tts3gT1TfTLStcbcS82yT/uaoQf
         0mYJMKEFXyYuTB0z4v4MLI46bddIGYNYOb0z1mRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 462/700] net: broadcom: bcm4908_enet: reset DMA rings sw indexes properly
Date:   Mon, 12 Jul 2021 08:09:05 +0200
Message-Id: <20210712061025.736638577@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index 65981931a798..a31984cd0fb7 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -165,9 +165,6 @@ static int bcm4908_dma_alloc_buf_descs(struct bcm4908_enet *enet,
 	if (!ring->slots)
 		goto err_free_buf_descs;
 
-	ring->read_idx = 0;
-	ring->write_idx = 0;
-
 	return 0;
 
 err_free_buf_descs:
@@ -295,6 +292,9 @@ static void bcm4908_enet_dma_ring_init(struct bcm4908_enet *enet,
 
 	enet_write(enet, ring->st_ram_block + ENET_DMA_CH_STATE_RAM_BASE_DESC_PTR,
 		   (uint32_t)ring->dma_addr);
+
+	ring->read_idx = 0;
+	ring->write_idx = 0;
 }
 
 static void bcm4908_enet_dma_uninit(struct bcm4908_enet *enet)
-- 
2.30.2



