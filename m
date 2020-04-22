Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32EFE1B410B
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729328AbgDVKMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:12:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729324AbgDVKMU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:12:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F33552070B;
        Wed, 22 Apr 2020 10:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550339;
        bh=ME0WeMs8A61c6lYVuqvVeOyocXUUkTtNfSPHYXf/LFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B6MA5VjoOfIraeP3uJzb6IWjJzGIfcT77CE1Mn2Yde3njpitgCoI7/u9vKTJYsMhq
         La7L/kOsZboFcapcMqTiT/e7O7HnQ1SVmiWxwoupOnd5UrpDIu2Eik7DwtM7FMhvVe
         jtHXeUttDnZ+ka0EohJoqhmDbx9ezfaRD9lHuT44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Remi Pommarel <repk@triplefau.lt>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.14 054/199] ath9k: Handle txpower changes even when TPC is disabled
Date:   Wed, 22 Apr 2020 11:56:20 +0200
Message-Id: <20200422095103.649955731@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095057.806111593@linuxfoundation.org>
References: <20200422095057.806111593@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Remi Pommarel <repk@triplefau.lt>

commit 968ae2caad0782db5dbbabb560d3cdefd2945d38 upstream.

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
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1456,6 +1456,9 @@ static int ath9k_config(struct ieee80211
 		ath_chanctx_set_channel(sc, ctx, &hw->conf.chandef);
 	}
 
+	if (changed & IEEE80211_CONF_CHANGE_POWER)
+		ath9k_set_txpower(sc, NULL);
+
 	mutex_unlock(&sc->mutex);
 	ath9k_ps_restore(sc);
 


