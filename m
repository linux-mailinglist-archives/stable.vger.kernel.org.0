Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26840420F9F
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236622AbhJDNgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:36:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236582AbhJDNex (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:34:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B06761881;
        Mon,  4 Oct 2021 13:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353338;
        bh=RtU55DnzmwifvM70zL20eJG7d1lJfdM7W4xWz2HvvjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJ7vL7TGCvFTS0nHP0QBRloy/6+OFemugSEZPQhpyMH3YzS8Q3XfvZ737CIX05pLA
         hr0f5/V3GIp+k2CqdU+y6n21t9+Bms2VectdBHqAy8NQeLzhpdbFtJE58+ZPRLg8RW
         kFA4v75RCYEwhpIK5t4kGnVIl61GVw+BdHLvSGLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 088/172] Revert "mac80211: do not use low data rates for data frames with no ack flag"
Date:   Mon,  4 Oct 2021 14:52:18 +0200
Message-Id: <20211004125047.836891379@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 98d46b021f6ee246c7a73f9d490d4cddb4511a3b ]

This reverts commit d333322361e7 ("mac80211: do not use low data rates for
data frames with no ack flag").

Returning false early in rate_control_send_low breaks sending broadcast
packets, since rate control will not select a rate for it.

Before re-introducing a fixed version of this patch, we should probably also
make some changes to rate control to be more conservative in selecting rates
for no-ack packets and also prevent using probing rates on them, since we won't
get any feedback.

Fixes: d333322361e7 ("mac80211: do not use low data rates for data frames with no ack flag")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20210906083559.9109-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rate.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index e5935e3d7a07..8c6416129d5b 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -392,10 +392,6 @@ static bool rate_control_send_low(struct ieee80211_sta *pubsta,
 	int mcast_rate;
 	bool use_basicrate = false;
 
-	if (ieee80211_is_tx_data(txrc->skb) &&
-	    info->flags & IEEE80211_TX_CTL_NO_ACK)
-		return false;
-
 	if (!pubsta || rc_no_data_or_no_ack_use_min(txrc)) {
 		__rate_control_send_low(txrc->hw, sband, pubsta, info,
 					txrc->rate_idx_mask);
-- 
2.33.0



