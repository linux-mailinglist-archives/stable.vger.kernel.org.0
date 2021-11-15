Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F8645110C
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237949AbhKOTA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:00:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:57534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243325AbhKOS4b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:56:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96D21633CF;
        Mon, 15 Nov 2021 18:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999924;
        bh=p+JnmMFi7WIdppKC+S1L3Kmen7abJPfHWXn7TwXkfh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nzca5Ra9kAmb+S79ikorO28MPurKmxw3SEK701V6voULeX7kRwo2F70Lfeg9tlpDj
         WEEGllZyZbj6523Lk3ES3+eCdfFiCuMmvGy5LsmDtTFIkPV0ZRXJHVHuRtgvdMHC+T
         mVGDpCY3EQNS0NsnlWqY6/JE5sHh72OHlybAqsSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shayne Chen <shayne.chen@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 474/849] mt76: mt7915: fix sta_rec_wtbl tag len
Date:   Mon, 15 Nov 2021 17:59:17 +0100
Message-Id: <20211115165436.315226288@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit afa0370f3a3a64af6d368da0bedd72ab2a026cd0 ]

Fix tag len error for sta_rec_wtbl, which causes fw parsing error for
the tags placed behind it.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 85c9c08ee2a82..6dfe3716a63a5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -757,7 +757,7 @@ mt7915_mcu_alloc_wtbl_req(struct mt7915_dev *dev, struct mt7915_sta *msta,
 	}
 
 	if (sta_hdr)
-		sta_hdr->len = cpu_to_le16(sizeof(hdr));
+		le16_add_cpu(&sta_hdr->len, sizeof(hdr));
 
 	return skb_put_data(nskb, &hdr, sizeof(hdr));
 }
-- 
2.33.0



