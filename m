Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D51B3968C8
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 22:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbhEaUab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 16:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232131AbhEaUaV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 16:30:21 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA54C061763;
        Mon, 31 May 2021 13:28:41 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lnoWd-000F0y-Nt; Mon, 31 May 2021 22:28:39 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v4.4 05/10] mac80211: drop A-MSDUs on old ciphers
Date:   Mon, 31 May 2021 22:28:29 +0200
Message-Id: <20210531202834.179810-6-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531202834.179810-1-johannes@sipsolutions.net>
References: <20210531202834.179810-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 270032a2a9c4535799736142e1e7c413ca7b836e upstream.

With old ciphers (WEP and TKIP) we shouldn't be using A-MSDUs
since A-MSDUs are only supported if we know that they are, and
the only practical way for that is HT support which doesn't
support old ciphers.

However, we would normally accept them anyway. Since we check
the MMIC before deaggregating A-MSDUs, and the A-MSDU bit in
the QoS header is not protected in TKIP (or WEP), this enables
attacks similar to CVE-2020-24588. To prevent that, drop A-MSDUs
completely with old ciphers.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210511200110.076543300172.I548e6e71f1ee9cad4b9a37bf212ae7db723587aa@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 85d7ac83d847..23c1e6529900 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2264,6 +2264,23 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 	if (skb_linearize(skb))
 		return RX_DROP_UNUSABLE;
 
+	if (rx->key) {
+		/*
+		 * We should not receive A-MSDUs on pre-HT connections,
+		 * and HT connections cannot use old ciphers. Thus drop
+		 * them, as in those cases we couldn't even have SPP
+		 * A-MSDUs or such.
+		 */
+		switch (rx->key->conf.cipher) {
+		case WLAN_CIPHER_SUITE_WEP40:
+		case WLAN_CIPHER_SUITE_WEP104:
+		case WLAN_CIPHER_SUITE_TKIP:
+			return RX_DROP_UNUSABLE;
+		default:
+			break;
+		}
+	}
+
 	ieee80211_amsdu_to_8023s(skb, &frame_list, dev->dev_addr,
 				 rx->sdata->vif.type,
 				 rx->local->hw.extra_tx_headroom, true);
-- 
2.31.1

