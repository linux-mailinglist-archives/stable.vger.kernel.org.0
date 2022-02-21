Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10334BE2EE
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345486AbiBUJ2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:28:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349149AbiBUJ1g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:27:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82923237D0;
        Mon, 21 Feb 2022 01:12:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ED383CE0E86;
        Mon, 21 Feb 2022 09:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56BEC340E9;
        Mon, 21 Feb 2022 09:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434752;
        bh=l6glye0ey3HnMvkVgZkD6bH+w42s+t5NCkMcO4e/d2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UTlZxY2zE44Hbpu3G7aYotFEc6V9WbPbjzxqW9gjossv71dX4OCNcORyPKeuH+eRs
         9LSY94clqa+IFki4OGD6mBlzhu82MOH7km2l5CPmgOQlEF/F5fRcEzooFSem9fL8UL
         fROtoiaZUKmGn9cOmPLjeti7t506PDOihtO+XIk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 086/196] mac80211: mlme: check for null after calling kmemdup
Date:   Mon, 21 Feb 2022 09:48:38 +0100
Message-Id: <20220221084933.803648563@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

commit a72c01a94f1d285a274219d36e2a17b4846c0615 upstream.

As the possible failure of the alloc, the ifmgd->assoc_req_ies might be
NULL pointer returned from kmemdup().
Therefore it might be better to free the skb and return error in order
to fail the association, like ieee80211_assoc_success().
Also, the caller, ieee80211_do_assoc(), needs to deal with the return
value from ieee80211_send_assoc().

Fixes: 4d9ec73d2b78 ("cfg80211: Report Association Request frame IEs in association events")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20220105081559.2387083-1-jiasheng@iscas.ac.cn
[fix some paths to be errors, not success]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/mlme.c |   29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -664,7 +664,7 @@ static void ieee80211_add_he_ie(struct i
 	ieee80211_ie_build_he_6ghz_cap(sdata, skb);
 }
 
-static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
+static int ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -684,6 +684,7 @@ static void ieee80211_send_assoc(struct
 	enum nl80211_iftype iftype = ieee80211_vif_type_p2p(&sdata->vif);
 	const struct ieee80211_sband_iftype_data *iftd;
 	struct ieee80211_prep_tx_info info = {};
+	int ret;
 
 	/* we know it's writable, cast away the const */
 	if (assoc_data->ie_len)
@@ -697,7 +698,7 @@ static void ieee80211_send_assoc(struct
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 	if (WARN_ON(!chanctx_conf)) {
 		rcu_read_unlock();
-		return;
+		return -EINVAL;
 	}
 	chan = chanctx_conf->def.chan;
 	rcu_read_unlock();
@@ -748,7 +749,7 @@ static void ieee80211_send_assoc(struct
 			(iftd ? iftd->vendor_elems.len : 0),
 			GFP_KERNEL);
 	if (!skb)
-		return;
+		return -ENOMEM;
 
 	skb_reserve(skb, local->hw.extra_tx_headroom);
 
@@ -1029,15 +1030,22 @@ skip_rates:
 		skb_put_data(skb, assoc_data->ie + offset, noffset - offset);
 	}
 
-	if (assoc_data->fils_kek_len &&
-	    fils_encrypt_assoc_req(skb, assoc_data) < 0) {
-		dev_kfree_skb(skb);
-		return;
+	if (assoc_data->fils_kek_len) {
+		ret = fils_encrypt_assoc_req(skb, assoc_data);
+		if (ret < 0) {
+			dev_kfree_skb(skb);
+			return ret;
+		}
 	}
 
 	pos = skb_tail_pointer(skb);
 	kfree(ifmgd->assoc_req_ies);
 	ifmgd->assoc_req_ies = kmemdup(ie_start, pos - ie_start, GFP_ATOMIC);
+	if (!ifmgd->assoc_req_ies) {
+		dev_kfree_skb(skb);
+		return -ENOMEM;
+	}
+
 	ifmgd->assoc_req_ies_len = pos - ie_start;
 
 	drv_mgd_prepare_tx(local, sdata, &info);
@@ -1047,6 +1055,8 @@ skip_rates:
 		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS |
 						IEEE80211_TX_INTFL_MLME_CONN_TX;
 	ieee80211_tx_skb(sdata, skb);
+
+	return 0;
 }
 
 void ieee80211_send_pspoll(struct ieee80211_local *local,
@@ -4451,6 +4461,7 @@ static int ieee80211_do_assoc(struct iee
 {
 	struct ieee80211_mgd_assoc_data *assoc_data = sdata->u.mgd.assoc_data;
 	struct ieee80211_local *local = sdata->local;
+	int ret;
 
 	sdata_assert_lock(sdata);
 
@@ -4471,7 +4482,9 @@ static int ieee80211_do_assoc(struct iee
 	sdata_info(sdata, "associate with %pM (try %d/%d)\n",
 		   assoc_data->bss->bssid, assoc_data->tries,
 		   IEEE80211_ASSOC_MAX_TRIES);
-	ieee80211_send_assoc(sdata);
+	ret = ieee80211_send_assoc(sdata);
+	if (ret)
+		return ret;
 
 	if (!ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
 		assoc_data->timeout = jiffies + IEEE80211_ASSOC_TIMEOUT;


