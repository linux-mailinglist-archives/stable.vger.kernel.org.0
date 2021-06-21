Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6013AF0A4
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbhFUQvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:51:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232959AbhFUQtG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:49:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1498C6141C;
        Mon, 21 Jun 2021 16:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293257;
        bh=5lK8PQzOoaZALFIJTkUp2xLa/ULEdSHdXhaBN6lQozQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C6bDhp6f0UkS0/zoOvm3NfTe3i+RH2qM2ThXs2yWxCA8cqQmiF62vH8dz7TdKSlhp
         maR9KAd3h+wjEF6mMeCVyhp1RthZs6PS5j0xZxsWguHEmvBC7T22fTKuTD2ZvhThKv
         8QX4L39bLH+2G0wkky0AD5LpmURFHTLZH24TeAv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.12 156/178] mac80211: move interface shutdown out of wiphy lock
Date:   Mon, 21 Jun 2021 18:16:10 +0200
Message-Id: <20210621154928.062449324@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit f5baf287f5da5641099ad5c809b3b4ebfc08506d upstream.

When reconfiguration fails, we shut down everything, but we
cannot call cfg80211_shutdown_all_interfaces() with the wiphy
mutex held. Since cfg80211 now calls it on resume errors, we
only need to do likewise for where we call reconfig (whether
directly or indirectly), but not under the wiphy lock.

Cc: stable@vger.kernel.org
Fixes: 2fe8ef106238 ("cfg80211: change netdev registration/unregistration semantics")
Link: https://lore.kernel.org/r/20210608113226.78233c80f548.Iecc104aceb89f0568f50e9670a9cb191a1c8887b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/debugfs.c |    7 ++++++-
 net/mac80211/main.c    |    7 ++++++-
 net/mac80211/util.c    |    2 --
 3 files changed, 12 insertions(+), 4 deletions(-)

--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -387,12 +387,17 @@ static ssize_t reset_write(struct file *
 			   size_t count, loff_t *ppos)
 {
 	struct ieee80211_local *local = file->private_data;
+	int ret;
 
 	rtnl_lock();
 	wiphy_lock(local->hw.wiphy);
 	__ieee80211_suspend(&local->hw, NULL);
-	__ieee80211_resume(&local->hw);
+	ret = __ieee80211_resume(&local->hw);
 	wiphy_unlock(local->hw.wiphy);
+
+	if (ret)
+		cfg80211_shutdown_all_interfaces(local->hw.wiphy);
+
 	rtnl_unlock();
 
 	return count;
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -252,6 +252,7 @@ static void ieee80211_restart_work(struc
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local, restart_work);
 	struct ieee80211_sub_if_data *sdata;
+	int ret;
 
 	/* wait for scan work complete */
 	flush_workqueue(local->workqueue);
@@ -294,8 +295,12 @@ static void ieee80211_restart_work(struc
 	/* wait for all packet processing to be done */
 	synchronize_net();
 
-	ieee80211_reconfig(local);
+	ret = ieee80211_reconfig(local);
 	wiphy_unlock(local->hw.wiphy);
+
+	if (ret)
+		cfg80211_shutdown_all_interfaces(local->hw.wiphy);
+
 	rtnl_unlock();
 }
 
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2186,8 +2186,6 @@ static void ieee80211_handle_reconfig_fa
 	list_for_each_entry(ctx, &local->chanctx_list, list)
 		ctx->driver_present = false;
 	mutex_unlock(&local->chanctx_mtx);
-
-	cfg80211_shutdown_all_interfaces(local->hw.wiphy);
 }
 
 static void ieee80211_assign_chanctx(struct ieee80211_local *local,


