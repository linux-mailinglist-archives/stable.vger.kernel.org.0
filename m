Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7C06AE959
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbjCGRXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbjCGRWo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:22:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22A17FD6D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:18:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A18EB81987
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F3EC4339B;
        Tue,  7 Mar 2023 17:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209494;
        bh=JEOQEUjjdwbB4mqUdUGq5hQYTdj1oNoOzvtqRQNMLl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RH1OGsnsVTfJuQ2DyldagUqL5+bRjFdqsvwiOJWQW9ju2VH1etO1v48I53bQ34zKp
         CwTX5aCsA2dfmJ6P8f1+Cwo3Uma7V+99MeHjFr1htg6V+Vu/DUNhY8F7mEa50+++r/
         DHZmzn1Z1tVYR11ADWVRMcq+LZf7FAHHhMmynyQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ryder Lee <ryder.lee@mediatek.com>,
        Howard Hsu <howard-yh.hsu@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0238/1001] wifi: mt76: mt7915: call mt7915_mcu_set_thermal_throttling() only after init_work
Date:   Tue,  7 Mar 2023 17:50:10 +0100
Message-Id: <20230307170032.157243223@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Howard Hsu <howard-yh.hsu@mediatek.com>

[ Upstream commit 7d12b38ab6f6b77198cd3a66db19587bbdd3308c ]

Enable thermal management by default shall not be executed during mcu
init. This causes thermal configuration being reset to the firmware
default settings.

Fixes: 0063b86c9120 ("mt76: mt7915e: Enable thermal management by default")
Reviewed-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 3 +--
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 6 ++++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index c810c31fbd6e9..41019ba24a048 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -201,8 +201,7 @@ static int mt7915_thermal_init(struct mt7915_phy *phy)
 	phy->throttle_temp[0] = 110;
 	phy->throttle_temp[1] = 120;
 
-	return mt7915_mcu_set_thermal_throttling(phy,
-						 MT7915_THERMAL_THROTTLE_MAX);
+	return 0;
 }
 
 static void mt7915_led_set_config(struct led_classdev *led_cdev,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 0511d6a505b09..98af032eba097 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -57,6 +57,12 @@ int mt7915_run(struct ieee80211_hw *hw)
 		mt7915_mac_enable_nf(dev, phy->mt76->band_idx);
 	}
 
+	ret = mt7915_mcu_set_thermal_throttling(phy,
+						MT7915_THERMAL_THROTTLE_MAX);
+
+	if (ret)
+		goto out;
+
 	ret = mt76_connac_mcu_set_rts_thresh(&dev->mt76, 0x92b,
 					     phy->mt76->band_idx);
 	if (ret)
-- 
2.39.2



