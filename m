Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFFE2C059C
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729686AbgKWMXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:23:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:33090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729684AbgKWMXu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:23:50 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1251E2076E;
        Mon, 23 Nov 2020 12:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134228;
        bh=fMDFc7sls7u6Zpyw/rSEiFHR2PZDRH/WfP6ox+BkHSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gs0OzG+AfZZ5yw2/tVqOIT6j/EbrOj7+OsN7S7NlUg2B5ZJruK2ZIHKEOErc9VBTd
         vaPTlrnR5h6VEoLS+Sc0J5T6/aFlOF8a46osuNpNeoFqZs1HSDBUaheOGpJikvC53u
         ogWN81rWHsceoaqoemxpD2StPLNfwoved6pIfFXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.4 33/38] mac80211: minstrel: remove deferred sampling code
Date:   Mon, 23 Nov 2020 13:22:19 +0100
Message-Id: <20201123121805.883326992@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121804.306030358@linuxfoundation.org>
References: <20201123121804.306030358@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

commit 4fe40b8e1566dad04c87fbf299049a1d0d4bd58d upstream.

Deferring sampling attempts to the second stage has some bad interactions
with drivers that process the rate table in hardware and use the probe flag
to indicate probing packets (e.g. most mt76 drivers). On affected drivers
it can lead to probing not working at all.

If the link conditions turn worse, it might not be such a good idea to
do a lot of sampling for lower rates in this case.

Fix this by simply skipping the sample attempt instead of deferring it,
but keep the checks that would allow it to be sampled if it was skipped
too often, but only if it has less than 95% success probability.

Also ensure that IEEE80211_TX_CTL_RATE_CTRL_PROBE is set for all probing
packets.

Cc: stable@vger.kernel.org
Fixes: cccf129f820e ("mac80211: add the 'minstrel' rate control algorithm")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20201111183359.43528-2-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/rc80211_minstrel.c |   25 ++++---------------------
 net/mac80211/rc80211_minstrel.h |    1 -
 2 files changed, 4 insertions(+), 22 deletions(-)

--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -287,12 +287,6 @@ minstrel_tx_status(void *priv, struct ie
 			mi->r[ndx].stats.success += success;
 	}
 
-	if ((info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE) && (i >= 0))
-		mi->sample_packets++;
-
-	if (mi->sample_deferred > 0)
-		mi->sample_deferred--;
-
 	if (time_after(jiffies, mi->last_stats_update +
 				(mp->update_interval * HZ) / 1000))
 		minstrel_update_stats(mp, mi);
@@ -366,7 +360,7 @@ minstrel_get_rate(void *priv, struct iee
 #endif
 
 	delta = (mi->total_packets * sampling_ratio / 100) -
-			(mi->sample_packets + mi->sample_deferred / 2);
+			mi->sample_packets;
 
 	/* delta < 0: no sampling required */
 	prev_sample = mi->prev_sample;
@@ -375,7 +369,6 @@ minstrel_get_rate(void *priv, struct iee
 		return;
 
 	if (mi->total_packets >= 10000) {
-		mi->sample_deferred = 0;
 		mi->sample_packets = 0;
 		mi->total_packets = 0;
 	} else if (delta > mi->n_rates * 2) {
@@ -400,19 +393,8 @@ minstrel_get_rate(void *priv, struct iee
 	 * rate sampling method should be used.
 	 * Respect such rates that are not sampled for 20 interations.
 	 */
-	if (mrr_capable &&
-	    msr->perfect_tx_time > mr->perfect_tx_time &&
-	    msr->stats.sample_skipped < 20) {
-		/* Only use IEEE80211_TX_CTL_RATE_CTRL_PROBE to mark
-		 * packets that have the sampling rate deferred to the
-		 * second MRR stage. Increase the sample counter only
-		 * if the deferred sample rate was actually used.
-		 * Use the sample_deferred counter to make sure that
-		 * the sampling is not done in large bursts */
-		info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
-		rate++;
-		mi->sample_deferred++;
-	} else {
+	if (msr->perfect_tx_time < mr->perfect_tx_time ||
+	    msr->stats.sample_skipped >= 20) {
 		if (!msr->sample_limit)
 			return;
 
@@ -432,6 +414,7 @@ minstrel_get_rate(void *priv, struct iee
 
 	rate->idx = mi->r[ndx].rix;
 	rate->count = minstrel_get_retry_count(&mi->r[ndx], info);
+	info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
 }
 
 
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -105,7 +105,6 @@ struct minstrel_sta_info {
 	u8 max_prob_rate;
 	unsigned int total_packets;
 	unsigned int sample_packets;
-	int sample_deferred;
 
 	unsigned int sample_row;
 	unsigned int sample_column;


