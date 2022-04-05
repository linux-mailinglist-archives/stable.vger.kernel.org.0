Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 623D24F28B4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235388AbiDEIV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbiDEIIA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:08:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1006AA71;
        Tue,  5 Apr 2022 01:02:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7121617E8;
        Tue,  5 Apr 2022 08:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A32C385A2;
        Tue,  5 Apr 2022 08:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145723;
        bh=9Fh6bldqlzwRXgBrOjm/tj48t5KpbZrKtorE/NBkk+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rQKvjoSbWAPBaVm+38lCcNsCN94AlXxa5/06jLd+m7oaAgbo1ato/yETa//p4HRWt
         MWw7eRs/aCwpASsITDvNx8JXSttgTP09LyLRWQJydaoKBPQuHYHEuBUG05Rif7znZR
         CGt+C+WE7en/ra61GzqV7vYAkpKeP3GXniMRwVu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0504/1126] mt76: mt7603: check sta_rates pointer in mt7603_sta_rate_tbl_update
Date:   Tue,  5 Apr 2022 09:20:51 +0200
Message-Id: <20220405070422.420801273@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

[ Upstream commit fc8e2c707ce11c8ec2e992885b0d53a5e04031ac ]

Check sta_rates pointer value in mt7603_sta_rate_tbl_update routine
since minstrel_ht_update_rates can fail allocating rates array.

Fixes: c8846e1015022 ("mt76: add driver for MT7603E and MT7628/7688")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
index 2b546bc05d82..83c5eec5b163 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -641,6 +641,9 @@ mt7603_sta_rate_tbl_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
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



