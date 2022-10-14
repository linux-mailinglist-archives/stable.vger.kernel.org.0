Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E3E5FF268
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 18:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiJNQmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 12:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbiJNQmb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 12:42:31 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC011BE938;
        Fri, 14 Oct 2022 09:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=PpNfdc+kfQKBB28y4sFqhoYIXOrcMl7h3A00FZIyZhs=;
        t=1665765750; x=1666975350; b=BjCJmAv3N5OWasx1CpE15tBns8Qa6e0BdQTJyvQFqlLp62i
        7SYa8RQuCB+gy6m0U2LkIzh2jn1DdWRuyEPzUN0gGStOo0WrKrC6kyogOwYLnxXcwy++M881QjAes
        ovmNzaiZp1MiXGHbSugGLIsilgog34oDV1glTDzsy59x7cLXxxyQobj3/dcFmvTLKscF66S3cp9a+
        xQz+Di6KaFrP/j1LUEkL7fldP9fKgQQCGoOcgMBkJmce6g7hPURmbucIg9o4fDXSvisuYWp1uCHS1
        CxbKerMbv1VXnvdykyMyZ/Hl+uE67LKJ4lzRB7Dr97omJymrx84dVbibaNbmoAng==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ojNlS-006gql-23;
        Fri, 14 Oct 2022 18:42:27 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Marcus Meissner <meissner@suse.de>,
        Jiri Kosina <jkosina@suse.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v5.10 2/3] wifi: mac80211: don't parse mbssid in assoc response
Date:   Fri, 14 Oct 2022 18:41:49 +0200
Message-Id: <20221014184133.c1c3a823db3d.I6c0186979a2872e7f7da75f9f8f93b07046afcf2@changeid>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221014164150.24310-1-johannes@sipsolutions.net>
References: <20221014164150.24310-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

This is simply not valid and simplifies the next commit.
I'll make a separate patch for this in the current main
tree as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9e70cb86b420..0163b835f608 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3300,7 +3300,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	}
 	capab_info = le16_to_cpu(mgmt->u.assoc_resp.capab_info);
 	ieee802_11_parse_elems(pos, len - (pos - (u8 *)mgmt), false, elems,
-			       mgmt->bssid, assoc_data->bss->bssid);
+			       mgmt->bssid, NULL);
 
 	if (elems->aid_resp)
 		aid = le16_to_cpu(elems->aid_resp->aid);
@@ -3708,7 +3708,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 		return;
 
 	ieee802_11_parse_elems(pos, len - (pos - (u8 *)mgmt), false, &elems,
-			       mgmt->bssid, assoc_data->bss->bssid);
+			       mgmt->bssid, NULL);
 
 	if (status_code == WLAN_STATUS_ASSOC_REJECTED_TEMPORARILY &&
 	    elems.timeout_int &&
-- 
2.37.3

