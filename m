Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 858FD10BDF4
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730646AbfK0Uwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:52:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:40630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729982AbfK0Uwp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:52:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C58F5218BA;
        Wed, 27 Nov 2019 20:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887965;
        bh=oh0ks+X54M4go9LLQLOV8qujEqe3WNtVIJ2zrYgMEqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OoWv/Dt8q95AdnWR1XEAbMcYtFRkhUlMEcjXV7yHQlr6fSbL5ljAduryv5c1vArpN
         nby0k6Dge+u8TjhaHE6qa2m/B+6XGrvUZK8NmQiFQVpqsRLez2FJd8ocv75HFVHxfx
         0prBzlrMv599Y1gy4ywMcXLwqUV58DdhthW7guHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 163/211] cfg80211: call disconnect_wk when AP stops
Date:   Wed, 27 Nov 2019 21:31:36 +0100
Message-Id: <20191127203109.296527722@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e005bd7ddea06784c1eb91ac5bb6b171a94f3b05 ]

Since we now prevent regulatory restore during STA disconnect
if concurrent AP interfaces are active, we need to reschedule
this check when the AP state changes. This fixes never doing
a restore when an AP is the last interface to stop. Or to put
it another way: we need to re-check after anything we check
here changes.

Cc: stable@vger.kernel.org
Fixes: 113f3aaa81bd ("cfg80211: Prevent regulatory restore during STA disconnect in concurrent interfaces")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/ap.c   | 2 ++
 net/wireless/core.h | 2 ++
 net/wireless/sme.c  | 2 +-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/wireless/ap.c b/net/wireless/ap.c
index 63682176c96cb..c4bd3ecef5089 100644
--- a/net/wireless/ap.c
+++ b/net/wireless/ap.c
@@ -40,6 +40,8 @@ int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 		cfg80211_sched_dfs_chan_update(rdev);
 	}
 
+	schedule_work(&cfg80211_disconnect_work);
+
 	return err;
 }
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 90f90c7d8bf9b..507ec6446eb67 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -429,6 +429,8 @@ void cfg80211_process_wdev_events(struct wireless_dev *wdev);
 bool cfg80211_does_bw_fit_range(const struct ieee80211_freq_range *freq_range,
 				u32 center_freq_khz, u32 bw_khz);
 
+extern struct work_struct cfg80211_disconnect_work;
+
 /**
  * cfg80211_chandef_dfs_usable - checks if chandef is DFS usable
  * @wiphy: the wiphy to validate against
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 66cccd16c24af..8344153800e27 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -667,7 +667,7 @@ static void disconnect_work(struct work_struct *work)
 	rtnl_unlock();
 }
 
-static DECLARE_WORK(cfg80211_disconnect_work, disconnect_work);
+DECLARE_WORK(cfg80211_disconnect_work, disconnect_work);
 
 
 /*
-- 
2.20.1



