Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0875D4513BD
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242393AbhKOTz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:55:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:45214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343964AbhKOTWb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00B3C6360C;
        Mon, 15 Nov 2021 18:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002162;
        bh=ZqtzCwWJmZwgK4rD5LjCXDimHEY7Is+c+F5SzG6TP9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mDKmB7hdR5OmXTKcDff9QNzPeJ+FRmmV8qMWml1fRBHcJYR4vwppEIWInIZnTodY9
         hZiR+2cYVIcRpfuMHQfK2Ej2bTWB0NNG+nvnfcLxYYPsl13g2PLZjrFKCDL1iBWCwa
         RVtSdVgEOb48f6qWUI77BzaK7GViUF5CEQcwtMxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Leon Yen <Leon.Yen@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 462/917] mt76: connac: fix mt76_connac_gtk_rekey_tlv usage
Date:   Mon, 15 Nov 2021 17:59:17 +0100
Message-Id: <20211115165444.438627839@linuxfoundation.org>
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

From: Leon Yen <Leon.Yen@mediatek.com>

[ Upstream commit d741abeafa47a7331cd4fe526e44db4ad3da0f62 ]

The mistaken structure is introduced since we added the GTK rekey offload
to mt7663. The patch fixes mt76_connac_gtk_rekey_tlv structure according
to the MT7663 and MT7921 firmware we have submitted into
linux-firmware.git.

Fixes: b47e21e75c80 ("mt76: mt7615: add gtk rekey offload support")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Leon Yen <Leon.Yen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 1c73beb226771..4bcd728ff97c5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -844,14 +844,14 @@ struct mt76_connac_gtk_rekey_tlv {
 			* 2: rekey update
 			*/
 	u8 keyid;
-	u8 pad[2];
+	u8 option; /* 1: rekey data update without enabling offload */
+	u8 pad[1];
 	__le32 proto; /* WPA-RSN-WAPI-OPSN */
 	__le32 pairwise_cipher;
 	__le32 group_cipher;
 	__le32 key_mgmt; /* NONE-PSK-IEEE802.1X */
 	__le32 mgmt_group_cipher;
-	u8 option; /* 1: rekey data update without enabling offload */
-	u8 reserverd[3];
+	u8 reserverd[4];
 } __packed;
 
 #define MT76_CONNAC_WOW_MASK_MAX_LEN			16
-- 
2.33.0



