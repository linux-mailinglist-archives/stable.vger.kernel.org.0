Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFF9A61672
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbfGGTiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:38:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58026 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727668AbfGGTiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:17 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCzE-0006kg-0j; Sun, 07 Jul 2019 20:38:12 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz9-0005gl-SV; Sun, 07 Jul 2019 20:38:07 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Takashi Iwai" <tiwai@suse.de>,
        "Kalle Valo" <kvalo@codeaurora.org>,
        "huangwen" <huangwen@venustech.com.cn>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.996126085@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 128/129] mwifiex: Fix heap overflow in
 mwifiex_uap_parse_tail_ies()
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 69ae4f6aac1578575126319d3f55550e7e440449 upstream.

A few places in mwifiex_uap_parse_tail_ies() perform memcpy()
unconditionally, which may lead to either buffer overflow or read over
boundary.

This patch addresses the issues by checking the read size and the
destination size at each place more properly.  Along with the fixes,
the patch cleans up the code slightly by introducing a temporary
variable for the token size, and unifies the error path with the
standard goto statement.

Reported-by: huangwen <huangwen@venustech.com.cn>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
[bwh: Backported to 3.16:
 - The tail IEs are parsed in mwifiex_set_mgmt_ies, which looks for two
   specific IEs rather than looping
 - Check IE length against tail length after calling
   cfg80211_find_vendor_ie(), but not after cfg80211_find_ie() since that
   already does it
 - On error, return without calling mwifiex_set_mgmt_beacon_data_ies()
 - Drop inapplicable change to WMM IE handling
 - Adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/mwifiex/ie.c | 47 +++++++++++++++--------
 1 file changed, 31 insertions(+), 16 deletions(-)

--- a/drivers/net/wireless/mwifiex/ie.c
+++ b/drivers/net/wireless/mwifiex/ie.c
@@ -328,6 +328,8 @@ int mwifiex_set_mgmt_ies(struct mwifiex_
 	struct ieee_types_header *rsn_ie, *wpa_ie = NULL;
 	u16 rsn_idx = MWIFIEX_AUTO_IDX_MASK, ie_len = 0;
 	const u8 *vendor_ie;
+	unsigned int token_len;
+	int err = 0;
 
 	if (info->tail && info->tail_len) {
 		gen_ie = kzalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
@@ -341,8 +343,13 @@ int mwifiex_set_mgmt_ies(struct mwifiex_
 		rsn_ie = (void *)cfg80211_find_ie(WLAN_EID_RSN,
 						  info->tail, info->tail_len);
 		if (rsn_ie) {
-			memcpy(gen_ie->ie_buffer, rsn_ie, rsn_ie->len + 2);
-			ie_len = rsn_ie->len + 2;
+			token_len = rsn_ie->len + 2;
+			if (ie_len + token_len > IEEE_MAX_IE_SIZE) {
+				err = -EINVAL;
+				goto out;
+			}
+			memcpy(gen_ie->ie_buffer + ie_len, rsn_ie, token_len);
+			ie_len += token_len;
 			gen_ie->ie_length = cpu_to_le16(ie_len);
 		}
 
@@ -352,9 +359,15 @@ int mwifiex_set_mgmt_ies(struct mwifiex_
 						    info->tail_len);
 		if (vendor_ie) {
 			wpa_ie = (struct ieee_types_header *)vendor_ie;
-			memcpy(gen_ie->ie_buffer + ie_len,
-			       wpa_ie, wpa_ie->len + 2);
-			ie_len += wpa_ie->len + 2;
+			token_len = wpa_ie->len + 2;
+			if (token_len >
+			    info->tail + info->tail_len - (u8 *)wpa_ie ||
+			    ie_len + token_len > IEEE_MAX_IE_SIZE) {
+				err = -EINVAL;
+				goto out;
+			}
+			memcpy(gen_ie->ie_buffer + ie_len, wpa_ie, token_len);
+			ie_len += token_len;
 			gen_ie->ie_length = cpu_to_le16(ie_len);
 		}
 
@@ -362,13 +375,16 @@ int mwifiex_set_mgmt_ies(struct mwifiex_
 			if (mwifiex_update_uap_custom_ie(priv, gen_ie, &rsn_idx,
 							 NULL, NULL,
 							 NULL, NULL)) {
-				kfree(gen_ie);
-				return -1;
+				err = -EINVAL;
+				goto out;
 			}
 			priv->rsn_idx = rsn_idx;
 		}
 
+	out:
 		kfree(gen_ie);
+		if (err)
+			return err;
 	}
 
 	return mwifiex_set_mgmt_beacon_data_ies(priv, info);

