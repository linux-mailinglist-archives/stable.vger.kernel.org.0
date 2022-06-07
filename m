Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C459E54075E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348062AbiFGRrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349062AbiFGRqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:46:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A2562BC4;
        Tue,  7 Jun 2022 10:36:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 979BF60DB5;
        Tue,  7 Jun 2022 17:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65A9C385A5;
        Tue,  7 Jun 2022 17:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623382;
        bh=mLUZPnwtxYepKpeekuKglrgz00FKKljKZilx1rGoNw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eeOKZbnL95rtuzSKH49pVZALv8rOdyxP41Vh8/HbPkRAcfyzcaszlqbhM2i74fL7w
         p+bPqkUjT2I3YF37Udt7cp7WRXIefQGcvRLbSZoBeVO9ect5wyHliEfuWQInybuzaH
         1DTKr95cGn5ETF63DlLQ1V8RpaFFXXzctGkZNopI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catrinel Catrinescu <cc@80211.de>,
        Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 397/452] mac80211: upgrade passive scan to active scan on DFS channels after beacon rx
Date:   Tue,  7 Jun 2022 19:04:14 +0200
Message-Id: <20220607164920.391930459@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

commit b041b7b9de6e1d4362de855ab90f9d03ef323edd upstream.

In client mode, we can't connect to hidden SSID APs or SSIDs not advertised
in beacons on DFS channels, since we're forced to passive scan. Fix this by
sending out a probe request immediately after the first beacon, if active
scan was requested by the user.

Cc: stable@vger.kernel.org
Reported-by: Catrinel Catrinescu <cc@80211.de>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20220420104907.36275-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/ieee80211_i.h |    5 +++++
 net/mac80211/scan.c        |   20 ++++++++++++++++++++
 2 files changed, 25 insertions(+)

--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1103,6 +1103,9 @@ struct tpt_led_trigger {
  *	a scan complete for an aborted scan.
  * @SCAN_HW_CANCELLED: Set for our scan work function when the scan is being
  *	cancelled.
+ * @SCAN_BEACON_WAIT: Set whenever we're passive scanning because of radar/no-IR
+ *	and could send a probe request after receiving a beacon.
+ * @SCAN_BEACON_DONE: Beacon received, we can now send a probe request
  */
 enum {
 	SCAN_SW_SCANNING,
@@ -1111,6 +1114,8 @@ enum {
 	SCAN_COMPLETED,
 	SCAN_ABORTED,
 	SCAN_HW_CANCELLED,
+	SCAN_BEACON_WAIT,
+	SCAN_BEACON_DONE,
 };
 
 /**
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -277,6 +277,16 @@ void ieee80211_scan_rx(struct ieee80211_
 	if (likely(!sdata1 && !sdata2))
 		return;
 
+	if (test_and_clear_bit(SCAN_BEACON_WAIT, &local->scanning)) {
+		/*
+		 * we were passive scanning because of radar/no-IR, but
+		 * the beacon/proberesp rx gives us an opportunity to upgrade
+		 * to active scan
+		 */
+		 set_bit(SCAN_BEACON_DONE, &local->scanning);
+		 ieee80211_queue_delayed_work(&local->hw, &local->scan_work, 0);
+	}
+
 	if (ieee80211_is_probe_resp(mgmt->frame_control)) {
 		struct cfg80211_scan_request *scan_req;
 		struct cfg80211_sched_scan_request *sched_scan_req;
@@ -783,6 +793,8 @@ static int __ieee80211_start_scan(struct
 						IEEE80211_CHAN_RADAR)) ||
 		    !req->n_ssids) {
 			next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
+			if (req->n_ssids)
+				set_bit(SCAN_BEACON_WAIT, &local->scanning);
 		} else {
 			ieee80211_scan_state_send_probe(local, &next_delay);
 			next_delay = IEEE80211_CHANNEL_TIME;
@@ -994,6 +1006,8 @@ set_channel:
 	    !scan_req->n_ssids) {
 		*next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
 		local->next_scan_state = SCAN_DECISION;
+		if (scan_req->n_ssids)
+			set_bit(SCAN_BEACON_WAIT, &local->scanning);
 		return;
 	}
 
@@ -1086,6 +1100,8 @@ void ieee80211_scan_work(struct work_str
 			goto out;
 	}
 
+	clear_bit(SCAN_BEACON_WAIT, &local->scanning);
+
 	/*
 	 * as long as no delay is required advance immediately
 	 * without scheduling a new work
@@ -1096,6 +1112,10 @@ void ieee80211_scan_work(struct work_str
 			goto out_complete;
 		}
 
+		if (test_and_clear_bit(SCAN_BEACON_DONE, &local->scanning) &&
+		    local->next_scan_state == SCAN_DECISION)
+			local->next_scan_state = SCAN_SEND_PROBE;
+
 		switch (local->next_scan_state) {
 		case SCAN_DECISION:
 			/* if no more bands/channels left, complete scan */


