Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699464BBAA0
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 15:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbiBRObZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 09:31:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbiBRObY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 09:31:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912B11CFA12
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 06:31:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CAEBB82659
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 14:31:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A049EC340E9;
        Fri, 18 Feb 2022 14:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645194665;
        bh=R/xnbefcfR6wxWYZhGXDbK2p4JLVBlsE+Cf2F/gUweI=;
        h=Subject:To:Cc:From:Date:From;
        b=km0y2+x6wOGbWd8ruZ+1Yl9oibxow64e2dtehaawOYBbuMcsV4YTi1pRwxxTzw2qF
         mN55UB3KcFwTLkE4DtCzb+k3YDtrtHW7JhLfHstD5IlJU629q/C5wzjXJ2GdPRq1kP
         AJBR2ORNnD/ItBbNjRc5fJeNbBqT1KAuCZCZU7+g=
Subject: FAILED: patch "[PATCH] mac80211: mlme: check for null after calling kmemdup" failed to apply to 5.4-stable tree
To:     jiasheng@iscas.ac.cn, johannes.berg@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Feb 2022 15:31:02 +0100
Message-ID: <16451946623243@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a72c01a94f1d285a274219d36e2a17b4846c0615 Mon Sep 17 00:00:00 2001
From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Date: Wed, 5 Jan 2022 16:15:59 +0800
Subject: [PATCH] mac80211: mlme: check for null after calling kmemdup

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

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1eeabdf10052..e5ccf17618ab 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -666,7 +666,7 @@ static void ieee80211_add_he_ie(struct ieee80211_sub_if_data *sdata,
 	ieee80211_ie_build_he_6ghz_cap(sdata, skb);
 }
 
-static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
+static int ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -686,6 +686,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	enum nl80211_iftype iftype = ieee80211_vif_type_p2p(&sdata->vif);
 	const struct ieee80211_sband_iftype_data *iftd;
 	struct ieee80211_prep_tx_info info = {};
+	int ret;
 
 	/* we know it's writable, cast away the const */
 	if (assoc_data->ie_len)
@@ -699,7 +700,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 	if (WARN_ON(!chanctx_conf)) {
 		rcu_read_unlock();
-		return;
+		return -EINVAL;
 	}
 	chan = chanctx_conf->def.chan;
 	rcu_read_unlock();
@@ -750,7 +751,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 			(iftd ? iftd->vendor_elems.len : 0),
 			GFP_KERNEL);
 	if (!skb)
-		return;
+		return -ENOMEM;
 
 	skb_reserve(skb, local->hw.extra_tx_headroom);
 
@@ -1031,15 +1032,22 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
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
@@ -1049,6 +1057,8 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS |
 						IEEE80211_TX_INTFL_MLME_CONN_TX;
 	ieee80211_tx_skb(sdata, skb);
+
+	return 0;
 }
 
 void ieee80211_send_pspoll(struct ieee80211_local *local,
@@ -4497,6 +4507,7 @@ static int ieee80211_do_assoc(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_mgd_assoc_data *assoc_data = sdata->u.mgd.assoc_data;
 	struct ieee80211_local *local = sdata->local;
+	int ret;
 
 	sdata_assert_lock(sdata);
 
@@ -4517,7 +4528,9 @@ static int ieee80211_do_assoc(struct ieee80211_sub_if_data *sdata)
 	sdata_info(sdata, "associate with %pM (try %d/%d)\n",
 		   assoc_data->bss->bssid, assoc_data->tries,
 		   IEEE80211_ASSOC_MAX_TRIES);
-	ieee80211_send_assoc(sdata);
+	ret = ieee80211_send_assoc(sdata);
+	if (ret)
+		return ret;
 
 	if (!ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
 		assoc_data->timeout = jiffies + IEEE80211_ASSOC_TIMEOUT;

