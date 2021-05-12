Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5CCA37CE95
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345027AbhELRFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:05:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235941AbhELQr4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:47:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2C1061E7E;
        Wed, 12 May 2021 16:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836128;
        bh=F47fYqBcJBfoO4/Vv01Jv7/ubvfB3rFIHoSPfyHa4co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E60Gl3oCatmetBE5cxRhsZe6yeNvsLuidfXAfWOs35wzj7NKHp5oCv7+aGOxjj5Tr
         ugfs0e09iDaJyUMVG5WeN48+4JC84EgIjkcV8wxg2ORiAh8b4HLSkPBsLsFyJb7KC1
         nvYDyKytNLoNFy8ffILTm+AIllXrjcsw5Fll8ORY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 621/677] mt76: mt7615: Fix a dereference of pointer sta before it is null checked
Date:   Wed, 12 May 2021 16:51:07 +0200
Message-Id: <20210512144857.998022072@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 4a52d6abb193aea0f2923a2c917502bd2d718630 ]

Currently the assignment of idx dereferences pointer sta before
sta is null checked, leading to a potential null pointer dereference.
Fix this by assigning idx when it is required after the null check on
pointer sta.

Addresses-Coverity: ("Dereference before null check")
Fixes: a4a5a430b076 ("mt76: mt7615: fix TSF configuration")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c b/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
index 4a370b9f7a17..f8d3673c2cae 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
@@ -67,7 +67,7 @@ static int mt7663_usb_sdio_set_rates(struct mt7615_dev *dev,
 	struct mt7615_rate_desc *rate = &wrd->rate;
 	struct mt7615_sta *sta = wrd->sta;
 	u32 w5, w27, addr, val;
-	u16 idx = sta->vif->mt76.omac_idx;
+	u16 idx;
 
 	lockdep_assert_held(&dev->mt76.mutex);
 
@@ -119,6 +119,7 @@ static int mt7663_usb_sdio_set_rates(struct mt7615_dev *dev,
 
 	sta->rate_probe = sta->rateset[rate->rateset].probe_rate.idx != -1;
 
+	idx = sta->vif->mt76.omac_idx;
 	idx = idx > HW_BSSID_MAX ? HW_BSSID_0 : idx;
 	addr = idx > 1 ? MT_LPON_TCR2(idx): MT_LPON_TCR0(idx);
 
-- 
2.30.2



