Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF1C28B7C9
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389347AbgJLNqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:46:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389818AbgJLNqC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:46:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BA7A2087E;
        Mon, 12 Oct 2020 13:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510362;
        bh=4ZjnxvMP8hOm6gTQz1cTceJlTeZiA8EVUE1QWmTcqvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S3Gjepi7ssUGqX+7JT7reFuLnE/Dcdhm5LMTmuquXg15DoIBNklf4N5hySviNDfrM
         xZveWrZDlXeRDEH+zoiRDazjG1Hms9B7/asrMEc5hUmSPISEgN40CKarTNVa6jHZvC
         3ufUItQbOVQu9PaiC+IMA7TLjeClE8JiqLgk9SS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 067/124] ice: fix memory leak if register_netdev_fails
Date:   Mon, 12 Oct 2020 15:31:11 +0200
Message-Id: <20201012133150.095636950@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 135f4b9e9340dadb78e9737bb4eb9817b9c89dac ]

The ice_setup_pf_sw function can cause a memory leak if register_netdev
fails, due to accidentally failing to free the VSI rings. Fix the memory
leak by using ice_vsi_release, ensuring we actually go through the full
teardown process.

This should be safe even if the netdevice is not registered because we
will have set the netdev pointer to NULL, ensuring ice_vsi_release won't
call unregister_netdev.

An alternative fix would be moving management of the PF VSI netdev into
the main VSI setup code. This is complicated and likely requires
significant refactor in how we manage VSIs

Fixes: 3a858ba392c3 ("ice: Add support for VSI allocation and deallocation")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c  |  6 +++---
 drivers/net/ethernet/intel/ice/ice_lib.h  |  6 ------
 drivers/net/ethernet/intel/ice/ice_main.c | 13 +++----------
 3 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 2e3a39cea2c03..133ba6f08e574 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -240,7 +240,7 @@ static int ice_get_free_slot(void *array, int size, int curr)
  * ice_vsi_delete - delete a VSI from the switch
  * @vsi: pointer to VSI being removed
  */
-void ice_vsi_delete(struct ice_vsi *vsi)
+static void ice_vsi_delete(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf = vsi->back;
 	struct ice_vsi_ctx *ctxt;
@@ -307,7 +307,7 @@ static void ice_vsi_free_arrays(struct ice_vsi *vsi)
  *
  * Returns 0 on success, negative on failure
  */
-int ice_vsi_clear(struct ice_vsi *vsi)
+static int ice_vsi_clear(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf = NULL;
 	struct device *dev;
@@ -557,7 +557,7 @@ static int ice_vsi_get_qs(struct ice_vsi *vsi)
  * ice_vsi_put_qs - Release queues from VSI to PF
  * @vsi: the VSI that is going to release queues
  */
-void ice_vsi_put_qs(struct ice_vsi *vsi)
+static void ice_vsi_put_qs(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf = vsi->back;
 	int i;
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index d80e6afa45112..2954b30e6ec79 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -43,10 +43,6 @@ int ice_cfg_vlan_pruning(struct ice_vsi *vsi, bool ena, bool vlan_promisc);
 
 void ice_cfg_sw_lldp(struct ice_vsi *vsi, bool tx, bool create);
 
-void ice_vsi_delete(struct ice_vsi *vsi);
-
-int ice_vsi_clear(struct ice_vsi *vsi);
-
 #ifdef CONFIG_DCB
 int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8 ena_tc);
 #endif /* CONFIG_DCB */
@@ -77,8 +73,6 @@ bool ice_is_reset_in_progress(unsigned long *state);
 void
 ice_write_qrxflxp_cntxt(struct ice_hw *hw, u16 pf_q, u32 rxdid, u32 prio);
 
-void ice_vsi_put_qs(struct ice_vsi *vsi);
-
 void ice_vsi_dis_irq(struct ice_vsi *vsi);
 
 void ice_vsi_free_irq(struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 4cbd49c87568a..4b52f1dea7f3a 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2605,10 +2605,8 @@ static int ice_setup_pf_sw(struct ice_pf *pf)
 		return -EBUSY;
 
 	vsi = ice_pf_vsi_setup(pf, pf->hw.port_info);
-	if (!vsi) {
-		status = -ENOMEM;
-		goto unroll_vsi_setup;
-	}
+	if (!vsi)
+		return -ENOMEM;
 
 	status = ice_cfg_netdev(vsi);
 	if (status) {
@@ -2655,12 +2653,7 @@ unroll_napi_add:
 	}
 
 unroll_vsi_setup:
-	if (vsi) {
-		ice_vsi_free_q_vectors(vsi);
-		ice_vsi_delete(vsi);
-		ice_vsi_put_qs(vsi);
-		ice_vsi_clear(vsi);
-	}
+	ice_vsi_release(vsi);
 	return status;
 }
 
-- 
2.25.1



