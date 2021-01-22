Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128C2300B1B
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 19:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729488AbhAVSWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:22:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:39306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728585AbhAVOXQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:23:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF2C023B79;
        Fri, 22 Jan 2021 14:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325051;
        bh=ZXBaXyIbiejXVj+zYqIgsppsmpPjA3UTJN3xCaPZB/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1qoEAsxAFe5WQkv12VlVnwbNItLYfW7iBOpEtDtABHE1oE7xIvedJw09P34vE/t2R
         tY7qzFWT/FfWhkKmAWRxRXsiyFdAE5rwr12Lll6eKYdVNlM8D+nug+OewnF4/Rwqbz
         5AWI/qVVtuNptvTPsBB7vlXfzIA3J4qaQ4jOfqGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 31/33] mac80211: do not drop tx nulldata packets on encrypted links
Date:   Fri, 22 Jan 2021 15:12:47 +0100
Message-Id: <20210122135734.824968810@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135733.565501039@linuxfoundation.org>
References: <20210122135733.565501039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

commit 2463ec86cd0338a2c2edbfb0b9d50c52ff76ff43 upstream.

ieee80211_tx_h_select_key drops any non-mgmt packets without a key when
encryption is used. This is wrong for nulldata packets that can't be
encrypted and are sent out for probing clients and indicating 4-address
mode.

Reported-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Fixes: a0761a301746 ("mac80211: drop data frames without key on encrypted links")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20201218191525.1168-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -657,7 +657,7 @@ ieee80211_tx_h_select_key(struct ieee802
 		if (!skip_hw && tx->key &&
 		    tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
 			info->control.hw_key = &tx->key->conf;
-	} else if (!ieee80211_is_mgmt(hdr->frame_control) && tx->sta &&
+	} else if (ieee80211_is_data_present(hdr->frame_control) && tx->sta &&
 		   test_sta_flag(tx->sta, WLAN_STA_USES_ENCRYPTION)) {
 		return TX_DROP;
 	}


