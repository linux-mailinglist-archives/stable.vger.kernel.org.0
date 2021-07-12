Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9713C4E14
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243522AbhGLHQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:16:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243440AbhGLHPn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:15:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3806661248;
        Mon, 12 Jul 2021 07:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073929;
        bh=e4r82FMF+fsJvb11Ykv3Vv12QYqvKz9mtZ36TyZ/AKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JDiLmIH6BYrG1r1PY6LyNcULpgpmZFP5vuK6+G06p457KLaqq+9FbvopBEsVMlrYV
         EHn0ZFd/DMulsQrdBRgyGFWgt+gkGl8NcVVumVvfWnSy8ewb1ID7rMhrrnJkstxphp
         cl08ihuZlKA37jAdR90T7fVH3qRGvpjvXulB/CbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 408/700] brcmfmac: fix setting of station info chains bitmask
Date:   Mon, 12 Jul 2021 08:08:11 +0200
Message-Id: <20210712061019.794904495@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alvin Šipraga <ALSI@bang-olufsen.dk>

[ Upstream commit feb45643762172110cb3a44f99dd54304f33b711 ]

The sinfo->chains field is a bitmask for filled values in chain_signal
and chain_signal_avg, not a count. Treat it as such so that the driver
can properly report per-chain RSSI information.

Before (MIMO mode):

  $ iw dev wlan0 station dump
      ...
      signal: -51 [-51] dBm

After (MIMO mode):

  $ iw dev wlan0 station dump
      ...
      signal: -53 [-53, -54] dBm

Fixes: cae355dc90db ("brcmfmac: Add RSSI information to get_station.")
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210506132010.3964484-1-alsi@bang-olufsen.dk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index f4405d7861b6..afa75cb83221 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -2838,6 +2838,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 		count_rssi = 0;
 		for (i = 0; i < BRCMF_ANT_MAX; i++) {
 			if (sta_info_le.rssi[i]) {
+				sinfo->chains |= BIT(count_rssi);
 				sinfo->chain_signal_avg[count_rssi] =
 					sta_info_le.rssi[i];
 				sinfo->chain_signal[count_rssi] =
@@ -2848,8 +2849,6 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 		}
 		if (count_rssi) {
 			sinfo->filled |= BIT_ULL(NL80211_STA_INFO_CHAIN_SIGNAL);
-			sinfo->chains = count_rssi;
-
 			sinfo->filled |= BIT_ULL(NL80211_STA_INFO_SIGNAL);
 			total_rssi /= count_rssi;
 			sinfo->signal = total_rssi;
-- 
2.30.2



