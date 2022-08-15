Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE6E6594A35
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiHOXWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241501AbiHOXTM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:19:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642F514A1D6;
        Mon, 15 Aug 2022 13:03:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E785D612E7;
        Mon, 15 Aug 2022 20:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4CEC433C1;
        Mon, 15 Aug 2022 20:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593837;
        bh=yRT4IHXH0eUR1dS7EIU5gkV3QRpYBYJ2aPTxUU5DRiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HVUGZmLodEhrjLjZN9P/PqVzqZrd7k6tbrRcym8FOBkqwOxbArfTJAW2elYz+Nh6u
         9fYf1+EouqzZA6OI3leaSyQ5Leq52567X5NCm4uxpdpUNQHgILeuvK4eiPZM1O4I3u
         OY+u3jQe28hi5NIHLdPwFOaKzeEQbbEkcn7JDdNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Ansuel Marangi <ansuelsmth@gmail.com>,
        Jeff Johnson <quic_jjohnson@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0333/1157] ath11k: fix missing skb drop on htc_tx_completion error
Date:   Mon, 15 Aug 2022 19:54:49 +0200
Message-Id: <20220815180452.977503852@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christian 'Ansuel' Marangi <ansuelsmth@gmail.com>

[ Upstream commit e5646fe3b7ef739c392e59da7db6adf5e1fdef42 ]

On htc_tx_completion error the skb is not dropped. This is wrong since
the completion_handler logic expect the skb to be consumed anyway even
when an error is triggered. Not freeing the skb on error is a memory
leak since the skb won't be freed anywere else. Correctly free the
packet on eid >= ATH11K_HTC_EP_COUNT before returning.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1

Fixes: f951380a6022 ("ath11k: Disabling credit flow for WMI path")
Signed-off-by: Christian 'Ansuel' Marangi <ansuelsmth@gmail.com>
Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220528142516.20819-2-ansuelsmth@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/htc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/htc.c b/drivers/net/wireless/ath/ath11k/htc.c
index 069c29a4fac7..ca3aedc0252d 100644
--- a/drivers/net/wireless/ath/ath11k/htc.c
+++ b/drivers/net/wireless/ath/ath11k/htc.c
@@ -258,8 +258,10 @@ void ath11k_htc_tx_completion_handler(struct ath11k_base *ab,
 	u8 eid;
 
 	eid = ATH11K_SKB_CB(skb)->eid;
-	if (eid >= ATH11K_HTC_EP_COUNT)
+	if (eid >= ATH11K_HTC_EP_COUNT) {
+		dev_kfree_skb_any(skb);
 		return;
+	}
 
 	ep = &htc->endpoint[eid];
 	spin_lock_bh(&htc->tx_lock);
-- 
2.35.1



