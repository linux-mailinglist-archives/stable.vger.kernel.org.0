Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E785B0157
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 12:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiIGKKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 06:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiIGKKp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 06:10:45 -0400
X-Greylist: delayed 1090 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 07 Sep 2022 03:10:43 PDT
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1643A8C47F;
        Wed,  7 Sep 2022 03:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=z96JYwHkG5ZMX+ITR927kcomX9VLur5EBNe6U2ylMag=; b=Tn0uzJ6SU3liCRCp8WCA7tQ48x
        Ix2jUf333YaxgYTNueoYbnM0B1C71oMw4ASzWoOdWjZkQDrpCe+kzWAAjpLwfVhdY+6VrIEuVgn3n
        0nv4VwaPl9qZcjS6e4DJx2v6STz72REBCQz+yTmd8e7NWp7O1N0xVOCU8waH8ulTgFgk=;
Received: from p200300daa712e200cd0c7d6e3308f16b.dip0.t-ipconnect.de ([2003:da:a712:e200:cd0c:7d6e:3308:f16b] helo=localhost.localdomain)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1oVrjR-002a8O-Uz; Wed, 07 Sep 2022 11:52:30 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     kvalo@kernel.org, stable@vger.kernel.org
Subject: [PATCH 6.0] mt76: fix 5 GHz connection regression on mt76x0/mt76x2
Date:   Wed,  7 Sep 2022 11:52:28 +0200
Message-Id: <20220907095228.82072-1-nbd@nbd.name>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some users have reported being unable to connect to MT76x0 APs running mt76
after a commit enabling the VHT extneded NSS BW feature.
Fix this regression by ensuring that this feature only gets enabled on drivers
that support it

Cc: stable@vger.kernel.org
Fixes: d9fcfc1424aa ("mt76: enable the VHT extended NSS BW feature")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 253cbc1956d1..6de13d641438 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -267,7 +267,8 @@ static void mt76_init_stream_cap(struct mt76_phy *phy,
 	}
 	vht_cap->vht_mcs.rx_mcs_map = cpu_to_le16(mcs_map);
 	vht_cap->vht_mcs.tx_mcs_map = cpu_to_le16(mcs_map);
-	vht_cap->vht_mcs.tx_highest |=
+	if (ieee80211_hw_check(phy->hw, SUPPORTS_VHT_EXT_NSS_BW))
+		vht_cap->vht_mcs.tx_highest |=
 				cpu_to_le16(IEEE80211_VHT_EXT_NSS_BW_CAPABLE);
 }
 
-- 
2.36.1

