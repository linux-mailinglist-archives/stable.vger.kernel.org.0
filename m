Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5000249979F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448900AbiAXVOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:14:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60210 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446607AbiAXVIs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:08:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B66ADB80CCF;
        Mon, 24 Jan 2022 21:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9A2C340E5;
        Mon, 24 Jan 2022 21:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058525;
        bh=AONqG5bMtL6kUVRHWb9GpOeyQRbkloKcPD/OKYlC4ZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jL0f3rTxZfy8f3kmECkdglqwRrdQBdN8rD97pUf8mAq48RtIbRxcNMu0bUVOSg0Wo
         AyxazxgG8y48Sza2X2cAErPiAc6MXmW3ei7K+HdwiQw1v/oNv5gee2CE+ZN4IVrIo8
         kr+i80in2bGNCB6ht6vvpiJDCVUd4wAR2Ngbbi40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0317/1039] mt76: connac: fix last_chan configuration in mt76_connac_mcu_rate_txpower_band
Date:   Mon, 24 Jan 2022 19:35:06 +0100
Message-Id: <20220124184135.951734676@linuxfoundation.org>
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

[ Upstream commit 73c7c0443685d8d152c3451e7305a2c2bc47b32e ]

last_ch configuration must not be dependent on the current configured band
but it is defined by hw capabilities since the fw always expects the
following order:
- 2GHz
- 5GHz
- 6GHz

Fixes: 9b2ea8eee42a1 ("mt76: connac: set 6G phymode in single-sku support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 61c4c86e79c88..b15bbd650a90c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -2008,12 +2008,12 @@ mt76_connac_mcu_rate_txpower_band(struct mt76_phy *phy,
 	}
 	batch_size = DIV_ROUND_UP(n_chan, batch_len);
 
-	if (!phy->cap.has_5ghz)
-		last_ch = chan_list_2ghz[n_chan - 1];
-	else if (phy->cap.has_6ghz)
-		last_ch = chan_list_6ghz[n_chan - 1];
+	if (phy->cap.has_6ghz)
+		last_ch = chan_list_6ghz[ARRAY_SIZE(chan_list_6ghz) - 1];
+	else if (phy->cap.has_5ghz)
+		last_ch = chan_list_5ghz[ARRAY_SIZE(chan_list_5ghz) - 1];
 	else
-		last_ch = chan_list_5ghz[n_chan - 1];
+		last_ch = chan_list_2ghz[ARRAY_SIZE(chan_list_2ghz) - 1];
 
 	for (i = 0; i < batch_size; i++) {
 		struct mt76_connac_tx_power_limit_tlv tx_power_tlv = {};
-- 
2.34.1



