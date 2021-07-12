Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2043C53E1
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348902AbhGLH4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350736AbhGLHvP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D998A61C3A;
        Mon, 12 Jul 2021 07:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076074;
        bh=f2yLioH0gqhAl+wZOfgsJCAfJsfL79kyo4J8lbudNt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hRFXSLnciR/hKNh+QxR2d6rCpwKboZo0OhAGJ9QJJHQVrcKW7QbKf6bUJuVKu+YTy
         NaGLLUbCBJw37SOVMD7AYO32prXYlUtpozwHpz+ew/KksRlsimy+JdaGO6GQSeuoTL
         Ma3QXUkx4Z/CQ9ayCJQxSou4ypXkzHG1kiM3zcus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 488/800] mt76: mt7915: fix a signedness bug in mt7915_mcu_apply_tx_dpd()
Date:   Mon, 12 Jul 2021 08:08:31 +0200
Message-Id: <20210712061019.087705812@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 861fad474ec7638aeca46a508da4ea81612374b9 ]

"idx" needs to be signed for the error handling to work.

Fixes: 495184ac91bb ("mt76: mt7915: add support for applying pre-calibration data")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index b3f14ff67c5a..764f25a828fa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -3440,8 +3440,9 @@ int mt7915_mcu_apply_tx_dpd(struct mt7915_phy *phy)
 {
 	struct mt7915_dev *dev = phy->dev;
 	struct cfg80211_chan_def *chandef = &phy->mt76->chandef;
-	u16 total = 2, idx, center_freq = chandef->center_freq1;
+	u16 total = 2, center_freq = chandef->center_freq1;
 	u8 *cal = dev->cal, *eep = dev->mt76.eeprom.data;
+	int idx;
 
 	if (!(eep[MT_EE_DO_PRE_CAL] & MT_EE_WIFI_CAL_DPD))
 		return 0;
-- 
2.30.2



