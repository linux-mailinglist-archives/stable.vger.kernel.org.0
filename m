Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5B442DCC0
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 16:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbhJNPBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:01:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232003AbhJNPAU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:00:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0C9F611EE;
        Thu, 14 Oct 2021 14:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223478;
        bh=Gzk/TXzU0E5X3+fFKMwL8d+HH/Zy/2lipu9hkOZ+sIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zkr2H+xWQcNhTyrkprLvd+iWeO6GI+kNcmiKYdpyQ0zwdxlMJHnWMMnN+cKxcsGaG
         lU/otpRlZWt+K4sIjKxLYvUxNFzgr5ecBTuC/f6fA63JY92qyJHj5tB5/zQnZ0ECJx
         glfN8IUeLcfQYaB6jW0AsORzmF9F9oV2J6gnvNfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 27/33] mac80211: Drop frames from invalid MAC address in ad-hoc mode
Date:   Thu, 14 Oct 2021 16:53:59 +0200
Message-Id: <20211014145209.710794734@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145208.775270267@linuxfoundation.org>
References: <20211014145208.775270267@linuxfoundation.org>
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
index 87926c6fe0bf..cbe1177d95f9 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3714,7 +3714,8 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
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



