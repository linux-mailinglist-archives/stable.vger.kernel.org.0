Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD15A3B6106
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234165AbhF1Obe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:31:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234807AbhF1Oaa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:30:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8665661CC1;
        Mon, 28 Jun 2021 14:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890413;
        bh=R+P/fmAqPBWiOGyyElPymleMNovTkWNa6HaTdgpPwzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2SdIN5O0UW51b3O/DtJ3+f8wgHSnmzp1Zubhbt96c5RXSy8wZOdUanZOzy6q1nOH
         7fRDoYxEGMLEEABAn8IvfhnwAINklIDup6SVjiSAHiwz9bHZ3h8VIzsPVX+9UEg2Mp
         +iQzD1C1B3S2GjNqwwHY9KWbY7iELsH2TX59bVAeji46tO6u2JQ3lCKfQeO/t1owWu
         bZyNVl+877yBC9AJsSHRAoc4bBxw8ETWKwhA+ZtsDVscQFqB8JhkmRLhp4XcIYgF9X
         yjADzhp7vRrORoe4PuZc8OszmdTIL44/AsBMfQz9pQfZfk41IiiCmidJqrjy4b9OYJ
         msYuAxu9mWivA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/101] mac80211: handle various extensible elements correctly
Date:   Mon, 28 Jun 2021 10:25:18 -0400
Message-Id: <20210628142607.32218-53-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 652e8363bbc7d149fa194a5cbf30b1001c0274b0 ]

Various elements are parsed with a requirement to have an
exact size, when really we should only check that they have
the minimum size that we need. Check only that and therefore
ignore any additional data that they might carry.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210618133832.cd101f8040a4.Iadf0e9b37b100c6c6e79c7b298cc657c2be9151a@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/util.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index d8f9fb0646a4..fbf56a203c0e 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -954,7 +954,7 @@ static void ieee80211_parse_extension_element(u32 *crc,
 
 	switch (elem->data[0]) {
 	case WLAN_EID_EXT_HE_MU_EDCA:
-		if (len == sizeof(*elems->mu_edca_param_set)) {
+		if (len >= sizeof(*elems->mu_edca_param_set)) {
 			elems->mu_edca_param_set = data;
 			if (crc)
 				*crc = crc32_be(*crc, (void *)elem,
@@ -975,7 +975,7 @@ static void ieee80211_parse_extension_element(u32 *crc,
 		}
 		break;
 	case WLAN_EID_EXT_UORA:
-		if (len == 1)
+		if (len >= 1)
 			elems->uora_element = data;
 		break;
 	case WLAN_EID_EXT_MAX_CHANNEL_SWITCH_TIME:
@@ -983,7 +983,7 @@ static void ieee80211_parse_extension_element(u32 *crc,
 			elems->max_channel_switch_time = data;
 		break;
 	case WLAN_EID_EXT_MULTIPLE_BSSID_CONFIGURATION:
-		if (len == sizeof(*elems->mbssid_config_ie))
+		if (len >= sizeof(*elems->mbssid_config_ie))
 			elems->mbssid_config_ie = data;
 		break;
 	case WLAN_EID_EXT_HE_SPR:
@@ -992,7 +992,7 @@ static void ieee80211_parse_extension_element(u32 *crc,
 			elems->he_spr = data;
 		break;
 	case WLAN_EID_EXT_HE_6GHZ_CAPA:
-		if (len == sizeof(*elems->he_6ghz_capa))
+		if (len >= sizeof(*elems->he_6ghz_capa))
 			elems->he_6ghz_capa = data;
 		break;
 	}
@@ -1081,14 +1081,14 @@ _ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 
 		switch (id) {
 		case WLAN_EID_LINK_ID:
-			if (elen + 2 != sizeof(struct ieee80211_tdls_lnkie)) {
+			if (elen + 2 < sizeof(struct ieee80211_tdls_lnkie)) {
 				elem_parse_failed = true;
 				break;
 			}
 			elems->lnk_id = (void *)(pos - 2);
 			break;
 		case WLAN_EID_CHAN_SWITCH_TIMING:
-			if (elen != sizeof(struct ieee80211_ch_switch_timing)) {
+			if (elen < sizeof(struct ieee80211_ch_switch_timing)) {
 				elem_parse_failed = true;
 				break;
 			}
@@ -1251,7 +1251,7 @@ _ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			elems->sec_chan_offs = (void *)pos;
 			break;
 		case WLAN_EID_CHAN_SWITCH_PARAM:
-			if (elen !=
+			if (elen <
 			    sizeof(*elems->mesh_chansw_params_ie)) {
 				elem_parse_failed = true;
 				break;
@@ -1260,7 +1260,7 @@ _ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			break;
 		case WLAN_EID_WIDE_BW_CHANNEL_SWITCH:
 			if (!action ||
-			    elen != sizeof(*elems->wide_bw_chansw_ie)) {
+			    elen < sizeof(*elems->wide_bw_chansw_ie)) {
 				elem_parse_failed = true;
 				break;
 			}
@@ -1279,7 +1279,7 @@ _ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			ie = cfg80211_find_ie(WLAN_EID_WIDE_BW_CHANNEL_SWITCH,
 					      pos, elen);
 			if (ie) {
-				if (ie[1] == sizeof(*elems->wide_bw_chansw_ie))
+				if (ie[1] >= sizeof(*elems->wide_bw_chansw_ie))
 					elems->wide_bw_chansw_ie =
 						(void *)(ie + 2);
 				else
@@ -1323,7 +1323,7 @@ _ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			elems->cisco_dtpc_elem = pos;
 			break;
 		case WLAN_EID_ADDBA_EXT:
-			if (elen != sizeof(struct ieee80211_addba_ext_ie)) {
+			if (elen < sizeof(struct ieee80211_addba_ext_ie)) {
 				elem_parse_failed = true;
 				break;
 			}
@@ -1349,7 +1349,7 @@ _ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 							  elem, elems);
 			break;
 		case WLAN_EID_S1G_CAPABILITIES:
-			if (elen == sizeof(*elems->s1g_capab))
+			if (elen >= sizeof(*elems->s1g_capab))
 				elems->s1g_capab = (void *)pos;
 			else
 				elem_parse_failed = true;
-- 
2.30.2

