Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9B396086DE
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbiJVHzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbiJVHwv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:52:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C942CA7DC;
        Sat, 22 Oct 2022 00:46:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3988B60B3B;
        Sat, 22 Oct 2022 07:45:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192F7C433D6;
        Sat, 22 Oct 2022 07:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424700;
        bh=VRLqewPZnRfvRb2gTusmvVhdK4472AhYpCvXWsyNu4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=128Mk6uGJWbDuGB2cdAvsIZmO90vMkS2ydUOCL+hldbFIYAV28W9GGp23Uvj+kWPQ
         PgUT8mnVxH+Rdnrs+Sgy6zoEHmYYkSqeUbV9E5rRIXe/dFfY9ElUkq6CQoy3Quzv4m
         oADV9bh54Rb3FBhneWC99L0clif9g7lgAGpM7dbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 244/717] wifi: mt76: mt7915: fix possible unaligned access in mt7915_mac_add_twt_setup
Date:   Sat, 22 Oct 2022 09:22:03 +0200
Message-Id: <20221022072458.124221443@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 89f10bf885ba..4f3a3a88f086 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -2536,8 +2536,9 @@ void mt7915_mac_add_twt_setup(struct ieee80211_hw *hw,
 	}
 
 	flowid = ffs(~msta->twt.flowid_mask) - 1;
-	le16p_replace_bits(&twt_agrt->req_type, flowid,
-			   IEEE80211_TWT_REQTYPE_FLOWID);
+	twt_agrt->req_type &= ~cpu_to_le16(IEEE80211_TWT_REQTYPE_FLOWID);
+	twt_agrt->req_type |= le16_encode_bits(flowid,
+					       IEEE80211_TWT_REQTYPE_FLOWID);
 
 	table_id = ffs(~dev->twt.table_mask) - 1;
 	exp = FIELD_GET(IEEE80211_TWT_REQTYPE_WAKE_INT_EXP, req_type);
@@ -2587,8 +2588,9 @@ void mt7915_mac_add_twt_setup(struct ieee80211_hw *hw,
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



