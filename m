Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127F645C5C2
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355915AbhKXOAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:00:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:47006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355595AbhKXN6f (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:58:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8BD2633AB;
        Wed, 24 Nov 2021 13:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759295;
        bh=I3px0ThtByVFUoyLgYEukj5MNt/+zgZPoCr2cfEGi1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZSjyMWSvofzbs2S1zGFU64peuj0QSTCxAjz9RR+W3NcOA0IDLn0R0DJY8rCIsxNK
         jYCZOpwJQzQlT3D+K+Y5ThQbs6aIfuZt3WzO4XbZpwdgE63uIsvFxCZ6SjwRdS44wi
         dLFiXr3ougwERkR/3To/Boxk87CFDMvXGKT3A7kw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Michal Maloszewski <michal.maloszewski@intel.com>,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Witold Fijalkowski <witoldx.fijalkowski@intel.com>,
        Jaroslaw Gawin <jaroslawx.gawin@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 161/279] i40e: Fix NULL ptr dereference on VSI filter sync
Date:   Wed, 24 Nov 2021 12:57:28 +0100
Message-Id: <20211124115724.331795155@linuxfoundation.org>
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

From: Michal Maloszewski <michal.maloszewski@intel.com>

[ Upstream commit 37d9e304acd903a445df8208b8a13d707902dea6 ]

Remove the reason of null pointer dereference in sync VSI filters.
Added new I40E_VSI_RELEASING flag to signalize deleting and releasing
of VSI resources to sync this thread with sync filters subtask.
Without this patch it is possible to start update the VSI filter list
after VSI is removed, that's causing a kernel oops.

Fixes: 41c445ff0f48 ("i40e: main driver core")
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Michal Maloszewski <michal.maloszewski@intel.com>
Reviewed-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Reviewed-by: Witold Fijalkowski <witoldx.fijalkowski@intel.com>
Reviewed-by: Jaroslaw Gawin <jaroslawx.gawin@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e.h      | 1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 39fb3d57c0574..d7db443abeafa 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -161,6 +161,7 @@ enum i40e_vsi_state_t {
 	__I40E_VSI_OVERFLOW_PROMISC,
 	__I40E_VSI_REINIT_REQUESTED,
 	__I40E_VSI_DOWN_REQUESTED,
+	__I40E_VSI_RELEASING,
 	/* This must be last as it determines the size of the BITMAP */
 	__I40E_VSI_STATE_SIZE__,
 };
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index e04b540cedc85..9777fa3535830 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -2623,7 +2623,8 @@ static void i40e_sync_filters_subtask(struct i40e_pf *pf)
 
 	for (v = 0; v < pf->num_alloc_vsi; v++) {
 		if (pf->vsi[v] &&
-		    (pf->vsi[v]->flags & I40E_VSI_FLAG_FILTER_CHANGED)) {
+		    (pf->vsi[v]->flags & I40E_VSI_FLAG_FILTER_CHANGED) &&
+		    !test_bit(__I40E_VSI_RELEASING, pf->vsi[v]->state)) {
 			int ret = i40e_sync_vsi_filters(pf->vsi[v]);
 
 			if (ret) {
@@ -13771,7 +13772,7 @@ int i40e_vsi_release(struct i40e_vsi *vsi)
 		dev_info(&pf->pdev->dev, "Can't remove PF VSI\n");
 		return -ENODEV;
 	}
-
+	set_bit(__I40E_VSI_RELEASING, vsi->state);
 	uplink_seid = vsi->uplink_seid;
 	if (vsi->type != I40E_VSI_SRIOV) {
 		if (vsi->netdev_registered) {
-- 
2.33.0



