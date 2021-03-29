Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D9A34C8A8
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbhC2IXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:23:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233955AbhC2IWj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:22:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C06761481;
        Mon, 29 Mar 2021 08:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006148;
        bh=k5mP0sVan2kKjq9ykLRDakpWtYP4u8P/RmMM4RnF5iI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=niM1gtc6f31r2wQ7veYIl9ZEXZ/Xu0m9jYir51vIJPQI8yZ+QOrRr8vUu9EwWOZbE
         owyrIVJR7oK5meBFteFMez5i+EACMwpqk46I+qxuIsiE1BB9uS5/g2SkBXTjbJTlWy
         6qVDrzeVBLwQI/AJc9Gq8Z+Dv9wKMLIQKI2zHuKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Yen-lin Lai <yenlinlai@chromium.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 134/221] mac80211: Allow HE operation to be longer than expected.
Date:   Mon, 29 Mar 2021 09:57:45 +0200
Message-Id: <20210329075633.661629128@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
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
index 6adfcb9c06dc..3f483e84d5df 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5023,7 +5023,7 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 		he_oper_ie = cfg80211_find_ext_ie(WLAN_EID_EXT_HE_OPERATION,
 						  ies->data, ies->len);
 		if (he_oper_ie &&
-		    he_oper_ie[1] == ieee80211_he_oper_size(&he_oper_ie[3]))
+		    he_oper_ie[1] >= ieee80211_he_oper_size(&he_oper_ie[3]))
 			he_oper = (void *)(he_oper_ie + 3);
 		else
 			he_oper = NULL;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 94e624e9439b..d8f9fb0646a4 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -967,7 +967,7 @@ static void ieee80211_parse_extension_element(u32 *crc,
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



