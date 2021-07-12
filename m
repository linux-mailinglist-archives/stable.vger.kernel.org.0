Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154A23C50E7
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344591AbhGLHfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:35:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242062AbhGLHcw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:32:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2506D61158;
        Mon, 12 Jul 2021 07:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074992;
        bh=Kuh6woRRTHxGDo2eMaqmBi9aEAcP8QHgJop9o5uz9Ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSDmgbSq9Y6wqwLDkG8XFs/JlXwRjSfcxm0BhRwjlc2dLP/0UB3nnrG4FwyIfzqdP
         7zKDAfEkhwlJ2NBB+K3wBpdkl2YtgKkD09+dfgjcqk97Enn9h6rEydvBoYBZVzfN9E
         w8Yr1YK8Z4jb9/hkPViClgVYVotK47jb0OXddiAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Abinaya Kalaiselvan <akalaise@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.13 066/800] mac80211: fix NULL ptr dereference during mesh peer connection for non HE devices
Date:   Mon, 12 Jul 2021 08:01:29 +0200
Message-Id: <20210712060922.556157385@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abinaya Kalaiselvan <akalaise@codeaurora.org>

commit 95f83ee8d857f006813755e89a126f1048b001e8 upstream.

"sband->iftype_data" is not assigned with any value for non HE supported
devices, which causes NULL pointer access during mesh peer connection
in those devices. Fix this by accessing the pointer after HE
capabilities condition check.

Cc: stable@vger.kernel.org
Fixes: 7f7aa94bcaf0 (mac80211: reduce peer HE MCS/NSS to own capabilities)
Signed-off-by: Abinaya Kalaiselvan <akalaise@codeaurora.org>
Link: https://lore.kernel.org/r/1624459244-4497-1-git-send-email-akalaise@codeaurora.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/he.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/mac80211/he.c
+++ b/net/mac80211/he.c
@@ -111,7 +111,7 @@ ieee80211_he_cap_ie_to_sta_he_cap(struct
 				  struct sta_info *sta)
 {
 	struct ieee80211_sta_he_cap *he_cap = &sta->sta.he_cap;
-	struct ieee80211_sta_he_cap own_he_cap = sband->iftype_data->he_cap;
+	struct ieee80211_sta_he_cap own_he_cap;
 	struct ieee80211_he_cap_elem *he_cap_ie_elem = (void *)he_cap_ie;
 	u8 he_ppe_size;
 	u8 mcs_nss_size;
@@ -123,6 +123,8 @@ ieee80211_he_cap_ie_to_sta_he_cap(struct
 	if (!he_cap_ie || !ieee80211_get_he_sta_cap(sband))
 		return;
 
+	own_he_cap = sband->iftype_data->he_cap;
+
 	/* Make sure size is OK */
 	mcs_nss_size = ieee80211_he_mcs_nss_size(he_cap_ie_elem);
 	he_ppe_size =


