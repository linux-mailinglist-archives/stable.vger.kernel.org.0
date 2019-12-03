Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17768111F89
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbfLCWnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:43:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:58238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728564AbfLCWnB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:43:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54D5D20684;
        Tue,  3 Dec 2019 22:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412980;
        bh=Oqj7gHsXnFP2pmn2Qi83jcoJYfWeViXDHc+v9myvd/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p5Rbmn6BHFfOimK1XXzM887yXC0w62QRmz3z2qlQATAVEfbcz/NJICpv6Eg8+FvyB
         Mog8Jzu9lZB9CAtxkgNp3c9JJJqRRPbDVev//cD8eatAmMLD1v3hIBh86QEFUtyYFu
         L0gPuCh9escxCdgXzqE8I/tSoRlz30109G50Qhfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ahmed Zaki <anzaki@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 091/135] mac80211: fix station inactive_time shortly after boot
Date:   Tue,  3 Dec 2019 23:35:31 +0100
Message-Id: <20191203213036.421397975@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmed Zaki <anzaki@gmail.com>

[ Upstream commit 285531f9e6774e3be71da6673d475ff1a088d675 ]

In the first 5 minutes after boot (time of INITIAL_JIFFIES),
ieee80211_sta_last_active() returns zero if last_ack is zero. This
leads to "inactive time" showing jiffies_to_msecs(jiffies).

 # iw wlan0 station get fc:ec:da:64:a6:dd
 Station fc:ec:da:64:a6:dd (on wlan0)
	inactive time:	4294894049 ms
	.
	.
	connected time:	70 seconds

Fix by returning last_rx if last_ack == 0.

Signed-off-by: Ahmed Zaki <anzaki@gmail.com>
Link: https://lore.kernel.org/r/20191031121243.27694-1-anzaki@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 5fb368cc26338..0030b13c2f501 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2455,7 +2455,8 @@ unsigned long ieee80211_sta_last_active(struct sta_info *sta)
 {
 	struct ieee80211_sta_rx_stats *stats = sta_get_last_rx_stats(sta);
 
-	if (time_after(stats->last_rx, sta->status_stats.last_ack))
+	if (!sta->status_stats.last_ack ||
+	    time_after(stats->last_rx, sta->status_stats.last_ack))
 		return stats->last_rx;
 	return sta->status_stats.last_ack;
 }
-- 
2.20.1



