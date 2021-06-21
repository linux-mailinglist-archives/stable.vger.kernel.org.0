Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F18C3AF094
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbhFUQub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:50:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232878AbhFUQs0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:48:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A760F61261;
        Mon, 21 Jun 2021 16:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293249;
        bh=5llupwawFWCcgtuCEhELqDzb0ymnrs9wODIqXwN9DbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VYS/TNgIe9/CwvDiddvwPGNQItLIRmmHj7S4NF2V1JeJJP5qmblTuqlPcvV5Z8WbT
         7JdvM4w30UtuvwUeIo84o/Uu8W/YW63UfzEyCwmv2I1+BRS54K/gjQCA2p2Dpdkj6x
         RHBrwF4ULS/B/3CSL3CLDvMyYeCFQAuwDDN6JLcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.12 153/178] mac80211: fix reset debugfs locking
Date:   Mon, 21 Jun 2021 18:16:07 +0200
Message-Id: <20210621154927.965366135@linuxfoundation.org>
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

commit adaed1b9daf5a045be71e923e04b5069d2bee664 upstream.

cfg80211 now calls suspend/resume with the wiphy lock
held, and while there's a problem with that needing
to be fixed, we should do the same in debugfs.

Cc: stable@vger.kernel.org
Fixes: a05829a7222e ("cfg80211: avoid holding the RTNL when calling the driver")
Link: https://lore.kernel.org/r/20210608113226.14020430e449.I78e19db0a55a8295a376e15ac4cf77dbb4c6fb51@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/debugfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -4,7 +4,7 @@
  *
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright (C) 2018 - 2019 Intel Corporation
+ * Copyright (C) 2018 - 2019, 2021 Intel Corporation
  */
 
 #include <linux/debugfs.h>
@@ -389,8 +389,10 @@ static ssize_t reset_write(struct file *
 	struct ieee80211_local *local = file->private_data;
 
 	rtnl_lock();
+	wiphy_lock(local->hw.wiphy);
 	__ieee80211_suspend(&local->hw, NULL);
 	__ieee80211_resume(&local->hw);
+	wiphy_unlock(local->hw.wiphy);
 	rtnl_unlock();
 
 	return count;


