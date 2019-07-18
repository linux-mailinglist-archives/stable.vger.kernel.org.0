Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04BED6C6FF
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389221AbfGRDKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:10:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403858AbfGRDKA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:10:00 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2A0021848;
        Thu, 18 Jul 2019 03:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419399;
        bh=vVBwFys+pQvF81Fmd+x7nvaIoQiP/mFgUb5zvSYnOpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wopslfIYSBYhjRxplBQGZhjjbrC2cLAgKQfw592OW3sHThFT23RYAff7a6DLP+dz8
         3nE9PAOeNLl8Sl7MksfuZSzEESTULM9W+vqOiK2CNoyc6xbwWwewQ/qzBV7qiom8D1
         UpWk25a3ztfMhL6iZT3UeheO37P1/OL1eLL6wfMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.14 49/80] mwifiex: Dont abort on small, spec-compliant vendor IEs
Date:   Thu, 18 Jul 2019 12:01:40 +0900
Message-Id: <20190718030102.425807417@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030058.615992480@linuxfoundation.org>
References: <20190718030058.615992480@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/marvell/mwifiex/fw.h        |   12 +++++++++---
 drivers/net/wireless/marvell/mwifiex/scan.c      |   18 +++++++++++-------
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c |    4 ++--
 drivers/net/wireless/marvell/mwifiex/wmm.c       |    2 +-
 4 files changed, 23 insertions(+), 13 deletions(-)

--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -1744,9 +1744,10 @@ struct mwifiex_ie_types_wmm_queue_status
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
@@ -1760,6 +1761,9 @@ struct ieee_types_wmm_parameter {
 	 *   Version     [1]
 	 */
 	struct ieee_types_vendor_header vend_hdr;
+	u8 oui_subtype;
+	u8 version;
+
 	u8 qos_info_bitmap;
 	u8 reserved;
 	struct ieee_types_wmm_ac_parameters ac_params[IEEE80211_NUM_ACS];
@@ -1777,6 +1781,8 @@ struct ieee_types_wmm_info {
 	 *   Version     [1]
 	 */
 	struct ieee_types_vendor_header vend_hdr;
+	u8 oui_subtype;
+	u8 version;
 
 	u8 qos_info_bitmap;
 } __packed;
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -1357,21 +1357,25 @@ int mwifiex_update_bss_desc_with_ie(stru
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
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -1388,7 +1388,7 @@ mwifiex_set_gen_ie_helper(struct mwifiex
 			/* Test to see if it is a WPA IE, if not, then
 			 * it is a gen IE
 			 */
-			if (!memcmp(pvendor_ie->oui, wpa_oui,
+			if (!memcmp(&pvendor_ie->oui, wpa_oui,
 				    sizeof(wpa_oui))) {
 				/* IE is a WPA/WPA2 IE so call set_wpa function
 				 */
@@ -1398,7 +1398,7 @@ mwifiex_set_gen_ie_helper(struct mwifiex
 				goto next_ie;
 			}
 
-			if (!memcmp(pvendor_ie->oui, wps_oui,
+			if (!memcmp(&pvendor_ie->oui, wps_oui,
 				    sizeof(wps_oui))) {
 				/* Test to see if it is a WPS IE,
 				 * if so, enable wps session flag
--- a/drivers/net/wireless/marvell/mwifiex/wmm.c
+++ b/drivers/net/wireless/marvell/mwifiex/wmm.c
@@ -240,7 +240,7 @@ mwifiex_wmm_setup_queue_priorities(struc
 	mwifiex_dbg(priv->adapter, INFO,
 		    "info: WMM Parameter IE: version=%d,\t"
 		    "qos_info Parameter Set Count=%d, Reserved=%#x\n",
-		    wmm_ie->vend_hdr.version, wmm_ie->qos_info_bitmap &
+		    wmm_ie->version, wmm_ie->qos_info_bitmap &
 		    IEEE80211_WMM_IE_AP_QOSINFO_PARAM_SET_CNT_MASK,
 		    wmm_ie->reserved);
 


