Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6605CE5314
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 20:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731792AbfJYSHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 14:07:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46852 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731474AbfJYSFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 14:05:44 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xw-0008Oi-Dj; Fri, 25 Oct 2019 19:05:36 +0100
Received: from ben by deadeye with local (Exim 4.92.2)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xv-0001jG-QG; Fri, 25 Oct 2019 19:05:35 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Brian Norris" <briannorris@chromium.org>,
        "Kalle Valo" <kvalo@codeaurora.org>, "Takashi Iwai" <tiwai@suse.de>
Date:   Fri, 25 Oct 2019 19:03:23 +0100
Message-ID: <lsq.1572026582.561095120@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 22/47] mwifiex: Don't abort on small, spec-compliant
 vendor IEs
In-Reply-To: <lsq.1572026581.992411028@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.76-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Norris <briannorris@chromium.org>

commit 63d7ef36103d26f20325a921ecc96a3288560146 upstream.

Per the 802.11 specification, vendor IEs are (at minimum) only required
to contain an OUI. A type field is also included in ieee80211.h (struct
ieee80211_vendor_ie) but doesn't appear in the specification. The
remaining fields (subtype, version) are a convention used in WMM
headers.

Thus, we should not reject vendor-specific IEs that have only the
minimum length (3 bytes) -- we should skip over them (since we only want
to match longer IEs, that match either WMM or WPA formats). We can
reject elements that don't have the minimum-required 3 byte OUI.

While we're at it, move the non-standard subtype and version fields into
the WMM structs, to avoid this confusion in the future about generic
"vendor header" attributes.

Fixes: 685c9b7750bf ("mwifiex: Abort at too short BSS descriptor element")
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
[bwh: Backported to 3.16: adjust filenames, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/mwifiex/fw.h        | 12 +++++++++---
 drivers/net/wireless/mwifiex/scan.c      | 18 +++++++++++-------
 drivers/net/wireless/mwifiex/sta_ioctl.c |  4 ++--
 drivers/net/wireless/mwifiex/wmm.c       |  2 +-
 4 files changed, 23 insertions(+), 13 deletions(-)

--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -1398,9 +1398,10 @@ struct mwifiex_ie_types_wmm_queue_status
 struct ieee_types_vendor_header {
 	u8 element_id;
 	u8 len;
-	u8 oui[4];	/* 0~2: oui, 3: oui_type */
-	u8 oui_subtype;
-	u8 version;
+	struct {
+		u8 oui[3];
+		u8 oui_type;
+	} __packed oui;
 } __packed;
 
 struct ieee_types_wmm_parameter {
@@ -1414,6 +1415,9 @@ struct ieee_types_wmm_parameter {
 	 *   Version     [1]
 	 */
 	struct ieee_types_vendor_header vend_hdr;
+	u8 oui_subtype;
+	u8 version;
+
 	u8 qos_info_bitmap;
 	u8 reserved;
 	struct ieee_types_wmm_ac_parameters ac_params[IEEE80211_NUM_ACS];
@@ -1431,6 +1435,8 @@ struct ieee_types_wmm_info {
 	 *   Version     [1]
 	 */
 	struct ieee_types_vendor_header vend_hdr;
+	u8 oui_subtype;
+	u8 version;
 
 	u8 qos_info_bitmap;
 } __packed;
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1284,21 +1284,25 @@ int mwifiex_update_bss_desc_with_ie(stru
 			break;
 
 		case WLAN_EID_VENDOR_SPECIFIC:
-			if (element_len + 2 < sizeof(vendor_ie->vend_hdr))
-				return -EINVAL;
-
 			vendor_ie = (struct ieee_types_vendor_specific *)
 					current_ptr;
 
-			if (!memcmp
-			    (vendor_ie->vend_hdr.oui, wpa_oui,
-			     sizeof(wpa_oui))) {
+			/* 802.11 requires at least 3-byte OUI. */
+			if (element_len < sizeof(vendor_ie->vend_hdr.oui.oui))
+				return -EINVAL;
+
+			/* Not long enough for a match? Skip it. */
+			if (element_len < sizeof(wpa_oui))
+				break;
+
+			if (!memcmp(&vendor_ie->vend_hdr.oui, wpa_oui,
+				    sizeof(wpa_oui))) {
 				bss_entry->bcn_wpa_ie =
 					(struct ieee_types_vendor_specific *)
 					current_ptr;
 				bss_entry->wpa_offset = (u16)
 					(current_ptr - bss_entry->beacon_buf);
-			} else if (!memcmp(vendor_ie->vend_hdr.oui, wmm_oui,
+			} else if (!memcmp(&vendor_ie->vend_hdr.oui, wmm_oui,
 				    sizeof(wmm_oui))) {
 				if (total_ie_len ==
 				    sizeof(struct ieee_types_wmm_parameter) ||
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -1318,7 +1318,7 @@ mwifiex_set_gen_ie_helper(struct mwifiex
 	pvendor_ie = (struct ieee_types_vendor_header *) ie_data_ptr;
 	/* Test to see if it is a WPA IE, if not, then it is a gen IE */
 	if (((pvendor_ie->element_id == WLAN_EID_VENDOR_SPECIFIC) &&
-	     (!memcmp(pvendor_ie->oui, wpa_oui, sizeof(wpa_oui)))) ||
+	     (!memcmp(&pvendor_ie->oui, wpa_oui, sizeof(wpa_oui)))) ||
 	    (pvendor_ie->element_id == WLAN_EID_RSN)) {
 
 		/* IE is a WPA/WPA2 IE so call set_wpa function */
@@ -1343,7 +1343,7 @@ mwifiex_set_gen_ie_helper(struct mwifiex
 		 */
 		pvendor_ie = (struct ieee_types_vendor_header *) ie_data_ptr;
 		if ((pvendor_ie->element_id == WLAN_EID_VENDOR_SPECIFIC) &&
-		    (!memcmp(pvendor_ie->oui, wps_oui, sizeof(wps_oui)))) {
+		    (!memcmp(&pvendor_ie->oui, wps_oui, sizeof(wps_oui)))) {
 			priv->wps.session_enable = true;
 			dev_dbg(priv->adapter->dev,
 				"info: WPS Session Enabled.\n");
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -241,7 +241,7 @@ mwifiex_wmm_setup_queue_priorities(struc
 
 	dev_dbg(priv->adapter->dev, "info: WMM Parameter IE: version=%d, "
 		"qos_info Parameter Set Count=%d, Reserved=%#x\n",
-		wmm_ie->vend_hdr.version, wmm_ie->qos_info_bitmap &
+		wmm_ie->version, wmm_ie->qos_info_bitmap &
 		IEEE80211_WMM_IE_AP_QOSINFO_PARAM_SET_CNT_MASK,
 		wmm_ie->reserved);
 

