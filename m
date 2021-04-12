Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49AB35BF4E
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238745AbhDLJDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:03:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:54824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237704AbhDLJBm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:01:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E665460241;
        Mon, 12 Apr 2021 09:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218025;
        bh=/68vqr8FnoWZIGzu1nMiYubZM/avCAEBOkMNwca8iz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k4c5/3iA7FQB8gaJ/e4y5DMaUXFg4EeIV549UVZbBpM8aYGjmQYoTsdeVMvafmIB0
         gje27UO55YeynUCTNRSGgCOfyfmSxG9ZbO/H/tcflBNx4YEzq7LzXPnXjTEV7exQx4
         R9k2a+40hSSiQSfTceASyHL364Mj/a0vYz2tvZV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Goreczny <krzysztof.goreczny@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.11 042/210] ice: prevent ice_open and ice_stop during reset
Date:   Mon, 12 Apr 2021 10:39:07 +0200
Message-Id: <20210412084017.415235078@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Goreczny <krzysztof.goreczny@intel.com>

commit e95fc8573e07c5e4825df4650fd8b8c93fad27a7 upstream.

There is a possibility of race between ice_open or ice_stop calls
performed by OS and reset handling routine both trying to modify VSI
resources. Observed scenarios:
- reset handler deallocates memory in ice_vsi_free_arrays and ice_open
  tries to access it in ice_vsi_cfg_txq leading to driver crash
- reset handler deallocates memory in ice_vsi_free_arrays and ice_close
  tries to access it in ice_down leading to driver crash
- reset handler clears port scheduler topology and sets port state to
  ICE_SCHED_PORT_STATE_INIT leading to ice_ena_vsi_txq fail in ice_open

To prevent this additional checks in ice_open and ice_stop are
introduced to make sure that OS is not allowed to alter VSI config while
reset is in progress.

Fixes: cdedef59deb0 ("ice: Configure VSIs for Tx/Rx")
Signed-off-by: Krzysztof Goreczny <krzysztof.goreczny@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice.h      |    1 +
 drivers/net/ethernet/intel/ice/ice_lib.c  |    4 ++--
 drivers/net/ethernet/intel/ice/ice_main.c |   28 ++++++++++++++++++++++++++++
 3 files changed, 31 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -604,6 +604,7 @@ int ice_fdir_create_dflt_rules(struct ic
 int ice_aq_wait_for_event(struct ice_pf *pf, u16 opcode, unsigned long timeout,
 			  struct ice_rq_event_info *event);
 int ice_open(struct net_device *netdev);
+int ice_open_internal(struct net_device *netdev);
 int ice_stop(struct net_device *netdev);
 void ice_service_task_schedule(struct ice_pf *pf);
 
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2489,7 +2489,7 @@ int ice_ena_vsi(struct ice_vsi *vsi, boo
 			if (!locked)
 				rtnl_lock();
 
-			err = ice_open(vsi->netdev);
+			err = ice_open_internal(vsi->netdev);
 
 			if (!locked)
 				rtnl_unlock();
@@ -2518,7 +2518,7 @@ void ice_dis_vsi(struct ice_vsi *vsi, bo
 			if (!locked)
 				rtnl_lock();
 
-			ice_stop(vsi->netdev);
+			ice_vsi_close(vsi);
 
 			if (!locked)
 				rtnl_unlock();
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6612,6 +6612,28 @@ static void ice_tx_timeout(struct net_de
 int ice_open(struct net_device *netdev)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_pf *pf = np->vsi->back;
+
+	if (ice_is_reset_in_progress(pf->state)) {
+		netdev_err(netdev, "can't open net device while reset is in progress");
+		return -EBUSY;
+	}
+
+	return ice_open_internal(netdev);
+}
+
+/**
+ * ice_open_internal - Called when a network interface becomes active
+ * @netdev: network interface device structure
+ *
+ * Internal ice_open implementation. Should not be used directly except for ice_open and reset
+ * handling routine
+ *
+ * Returns 0 on success, negative value on failure
+ */
+int ice_open_internal(struct net_device *netdev)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
 	struct ice_port_info *pi;
@@ -6690,6 +6712,12 @@ int ice_stop(struct net_device *netdev)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
+	struct ice_pf *pf = vsi->back;
+
+	if (ice_is_reset_in_progress(pf->state)) {
+		netdev_err(netdev, "can't stop net device while reset is in progress");
+		return -EBUSY;
+	}
 
 	ice_vsi_close(vsi);
 


