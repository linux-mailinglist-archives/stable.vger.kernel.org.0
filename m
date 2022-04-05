Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 282B24F373D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352564AbiDELLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345179AbiDEJst (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B32EEE4F4;
        Tue,  5 Apr 2022 02:37:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C946D6164D;
        Tue,  5 Apr 2022 09:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4AFEC385A2;
        Tue,  5 Apr 2022 09:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151469;
        bh=IbeurulMDdnYp8aYTOTd5w6wDxHc+on3dCF14Ycz08E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TTG8V6lt4aZ8Mo+g1XgfvZNsSfPxn5/tTO2QywfSnGIlm3Ka21TN9lFFdjiJdsPVq
         p6aHPRNJmOMiHIwnp7MNUuIllhaZc5sgM25nVdzcOrSUQNE6zeeaZ2LgvEBzKmUan+
         1tUI17In8/a8U9PnYaa3/pfbsetQ4D7Ez1fMYvus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 427/913] mt76: mt7615: check sta_rates pointer in mt7615_sta_rate_tbl_update
Date:   Tue,  5 Apr 2022 09:24:49 +0200
Message-Id: <20220405070352.644091878@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 6a6f457ed5fdf6777536c20644a9e42128a50ec2 ]

Check sta_rates pointer value in mt7615_sta_rate_tbl_update routine
since minstrel_ht_update_rates can fail allocating rates array.

Fixes: 04b8e65922f63 ("mt76: add mac80211 driver for MT7615 PCIe-based chipsets")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index fc266da54fe7..60a41d082961 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -682,6 +682,9 @@ static void mt7615_sta_rate_tbl_update(struct ieee80211_hw *hw,
 	struct ieee80211_sta_rates *sta_rates = rcu_dereference(sta->rates);
 	int i;
 
+	if (!sta_rates)
+		return;
+
 	spin_lock_bh(&dev->mt76.lock);
 	for (i = 0; i < ARRAY_SIZE(msta->rates); i++) {
 		msta->rates[i].idx = sta_rates->rate[i].idx;
-- 
2.34.1



