Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06632498D2C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348256AbiAXT2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:28:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53936 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351307AbiAXT0V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:26:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1BD26148F;
        Mon, 24 Jan 2022 19:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE9AC340E5;
        Mon, 24 Jan 2022 19:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052380;
        bh=r6e+fF/5rc9o7aH9xY3L04cGqonlLwRa/MfShbrQAt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xesPHjdpYC/LqnucsgcwM7KcaNI2KR6AZ9c2kofIIqKt2UvJWJ0LrDodYtqmTHVzr
         se456peV1cwMQf/QEt6kcKUm+A20rTJ7zpZWv/J/TzTPikJo8rehmbNyteMnu06Pvd
         TaYl5wSunoujCQTraL5eB8J7fDVO8anXwB48JGxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 040/320] wcn36xx: Indicate beacon not connection loss on MISSED_BEACON_IND
Date:   Mon, 24 Jan 2022 19:40:24 +0100
Message-Id: <20220124183955.120302955@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit 588b45c88ae130fe373a8c50edaf54735c3f4fe3 ]

Firmware can trigger a missed beacon indication, this is not the same as a
lost signal.

Flag to Linux the missed beacon and let the WiFi stack decide for itself if
the link is up or down by sending its own probe to determine this.

We should only be signalling the link is lost when the firmware indicates

Fixes: 8e84c2582169 ("wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware")
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211027232529.657764-1-bryan.odonoghue@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index a7532028bf9db..74cf173c186ff 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2311,7 +2311,7 @@ static int wcn36xx_smd_missed_beacon_ind(struct wcn36xx *wcn,
 			wcn36xx_dbg(WCN36XX_DBG_HAL, "beacon missed bss_index %d\n",
 				    tmp->bss_index);
 			vif = wcn36xx_priv_to_vif(tmp);
-			ieee80211_connection_loss(vif);
+			ieee80211_beacon_loss(vif);
 		}
 		return 0;
 	}
@@ -2326,7 +2326,7 @@ static int wcn36xx_smd_missed_beacon_ind(struct wcn36xx *wcn,
 			wcn36xx_dbg(WCN36XX_DBG_HAL, "beacon missed bss_index %d\n",
 				    rsp->bss_index);
 			vif = wcn36xx_priv_to_vif(tmp);
-			ieee80211_connection_loss(vif);
+			ieee80211_beacon_loss(vif);
 			return 0;
 		}
 	}
-- 
2.34.1



