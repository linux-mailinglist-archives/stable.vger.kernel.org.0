Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8141E3CAAB4
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243378AbhGOTPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:15:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242142AbhGOTMu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:12:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 283CC613C0;
        Thu, 15 Jul 2021 19:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376159;
        bh=eGCsxFpG369ra2/yp5FBcSX3MxKYhKaMSefN2aQyDZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D0GIyO4Nqw9qugWT9Gnf1Xtvva+UI2ybXR3zcCSkpk9J3pbPSu2X9XsStk/7PArK2
         Ky/1/M821zKiuO0hB3ol2Fbb//7aecDiam5e7LJXSU+DAnl98U4Rhi5nKnFSIhhPFe
         BNx8Xo5PuSlnvmy9h4bN7hmduf4dALPfA0TO9Mtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 151/266] mac80211: Properly WARN on HW scan before restart
Date:   Thu, 15 Jul 2021 20:38:26 +0200
Message-Id: <20210715182639.956601431@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
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
index f33a3acd7f96..2481bfdfafd0 100644
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



