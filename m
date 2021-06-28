Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836043B6190
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234869AbhF1Og2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:36:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235166AbhF1OfH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:35:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA83261C93;
        Mon, 28 Jun 2021 14:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890620;
        bh=55DVHUlb33fLzBbcpDnb2kMvPyNHKRg6I8U85tlirjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rorbJ6C/OvxNPSRz8VsYI1C4a+4UeE4Tepf7wU/C2djWcNV3xT3um4NHVwy3ZhlS5
         8HazmePTHIV4MqDijsCW7ivCupWfTYapYbvttO3NxEZfK43By/c1H22XH7f7HXb2Yj
         VJlyKHcLq5lsY5InqWD17zUhu79yYUKhJkPclv/dCQt+72q/ONnlkwBqD7ZenMBDtk
         zEbSi+xRPOYBXrlu4JXJCarBIag5AZeiWIan7QHYwvgMZpADVwNoUANU5qbdM440ch
         P4FexHcRlnDakjuhFCwrLKM8gg98uWFzrjycBj8cso3pXjdyZ5DvxswakeOOvjUtLS
         xgMSez7Fex5aQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        syzbot+a063bbf0b15737362592@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 15/71] mac80211_hwsim: drop pending frames on stop
Date:   Mon, 28 Jun 2021 10:29:08 -0400
Message-Id: <20210628143004.32596-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit bd18de517923903a177508fc8813f44e717b1c00 ]

Syzbot reports that we may be able to get into a situation where
mac80211 has pending ACK frames on shutdown with hwsim. It appears
that the reason for this is that syzbot uses the wmediumd hooks to
intercept/injection frames, and may shut down hwsim, removing the
radio(s), while frames are pending in the air simulation.

Clean out the pending queue when the interface is stopped, after
this the frames can't be reported back to mac80211 properly anyway.

Reported-by: syzbot+a063bbf0b15737362592@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20210517170429.b0f85ab0eda1.Ie42a6ec6b940c971f3441286aeaaae2fe368e29a@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index c48c68090d76..1033513d3d9d 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1458,8 +1458,13 @@ static int mac80211_hwsim_start(struct ieee80211_hw *hw)
 static void mac80211_hwsim_stop(struct ieee80211_hw *hw)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
+
 	data->started = false;
 	hrtimer_cancel(&data->beacon_timer);
+
+	while (!skb_queue_empty(&data->pending))
+		ieee80211_free_txskb(hw, skb_dequeue(&data->pending));
+
 	wiphy_dbg(hw->wiphy, "%s\n", __func__);
 }
 
-- 
2.30.2

