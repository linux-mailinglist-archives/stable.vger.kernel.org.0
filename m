Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB7FB4A4519
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377283AbiAaLge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378604AbiAaLe1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:34:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB17C07979C;
        Mon, 31 Jan 2022 03:23:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCB7D60B28;
        Mon, 31 Jan 2022 11:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21B3C340E8;
        Mon, 31 Jan 2022 11:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628221;
        bh=guVQ+V1aZEpjK3fzuRxBMXzdw9oPOX8He4aeUdYe3vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pHeWJTUgLZMdXvidRgDXRl/hwdQIWMglWwl9OWHUrXveCH9DJp9jghlFmOZpEkD1y
         /T8xnettmA6nSlhDervUxpW2LQJCbbd2UVIjFTlP1auA2XxGZYkQfcFe1TAXscNBp3
         ivpWwkJ/8oUtPchY04FS5GhQYh8PANA8GqJi01Ho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 162/200] ibmvnic: Allow extra failures before disabling
Date:   Mon, 31 Jan 2022 11:57:05 +0100
Message-Id: <20220131105239.005295871@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

[ Upstream commit db9f0e8bf79e6da7068b5818fea0ffd9d0d4b4da ]

If auto-priority-failover (APF) is enabled and there are at least two
backing devices of different priorities, some resets like fail-over,
change-param etc can cause at least two back to back failovers. (Failover
from high priority backing device to lower priority one and then back
to the higher priority one if that is still functional).

Depending on the timimg of the two failovers it is possible to trigger
a "hard" reset and for the hard reset to fail due to failovers. When this
occurs, the driver assumes that the network is unstable and disables the
VNIC for a 60-second "settling time". This in turn can cause the ethtool
command to fail with "No such device" while the vnic automatically recovers
a little while later.

Given that it's possible to have two back to back failures, allow for extra
failures before disabling the vnic for the settling time.

Fixes: f15fde9d47b8 ("ibmvnic: delay next reset if hard reset fails")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 0bb3911dd014d..9b2d16ad76f12 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2598,6 +2598,7 @@ static void __ibmvnic_reset(struct work_struct *work)
 	struct ibmvnic_rwi *rwi;
 	unsigned long flags;
 	u32 reset_state;
+	int num_fails = 0;
 	int rc = 0;
 
 	adapter = container_of(work, struct ibmvnic_adapter, ibmvnic_reset);
@@ -2651,11 +2652,23 @@ static void __ibmvnic_reset(struct work_struct *work)
 				rc = do_hard_reset(adapter, rwi, reset_state);
 				rtnl_unlock();
 			}
-			if (rc) {
-				/* give backing device time to settle down */
+			if (rc)
+				num_fails++;
+			else
+				num_fails = 0;
+
+			/* If auto-priority-failover is enabled we can get
+			 * back to back failovers during resets, resulting
+			 * in at least two failed resets (from high-priority
+			 * backing device to low-priority one and then back)
+			 * If resets continue to fail beyond that, give the
+			 * adapter some time to settle down before retrying.
+			 */
+			if (num_fails >= 3) {
 				netdev_dbg(adapter->netdev,
-					   "[S:%s] Hard reset failed, waiting 60 secs\n",
-					   adapter_state_to_string(adapter->state));
+					   "[S:%s] Hard reset failed %d times, waiting 60 secs\n",
+					   adapter_state_to_string(adapter->state),
+					   num_fails);
 				set_current_state(TASK_UNINTERRUPTIBLE);
 				schedule_timeout(60 * HZ);
 			}
-- 
2.34.1



