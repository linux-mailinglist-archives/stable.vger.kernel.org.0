Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0EE450CE3
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236886AbhKORpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:45:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:55528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238718AbhKORoY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:44:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BE72632FE;
        Mon, 15 Nov 2021 17:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997316;
        bh=VcyStWBYW/6pXX4Tk3d0H/jzTd0Mn4x+3CjxWdjlwOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wNKuJ5370Xl3fFuhHLxPEBSvVMOkrw1+GTnYRhEWG94ihkxyPhrZhpeCb7hgYBlxb
         uwQ5iM9d/wtyBCmiXk7xPrF9BkL/9trrRE0GnldD/2vVkzFwULuqsMk3BCC+h3WX4c
         D5Sz8AJFsBlNbGkSZS/cJKs8TzEUd+NvKq3j1yA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.10 103/575] wcn36xx: Fix HT40 capability for 2Ghz band
Date:   Mon, 15 Nov 2021 17:57:08 +0100
Message-Id: <20211115165347.225132260@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
@@ -134,7 +134,9 @@ static struct ieee80211_supported_band w
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


