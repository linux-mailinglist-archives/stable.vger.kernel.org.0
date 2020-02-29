Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 760121747D8
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 17:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbgB2QE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 11:04:59 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:44099 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727164AbgB2QE7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Feb 2020 11:04:59 -0500
Received: from localhost (lfbn-ren-1-591-115.w81-53.abo.wanadoo.fr [81.53.169.115])
        (Authenticated sender: repk@triplefau.lt)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 7B566240003;
        Sat, 29 Feb 2020 16:04:56 +0000 (UTC)
From:   Remi Pommarel <repk@triplefau.lt>
To:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Remi Pommarel <repk@triplefau.lt>, stable@vger.kernel.org
Subject: [PATCH] ath9k: Handle txpower changes even when TPC is disabled
Date:   Sat, 29 Feb 2020 17:13:47 +0100
Message-Id: <20200229161347.31341-1-repk@triplefau.lt>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When TPC is disabled IEEE80211_CONF_CHANGE_POWER event can be handled to
reconfigure HW's maximum txpower.

This fixes 0dBm txpower setting when user attaches to an interface for
the first time with the following scenario:

ieee80211_do_open()
    ath9k_add_interface()
        ath9k_set_txpower() /* Set TX power with not yet initialized
                               sc->hw->conf.power_level */

    ieee80211_hw_config() /* Iniatilize sc->hw->conf.power_level and
                             raise IEEE80211_CONF_CHANGE_POWER */

    ath9k_config() /* IEEE80211_CONF_CHANGE_POWER is ignored */

This issue can be reproduced with the following:

  $ modprobe -r ath9k
  $ modprobe ath9k
  $ wpa_supplicant -i wlan0 -c /tmp/wpa.conf &
  $ iw dev /* Here TX power is either 0 or 3 depending on RF chain */
  $ killall wpa_supplicant
  $ iw dev /* TX power goes back to calibrated value and subsequent
              calls will be fine */

Fixes: 283dd11994cde ("ath9k: add per-vif TX power capability")
Cc: stable@vger.kernel.org
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
---
 drivers/net/wireless/ath/ath9k/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 0548aa3702e3..ef2b856670e1 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1457,6 +1457,9 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		ath_chanctx_set_channel(sc, ctx, &hw->conf.chandef);
 	}
 
+	if (changed & IEEE80211_CONF_CHANGE_POWER)
+		ath9k_set_txpower(sc, NULL);
+
 	mutex_unlock(&sc->mutex);
 	ath9k_ps_restore(sc);
 
-- 
2.25.0

