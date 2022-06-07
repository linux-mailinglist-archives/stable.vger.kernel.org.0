Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73B6B541175
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355899AbiFGThn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356474AbiFGTge (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:36:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC271ACE48;
        Tue,  7 Jun 2022 11:13:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFBBE6062B;
        Tue,  7 Jun 2022 18:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB476C34115;
        Tue,  7 Jun 2022 18:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625601;
        bh=I+5VL4h4/uUKIFvLHkwrzyV1ZwSfo2lBjc7LZAxD4nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t51HGidp5Bf62nwz4UloeQYVrIvjCHlXgBS4gouynuYMlVsPd4yLIyDV1jEqPDS3j
         vDSImy2yyC8iFTorkAQJoZSPuu9uqxmuS3RW7A/vSlqm0TCXVSXlknAUTQdRksLQx4
         ITAe1qO3zUgf8kLhu8V0/mplZN/Wvh8u1/M58QOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Po-Hao Huang <phhuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 074/772] rtw88: fix incorrect frequency reported
Date:   Tue,  7 Jun 2022 18:54:26 +0200
Message-Id: <20220607164951.221942748@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Po-Hao Huang <phhuang@realtek.com>

[ Upstream commit 6723c0cde84fde582a261c186ce84100dcfa0019 ]

We should only fill in frequency reported by firmware during scan.
Add this so frames won't be dropped by mac80211 due to frequency
mismatch.

Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220407095858.46807-3-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rx.c b/drivers/net/wireless/realtek/rtw88/rx.c
index d2d607e22198..84aedabdf285 100644
--- a/drivers/net/wireless/realtek/rtw88/rx.c
+++ b/drivers/net/wireless/realtek/rtw88/rx.c
@@ -158,7 +158,8 @@ void rtw_rx_fill_rx_status(struct rtw_dev *rtwdev,
 	memset(rx_status, 0, sizeof(*rx_status));
 	rx_status->freq = hw->conf.chandef.chan->center_freq;
 	rx_status->band = hw->conf.chandef.chan->band;
-	if (rtw_fw_feature_check(&rtwdev->fw, FW_FEATURE_SCAN_OFFLOAD))
+	if (rtw_fw_feature_check(&rtwdev->fw, FW_FEATURE_SCAN_OFFLOAD) &&
+	    test_bit(RTW_FLAG_SCANNING, rtwdev->flags))
 		rtw_set_rx_freq_by_pktstat(pkt_stat, rx_status);
 	if (pkt_stat->crc_err)
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
-- 
2.35.1



