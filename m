Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A38C35BE36
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238787AbhDLI5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:57:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238992AbhDLIzR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:55:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F07F96125F;
        Mon, 12 Apr 2021 08:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217667;
        bh=PNofxI6sIvCp2AxAW5xCeCO5rACjP1WGLH4QwCCnBPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G/wl0qwPDcnBXMx9oD5hyJCxybshSmkeKcOmvEYU5sIRgadmyCMclaxPFtaNFL3rK
         2jPDf378vvU0TTU8sJxUI9I9l2WztjqhB3ZRHD0oAO1fy/YuDnmrumQ+NjWOulXxFx
         bB5bjh9ZT8vKMvyE64zuGzAEU58/GxaV1+ptiNIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Greear <greearb@candelatech.com>,
        Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 066/188] mac80211: fix time-is-after bug in mlme
Date:   Mon, 12 Apr 2021 10:39:40 +0200
Message-Id: <20210412084015.848407820@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

commit 7d73cd946d4bc7d44cdc5121b1c61d5d71425dea upstream.

The incorrect timeout check caused probing to happen when it did
not need to happen.  This in turn caused tx performance drop
for around 5 seconds in ath10k-ct driver.  Possibly that tx drop
is due to a secondary issue, but fixing the probe to not happen
when traffic is running fixes the symptom.

Signed-off-by: Ben Greear <greearb@candelatech.com>
Fixes: 9abf4e49830d ("mac80211: optimize station connection monitor")
Acked-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20210330230749.14097-1-greearb@candelatech.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/mlme.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4660,7 +4660,10 @@ static void ieee80211_sta_conn_mon_timer
 		timeout = sta->rx_stats.last_rx;
 	timeout += IEEE80211_CONNECTION_IDLE_TIME;
 
-	if (time_is_before_jiffies(timeout)) {
+	/* If timeout is after now, then update timer to fire at
+	 * the later date, but do not actually probe at this time.
+	 */
+	if (time_is_after_jiffies(timeout)) {
 		mod_timer(&ifmgd->conn_mon_timer, round_jiffies_up(timeout));
 		return;
 	}


