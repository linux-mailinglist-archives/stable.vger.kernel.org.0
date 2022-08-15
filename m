Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109E559516C
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbiHPE5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234170AbiHPE41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:56:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBEC9BBA52;
        Mon, 15 Aug 2022 13:51:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79E396126B;
        Mon, 15 Aug 2022 20:51:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72733C433C1;
        Mon, 15 Aug 2022 20:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596662;
        bh=Gy9GEjewIsc6TeXRPwI50deSb4z9hDbTNSVmmGmL6ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YAuCBp7t1fznDXFT9Xy1MelKk+Z9AUcj4CipVwV4/aLK/4LB5PPHB2/xwpSg+OdlA
         lpv4T61QUBdvUb4yJeB7eyz0Sqjq864EBGQFhddOSazxPy4yzcR0kwmGNg5EDl7y/F
         752teZ9k85nygn+61b7UhGPH2s9H0i9dppoNpGwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.19 1150/1157] wifi: nl80211: acquire wdev mutex earlier in start_ap
Date:   Mon, 15 Aug 2022 20:08:26 +0200
Message-Id: <20220815180526.529002155@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit c2653990d5729a445296d6d04395be5dea8e282e upstream.

We need to hold the wdev mutex already in order to call
nl80211_parse_tx_bitrate_mask(), so acquire it earlier.

Fixes: 7b0a0e3c3a88 ("wifi: cfg80211: do some rework towards MLO link APIs")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/nl80211.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5747,18 +5747,20 @@ static int nl80211_start_ap(struct sk_bu
 		goto out;
 	}
 
+	wdev_lock(wdev);
+
 	if (info->attrs[NL80211_ATTR_TX_RATES]) {
 		err = nl80211_parse_tx_bitrate_mask(info, info->attrs,
 						    NL80211_ATTR_TX_RATES,
 						    &params->beacon_rate,
 						    dev, false, link_id);
 		if (err)
-			goto out;
+			goto out_unlock;
 
 		err = validate_beacon_tx_rate(rdev, params->chandef.chan->band,
 					      &params->beacon_rate);
 		if (err)
-			goto out;
+			goto out_unlock;
 	}
 
 	if (info->attrs[NL80211_ATTR_SMPS_MODE]) {
@@ -5771,19 +5773,19 @@ static int nl80211_start_ap(struct sk_bu
 			if (!(rdev->wiphy.features &
 			      NL80211_FEATURE_STATIC_SMPS)) {
 				err = -EINVAL;
-				goto out;
+				goto out_unlock;
 			}
 			break;
 		case NL80211_SMPS_DYNAMIC:
 			if (!(rdev->wiphy.features &
 			      NL80211_FEATURE_DYNAMIC_SMPS)) {
 				err = -EINVAL;
-				goto out;
+				goto out_unlock;
 			}
 			break;
 		default:
 			err = -EINVAL;
-			goto out;
+			goto out_unlock;
 		}
 	} else {
 		params->smps_mode = NL80211_SMPS_OFF;
@@ -5792,7 +5794,7 @@ static int nl80211_start_ap(struct sk_bu
 	params->pbss = nla_get_flag(info->attrs[NL80211_ATTR_PBSS]);
 	if (params->pbss && !rdev->wiphy.bands[NL80211_BAND_60GHZ]) {
 		err = -EOPNOTSUPP;
-		goto out;
+		goto out_unlock;
 	}
 
 	if (info->attrs[NL80211_ATTR_ACL_POLICY]) {
@@ -5800,7 +5802,7 @@ static int nl80211_start_ap(struct sk_bu
 		if (IS_ERR(params->acl)) {
 			err = PTR_ERR(params->acl);
 			params->acl = NULL;
-			goto out;
+			goto out_unlock;
 		}
 	}
 
@@ -5812,7 +5814,7 @@ static int nl80211_start_ap(struct sk_bu
 					info->attrs[NL80211_ATTR_HE_OBSS_PD],
 					&params->he_obss_pd);
 		if (err)
-			goto out;
+			goto out_unlock;
 	}
 
 	if (info->attrs[NL80211_ATTR_FILS_DISCOVERY]) {
@@ -5820,7 +5822,7 @@ static int nl80211_start_ap(struct sk_bu
 						   info->attrs[NL80211_ATTR_FILS_DISCOVERY],
 						   params);
 		if (err)
-			goto out;
+			goto out_unlock;
 	}
 
 	if (info->attrs[NL80211_ATTR_UNSOL_BCAST_PROBE_RESP]) {
@@ -5828,7 +5830,7 @@ static int nl80211_start_ap(struct sk_bu
 			rdev, info->attrs[NL80211_ATTR_UNSOL_BCAST_PROBE_RESP],
 			params);
 		if (err)
-			goto out;
+			goto out_unlock;
 	}
 
 	if (info->attrs[NL80211_ATTR_MBSSID_CONFIG]) {
@@ -5839,7 +5841,7 @@ static int nl80211_start_ap(struct sk_bu
 							params->beacon.mbssid_ies->cnt :
 							0);
 		if (err)
-			goto out;
+			goto out_unlock;
 	}
 
 	nl80211_calculate_ap_params(params);
@@ -5850,7 +5852,6 @@ static int nl80211_start_ap(struct sk_bu
 	else if (info->attrs[NL80211_ATTR_EXTERNAL_AUTH_SUPPORT])
 		params->flags |= NL80211_AP_SETTINGS_EXTERNAL_AUTH_SUPPORT;
 
-	wdev_lock(wdev);
 	if (wdev->conn_owner_nlportid &&
 	    info->attrs[NL80211_ATTR_SOCKET_OWNER] &&
 	    wdev->conn_owner_nlportid != info->snd_portid) {


