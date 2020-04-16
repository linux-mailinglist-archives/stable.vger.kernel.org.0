Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5421AC938
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408731AbgDPPU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:20:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898648AbgDPNrL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:47:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79C962223D;
        Thu, 16 Apr 2020 13:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044831;
        bh=WtyTCRlFyMzJAkJbuvSlHht8TZrezfj5ottSM/w2hRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GD91+rmDcyWrFkzsphnMmQB5kmG3l2lvDgioQeY4g1ucZnUJau0vyWp47sEt52Av9
         kZPjA6QSra2WM2FFGu87arMJv6KJMdHdKEBCbV/akcC6QNdzW4RGLqlGziSTK0uBB9
         yP+JV3rpqoIL/zc7e1NX69a/Z8P4sjMfE1komwVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Remi Pommarel <repk@triplefau.lt>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.4 118/232] ath9k: Handle txpower changes even when TPC is disabled
Date:   Thu, 16 Apr 2020 15:23:32 +0200
Message-Id: <20200416131329.875693597@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
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
@@ -1457,6 +1457,9 @@ static int ath9k_config(struct ieee80211
 		ath_chanctx_set_channel(sc, ctx, &hw->conf.chandef);
 	}
 
+	if (changed & IEEE80211_CONF_CHANGE_POWER)
+		ath9k_set_txpower(sc, NULL);
+
 	mutex_unlock(&sc->mutex);
 	ath9k_ps_restore(sc);
 


