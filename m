Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D89845C380
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350461AbhKXNjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:39:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:60380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350333AbhKXNhh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:37:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C39C4630EC;
        Wed, 24 Nov 2021 12:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758540;
        bh=Fedp7YBcSsxKrK4E4w6jwe2FXBoTjJGWEOvxZPK89G4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jSmF7TwpeJakGPlRWWz4dLMspXg7DKHBrtoHJikS5nXzCl01rUIScu0RsU2/qW2NM
         1a65l/wWeqhGSag74tWW4INkYhwpvRnfMwIJ8hW2U0P81DxXBRFuNASj7CfL+k5Lv8
         2rRQ72VEpz8Q8KMz2gmqg/sHiRp5P6ZGmCUY6LyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Eryk Rybak <eryk.roch.rybak@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/154] i40e: Fix changing previously set num_queue_pairs for PFs
Date:   Wed, 24 Nov 2021 12:58:18 +0100
Message-Id: <20211124115705.594288371@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eryk Rybak <eryk.roch.rybak@intel.com>

[ Upstream commit d2a69fefd75683004ffe87166de5635b3267ee07 ]

Currently, the i40e_vsi_setup_queue_map is basing the count of queues in
TCs on a VSI's alloc_queue_pairs member which is not changed throughout
any user's action (for example via ethtool's set_channels callback).

This implies that vsi->tc_config.tc_info[n].qcount value that is given
to the kernel via netdev_set_tc_queue() that notifies about the count of
queues per particular traffic class is constant even if user has changed
the total count of queues.

This in turn caused the kernel warning after setting the queue count to
the lower value than the initial one:

$ ethtool -l ens801f0
Channel parameters for ens801f0:
Pre-set maximums:
RX:             0
TX:             0
Other:          1
Combined:       64
Current hardware settings:
RX:             0
TX:             0
Other:          1
Combined:       64

$ ethtool -L ens801f0 combined 40

[dmesg]
Number of in use tx queues changed invalidating tc mappings. Priority
traffic classification disabled!

Reason was that vsi->alloc_queue_pairs stayed at 64 value which was used
to set the qcount on TC0 (by default only TC0 exists so all of the
existing queues are assigned to TC0). we update the offset/qcount via
netdev_set_tc_queue() back to the old value but then the
netif_set_real_num_tx_queues() is using the vsi->num_queue_pairs as a
value which got set to 40.

Fix it by using vsi->req_queue_pairs as a queue count that will be
distributed across TCs. Do it only for non-zero values, which implies
that user actually requested the new count of queues.

For VSIs other than main, stay with the vsi->alloc_queue_pairs as we
only allow manipulating the queue count on main VSI.

Fixes: bc6d33c8d93f ("i40e: Fix the number of queues available to be mapped for use")
Co-developed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Co-developed-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Eryk Rybak <eryk.roch.rybak@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 35 ++++++++++++++-------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 72405a0aabde7..48856dea512c8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -1789,6 +1789,7 @@ static void i40e_vsi_setup_queue_map(struct i40e_vsi *vsi,
 				     bool is_add)
 {
 	struct i40e_pf *pf = vsi->back;
+	u16 num_tc_qps = 0;
 	u16 sections = 0;
 	u8 netdev_tc = 0;
 	u16 numtc = 1;
@@ -1796,13 +1797,29 @@ static void i40e_vsi_setup_queue_map(struct i40e_vsi *vsi,
 	u8 offset;
 	u16 qmap;
 	int i;
-	u16 num_tc_qps = 0;
 
 	sections = I40E_AQ_VSI_PROP_QUEUE_MAP_VALID;
 	offset = 0;
 
+	if (vsi->type == I40E_VSI_MAIN) {
+		/* This code helps add more queue to the VSI if we have
+		 * more cores than RSS can support, the higher cores will
+		 * be served by ATR or other filters. Furthermore, the
+		 * non-zero req_queue_pairs says that user requested a new
+		 * queue count via ethtool's set_channels, so use this
+		 * value for queues distribution across traffic classes
+		 */
+		if (vsi->req_queue_pairs > 0)
+			vsi->num_queue_pairs = vsi->req_queue_pairs;
+		else if (pf->flags & I40E_FLAG_MSIX_ENABLED)
+			vsi->num_queue_pairs = pf->num_lan_msix;
+	}
+
 	/* Number of queues per enabled TC */
-	num_tc_qps = vsi->alloc_queue_pairs;
+	if (vsi->type == I40E_VSI_MAIN)
+		num_tc_qps = vsi->num_queue_pairs;
+	else
+		num_tc_qps = vsi->alloc_queue_pairs;
 	if (enabled_tc && (vsi->back->flags & I40E_FLAG_DCB_ENABLED)) {
 		/* Find numtc from enabled TC bitmap */
 		for (i = 0, numtc = 0; i < I40E_MAX_TRAFFIC_CLASS; i++) {
@@ -1880,16 +1897,10 @@ static void i40e_vsi_setup_queue_map(struct i40e_vsi *vsi,
 		}
 		ctxt->info.tc_mapping[i] = cpu_to_le16(qmap);
 	}
-
-	/* Set actual Tx/Rx queue pairs */
-	vsi->num_queue_pairs = offset;
-	if ((vsi->type == I40E_VSI_MAIN) && (numtc == 1)) {
-		if (vsi->req_queue_pairs > 0)
-			vsi->num_queue_pairs = vsi->req_queue_pairs;
-		else if (pf->flags & I40E_FLAG_MSIX_ENABLED)
-			vsi->num_queue_pairs = pf->num_lan_msix;
-	}
-
+	/* Do not change previously set num_queue_pairs for PFs */
+	if ((vsi->type == I40E_VSI_MAIN && numtc != 1) ||
+	    vsi->type != I40E_VSI_MAIN)
+		vsi->num_queue_pairs = offset;
 	/* Scheduler section valid can only be set for ADD VSI */
 	if (is_add) {
 		sections |= I40E_AQ_VSI_PROP_SCHED_VALID;
-- 
2.33.0



