Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2949834CA6D
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbhC2Iif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:38:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234514AbhC2IgM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:36:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADF0261582;
        Mon, 29 Mar 2021 08:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006950;
        bh=Y0VvlWboovBmsNia49sfU9QoG5zcTaaChcyJbULoRb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3DuB++krWqaaUVCTDC8tP2AQlCLYwIhYMyFWDJP4DMVVYc9ZEUcha5RRbAogJFkn
         +jGh3l8SsjiAjkzApCJ/QL1Bkb2i9HYskaGCoWvuYEZ2G+/5T0qQMJuszEHMLNGjFJ
         sqjpfYeAg6YMnk10S+UGwe39OsKVtojP0qON7erc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Yen-lin Lai <yenlinlai@chromium.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 157/254] mac80211: Allow HE operation to be longer than expected.
Date:   Mon, 29 Mar 2021 09:57:53 +0200
Message-Id: <20210329075638.360711184@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit 0f7e90faddeef53a3568f449a0c3992d77510b66 ]

We observed some Cisco APs sending the following HE Operation IE in
associate response:

  ff 0a 24 f4 3f 00 01 fc ff 00 00 00

Its HE operation parameter is 0x003ff4, so the expected total length is
7 which does not match the actual length = 10. This causes association
failing with "HE AP is missing HE Capability/operation."

According to P802.11ax_D4 Table9-94, HE operation is extensible, and
according to 802.11-2016 10.27.8, STA should discard the part beyond
the maximum length and parse the truncated element.

Allow HE operation element to be longer than expected to handle this
case and future extensions.

Fixes: e4d005b80dee ("mac80211: refactor extended element parsing")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Yen-lin Lai <yenlinlai@chromium.org>
Link: https://lore.kernel.org/r/20210223051926.2653301-1-yenlinlai@chromium.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 2 +-
 net/mac80211/util.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0e4d950cf907..9db648a91a4f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5071,7 +5071,7 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 		he_oper_ie = cfg80211_find_ext_ie(WLAN_EID_EXT_HE_OPERATION,
 						  ies->data, ies->len);
 		if (he_oper_ie &&
-		    he_oper_ie[1] == ieee80211_he_oper_size(&he_oper_ie[3]))
+		    he_oper_ie[1] >= ieee80211_he_oper_size(&he_oper_ie[3]))
 			he_oper = (void *)(he_oper_ie + 3);
 		else
 			he_oper = NULL;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 8d3ae6b2f95f..f4507a708965 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -968,7 +968,7 @@ static void ieee80211_parse_extension_element(u32 *crc,
 		break;
 	case WLAN_EID_EXT_HE_OPERATION:
 		if (len >= sizeof(*elems->he_operation) &&
-		    len == ieee80211_he_oper_size(data) - 1) {
+		    len >= ieee80211_he_oper_size(data) - 1) {
 			if (crc)
 				*crc = crc32_be(*crc, (void *)elem,
 						elem->datalen + 2);
-- 
2.30.1



