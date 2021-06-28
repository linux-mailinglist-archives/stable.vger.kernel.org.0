Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8515B3B5FF4
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbhF1OVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:21:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232806AbhF1OVT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 286FD61C76;
        Mon, 28 Jun 2021 14:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889933;
        bh=1sHIQdPRn/XYTHYJ7Gb5M0sxtlirFmYni9xPyfy/yw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q/k5pZv+F0Mpj3b+gd4e15OveeIZok7HrzoNd1qtc+dEM/SduQawg3a2c22qmcFc6
         ZSh/7Yza7+6EBNjaUOf8cYF30Nk7H5GaDTF3mqZThnQh2Qd7dImr6f7rFPwawN615S
         Nk0me2j+z7ej1qIgeX99mruvh1hyaZrA8H68PqbwikTSC3p3JP+VBBHA+6IpGvpY83
         pwcEKWYrAAr01LslN63UGaOpoBgdInxtuX+8xyIJA5c6xHWdlLA50R1U+DYuFbfL2n
         fcuetolF2VU9dXCVv5asMqyM5x8etdHTQmWKdrnD6sGgABVNjkhlny5TZIasfh0LsM
         VdtAmzFNxnZwA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        syzbot+a063bbf0b15737362592@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 027/110] mac80211_hwsim: drop pending frames on stop
Date:   Mon, 28 Jun 2021 10:17:05 -0400
Message-Id: <20210628141828.31757-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
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
index fa7d4c20dc13..30b39cb4056a 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1693,8 +1693,13 @@ static int mac80211_hwsim_start(struct ieee80211_hw *hw)
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

