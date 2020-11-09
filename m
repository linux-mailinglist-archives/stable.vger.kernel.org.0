Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E262ABA62
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731624AbgKINSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:18:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387711AbgKINSf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:18:35 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C8142076E;
        Mon,  9 Nov 2020 13:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927914;
        bh=F5IN/4wd1UpNG48jBcx9OqBIT0cuMA6+CwFeji68JXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ip/wi3bt3NFmGWv2YRv1W2KPcM78U1bIDdh6ZmtlwSrBV3W/bLwgTDfhUTUQIA4BW
         +BB1SEnLrho6BxfUVWMXqxDlucD8NpLDQNNygjD/4q5X72IHgIvFxxwxpzqtBCfCzH
         Pgk7YBBgD38TNB7npsiFCN/cWSH3UFqq0IUDt1sY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 034/133] powerpc/vnic: Extend "failover pending" window
Date:   Mon,  9 Nov 2020 13:54:56 +0100
Message-Id: <20201109125032.353249166@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

[ Upstream commit 1d8504937478fdc2f3ef2174a816fd3302eca882 ]

Commit 5a18e1e0c193b introduced the 'failover_pending' state to track
the "failover pending window" - where we wait for the partner to become
ready (after a transport event) before actually attempting to failover.
i.e window is between following two events:

        a. we get a transport event due to a FAILOVER

        b. later, we get CRQ_INITIALIZED indicating the partner is
           ready  at which point we schedule a FAILOVER reset.

and ->failover_pending is true during this window.

If during this window, we attempt to open (or close) a device, we pretend
that the operation succeded and let the FAILOVER reset path complete the
operation.

This is fine, except if the transport event ("a" above) occurs during the
open and after open has already checked whether a failover is pending. If
that happens, we fail the open, which can cause the boot scripts to leave
the interface down requiring administrator to manually bring up the device.

This fix "extends" the failover pending window till we are _actually_
ready to perform the failover reset (i.e until after we get the RTNL
lock). Since open() holds the RTNL lock, we can be sure that we either
finish the open or if the open() fails due to the failover pending window,
we can again pretend that open is done and let the failover complete it.

We could try and block the open until failover is completed but a) that
could still timeout the application and b) Existing code "pretends" that
failover occurred "just after" open succeeded, so marks the open successful
and lets the failover complete the open. So, mark the open successful even
if the transport event occurs before we actually start the open.

Fixes: 5a18e1e0c193 ("ibmvnic: Fix failover case for non-redundant configuration")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Acked-by: Dany Madden <drt@linux.ibm.com>
Link: https://lore.kernel.org/r/20201030170711.1562994-1-sukadev@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c |   36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1197,18 +1197,27 @@ static int ibmvnic_open(struct net_devic
 	if (adapter->state != VNIC_CLOSED) {
 		rc = ibmvnic_login(netdev);
 		if (rc)
-			return rc;
+			goto out;
 
 		rc = init_resources(adapter);
 		if (rc) {
 			netdev_err(netdev, "failed to initialize resources\n");
 			release_resources(adapter);
-			return rc;
+			goto out;
 		}
 	}
 
 	rc = __ibmvnic_open(netdev);
 
+out:
+	/*
+	 * If open fails due to a pending failover, set device state and
+	 * return. Device operation will be handled by reset routine.
+	 */
+	if (rc && adapter->failover_pending) {
+		adapter->state = VNIC_OPEN;
+		rc = 0;
+	}
 	return rc;
 }
 
@@ -1935,6 +1944,13 @@ static int do_reset(struct ibmvnic_adapt
 		   rwi->reset_reason);
 
 	rtnl_lock();
+	/*
+	 * Now that we have the rtnl lock, clear any pending failover.
+	 * This will ensure ibmvnic_open() has either completed or will
+	 * block until failover is complete.
+	 */
+	if (rwi->reset_reason == VNIC_RESET_FAILOVER)
+		adapter->failover_pending = false;
 
 	netif_carrier_off(netdev);
 	adapter->reset_reason = rwi->reset_reason;
@@ -2215,6 +2231,13 @@ static void __ibmvnic_reset(struct work_
 			/* CHANGE_PARAM requestor holds rtnl_lock */
 			rc = do_change_param_reset(adapter, rwi, reset_state);
 		} else if (adapter->force_reset_recovery) {
+			/*
+			 * Since we are doing a hard reset now, clear the
+			 * failover_pending flag so we don't ignore any
+			 * future MOBILITY or other resets.
+			 */
+			adapter->failover_pending = false;
+
 			/* Transport event occurred during previous reset */
 			if (adapter->wait_for_reset) {
 				/* Previous was CHANGE_PARAM; caller locked */
@@ -2279,9 +2302,15 @@ static int ibmvnic_reset(struct ibmvnic_
 	unsigned long flags;
 	int ret;
 
+	/*
+	 * If failover is pending don't schedule any other reset.
+	 * Instead let the failover complete. If there is already a
+	 * a failover reset scheduled, we will detect and drop the
+	 * duplicate reset when walking the ->rwi_list below.
+	 */
 	if (adapter->state == VNIC_REMOVING ||
 	    adapter->state == VNIC_REMOVED ||
-	    adapter->failover_pending) {
+	    (adapter->failover_pending && reason != VNIC_RESET_FAILOVER)) {
 		ret = EBUSY;
 		netdev_dbg(netdev, "Adapter removing or pending failover, skipping reset\n");
 		goto err;
@@ -4665,7 +4694,6 @@ static void ibmvnic_handle_crq(union ibm
 		case IBMVNIC_CRQ_INIT:
 			dev_info(dev, "Partner initialized\n");
 			adapter->from_passive_init = true;
-			adapter->failover_pending = false;
 			if (!completion_done(&adapter->init_done)) {
 				complete(&adapter->init_done);
 				adapter->init_done_rc = -EIO;


