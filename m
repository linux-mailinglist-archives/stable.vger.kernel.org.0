Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5403B541AF2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378036AbiFGVmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380822AbiFGViz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:38:55 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518E233E39;
        Tue,  7 Jun 2022 12:05:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7931BCE249F;
        Tue,  7 Jun 2022 19:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62816C341C4;
        Tue,  7 Jun 2022 19:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628736;
        bh=VvEMwFTsWdTGPEoYmkCgqck1dH6F3jcTrr8S+0Olq6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OyZBzEgcsOdHoec92xQZXNvGZmJfRaSVX/INX6tc6Z6mHzgY6hZCHZR5NQ8jIaTSW
         rYpp9xjf4M45wJVuyxMKSsbN4uxDUvpYkqAd/iVALLyi4L07vL4zGIvH/z/0YHX8Ak
         k64Q+P+XfXmapEU1zZ3+MEpSk8ogzmpo1m7z6Tfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Deren Wu <deren.wu@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 437/879] mt76: fix antenna config missing in 6G cap
Date:   Tue,  7 Jun 2022 18:59:15 +0200
Message-Id: <20220607165015.554653307@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deren Wu <deren.wu@mediatek.com>

[ Upstream commit abba345311a740d9dca1b5eb293b3b1c296715dd ]

To make sure we have the proper antenna config in 6g cap,
move IEEE80211_VHT_CAP_[T/R]X_ANTENNA_PATTERN to stream init.

Fixes: edf9dab8ba27 ("mt76: add 6GHz support")
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 5b53d008eb66..917ea20c026b 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -248,6 +248,8 @@ static void mt76_init_stream_cap(struct mt76_phy *phy,
 		vht_cap->cap |= IEEE80211_VHT_CAP_TXSTBC;
 	else
 		vht_cap->cap &= ~IEEE80211_VHT_CAP_TXSTBC;
+	vht_cap->cap |= IEEE80211_VHT_CAP_TX_ANTENNA_PATTERN |
+			IEEE80211_VHT_CAP_RX_ANTENNA_PATTERN;
 
 	for (i = 0; i < 8; i++) {
 		if (i < nstream)
@@ -323,8 +325,6 @@ mt76_init_sband(struct mt76_phy *phy, struct mt76_sband *msband,
 	vht_cap->cap |= IEEE80211_VHT_CAP_RXLDPC |
 			IEEE80211_VHT_CAP_RXSTBC_1 |
 			IEEE80211_VHT_CAP_SHORT_GI_80 |
-			IEEE80211_VHT_CAP_RX_ANTENNA_PATTERN |
-			IEEE80211_VHT_CAP_TX_ANTENNA_PATTERN |
 			(3 << IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_SHIFT);
 
 	return 0;
-- 
2.35.1



