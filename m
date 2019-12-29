Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 633BD12C874
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732761AbfL2Ry5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:54:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:43214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732494AbfL2Ry4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:54:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3FC220718;
        Sun, 29 Dec 2019 17:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642096;
        bh=e0Jf8XfCt+ro6en0WD9ghdHlLEAs8kS8RebIWIpPM1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vPb3x+Rcewjk/+GCCXsEN24+PlQXEfcViHQUPnfK5KfY3FHcwZxIY8obLP8FraKF0
         Pf93v27jGcAzijhrdT2rf2Bo5yNxHMEv3rq5nPCHes8jfK9HBVOcm2Rg1687mRAL+9
         NEpfHksONuR/rV2UYRW6W+lkFS0/Cq60KdZWuscE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 341/434] mt76: fix possible out-of-bound access in mt7615_fill_txs/mt7603_fill_txs
Date:   Sun, 29 Dec 2019 18:26:34 +0100
Message-Id: <20191229172724.619423269@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit e8b970c8e367e85fab9b8ac4f36080e5d653c38e ]

Fix possible out-of-bound access of status rates array in
mt7615_fill_txs/mt7603_fill_txs routines

Fixes: c5211e997eca ("mt76: mt7603: rework and fix tx status reporting")
Fixes: 4af81f02b49c ("mt76: mt7615: sync with mt7603 rate control changes")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c | 4 +++-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index c328192307c4..ff3f3d98b625 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -1032,8 +1032,10 @@ mt7603_fill_txs(struct mt7603_dev *dev, struct mt7603_sta *sta,
 		if (idx && (cur_rate->idx != info->status.rates[i].idx ||
 			    cur_rate->flags != info->status.rates[i].flags)) {
 			i++;
-			if (i == ARRAY_SIZE(info->status.rates))
+			if (i == ARRAY_SIZE(info->status.rates)) {
+				i--;
 				break;
+			}
 
 			info->status.rates[i] = *cur_rate;
 			info->status.rates[i].count = 0;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index e07ce2c10013..111e38ff954a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -914,8 +914,10 @@ static bool mt7615_fill_txs(struct mt7615_dev *dev, struct mt7615_sta *sta,
 		if (idx && (cur_rate->idx != info->status.rates[i].idx ||
 			    cur_rate->flags != info->status.rates[i].flags)) {
 			i++;
-			if (i == ARRAY_SIZE(info->status.rates))
+			if (i == ARRAY_SIZE(info->status.rates)) {
+				i--;
 				break;
+			}
 
 			info->status.rates[i] = *cur_rate;
 			info->status.rates[i].count = 0;
-- 
2.20.1



