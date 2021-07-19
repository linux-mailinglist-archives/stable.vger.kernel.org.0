Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8B43CDCC9
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238436AbhGSOxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:53:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237517AbhGSOuU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:50:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7C416120D;
        Mon, 19 Jul 2021 15:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708655;
        bh=uJqBGneM2aOXhO4K5cK9pkyIhDw/C9QijYv5l6p55kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rAtDa+ppmTiGplmlB/NwrDgwBjKmEZ+CEDDpSpH7zcIs1JLGooICO3OKMgoN0t97L
         O2OyHfxKQGSh7Frnz8osuhDForHzYvXx9DdjrNMPCvAf7T4XXvJmaYcCn2SONVmsAv
         v+BaTutFfAMA1uM7jbs6VAKG+sTakb+W83FSaq0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.19 043/421] rsi: fix AP mode with WPA failure due to encrypted EAPOL
Date:   Mon, 19 Jul 2021 16:47:34 +0200
Message-Id: <20210719144947.719353150@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Fuzzey <martin.fuzzey@flowbird.group>

commit 314538041b5632ffaf64798faaeabaf2793fe029 upstream.

In AP mode WPA2-PSK connections were not established.

The reason was that the AP was sending the first message
of the 4 way handshake encrypted, even though no pairwise
key had (correctly) yet been set.

Encryption was enabled if the "security_enable" driver flag
was set and encryption was not explicitly disabled by
IEEE80211_TX_INTFL_DONT_ENCRYPT.

However security_enable was set when *any* key, including
the AP GTK key, had been set which was causing unwanted
encryption even if no key was avaialble for the unicast
packet to be sent.

Fix this by adding a check that we have a key and drop
the old security_enable driver flag which is insufficient
and redundant.

The Redpine downstream out of tree driver does it this way too.

Regarding the Fixes tag the actual code being modified was
introduced earlier, with the original driver submission, in
dad0d04fa7ba ("rsi: Add RS9113 wireless driver"), however
at that time AP mode was not yet supported so there was
no bug at that point.

So I have tagged the introduction of AP support instead
which was part of the patch set "rsi: support for AP mode" [1]

It is not clear whether AP WPA has ever worked, I can see nothing
on the kernel side that broke it afterwards yet the AP support
patch series says "Tests are performed to confirm aggregation,
connections in WEP and WPA/WPA2 security."

One possibility is that the initial tests were done with a modified
userspace (hostapd).

[1] https://www.spinics.net/lists/linux-wireless/msg165302.html

Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
Fixes: 38ef62353acb ("rsi: security enhancements for AP mode")
CC: stable@vger.kernel.org
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1622564459-24430-1-git-send-email-martin.fuzzey@flowbird.group
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rsi/rsi_91x_hal.c      |    2 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |    3 ---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |    3 +--
 drivers/net/wireless/rsi/rsi_main.h         |    1 -
 4 files changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -193,7 +193,7 @@ int rsi_prepare_data_desc(struct rsi_com
 		wh->frame_control |= cpu_to_le16(RSI_SET_PS_ENABLE);
 
 	if ((!(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)) &&
-	    (common->secinfo.security_enable)) {
+	    info->control.hw_key) {
 		if (rsi_is_cipher_wep(common))
 			ieee80211_size += 4;
 		else
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -959,7 +959,6 @@ static int rsi_mac80211_set_key(struct i
 	mutex_lock(&common->mutex);
 	switch (cmd) {
 	case SET_KEY:
-		secinfo->security_enable = true;
 		status = rsi_hal_key_config(hw, vif, key, sta);
 		if (status) {
 			mutex_unlock(&common->mutex);
@@ -978,8 +977,6 @@ static int rsi_mac80211_set_key(struct i
 		break;
 
 	case DISABLE_KEY:
-		if (vif->type == NL80211_IFTYPE_STATION)
-			secinfo->security_enable = false;
 		rsi_dbg(ERR_ZONE, "%s: RSI del key\n", __func__);
 		memset(key, 0, sizeof(struct ieee80211_key_conf));
 		status = rsi_hal_key_config(hw, vif, key, sta);
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1615,8 +1615,7 @@ int rsi_send_wowlan_request(struct rsi_c
 			RSI_WIFI_MGMT_Q);
 	cmd_frame->desc.desc_dword0.frame_type = WOWLAN_CONFIG_PARAMS;
 	cmd_frame->host_sleep_status = sleep_status;
-	if (common->secinfo.security_enable &&
-	    common->secinfo.gtk_cipher)
+	if (common->secinfo.gtk_cipher)
 		flags |= RSI_WOW_GTK_REKEY;
 	if (sleep_status)
 		cmd_frame->wow_flags = flags;
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -147,7 +147,6 @@ enum edca_queue {
 };
 
 struct security_info {
-	bool security_enable;
 	u32 ptk_cipher;
 	u32 gtk_cipher;
 };


