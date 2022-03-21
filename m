Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01BC44E2A29
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348993AbiCUOOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349477AbiCUOI0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:08:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B282546169;
        Mon, 21 Mar 2022 07:02:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0420B816D7;
        Mon, 21 Mar 2022 14:02:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BBAAC340E8;
        Mon, 21 Mar 2022 14:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871369;
        bh=oxVeHmU6vXUXNj8ii8MS42qnjCRLISMiq/1Pu/HbLOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+Q82zq41qiONYGp6esSJrDp3XsyJM92MHGVZgzoke7Pdm9lUTdASXWApehEOwYFa
         stihnK3mjB+1Xh3RmRPDdI5XKjjfYBx6DcfeE9PowOdewsLb+SgIYBaMTVdbhAlJOF
         OaIt/HhmM9e5NoB+mgR4TrWXu9AuqQR3Cn6/szsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kalle Valo <quic_kvalo@quicinc.com>
Subject: [PATCH 5.16 36/37] Revert "ath10k: drop beacon and probe response which leak from other channel"
Date:   Mon, 21 Mar 2022 14:53:18 +0100
Message-Id: <20220321133222.334723442@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133221.290173884@linuxfoundation.org>
References: <20220321133221.290173884@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kalle Valo <quic_kvalo@quicinc.com>

commit 45b4eb7ee6aa1a55a50831b328aa5f46ac3a7187 upstream.

This reverts commit 3bf2537ec2e33310b431b53fd84be8833736c256.

I was reported privately that this commit breaks AP and mesh mode on QCA9984
(firmware 10.4-3.9.0.2-00156). So revert the commit to fix the regression.

There was a conflict due to cfg80211 API changes but that was easy to fix.

Fixes: 3bf2537ec2e3 ("ath10k: drop beacon and probe response which leak from other channel")
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220315155455.20446-1-kvalo@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath10k/wmi.c |   27 +--------------------------
 1 file changed, 1 insertion(+), 26 deletions(-)

--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2611,30 +2611,9 @@ int ath10k_wmi_event_mgmt_rx(struct ath1
 		ath10k_mac_handle_beacon(ar, skb);
 
 	if (ieee80211_is_beacon(hdr->frame_control) ||
-	    ieee80211_is_probe_resp(hdr->frame_control)) {
-		struct ieee80211_mgmt *mgmt = (void *)skb->data;
-		u8 *ies;
-		int ies_ch;
-
+	    ieee80211_is_probe_resp(hdr->frame_control))
 		status->boottime_ns = ktime_get_boottime_ns();
 
-		if (!ar->scan_channel)
-			goto drop;
-
-		ies = mgmt->u.beacon.variable;
-
-		ies_ch = cfg80211_get_ies_channel_number(mgmt->u.beacon.variable,
-							 skb_tail_pointer(skb) - ies,
-							 sband->band);
-
-		if (ies_ch > 0 && ies_ch != channel) {
-			ath10k_dbg(ar, ATH10K_DBG_MGMT,
-				   "channel mismatched ds channel %d scan channel %d\n",
-				   ies_ch, channel);
-			goto drop;
-		}
-	}
-
 	ath10k_dbg(ar, ATH10K_DBG_MGMT,
 		   "event mgmt rx skb %pK len %d ftype %02x stype %02x\n",
 		   skb, skb->len,
@@ -2648,10 +2627,6 @@ int ath10k_wmi_event_mgmt_rx(struct ath1
 	ieee80211_rx_ni(ar->hw, skb);
 
 	return 0;
-
-drop:
-	dev_kfree_skb(skb);
-	return 0;
 }
 
 static int freq_to_idx(struct ath10k *ar, int freq)


