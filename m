Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A993AEE63
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbhFUQ22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:28:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231837AbhFUQ1O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:27:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34F6D613CC;
        Mon, 21 Jun 2021 16:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292563;
        bh=ALqKo1VmroxhzO8nwgjB/9QqKYkuPOE7lUq6KOJjfo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SXeoGDajsJP7TyKM3QAEq8c7NEwn67N9A+d2oMxUl1O7uGXCc5q4g6EOMW0H9p2E2
         N5hgZUTmJqNoZHHk5nZyqDYfcg59/oNDR26ykNg2X+tn4VDXo4vmWylfZnuZtlqwcT
         KGcPhN11E7PPZu7tP/XSHeF6pO1OOiDj4xygqA8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+405843667e93b9790fc1@syzkaller.appspotmail.com,
        Du Cheng <ducheng2@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/146] mac80211: fix skb length check in ieee80211_scan_rx()
Date:   Mon, 21 Jun 2021 18:14:03 +0200
Message-Id: <20210621154911.715681409@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Du Cheng <ducheng2@gmail.com>

[ Upstream commit e298aa358f0ca658406d524b6639fe389cb6e11e ]

Replace hard-coded compile-time constants for header length check
with dynamic determination based on the frame type. Otherwise, we
hit a validation WARN_ON in cfg80211 later.

Fixes: cd418ba63f0c ("mac80211: convert S1G beacon to scan results")
Reported-by: syzbot+405843667e93b9790fc1@syzkaller.appspotmail.com
Signed-off-by: Du Cheng <ducheng2@gmail.com>
Link: https://lore.kernel.org/r/20210510041649.589754-1-ducheng2@gmail.com
[style fixes, reword commit message]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/scan.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index d4cc9ac2d703..6b50cb5e0e3c 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -251,13 +251,24 @@ void ieee80211_scan_rx(struct ieee80211_local *local, struct sk_buff *skb)
 	struct ieee80211_mgmt *mgmt = (void *)skb->data;
 	struct ieee80211_bss *bss;
 	struct ieee80211_channel *channel;
+	size_t min_hdr_len = offsetof(struct ieee80211_mgmt,
+				      u.probe_resp.variable);
+
+	if (!ieee80211_is_probe_resp(mgmt->frame_control) &&
+	    !ieee80211_is_beacon(mgmt->frame_control) &&
+	    !ieee80211_is_s1g_beacon(mgmt->frame_control))
+		return;
 
 	if (ieee80211_is_s1g_beacon(mgmt->frame_control)) {
-		if (skb->len < 15)
-			return;
-	} else if (skb->len < 24 ||
-		 (!ieee80211_is_probe_resp(mgmt->frame_control) &&
-		  !ieee80211_is_beacon(mgmt->frame_control)))
+		if (ieee80211_is_s1g_short_beacon(mgmt->frame_control))
+			min_hdr_len = offsetof(struct ieee80211_ext,
+					       u.s1g_short_beacon.variable);
+		else
+			min_hdr_len = offsetof(struct ieee80211_ext,
+					       u.s1g_beacon);
+	}
+
+	if (skb->len < min_hdr_len)
 		return;
 
 	sdata1 = rcu_dereference(local->scan_sdata);
-- 
2.30.2



