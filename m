Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302BA441828
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbhKAJo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:44:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233960AbhKAJnn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:43:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B046613A6;
        Mon,  1 Nov 2021 09:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758928;
        bh=X/vi48mBu5qrOYZhtahprqNte3ClNHqtIM2agfT/9DQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S0vNGeOaqiEg28EKcVDjNaTQlwTPE09C0N6+ocClKWQDrivrsfyK30A5Iw65BABLj
         X+krsNxDEjQAAz+4HEYgNB63l7KPHmM7KLEtbaG39CWV5AeclZSXB5Ns1PjPksWrMy
         UP4TIxkuNrrb94UtMZQsBBGn9w1LiizIHtaSEUqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.14 042/125] mac80211: mesh: fix HE operation element length check
Date:   Mon,  1 Nov 2021 10:16:55 +0100
Message-Id: <20211101082541.165944078@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 636707e593120c9fa35f6a908c0d052f6154910d upstream.

The length check here was bad, if the length doesn't at
least include the length of the fixed part, we cannot
call ieee80211_he_oper_size() to determine the total.
Fix this, and convert to cfg80211_find_ext_elem() while
at it.

Cc: stable@vger.kernel.org
Fixes: 70debba3ab7d ("mac80211: save HE oper info in BSS config for mesh")
Link: https://lore.kernel.org/r/20210930131120.b0f940976c56.I954e1be55e9f87cc303165bff5c906afe1e54648@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/mesh.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -672,7 +672,7 @@ ieee80211_mesh_update_bss_params(struct
 				 u8 *ie, u8 ie_len)
 {
 	struct ieee80211_supported_band *sband;
-	const u8 *cap;
+	const struct element *cap;
 	const struct ieee80211_he_operation *he_oper = NULL;
 
 	sband = ieee80211_get_sband(sdata);
@@ -687,9 +687,10 @@ ieee80211_mesh_update_bss_params(struct
 
 	sdata->vif.bss_conf.he_support = true;
 
-	cap = cfg80211_find_ext_ie(WLAN_EID_EXT_HE_OPERATION, ie, ie_len);
-	if (cap && cap[1] >= ieee80211_he_oper_size(&cap[3]))
-		he_oper = (void *)(cap + 3);
+	cap = cfg80211_find_ext_elem(WLAN_EID_EXT_HE_OPERATION, ie, ie_len);
+	if (cap && cap->datalen >= 1 + sizeof(*he_oper) &&
+	    cap->datalen >= 1 + ieee80211_he_oper_size(cap->data + 1))
+		he_oper = (void *)(cap->data + 1);
 
 	if (he_oper)
 		sdata->vif.bss_conf.he_oper.params =


