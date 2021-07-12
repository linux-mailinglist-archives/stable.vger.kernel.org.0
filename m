Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C303C53F5
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349114AbhGLH4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351197AbhGLHvc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F066D61152;
        Mon, 12 Jul 2021 07:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076123;
        bh=fxspT45mABf432UG+nRVfwmql+OY/bRQ/p+G/N05w7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zd4WuH5Wp/nb9LmS6IUHPGQCYhz2NAkYYTFcXbhNe+V+0ozKhEcfxfU2oqhldrkHC
         DFsZ4xRMa/OeZOr2Nq7IoVsndAS/jiAezUtFp85b8po9HO6P8Wp2hFQ1W1gFHCdmtc
         r51fHZ7aJhIL1FZiOZ8aW3P2WwySil5hITy5LTZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 507/800] mt76: mt7921: fix kernel warning when reset on vif is not sta
Date:   Mon, 12 Jul 2021 08:08:50 +0200
Message-Id: <20210712061021.152396719@linuxfoundation.org>
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

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 78b0328ff8c46fce64eb969d2572c3f631735dc1 ]

ieee80211_disconnect is only called for the staton mode.

[  714.050429] WARNING: CPU: 1 PID: 382 at net/mac80211/mlme.c:2787
ieee80211_disconnect+0x108/0x118 [mac80211]
[  714.116704] Hardware name: MediaTek Asurada rev1 board (DT)
[  714.122303] Workqueue: mt76 mt7921_mac_reset_work [mt7921e]
[  714.127877] pstate: 20c00009 (nzCv daif +PAN +UAO)
[  714.132761] pc : ieee80211_disconnect+0x108/0x118 [mac80211]
[  714.138430] lr : mt7921_vif_connect_iter+0x28/0x54 [mt7921e]
[  714.144083] sp : ffffffc0107cbbd0
[  714.147394] x29: ffffffc0107cbbd0 x28: ffffffb26c9cb928
[  714.152706] x27: ffffffb26c9cbd98 x26: 0000000000000000
[  714.158017] x25: 0000000000000003 x24: ffffffb26c9c9c38
[  714.163328] x23: ffffffb26c9c9c38 x22: ffffffb26c9c8860
[  714.168639] x21: ffffffb23b940000 x20: ffffffb26c9c8860
[  714.173950] x19: 0000000000000001 x18: 000000000000b67e
[  714.179261] x17: 00000000064dd409 x16: ffffffd739cb28f0
[  714.184571] x15: 0000000000000000 x14: 0000000000000227
[  714.189881] x13: 0000000000000400 x12: ffffffd73a4eb060
[  714.195191] x11: 0000000000000000 x10: 0000000000000000
[  714.200502] x9 : ffffffd703a0a000 x8 : 0000000000000006
[  714.205812] x7 : 2828282828282828 x6 : ffffffb200440396
[  714.211122] x5 : 0000000000000000 x4 : 0000000000000004
[  714.216432] x3 : 0000000000000000 x2 : ffffffb23b940c90
[  714.221743] x1 : 0000000000000001 x0 : ffffffb23b940c90
[  714.227054] Call trace:
[  714.229594]  ieee80211_disconnect+0x108/0x118 [mac80211]
[  714.234913]  mt7921_vif_connect_iter+0x28/0x54 [mt7921e]
[  714.240313]  __iterate_interfaces+0xc4/0xdc [mac80211]
[  714.245541]  ieee80211_iterate_interfaces+0x4c/0x68 [mac80211]
[  714.251381]  mt7921_mac_reset_work+0x410/0x468 [mt7921e]
[  714.256696]  process_one_work+0x208/0x3c8
[  714.260706]  worker_thread+0x23c/0x3e8
[  714.264456]  kthread+0x140/0x17c
[  714.267685]  ret_from_fork+0x10/0x18

Fixes: 0c1ce9884607 ("mt76: mt7921: add wifi reset support")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index 5e00dd589331..853db0a52181 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -1199,7 +1199,8 @@ mt7921_vif_connect_iter(void *priv, u8 *mac,
 	struct mt7921_vif *mvif = (struct mt7921_vif *)vif->drv_priv;
 	struct mt7921_dev *dev = mvif->phy->dev;
 
-	ieee80211_disconnect(vif, true);
+	if (vif->type == NL80211_IFTYPE_STATION)
+		ieee80211_disconnect(vif, true);
 
 	mt76_connac_mcu_uni_add_dev(&dev->mphy, vif, &mvif->sta.wcid, true);
 	mt7921_mcu_set_tx(dev, vif);
-- 
2.30.2



