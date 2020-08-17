Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA4724734A
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730945AbgHQSxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:53:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387803AbgHQPvl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:51:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D64E208B3;
        Mon, 17 Aug 2020 15:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679500;
        bh=xahJdK5HOHjZ/sQrsJBMAbZG1S10XcSs6h1S6y1Lf64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P2DPLvB+1FvErWLLQ4CSq3Jt87737uM4P0LY+m9hn7P1qu7zTVOey+NcHhSCKIC2L
         D0afA0ATbUT/rIkfqCzcKceyDJKF9iQj+JhDw9OkizwPr3uEpzwqHpmlu372YAJsJ7
         FGYbhU/iOAfNrmqRX/47GoUXI3LRTEuu5gl7ZA5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 234/393] mt76: mt7615: fix possible memory leak in mt7615_mcu_wtbl_sta_add
Date:   Mon, 17 Aug 2020 17:14:44 +0200
Message-Id: <20200817143830.972501520@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 2bccc8415883c1cd5ae8836548d9783dbbd84999 ]

Free the second mcu skb if __mt76_mcu_skb_send_msg() fails to transmit
the first one in mt7615_mcu_wtbl_sta_add().

Fixes: 99c457d902cf9 ("mt76: mt7615: move mt7615_mcu_set_bmc to mt7615_mcu_ops")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 9c55424962522..81d6127dc6fd8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -1036,8 +1036,12 @@ mt7615_mcu_wtbl_sta_add(struct mt7615_dev *dev, struct ieee80211_vif *vif,
 	skb = enable ? wskb : sskb;
 
 	err = __mt76_mcu_skb_send_msg(&dev->mt76, skb, cmd, true);
-	if (err < 0)
+	if (err < 0) {
+		skb = enable ? sskb : wskb;
+		dev_kfree_skb(skb);
+
 		return err;
+	}
 
 	cmd = enable ? MCU_EXT_CMD_STA_REC_UPDATE : MCU_EXT_CMD_WTBL_UPDATE;
 	skb = enable ? sskb : wskb;
-- 
2.25.1



