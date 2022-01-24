Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE06499FEF
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842383AbiAXXBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351118AbiAXWxj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:53:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A111C0EE12B;
        Mon, 24 Jan 2022 13:08:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 275DFB8123D;
        Mon, 24 Jan 2022 21:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20201C340E5;
        Mon, 24 Jan 2022 21:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058506;
        bh=7kR9ewpZ7hOXX/Afq2CPiSJiQAxrzpCzuz/GkMjpraY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AZwb7YScHIfHQJEPq6tT1sGRM9cbfQdpNR2GRiczGyWfwBqajvfReSUJ2/sAGAhx1
         xYMety0mYuUFssKyVymBzJlWpHLP+sQget4MSzshQ5zb8PB0v8f7vWlZt69cN0ox+M
         RZdgEcRmc5wOLv16uiqLZ4qTh43teYe2JwyYIuDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0312/1039] mt76: mt7921: fix possible NULL pointer dereference in mt7921_mac_write_txwi
Date:   Mon, 24 Jan 2022 19:35:01 +0100
Message-Id: <20220124184135.792115428@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit ec2ebc1c5a5ce49538fa78108c53eaf722eee908 ]

Fix a possible NULL pointer deference issue in mt7921_mac_write_txwi
routine if vif is NULL.

Fixes: 33920b2bf0483 ("mt76: add support for setting mcast rate")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index db3302b1576a0..321d9f1d3f865 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -903,7 +903,7 @@ void mt7921_mac_write_txwi(struct mt7921_dev *dev, __le32 *txwi,
 		mt7921_mac_write_txwi_80211(dev, txwi, skb, key);
 
 	if (txwi[2] & cpu_to_le32(MT_TXD2_FIX_RATE)) {
-		int rateidx = ffs(vif->bss_conf.basic_rates) - 1;
+		int rateidx = vif ? ffs(vif->bss_conf.basic_rates) - 1 : 0;
 		u16 rate, mode;
 
 		/* hardware won't add HTC for mgmt/ctrl frame */
-- 
2.34.1



