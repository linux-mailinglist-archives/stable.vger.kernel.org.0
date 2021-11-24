Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B6645C590
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348988AbhKXN7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:59:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:45364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353037AbhKXN4l (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:56:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6F5863359;
        Wed, 24 Nov 2021 13:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759203;
        bh=bH7CpkY5RxFzbgg8R8BVZ4gOpYbNOmd7T+SjI2STAPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zgGlbIX5Bb5VzjDHpaZeJqskiNRhq3KAxE2spQ/dh0YgZz1uBUcDIFOq7zdapJXnh
         mgyxaInXPEUDIM0n3vWu0L+Nn03A34vS4V7Cwdvp0N0h+4+q629J4qCNwxyvkTul8S
         8bDHBikozqpdtcEcEz+KY6/icQNTbynK4MJmMDgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 166/279] i40e: Fix creation of first queue by omitting it if is not power of two
Date:   Wed, 24 Nov 2021 12:57:33 +0100
Message-Id: <20211124115724.489556155@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

[ Upstream commit 2e6d218c1ec6fb9cd70693b78134cbc35ae0b5a9 ]

Reject TCs creation with proper message if the first queue
assignment is not equal to the power of two.
The first queue number was checked too late in the second queue
iteration, if second queue was configured at all. Now if first queue value
is not a power of two, then trying to create qdisc will be rejected.

Fixes: 8f88b3034db3 ("i40e: Add infrastructure for queue channel support")
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 59 +++++++--------------
 1 file changed, 19 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 42e26ee5b6d5f..83413999902e5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -5786,24 +5786,6 @@ static void i40e_remove_queue_channels(struct i40e_vsi *vsi)
 	INIT_LIST_HEAD(&vsi->ch_list);
 }
 
-/**
- * i40e_is_any_channel - channel exist or not
- * @vsi: ptr to VSI to which channels are associated with
- *
- * Returns true or false if channel(s) exist for associated VSI or not
- **/
-static bool i40e_is_any_channel(struct i40e_vsi *vsi)
-{
-	struct i40e_channel *ch, *ch_tmp;
-
-	list_for_each_entry_safe(ch, ch_tmp, &vsi->ch_list, list) {
-		if (ch->initialized)
-			return true;
-	}
-
-	return false;
-}
-
 /**
  * i40e_get_max_queues_for_channel
  * @vsi: ptr to VSI to which channels are associated with
@@ -6310,26 +6292,15 @@ int i40e_create_queue_channel(struct i40e_vsi *vsi,
 	/* By default we are in VEPA mode, if this is the first VF/VMDq
 	 * VSI to be added switch to VEB mode.
 	 */
-	if ((!(pf->flags & I40E_FLAG_VEB_MODE_ENABLED)) ||
-	    (!i40e_is_any_channel(vsi))) {
-		if (!is_power_of_2(vsi->tc_config.tc_info[0].qcount)) {
-			dev_dbg(&pf->pdev->dev,
-				"Failed to create channel. Override queues (%u) not power of 2\n",
-				vsi->tc_config.tc_info[0].qcount);
-			return -EINVAL;
-		}
 
-		if (!(pf->flags & I40E_FLAG_VEB_MODE_ENABLED)) {
-			pf->flags |= I40E_FLAG_VEB_MODE_ENABLED;
+	if (!(pf->flags & I40E_FLAG_VEB_MODE_ENABLED)) {
+		pf->flags |= I40E_FLAG_VEB_MODE_ENABLED;
 
-			if (vsi->type == I40E_VSI_MAIN) {
-				if (pf->flags & I40E_FLAG_TC_MQPRIO)
-					i40e_do_reset(pf, I40E_PF_RESET_FLAG,
-						      true);
-				else
-					i40e_do_reset_safe(pf,
-							   I40E_PF_RESET_FLAG);
-			}
+		if (vsi->type == I40E_VSI_MAIN) {
+			if (pf->flags & I40E_FLAG_TC_MQPRIO)
+				i40e_do_reset(pf, I40E_PF_RESET_FLAG, true);
+			else
+				i40e_do_reset_safe(pf, I40E_PF_RESET_FLAG);
 		}
 		/* now onwards for main VSI, number of queues will be value
 		 * of TC0's queue count
@@ -7982,12 +7953,20 @@ config_tc:
 			    vsi->seid);
 		need_reset = true;
 		goto exit;
-	} else {
-		dev_info(&vsi->back->pdev->dev,
-			 "Setup channel (id:%u) utilizing num_queues %d\n",
-			 vsi->seid, vsi->tc_config.tc_info[0].qcount);
+	} else if (enabled_tc &&
+		   (!is_power_of_2(vsi->tc_config.tc_info[0].qcount))) {
+		netdev_info(netdev,
+			    "Failed to create channel. Override queues (%u) not power of 2\n",
+			    vsi->tc_config.tc_info[0].qcount);
+		ret = -EINVAL;
+		need_reset = true;
+		goto exit;
 	}
 
+	dev_info(&vsi->back->pdev->dev,
+		 "Setup channel (id:%u) utilizing num_queues %d\n",
+		 vsi->seid, vsi->tc_config.tc_info[0].qcount);
+
 	if (pf->flags & I40E_FLAG_TC_MQPRIO) {
 		if (vsi->mqprio_qopt.max_rate[0]) {
 			u64 max_tx_rate = vsi->mqprio_qopt.max_rate[0];
-- 
2.33.0



