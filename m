Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BED91F0B5
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731558AbfEOLY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:24:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731783AbfEOLY0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:24:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E20F2084F;
        Wed, 15 May 2019 11:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919464;
        bh=dVQBo5mtvrTupR7EEWhapQ5svi0kusxcNoYyTDZh03o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xCgx9aktsvgjKFwQ+D9uw4FGkMy5OykDJRfQRSJVFJpyHT71JDHZvIlaS0OWkmVOd
         yUhXBetLxo/17PDbiEoWVYl25enATvcj9ItTZzNlQaxBBdS46kVge8y+aldXjTHf0k
         zB3TYEex9mT8o/r1h2RGuONLj5Wc/sg0ov7H9xH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eubert Bao <bunnier@gmail.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.19 083/113] mwl8k: Fix rate_idx underflow
Date:   Wed, 15 May 2019 12:56:14 +0200
Message-Id: <20190515090659.931745665@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: <stable@vger.kernel.org>
Tested-by: Eubert Bao <bunnier@gmail.com>
Reported-by: Eubert Bao <bunnier@gmail.com>
Signed-off-by: Petr Štetiar <ynezz@true.cz>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/marvell/mwl8k.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -441,6 +441,9 @@ static const struct ieee80211_rate mwl8k
 #define MWL8K_CMD_UPDATE_STADB		0x1123
 #define MWL8K_CMD_BASTREAM		0x1125
 
+#define MWL8K_LEGACY_5G_RATE_OFFSET \
+	(ARRAY_SIZE(mwl8k_rates_24) - ARRAY_SIZE(mwl8k_rates_50))
+
 static const char *mwl8k_cmd_name(__le16 cmd, char *buf, int bufsize)
 {
 	u16 command = le16_to_cpu(cmd);
@@ -1016,8 +1019,9 @@ mwl8k_rxd_ap_process(void *_rxd, struct
 
 	if (rxd->channel > 14) {
 		status->band = NL80211_BAND_5GHZ;
-		if (!(status->encoding == RX_ENC_HT))
-			status->rate_idx -= 5;
+		if (!(status->encoding == RX_ENC_HT) &&
+		    status->rate_idx >= MWL8K_LEGACY_5G_RATE_OFFSET)
+			status->rate_idx -= MWL8K_LEGACY_5G_RATE_OFFSET;
 	} else {
 		status->band = NL80211_BAND_2GHZ;
 	}
@@ -1124,8 +1128,9 @@ mwl8k_rxd_sta_process(void *_rxd, struct
 
 	if (rxd->channel > 14) {
 		status->band = NL80211_BAND_5GHZ;
-		if (!(status->encoding == RX_ENC_HT))
-			status->rate_idx -= 5;
+		if (!(status->encoding == RX_ENC_HT) &&
+		    status->rate_idx >= MWL8K_LEGACY_5G_RATE_OFFSET)
+			status->rate_idx -= MWL8K_LEGACY_5G_RATE_OFFSET;
 	} else {
 		status->band = NL80211_BAND_2GHZ;
 	}


