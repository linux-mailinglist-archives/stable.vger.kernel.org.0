Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF494F28D0
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbiDEIXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236456AbiDEIQq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:16:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C483270CC2;
        Tue,  5 Apr 2022 01:04:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85892B81BBD;
        Tue,  5 Apr 2022 08:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAFCC385A3;
        Tue,  5 Apr 2022 08:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145836;
        bh=6Hsugf3hew1UI09HjRquu7J/Ln94XbVvsslObP2Jc5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rtqnrElMmyFSVWKFw04rBSIZ6xkypElc/OtGAsxMNLptj7aaAplHxSiG8GxX9DCZW
         K2xovKF8NpbA0HDsxPXG+hMPUhtahfnkqJ+N6ShtAB2mME+IBGZJxkbB2BB/ZANJDw
         Ea2Jjvbte/m8+ExwKfZWXQCO/iQ5n63OGvXnaQ1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Gong <quic_wgong@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0545/1126] ath11k: fix uninitialized rate_idx in ath11k_dp_tx_update_txcompl()
Date:   Tue,  5 Apr 2022 09:21:32 +0200
Message-Id: <20220405070423.630202991@linuxfoundation.org>
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

From: Wen Gong <quic_wgong@quicinc.com>

[ Upstream commit 8c4c567fa291e4805d5116f1333b2ed83877032b ]

The rate_idx which passed to ath11k_debugfs_sta_add_tx_stats() by
ath11k_dp_tx_update_txcompl() is not initialized, add initialization
for it.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03003-QCAHSPSWPL_V1_V2_SILICONZ_LITE-2

Fixes: 1b8bb94c0612 ("ath11k: report tx bitrate for iw wlan station dump")
Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220209060816.423-1-quic_wgong@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_tx.c b/drivers/net/wireless/ath/ath11k/dp_tx.c
index 91d6244b6543..8402961c6688 100644
--- a/drivers/net/wireless/ath/ath11k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_tx.c
@@ -426,7 +426,7 @@ void ath11k_dp_tx_update_txcompl(struct ath11k *ar, struct hal_tx_status *ts)
 	struct ath11k_sta *arsta;
 	struct ieee80211_sta *sta;
 	u16 rate, ru_tones;
-	u8 mcs, rate_idx, ofdma;
+	u8 mcs, rate_idx = 0, ofdma;
 	int ret;
 
 	spin_lock_bh(&ab->base_lock);
-- 
2.34.1



