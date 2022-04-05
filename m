Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16C3A4F33EB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240194AbiDEJeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245540AbiDEI4O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:56:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23AF812AA0;
        Tue,  5 Apr 2022 01:52:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0EEF609D0;
        Tue,  5 Apr 2022 08:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD22CC385A0;
        Tue,  5 Apr 2022 08:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148743;
        bh=mzkj7bdPyPwyHELeTDKpXc4Xr4tRKHgjWC3TkZCHIe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1PRibyI14UVWIBqK2MwrhN1ojtS7jEmiKz4Cs5R5ixTxRmgggzeOU3QQdNp0/iiMW
         YIH9KIWfWXVVD1ykqiAE2Q6GKIxvwttEeh/kda1XYFxc28OTw5wkBaiM5Vm0Xdds+5
         J5Nk+DV8/OKgBH7JAyn8F5a7X5NITb4CES5ma+Pg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0464/1017] mt76: mt7615: check sta_rates pointer in mt7615_sta_rate_tbl_update
Date:   Tue,  5 Apr 2022 09:22:57 +0200
Message-Id: <20220405070408.072775283@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index 1fdcada157d6..18a320d00d8d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -686,6 +686,9 @@ static void mt7615_sta_rate_tbl_update(struct ieee80211_hw *hw,
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



