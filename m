Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC454F28AD
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbiDEIVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233741AbiDEIIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:08:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7786B6BDF3;
        Tue,  5 Apr 2022 01:02:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32F78B81BBC;
        Tue,  5 Apr 2022 08:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7213BC385A1;
        Tue,  5 Apr 2022 08:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145731;
        bh=btiiagmz3bqcXDGyq2WODMzJBHjrXBPkr3b6cCLRGB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tEHrqtKjer628rq7de6ZVAg9f35Zd0JOMBhRWe7cKh6aP7Iyw6E2WZ48GSWiTuBjy
         3Un3abaNyKaHpIXxjCAbKiWyC/8mq4Sv/xzWSZTi1IBk5cWaNa5MsoHJq9YTBdbQL4
         7bcCpMtlhJGzIqhROdBhMnW56hKXEEM6eHrX7o08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Gong <quic_wgong@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0471/1126] ath11k: set WMI_PEER_40MHZ while peer assoc for 6 GHz
Date:   Tue,  5 Apr 2022 09:20:18 +0200
Message-Id: <20220405070421.452708686@linuxfoundation.org>
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

[ Upstream commit 1cb747192de2edb7e55920af8c458e4792908486 ]

When station connect to AP of 6 GHz with 40 MHz bandwidth, the TX is
always stay 20 MHz, it is because the flag WMI_PEER_40MHZ is not set
while peer assoc. Add the flag if remote peer is 40 MHz bandwidth.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03003-QCAHSPSWPL_V1_V2_SILICONZ_LITE-2

Fixes: c3a7d7eb4c98 ("ath11k: add 6 GHz params in peer assoc command")
Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220119034211.28622-1-quic_wgong@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index ac6a192185c1..08e33778f63b 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -2319,6 +2319,9 @@ static void ath11k_peer_assoc_h_he_6ghz(struct ath11k *ar,
 	if (!arg->he_flag || band != NL80211_BAND_6GHZ || !sta->he_6ghz_capa.capa)
 		return;
 
+	if (sta->bandwidth == IEEE80211_STA_RX_BW_40)
+		arg->bw_40 = true;
+
 	if (sta->bandwidth == IEEE80211_STA_RX_BW_80)
 		arg->bw_80 = true;
 
-- 
2.34.1



