Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B54AB91C2
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388455AbfITOZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:25:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36982 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388434AbfITOZR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:17 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqT-000514-LV; Fri, 20 Sep 2019 15:25:13 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqE-0007tJ-K3; Fri, 20 Sep 2019 15:24:58 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "=?UTF-8?q?Petr=20=C5=A0tetiar?=" <ynezz@true.cz>,
        "Eubert Bao" <bunnier@gmail.com>,
        "Kalle Valo" <kvalo@codeaurora.org>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.749085752@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 059/132] mwl8k: Fix rate_idx underflow
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Štetiar <ynezz@true.cz>

commit 6b583201fa219b7b1b6aebd8966c8fd9357ef9f4 upstream.

It was reported on OpenWrt bug tracking system[1], that several users
are affected by the endless reboot of their routers if they configure
5GHz interface with channel 44 or 48.

The reboot loop is caused by the following excessive number of WARN_ON
messages:

 WARNING: CPU: 0 PID: 0 at backports-4.19.23-1/net/mac80211/rx.c:4516
                             ieee80211_rx_napi+0x1fc/0xa54 [mac80211]

as the messages are being correctly emitted by the following guard:

 case RX_ENC_LEGACY:
      if (WARN_ON(status->rate_idx >= sband->n_bitrates))

as the rate_idx is in this case erroneously set to 251 (0xfb). This fix
simply converts previously used magic number to proper constant and
guards against substraction which is leading to the currently observed
underflow.

1. https://bugs.openwrt.org/index.php?do=details&task_id=2218

Fixes: 854783444bab ("mwl8k: properly set receive status rate index on 5 GHz receive")
Tested-by: Eubert Bao <bunnier@gmail.com>
Reported-by: Eubert Bao <bunnier@gmail.com>
Signed-off-by: Petr Štetiar <ynezz@true.cz>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
[bwh: Backported to 3.16: adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/mwl8k.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -436,6 +436,9 @@ static const struct ieee80211_rate mwl8k
 #define MWL8K_CMD_UPDATE_STADB		0x1123
 #define MWL8K_CMD_BASTREAM		0x1125
 
+#define MWL8K_LEGACY_5G_RATE_OFFSET \
+	(ARRAY_SIZE(mwl8k_rates_24) - ARRAY_SIZE(mwl8k_rates_50))
+
 static const char *mwl8k_cmd_name(__le16 cmd, char *buf, int bufsize)
 {
 	u16 command = le16_to_cpu(cmd);
@@ -1011,8 +1014,9 @@ mwl8k_rxd_ap_process(void *_rxd, struct
 
 	if (rxd->channel > 14) {
 		status->band = IEEE80211_BAND_5GHZ;
-		if (!(status->flag & RX_FLAG_HT))
-			status->rate_idx -= 5;
+		if (!(status->flag & RX_FLAG_HT) &&
+		    status->rate_idx >= MWL8K_LEGACY_5G_RATE_OFFSET)
+			status->rate_idx -= MWL8K_LEGACY_5G_RATE_OFFSET;
 	} else {
 		status->band = IEEE80211_BAND_2GHZ;
 	}
@@ -1119,8 +1123,9 @@ mwl8k_rxd_sta_process(void *_rxd, struct
 
 	if (rxd->channel > 14) {
 		status->band = IEEE80211_BAND_5GHZ;
-		if (!(status->flag & RX_FLAG_HT))
-			status->rate_idx -= 5;
+		if (!(status->flag & RX_FLAG_HT) &&
+		    status->rate_idx >= MWL8K_LEGACY_5G_RATE_OFFSET)
+			status->rate_idx -= MWL8K_LEGACY_5G_RATE_OFFSET;
 	} else {
 		status->band = IEEE80211_BAND_2GHZ;
 	}

