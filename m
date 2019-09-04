Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDD6A9147
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390419AbfIDSOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:14:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:59828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390529AbfIDSOb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:14:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 581DB22CF7;
        Wed,  4 Sep 2019 18:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620870;
        bh=Gv3o9jc/CWvLdaxVZ2vJNVBL76ADaBp67Nglqgg26R8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tfd520Jq6G91u7LACHuJf0GiA1tV5YnkgSSOuNeqdTepCjH7T4aVDMMQ2dNH37X06
         3L8gz07to8wwaDS32ShWWhekrbsCygDKgn2TGCn7AzAphea4YwA9VMoNi73ryDQ16Y
         lpdlgSScP8EGK5UbYkzatxOn4nXAYMZGfe+8a7Hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.2 126/143] cfg80211: Fix Extended Key ID key install checks
Date:   Wed,  4 Sep 2019 19:54:29 +0200
Message-Id: <20190904175319.336774224@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Wetzel <alexander@wetzel-home.de>

commit b67fd72e84a88cae64cea8ab47ccdaab3bb3094d upstream.

Fix two shortcomings in the Extended Key ID API:

 1) Allow the userspace to install pairwise keys using keyid 1 without
    NL80211_KEY_NO_TX set. This allows the userspace to install and
    activate pairwise keys with keyid 1 in the same way as for keyid 0,
    simplifying the API usage for e.g. FILS and FT key installs.

 2) IEEE 802.11 - 2016 restricts Extended Key ID usage to CCMP/GCMP
    ciphers in IEEE 802.11 - 2016 "9.4.2.25.4 RSN capabilities".
    Enforce that when installing a key.

Cc: stable@vger.kernel.org # 5.2
Fixes: 6cdd3979a2bd ("nl80211/cfg80211: Extended Key ID support")
Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
Link: https://lore.kernel.org/r/20190805123400.51567-1-alexander@wetzel-home.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/util.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -233,25 +233,30 @@ int cfg80211_validate_key_settings(struc
 
 	switch (params->cipher) {
 	case WLAN_CIPHER_SUITE_TKIP:
+		/* Extended Key ID can only be used with CCMP/GCMP ciphers */
+		if ((pairwise && key_idx) ||
+		    params->mode != NL80211_KEY_RX_TX)
+			return -EINVAL;
+		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 	case WLAN_CIPHER_SUITE_CCMP_256:
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
-		/* IEEE802.11-2016 allows only 0 and - when using Extended Key
-		 * ID - 1 as index for pairwise keys.
+		/* IEEE802.11-2016 allows only 0 and - when supporting
+		 * Extended Key ID - 1 as index for pairwise keys.
 		 * @NL80211_KEY_NO_TX is only allowed for pairwise keys when
 		 * the driver supports Extended Key ID.
 		 * @NL80211_KEY_SET_TX can't be set when installing and
 		 * validating a key.
 		 */
-		if (params->mode == NL80211_KEY_NO_TX) {
-			if (!wiphy_ext_feature_isset(&rdev->wiphy,
-						     NL80211_EXT_FEATURE_EXT_KEY_ID))
-				return -EINVAL;
-			else if (!pairwise || key_idx < 0 || key_idx > 1)
+		if ((params->mode == NL80211_KEY_NO_TX && !pairwise) ||
+		    params->mode == NL80211_KEY_SET_TX)
+			return -EINVAL;
+		if (wiphy_ext_feature_isset(&rdev->wiphy,
+					    NL80211_EXT_FEATURE_EXT_KEY_ID)) {
+			if (pairwise && (key_idx < 0 || key_idx > 1))
 				return -EINVAL;
-		} else if ((pairwise && key_idx) ||
-			   params->mode == NL80211_KEY_SET_TX) {
+		} else if (pairwise && key_idx) {
 			return -EINVAL;
 		}
 		break;


