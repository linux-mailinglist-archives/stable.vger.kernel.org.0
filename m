Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D774D4F2F02
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239477AbiDEJfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245755AbiDEI4z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:56:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BDF1BE9B;
        Tue,  5 Apr 2022 01:52:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA3B8B81B92;
        Tue,  5 Apr 2022 08:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D60C385A1;
        Tue,  5 Apr 2022 08:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148762;
        bh=Y/7jtSn6aGrN/v5wrkJVEW1vqMuG+HkgxYZMWRO9Hik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qs00FsyB0Y6acc1U2/wm3RSPE05CPVQaHX4ov4/OG+1tzarPy6mPWtODUqB1m9rRk
         K8lSIisxqJVR40Oc6wYm1Sk2vOyr5LdMq/wmKEBU3O5ndWcetw3oVH9xT/leZi1a04
         zrCdHw+6waCPGwjyr5vaZRTDYW2XFj2+qOQ66usI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Gong <quic_wgong@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0434/1017] ath11k: set WMI_PEER_40MHZ while peer assoc for 6 GHz
Date:   Tue,  5 Apr 2022 09:22:27 +0200
Message-Id: <20220405070407.177413831@linuxfoundation.org>
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
index a7400ade7a0c..8d8eae438567 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -2039,6 +2039,9 @@ static void ath11k_peer_assoc_h_he_6ghz(struct ath11k *ar,
 	if (!arg->he_flag || band != NL80211_BAND_6GHZ || !sta->he_6ghz_capa.capa)
 		return;
 
+	if (sta->bandwidth == IEEE80211_STA_RX_BW_40)
+		arg->bw_40 = true;
+
 	if (sta->bandwidth == IEEE80211_STA_RX_BW_80)
 		arg->bw_80 = true;
 
-- 
2.34.1



