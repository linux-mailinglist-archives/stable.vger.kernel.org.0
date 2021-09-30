Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6333841D870
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 13:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350321AbhI3LNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 07:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350266AbhI3LNJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Sep 2021 07:13:09 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04F8C06176A;
        Thu, 30 Sep 2021 04:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=YaAVZzMRlt2cuxF/VnOWuM/PzYC9bAHwPTryDdlLyvE=; t=1633000287; x=1634209887; 
        b=RtSgdqAA7e0cN+Cf3QfpGgKIycrbkyTovJ5NLvVh1rmYYJ+iJ50HV+0XfeXb8g7YDX89RgxdpL6
        pXkLnakatv9Um1U3+v47kzjkYSbuEOuVHYKLWeVsHa06DroHrR/GwTrR61LnelYN8J8W2Ynol+sc9
        X/1o75+hYOU+nnuyhj3h8MCKwI1nrm+HJx9D8KCKQBc6cB9omE/h1qLEdtlv0mWODprIDdDGiySk9
        Dl/c4s3ashNCvxrs/kv816Ai7q4KLAYP1so763dGl+vbl3uIMfb0gF1OwgazdsC+B6v8W9pQU8Y57
        FbBXBvKDK9Pcz1/JtMucvzsYmYonJe5ufPZw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95-RC2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mVtyF-00Dlt4-Tk;
        Thu, 30 Sep 2021 13:11:24 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] mac80211: mesh: fix HE operation element length check
Date:   Thu, 30 Sep 2021 13:11:20 +0200
Message-Id: <20210930131120.b0f940976c56.I954e1be55e9f87cc303165bff5c906afe1e54648@changeid>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

The length check here was bad, if the length doesn't at
least include the length of the fixed part, we cannot
call ieee80211_he_oper_size() to determine the total.
Fix this, and convert to cfg80211_find_ext_elem() while
at it.

Cc: stable@vger.kernel.org
Fixes: 70debba3ab7d ("mac80211: save HE oper info in BSS config for mesh")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index a4212a333d61..15ac08d111ea 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -672,7 +672,7 @@ ieee80211_mesh_update_bss_params(struct ieee80211_sub_if_data *sdata,
 				 u8 *ie, u8 ie_len)
 {
 	struct ieee80211_supported_band *sband;
-	const u8 *cap;
+	const struct element *cap;
 	const struct ieee80211_he_operation *he_oper = NULL;
 
 	sband = ieee80211_get_sband(sdata);
@@ -687,9 +687,10 @@ ieee80211_mesh_update_bss_params(struct ieee80211_sub_if_data *sdata,
 
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
-- 
2.31.1

