Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F18C59395E
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244662AbiHOS62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245123AbiHOS4t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:56:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723B932B80;
        Mon, 15 Aug 2022 11:31:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F0DAB81074;
        Mon, 15 Aug 2022 18:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F33AC433C1;
        Mon, 15 Aug 2022 18:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588303;
        bh=wyiVrrGdycrYaIwarSvQnWljLCRKuXVgDXQDnpxxn+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LNlYtFzA5tAhb/VtnpGNUPORWT49hn/H0XvCOIM0CthSBTmSseWay/PNqZ4+M5+4i
         l8iGIwpWP2V3BVqpNUAaqRBLDclDHakecbxinq2+ZG/JhYMLFZ9/NaJrZlA4rQV3sI
         SahnO6WxjYOgCTX3TrE1tRhq4tAbBqSG4LVt0ovE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Deren Wu <deren.wu@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 329/779] mt76: mt7921: fix aggregation subframes setting to HE max
Date:   Mon, 15 Aug 2022 19:59:33 +0200
Message-Id: <20220815180351.353510538@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deren Wu <deren.wu@mediatek.com>

[ Upstream commit d5a50e6bd1972c481f82befa846dce0b9866f025 ]

mt7921/mt7922 support HE max aggregation subframes 256 for both tx/rx.
Get better throughput then before.

Fixes: 94bb18b03d43 ("mt76: mt7921: fix max aggregation subframes setting")
Tested-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Reviewed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index 78a00028137b..a8998e6bfb6f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -49,8 +49,8 @@ mt7921_init_wiphy(struct ieee80211_hw *hw)
 	struct wiphy *wiphy = hw->wiphy;
 
 	hw->queues = 4;
-	hw->max_rx_aggregation_subframes = 64;
-	hw->max_tx_aggregation_subframes = 128;
+	hw->max_rx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF_HE;
+	hw->max_tx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF_HE;
 	hw->netdev_features = NETIF_F_RXCSUM;
 
 	hw->radiotap_timestamp.units_pos =
-- 
2.35.1



