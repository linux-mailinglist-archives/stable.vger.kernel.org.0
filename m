Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2523CAAC6
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244216AbhGOTPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:15:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244235AbhGOTOh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:14:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EB97613D4;
        Thu, 15 Jul 2021 19:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376190;
        bh=oYpL2aaow/wJPbnsz25tGe7LetsSdX7DUMIWaFdH0jY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EnDY6KdU0rTF6PSpuqHckxx+qFylvzg+Nrqcm+UdKvkPCPrtA1tkfE8qlojqjWLM7
         ZAlr4qt9fhzsHIcKsudBnKMCnbghjBzDUmDi8SB0beglSjxDbK+B0haldfn241582o
         wLJzpL+43eZhmKGDl+fsBlbitqa6u3pd08a04uMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 123/266] mt76: mt7921: reset wfsys during hw probe
Date:   Thu, 15 Jul 2021 20:37:58 +0200
Message-Id: <20210715182635.612615526@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 01f7da40917923bf9d8fd8d5c9a6ed646004e47c ]

This patch fixes a mcu hang during device probe on
Marvell ESPRESSObin after a hot reboot.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/dma.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/dma.c b/drivers/net/wireless/mediatek/mt76/mt7921/dma.c
index bd9143dc865f..7fca7dc466b8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/dma.c
@@ -402,6 +402,10 @@ int mt7921_dma_init(struct mt7921_dev *dev)
 	if (ret)
 		return ret;
 
+	ret = mt7921_wfsys_reset(dev);
+	if (ret)
+		return ret;
+
 	/* init tx queue */
 	ret = mt7921_init_tx_queues(&dev->phy, MT7921_TXQ_BAND0,
 				    MT7921_TX_RING_SIZE);
-- 
2.30.2



