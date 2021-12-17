Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB71479585
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 21:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236983AbhLQUf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 15:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbhLQUf7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 15:35:59 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF13CC061574
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 12:35:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=fY6U2z1wNeEEmGE07qqsNsDX+k6IlT7A8v0LAH+5vwE=; t=1639773358; x=1640982958; 
        b=hhww9JVvmS5VV5kYcUU78TupOgY2XgAziq10/peBpxL4IjejG81FgYWehAngaOWi2787qMd+3dM
        owUNZmzqogi8Czgbp33l4oQhYnc0W+eu+pmgavEfbC1QzdXw+Qc6+v6pT4uwbA4aLRpxE0BNmHbhe
        7uw4PwCV3HmV5la+89K0OiSTPZRTyvyLMJfP8RvobwIcQQPiTIThwvhYMUlhT+EXjehsxqU5vTrRM
        0dDLAB6mRONaBcqHuzdoL78EPsUw8gotdhVOe9TaqVa6P3pX7q+wWmt8oCT5aKdcKW/Qriji1beLE
        QiqYtoCA7qK8iYVaxWk3aHrFRo8lH6MumXZg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1myJxK-00CuHI-L1;
        Fri, 17 Dec 2021 21:35:54 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v4.19 1/2] mac80211: mark TX-during-stop for TX in in_reconfig
Date:   Fri, 17 Dec 2021 21:35:49 +0100
Message-Id: <20211217203550.54684-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Commit db7205af049d230e7e0abf61c1e74c1aab40f390 upstream.

Mark TXQs as having seen transmit while they were stopped if
we bail out of drv_wake_tx_queue() due to reconfig, so that
the queue wake after this will make them catch up. This is
particularly necessary for when TXQs are used for management
packets since those TXQs won't see a lot of traffic that'd
make them catch up later.

Cc: stable@vger.kernel.org
Fixes: 4856bfd23098 ("mac80211: do not call driver wake_tx_queue op during reconfig")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211129152938.4573a221c0e1.I0d1d5daea3089be3fc0dccc92991b0f8c5677f0c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
I'm not sure why you say it doesn't apply - it did for me?
---
 net/mac80211/driver-ops.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 2123f6e90fc0..8f71c271653f 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1166,8 +1166,11 @@ static inline void drv_wake_tx_queue(struct ieee80211_local *local,
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(txq->txq.vif);
 
-	if (local->in_reconfig)
+	/* In reconfig don't transmit now, but mark for waking later */
+	if (local->in_reconfig) {
+		set_bit(IEEE80211_TXQ_STOP_NETIF_TX, &txq->flags);
 		return;
+	}
 
 	if (!check_sdata_in_driver(sdata))
 		return;
-- 
2.33.1

