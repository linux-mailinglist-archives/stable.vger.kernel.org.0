Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832D45FF281
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 18:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbiJNQsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 12:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbiJNQsJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 12:48:09 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2131C7D63;
        Fri, 14 Oct 2022 09:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=P+p9ZLEDYTWGgS51mcVAADhDwgpSOEE4/vNxHMyV37A=;
        t=1665766080; x=1666975680; b=rVCULPUeKHPf2AIjpb4XD8z0fJdrpImH3E3Bc2ML33yBOwD
        A9B58BsxNV/+oNGxQldvtHvPxPXzAJjrXbtvmlweAjF2dfhkQ0KNdbA5Sv8a+ZCN26Mneaf0QlAzF
        C3O6SmURg3hN1s5ju5Uq9FUdHasNync0UlEEMHkrh4QR0zFIr9wsLTtG+RsebwUpvcBNqJsvwInvR
        +eAWtduuf0AcOp7I0DtCF1J4e9nRO/rvgsncWqq4eWGGhvUQDoeu0Gh6uYvkKY3NWIQB1Ub1Al+SB
        lwH5sVEH0fCZrtaqrl/ylDmiX1tdvQ4LQw1cce0hvUmhlbuHdyRf9jOAoOCW1GmQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ojNqj-006gzN-0I;
        Fri, 14 Oct 2022 18:47:54 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Marcus Meissner <meissner@suse.de>,
        Jiri Kosina <jkosina@suse.de>,
        Steve deRosier <steve.derosier@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v5.4 2/3] wifi: mac80211: don't parse mbssid in assoc response
Date:   Fri, 14 Oct 2022 18:47:04 +0200
Message-Id: <20221014184650.f3deb2e15fcb.I6c0186979a2872e7f7da75f9f8f93b07046afcf2@changeid>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221014164705.31486-1-johannes@sipsolutions.net>
References: <20221014164705.31486-1-johannes@sipsolutions.net>
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
index aaec8a78b159..7d116aa4ea1f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3224,7 +3224,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 
 	pos = mgmt->u.assoc_resp.variable;
 	ieee802_11_parse_elems(pos, len - (pos - (u8 *)mgmt), false, &elems,
-			       mgmt->bssid, assoc_data->bss->bssid);
+			       mgmt->bssid, NULL);
 
 	if (!elems.supp_rates) {
 		sdata_info(sdata, "no SuppRates element in AssocResp\n");
@@ -3576,7 +3576,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 
 	pos = mgmt->u.assoc_resp.variable;
 	ieee802_11_parse_elems(pos, len - (pos - (u8 *)mgmt), false, &elems,
-			       mgmt->bssid, assoc_data->bss->bssid);
+			       mgmt->bssid, NULL);
 
 	if (status_code == WLAN_STATUS_ASSOC_REJECTED_TEMPORARILY &&
 	    elems.timeout_int &&
-- 
2.37.3

