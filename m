Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0853045BAD8
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243069AbhKXMOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:14:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:49258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243447AbhKXMOD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:14:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C76060FD9;
        Wed, 24 Nov 2021 12:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755733;
        bh=LZK2UuE+aA/sL4+9/mNxxwyepbUbuW4WdsWmQDjpHXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eVaBIAQ3kag7Bp31k3Cg8rDv4nERmAsyY9bS7FvHDDfMrcrrZNDsAUcfwremLjFnR
         zyTCI/rXYNUxRJy/fdnncSlsIadGGbXVIZgvzXjiMJtCn7k5K/V03m9Dk3QXBpkWTT
         02ndjsA0mUBooucwqK9WJz+WudJWBMkJKRdQiEa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.9 038/207] wcn36xx: Fix HT40 capability for 2Ghz band
Date:   Wed, 24 Nov 2021 12:55:09 +0100
Message-Id: <20211124115705.175166011@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

commit 960ae77f25631bbe4e3aafefe209b52e044baf31 upstream.

All wcn36xx controllers are supposed to support HT40 (and SGI40),
This doubles the maximum bitrate/throughput with compatible APs.

Tested with wcn3620 & wcn3680B.

Cc: stable@vger.kernel.org
Fixes: 8e84c2582169 ("wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware")
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1634737133-22336-1-git-send-email-loic.poulain@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -129,7 +129,9 @@ static struct ieee80211_supported_band w
 		.cap =	IEEE80211_HT_CAP_GRN_FLD |
 			IEEE80211_HT_CAP_SGI_20 |
 			IEEE80211_HT_CAP_DSSSCCK40 |
-			IEEE80211_HT_CAP_LSIG_TXOP_PROT,
+			IEEE80211_HT_CAP_LSIG_TXOP_PROT |
+			IEEE80211_HT_CAP_SGI_40 |
+			IEEE80211_HT_CAP_SUP_WIDTH_20_40,
 		.ht_supported = true,
 		.ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K,
 		.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16,


