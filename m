Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33DC3CA8FE
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242088AbhGOTFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:05:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242930AbhGOTC1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:02:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C319E613D6;
        Thu, 15 Jul 2021 18:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375534;
        bh=i9LbO88BQlRz9UewtnHD4ToRZXkZ1jIba8GKpBuY0pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yKcVinasdrnJRpf43vq0Nf7QjdmNI1sMZLbovtVeRwxFwy327MKUSdJc6F2PHkycK
         FzykDv6/nI/vzL/C3un5S6p+Mfu6gV2B95NmxQWe2hArMqNOt+RPoinn6QJu0a000s
         6MAkdLoOeM7k3GUEfeGa+v1h6Qzgym5Kxlr+C19o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 129/242] mac80211: Properly WARN on HW scan before restart
Date:   Thu, 15 Jul 2021 20:38:11 +0200
Message-Id: <20210715182615.746927819@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 45daaa1318410794de956fb8e9d06aed2dbb23d0 ]

The following race was possible:

1. The device driver requests HW restart.
2. A scan is requested from user space and is propagated
   to the driver. During this flow HW_SCANNING flag is set.
3. The thread that handles the HW restart is scheduled,
   and before starting the actual reconfiguration it
   checks that HW_SCANNING is not set. The flow does so
   without acquiring any lock, and thus the WARN fires.

Fix this by checking that HW_SCANNING is on only after RTNL is
acquired, i.e., user space scan request handling is no longer
in transit.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210618133832.8238ab3e19ab.I2693c581c70251472b4f9089e37e06fb2c18268f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 9dd741b68f26..937a024a13e2 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -257,14 +257,13 @@ static void ieee80211_restart_work(struct work_struct *work)
 	/* wait for scan work complete */
 	flush_workqueue(local->workqueue);
 	flush_work(&local->sched_scan_stopped_work);
+	flush_work(&local->radar_detected_work);
+
+	rtnl_lock();
 
 	WARN(test_bit(SCAN_HW_SCANNING, &local->scanning),
 	     "%s called with hardware scan in progress\n", __func__);
 
-	flush_work(&local->radar_detected_work);
-	/* we might do interface manipulations, so need both */
-	rtnl_lock();
-	wiphy_lock(local->hw.wiphy);
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		/*
 		 * XXX: there may be more work for other vif types and even
-- 
2.30.2



