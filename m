Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB10B42DCD8
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbhJNPC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:02:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232183AbhJNPA5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:00:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A786611F0;
        Thu, 14 Oct 2021 14:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223509;
        bh=1mVA/dIFluUI+oN8vg557h1bTtlAe17ZpEeU2IQfOSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eBI/VdyZqdXJam20Z+mT9b4533OChSZw4hwh8z+e41gRrR70NRVf+twnBNU+v8UlO
         sBMZOeOzQ934rQGxb0I1Kw+yQW3+wDtwprT76l+1XzwV5qL2MTDMOusR1+X/h7Hx18
         XaMvSJ5FvOAe7su5XiYiGoHI5w0lE70f6tCG/mr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 04/12] mac80211: Drop frames from invalid MAC address in ad-hoc mode
Date:   Thu, 14 Oct 2021 16:54:04 +0200
Message-Id: <20211014145206.702722726@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145206.566123760@linuxfoundation.org>
References: <20211014145206.566123760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit a6555f844549cd190eb060daef595f94d3de1582 ]

WARNING: CPU: 1 PID: 9 at net/mac80211/sta_info.c:554
sta_info_insert_rcu+0x121/0x12a0
Modules linked in:
CPU: 1 PID: 9 Comm: kworker/u8:1 Not tainted 5.14.0-rc7+ #253
Workqueue: phy3 ieee80211_iface_work
RIP: 0010:sta_info_insert_rcu+0x121/0x12a0
...
Call Trace:
 ieee80211_ibss_finish_sta+0xbc/0x170
 ieee80211_ibss_work+0x13f/0x7d0
 ieee80211_iface_work+0x37a/0x500
 process_one_work+0x357/0x850
 worker_thread+0x41/0x4d0

If an Ad-Hoc node receives packets with invalid source MAC address,
it hits a WARN_ON in sta_info_insert_check(), this can spam the log.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Link: https://lore.kernel.org/r/20210827144230.39944-1-yuehaibing@huawei.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 012697efafc3..e0baa563a4de 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3875,7 +3875,8 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 		if (!bssid)
 			return false;
 		if (ether_addr_equal(sdata->vif.addr, hdr->addr2) ||
-		    ether_addr_equal(sdata->u.ibss.bssid, hdr->addr2))
+		    ether_addr_equal(sdata->u.ibss.bssid, hdr->addr2) ||
+		    !is_valid_ether_addr(hdr->addr2))
 			return false;
 		if (ieee80211_is_beacon(hdr->frame_control))
 			return true;
-- 
2.33.0



