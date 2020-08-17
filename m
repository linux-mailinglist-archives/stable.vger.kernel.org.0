Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD3824734E
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731288AbgHQSyK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:54:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387684AbgHQPvi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:51:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50A6920888;
        Mon, 17 Aug 2020 15:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679497;
        bh=QZcpCo9ScGW3+oAFSbob6JjjsEdCo+0uTrz+AhIOvko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kl95fow5pkoF2LhltzsXO71uoUMUxtgkQPMgrLxyHSUAXrOi6QLhE/+qZRYoRFD+O
         4pHm2jIi0nxCJMcyYnMorwsQd1QyAyfdVBjin6weR/6srkYXmqllCv0OTFLIz3EBEg
         KF071q4wt32IbiI1CerwZPTfx1/hfc1l4OFducyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 233/393] mt76: mt7615: fix potential memory leak in mcu message handler
Date:   Mon, 17 Aug 2020 17:14:43 +0200
Message-Id: <20200817143830.924540128@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 9248c08c3fc4ef816c82aa49d01123f4746d349f ]

Fix potential memory leak in mcu message handler on error condition.

Fixes: 0e6a29e477f3 ("mt76: mt7615: add support to read temperature from mcu")
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 29a7aaabb6da1..9c55424962522 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -167,8 +167,10 @@ mt7615_mcu_parse_response(struct mt7615_dev *dev, int cmd,
 	struct mt7615_mcu_rxd *rxd = (struct mt7615_mcu_rxd *)skb->data;
 	int ret = 0;
 
-	if (seq != rxd->seq)
-		return -EAGAIN;
+	if (seq != rxd->seq) {
+		ret = -EAGAIN;
+		goto out;
+	}
 
 	switch (cmd) {
 	case MCU_CMD_PATCH_SEM_CONTROL:
@@ -182,6 +184,7 @@ mt7615_mcu_parse_response(struct mt7615_dev *dev, int cmd,
 	default:
 		break;
 	}
+out:
 	dev_kfree_skb(skb);
 
 	return ret;
-- 
2.25.1



