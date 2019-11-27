Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94B3410BAB4
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731743AbfK0VFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:05:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:59632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727440AbfK0VFt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:05:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C9EB21770;
        Wed, 27 Nov 2019 21:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888748;
        bh=5Pdak+JPJzVEhoD/8rcgc5m8LdWqf4v8nm3VoE3IvzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LpxKWBvmRTf7cRgPIsOxhPWFkbLE8B30tIPwqbBUVUcuzAB/OWu6rfi1CiCDCFcSp
         3xDY81mpG5B+hRAGcruzzT/hAXPzJ0w3jnDsCktSdxGAgagqqKwWjvDZrYRMnSZM4x
         /SfPYU6C/D9BwdFA6OSUqkZmKjIDZqALJ4Vo9Q+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 254/306] cfg80211: call disconnect_wk when AP stops
Date:   Wed, 27 Nov 2019 21:31:44 +0100
Message-Id: <20191127203133.433190312@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
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
index 882d97bdc6bfd..550ac9d827fe7 100644
--- a/net/wireless/ap.c
+++ b/net/wireless/ap.c
@@ -41,6 +41,8 @@ int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 		cfg80211_sched_dfs_chan_update(rdev);
 	}
 
+	schedule_work(&cfg80211_disconnect_work);
+
 	return err;
 }
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 7f52ef5693203..f5d58652108dd 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -430,6 +430,8 @@ void cfg80211_process_wdev_events(struct wireless_dev *wdev);
 bool cfg80211_does_bw_fit_range(const struct ieee80211_freq_range *freq_range,
 				u32 center_freq_khz, u32 bw_khz);
 
+extern struct work_struct cfg80211_disconnect_work;
+
 /**
  * cfg80211_chandef_dfs_usable - checks if chandef is DFS usable
  * @wiphy: the wiphy to validate against
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index c7047c7b4e80f..07c2196e9d573 100644
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



