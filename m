Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F764B4B86
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346361AbiBNKSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:18:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346795AbiBNKQC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:16:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D480C79C57;
        Mon, 14 Feb 2022 01:53:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0244A60DFE;
        Mon, 14 Feb 2022 09:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0378C340E9;
        Mon, 14 Feb 2022 09:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832392;
        bh=XqiW59tqA5tURicwKmtRFK/00GoJ67mH+dt7Y8YvL9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CPvo7umNs2LkeQMJGpP003qK/b/h6YLAW7GiJue5301ZHj0lXoUELErr4f6TiuKjR
         dWPQ/48T4y1A/NST8q/pLlRoV4OoJpqPx9nk9SGAKgM91B8insEA34sqs7dBbUC45M
         LiedlU8GKOGjb2pE1Tem7hBf/HzbiWvNUlwT/NvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Ertman <david.m.ertman@intel.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Sunitha Mekala <sunithax.d.mekala@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/172] ice: Fix KASAN error in LAG NETDEV_UNREGISTER handler
Date:   Mon, 14 Feb 2022 10:26:28 +0100
Message-Id: <20220214092510.898803862@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

[ Upstream commit bea1898f65b9b7096cb4e73e97c83b94718f1fa1 ]

Currently, the same handler is called for both a NETDEV_BONDING_INFO
LAG unlink notification as for a NETDEV_UNREGISTER call.  This is
causing a problem though, since the netdev_notifier_info passed has
a different structure depending on which event is passed.  The problem
manifests as a call trace from a BUG: KASAN stack-out-of-bounds error.

Fix this by creating a handler specific to NETDEV_UNREGISTER that only
is passed valid elements in the netdev_notifier_info struct for the
NETDEV_UNREGISTER event.

Also included is the removal of an unbalanced dev_put on the peer_netdev
and related braces.

Fixes: 6a8b357278f5 ("ice: Respond to a NETDEV_UNREGISTER event for LAG")
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Acked-by: Jonathan Toppins <jtoppins@redhat.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lag.c | 34 +++++++++++++++++++-----
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lag.c b/drivers/net/ethernet/intel/ice/ice_lag.c
index e375ac849aecd..4f954db01b929 100644
--- a/drivers/net/ethernet/intel/ice/ice_lag.c
+++ b/drivers/net/ethernet/intel/ice/ice_lag.c
@@ -204,17 +204,39 @@ ice_lag_unlink(struct ice_lag *lag,
 		lag->upper_netdev = NULL;
 	}
 
-	if (lag->peer_netdev) {
-		dev_put(lag->peer_netdev);
-		lag->peer_netdev = NULL;
-	}
-
+	lag->peer_netdev = NULL;
 	ice_set_sriov_cap(pf);
 	ice_set_rdma_cap(pf);
 	lag->bonded = false;
 	lag->role = ICE_LAG_NONE;
 }
 
+/**
+ * ice_lag_unregister - handle netdev unregister events
+ * @lag: LAG info struct
+ * @netdev: netdev reporting the event
+ */
+static void ice_lag_unregister(struct ice_lag *lag, struct net_device *netdev)
+{
+	struct ice_pf *pf = lag->pf;
+
+	/* check to see if this event is for this netdev
+	 * check that we are in an aggregate
+	 */
+	if (netdev != lag->netdev || !lag->bonded)
+		return;
+
+	if (lag->upper_netdev) {
+		dev_put(lag->upper_netdev);
+		lag->upper_netdev = NULL;
+		ice_set_sriov_cap(pf);
+		ice_set_rdma_cap(pf);
+	}
+	/* perform some cleanup in case we come back */
+	lag->bonded = false;
+	lag->role = ICE_LAG_NONE;
+}
+
 /**
  * ice_lag_changeupper_event - handle LAG changeupper event
  * @lag: LAG info struct
@@ -307,7 +329,7 @@ ice_lag_event_handler(struct notifier_block *notif_blk, unsigned long event,
 		ice_lag_info_event(lag, ptr);
 		break;
 	case NETDEV_UNREGISTER:
-		ice_lag_unlink(lag, ptr);
+		ice_lag_unregister(lag, netdev);
 		break;
 	default:
 		break;
-- 
2.34.1



