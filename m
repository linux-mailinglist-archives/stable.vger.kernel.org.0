Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F32451F27
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347608AbhKPAha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:45390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344797AbhKOTZa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75E97636CB;
        Mon, 15 Nov 2021 19:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003075;
        bh=+ifzoYYWvN0Eb12KuMcC/f+7bs6eJcLXBeSXdLyVcd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jKUR0PEfYk0aYwSj5y9oO+TOr8D3q1CvyINJl0/krncRmYQE4/3PW7JDkFwABJpEQ
         rzz1onelga2meDeGpsuX8OPeBf/Fv6zfIrU+vOrafICiS9h/kc7r1VZCZrZw+BtD7F
         q+3LPbjr/8+iLQICLgfwHGXdQjIH7qqhoemBro/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brett Creeley <brett.creeley@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 774/917] ice: Fix not stopping Tx queues for VFs
Date:   Mon, 15 Nov 2021 18:04:29 +0100
Message-Id: <20211115165455.187044410@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

[ Upstream commit b385cca47363316c6d9a74ae9db407bbc281f815 ]

When a VF is removed and/or reset its Tx queues need to be
stopped from the PF. This is done by calling the ice_dis_vf_qs()
function, which calls ice_vsi_stop_lan_tx_rings(). Currently
ice_dis_vf_qs() is protected by the VF state bit ICE_VF_STATE_QS_ENA.
Unfortunately, this is causing the Tx queues to not be disabled in some
cases and when the VF tries to re-enable/reconfigure its Tx queues over
virtchnl the op is failing. This is because a VF can be reset and/or
removed before the ICE_VF_STATE_QS_ENA bit is set, but the Tx queues
were already configured via ice_vsi_cfg_single_txq() in the
VIRTCHNL_OP_CONFIG_VSI_QUEUES op. However, the ICE_VF_STATE_QS_ENA bit
is set on a successful VIRTCHNL_OP_ENABLE_QUEUES, which will always
happen after the VIRTCHNL_OP_CONFIG_VSI_QUEUES op.

This was causing the following error message when loading the ice
driver, creating VFs, and modifying VF trust in an endless loop:

[35274.192484] ice 0000:88:00.0: Failed to set LAN Tx queue context, error: ICE_ERR_PARAM
[35274.193074] ice 0000:88:00.0: VF 0 failed opcode 6, retval: -5
[35274.193640] iavf 0000:88:01.0: PF returned error -5 (IAVF_ERR_PARAM) to our request 6

Fix this by always calling ice_dis_vf_qs() and silencing the error
message in ice_vsi_stop_tx_ring() since the calling code ignores the
return anyway. Also, all other places that call ice_vsi_stop_tx_ring()
catch the error, so this doesn't affect those flows since there was no
change to the values the function returns.

Other solutions were considered (i.e. tracking which VF queues had been
"started/configured" in VIRTCHNL_OP_CONFIG_VSI_QUEUES, but it seemed
more complicated than it was worth. This solution also brings in the
chance for other unexpected conditions due to invalid state bit checks.
So, the proposed solution seemed like the best option since there is no
harm in failing to stop Tx queues that were never started.

This issue can be seen using the following commands:

for i in {0..50}; do
        rmmod ice
        modprobe ice

        sleep 1

        echo 1 > /sys/class/net/ens785f0/device/sriov_numvfs
        echo 1 > /sys/class/net/ens785f1/device/sriov_numvfs

        ip link set ens785f1 vf 0 trust on
        ip link set ens785f0 vf 0 trust on

        sleep 2

        echo 0 > /sys/class/net/ens785f0/device/sriov_numvfs
        echo 0 > /sys/class/net/ens785f1/device/sriov_numvfs
        sleep 1
        echo 1 > /sys/class/net/ens785f0/device/sriov_numvfs
        echo 1 > /sys/class/net/ens785f1/device/sriov_numvfs

        ip link set ens785f1 vf 0 trust on
        ip link set ens785f0 vf 0 trust on
done

Fixes: 77ca27c41705 ("ice: add support for virtchnl_queue_select.[tx|rx]_queues bitmap")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_base.c        | 2 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index c36057efc7ae3..f74610442bda7 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -909,7 +909,7 @@ ice_vsi_stop_tx_ring(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
 	} else if (status == ICE_ERR_DOES_NOT_EXIST) {
 		dev_dbg(ice_pf_to_dev(vsi->back), "LAN Tx queues do not exist, nothing to disable\n");
 	} else if (status) {
-		dev_err(ice_pf_to_dev(vsi->back), "Failed to disable LAN Tx queues, error: %s\n",
+		dev_dbg(ice_pf_to_dev(vsi->back), "Failed to disable LAN Tx queues, error: %s\n",
 			ice_stat_str(status));
 		return -ENODEV;
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 9f5da506d8f4b..7e3ae4cc17a39 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -634,8 +634,7 @@ void ice_free_vfs(struct ice_pf *pf)
 
 	/* Avoid wait time by stopping all VFs at the same time */
 	ice_for_each_vf(pf, i)
-		if (test_bit(ICE_VF_STATE_QS_ENA, pf->vf[i].vf_states))
-			ice_dis_vf_qs(&pf->vf[i]);
+		ice_dis_vf_qs(&pf->vf[i]);
 
 	tmp = pf->num_alloc_vfs;
 	pf->num_qps_per_vf = 0;
@@ -1645,8 +1644,7 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 
 	vsi = ice_get_vf_vsi(vf);
 
-	if (test_bit(ICE_VF_STATE_QS_ENA, vf->vf_states))
-		ice_dis_vf_qs(vf);
+	ice_dis_vf_qs(vf);
 
 	/* Call Disable LAN Tx queue AQ whether or not queues are
 	 * enabled. This is needed for successful completion of VFR.
-- 
2.33.0



