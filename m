Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8424451F5C
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356102AbhKPAiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343958AbhKOTWb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69DC0613A7;
        Mon, 15 Nov 2021 18:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002173;
        bh=U+Cz+1MOXx3jqtBh8kCLfofdzsmkjEKbIY+PGsRFGV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGJAYQiTNok7Ge3XvvfDUH81sLo1bYllwH+ojc/tezF3xNaPZeU0rFgoGhnhgin62
         8PMEx0yJuA4ulyIl/6olRW/3MDpGfz8PQ9kdkEDaxD+1maAwnYrymVUXzadbD2M4hi
         vYXRNtNuQvTpQtKEn9IcjQSHZdfSI3HJ9BshsoIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jimmy Hu <Jimmy.Hu@mediatek.com>,
        Deren Wu <deren.wu@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 466/917] mt76: mt7921: Fix out of order process by invalid event pkt
Date:   Mon, 15 Nov 2021 17:59:21 +0100
Message-Id: <20211115165444.575954915@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deren Wu <deren.wu@mediatek.com>

[ Upstream commit cd3f387371e941e6806b455b4ba5b9f4ca4b77c6 ]

The acceptable event report should inlcude original CMD-ID. Otherwise,
drop unexpected result from fw.

Fixes: 1c099ab44727c ("mt76: mt7921: add MCU support")
Signed-off-by: Jimmy Hu <Jimmy.Hu@mediatek.com>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 8329b705c2ca2..8ced55501d373 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -157,6 +157,7 @@ mt7921_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 			  struct sk_buff *skb, int seq)
 {
 	struct mt7921_mcu_rxd *rxd;
+	int mcu_cmd = cmd & MCU_CMD_MASK;
 	int ret = 0;
 
 	if (!skb) {
@@ -194,6 +195,9 @@ mt7921_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 		skb_pull(skb, sizeof(*rxd));
 		event = (struct mt7921_mcu_uni_event *)skb->data;
 		ret = le32_to_cpu(event->status);
+		/* skip invalid event */
+		if (mcu_cmd != event->cid)
+			ret = -EAGAIN;
 		break;
 	}
 	case MCU_CMD_REG_READ: {
-- 
2.33.0



