Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35219603D17
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbiJSI5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbiJSI4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:56:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E3B193DC;
        Wed, 19 Oct 2022 01:52:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB18C61866;
        Wed, 19 Oct 2022 08:50:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0E0C433C1;
        Wed, 19 Oct 2022 08:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169456;
        bh=kwElycgk0G90REzPfSoa4Yxr7/w7BcPRL2CXRgWe54U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gym8csTlV+Opwmw6lrQ8a8KKD2MuWRRvDGGfqbZROyReNd9FuBwBUgD+BK9+DJf6a
         2rVFFCEHblC4H3LxVGZhgfUjwxCfkZ/ZPsA2Jz8cRKG0OM4VIo6j430Rw2zlTWD8rb
         VDpNaw2ML3nD4Vq16UsM4lOZ4AoSg4+7kUB6fhMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 284/862] wifi: mt76: mt7915: fix possible unaligned access in mt7915_mac_add_twt_setup
Date:   Wed, 19 Oct 2022 10:26:11 +0200
Message-Id: <20221019083302.553066406@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 3d9aa54355d863e5412a7e08180f50a8f1827b7f ]

Fix possible unaligned pointer in mt7915_mac_add_twt_setup routine.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 3782b69d03e71 ("mt76: mt7915: introduce mt7915_mac_add_twt_setup routine")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 4ddcd3afa428..49aa5c056063 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -2071,8 +2071,9 @@ void mt7915_mac_add_twt_setup(struct ieee80211_hw *hw,
 	}
 
 	flowid = ffs(~msta->twt.flowid_mask) - 1;
-	le16p_replace_bits(&twt_agrt->req_type, flowid,
-			   IEEE80211_TWT_REQTYPE_FLOWID);
+	twt_agrt->req_type &= ~cpu_to_le16(IEEE80211_TWT_REQTYPE_FLOWID);
+	twt_agrt->req_type |= le16_encode_bits(flowid,
+					       IEEE80211_TWT_REQTYPE_FLOWID);
 
 	table_id = ffs(~dev->twt.table_mask) - 1;
 	exp = FIELD_GET(IEEE80211_TWT_REQTYPE_WAKE_INT_EXP, req_type);
@@ -2122,8 +2123,9 @@ void mt7915_mac_add_twt_setup(struct ieee80211_hw *hw,
 unlock:
 	mutex_unlock(&dev->mt76.mutex);
 out:
-	le16p_replace_bits(&twt_agrt->req_type, setup_cmd,
-			   IEEE80211_TWT_REQTYPE_SETUP_CMD);
+	twt_agrt->req_type &= ~cpu_to_le16(IEEE80211_TWT_REQTYPE_SETUP_CMD);
+	twt_agrt->req_type |=
+		le16_encode_bits(setup_cmd, IEEE80211_TWT_REQTYPE_SETUP_CMD);
 	twt->control = (twt->control & IEEE80211_TWT_CONTROL_WAKE_DUR_UNIT) |
 		       (twt->control & IEEE80211_TWT_CONTROL_RX_DISABLED);
 }
-- 
2.35.1



