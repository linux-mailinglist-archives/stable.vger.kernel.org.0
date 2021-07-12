Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A483C4592
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234873AbhGLG0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:26:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234890AbhGLGZN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:25:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28A0E610A7;
        Mon, 12 Jul 2021 06:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070945;
        bh=5XYe6u1nvtpBxks6N1lftbp2mSG9ICtQGBWUX4FHS2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YnHTYr57A2jDrewCfKG5tevLjXanywTUzug6lQxc+2nHlhOmvpfzCyp3sHYvielDA
         3jQ6GpBin9oyAFHs/gtxFVzDnNgocF21G6ttVZ4s7FYi1O7zriumMlDc3qk27HIG2o
         idq0/D+PFjVFoG+aMrZv5FmUjqPMh7692umEmltE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 206/348] brcmfmac: fix setting of station info chains bitmask
Date:   Mon, 12 Jul 2021 08:09:50 +0200
Message-Id: <20210712060728.879114417@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
index cd813c69a178..626449c1e897 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -2683,6 +2683,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 		count_rssi = 0;
 		for (i = 0; i < BRCMF_ANT_MAX; i++) {
 			if (sta_info_le.rssi[i]) {
+				sinfo->chains |= BIT(count_rssi);
 				sinfo->chain_signal_avg[count_rssi] =
 					sta_info_le.rssi[i];
 				sinfo->chain_signal[count_rssi] =
@@ -2693,8 +2694,6 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
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



