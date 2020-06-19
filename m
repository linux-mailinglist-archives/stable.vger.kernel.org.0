Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61CEE2011D6
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405250AbgFSPqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:46:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393323AbgFSP04 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:26:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BB3820734;
        Fri, 19 Jun 2020 15:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580416;
        bh=6fIE5Hz8OMymYYjrHzCdvXBjcqLLwBhH7L5RJjvcvQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DFZPE4k92v0YPHCeH1W0i1itz2VXMYRAsR939ksWTgqWubmkK13rte1ulMruKoCpe
         bu3RHbhjF1/UM4rfJQ8uN4PgM0i4PluuS7brbojFadinYzWDryMAK5NSa7lYGohVvQ
         apdtXH1CyIHr4aJ0T4muimOy+ZcQ0ow8vqZ0lH3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brett Creeley <brett.creeley@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 213/376] ice: Fix Tx timeout when link is toggled on a VFs interface
Date:   Fri, 19 Jun 2020 16:32:11 +0200
Message-Id: <20200619141720.418674750@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

[ Upstream commit 4dc926d3a59e73b8c4adf51b261f1a1bbd48a989 ]

Currently if the iavf is loaded and a VF link transitions from up to
down to up again a Tx timeout will be triggered. This happens because
Tx/Rx queue interrupts are only enabled when receiving the
VIRTCHNL_OP_CONFIG_MAP_IRQ message, which happens on reset or initial
iavf driver load, but not when bringing link up. This is problematic
because they are disabled on the VIRTCHNL_OP_DISABLE_QUEUES message,
which is part of bringing a VF's link down. However, they are not
enabled on the VIRTCHNL_OP_ENABLE_QUEUES message, which is part of
bringing a VF's link up.

Fix this by re-enabling the VF's Rx and Tx queue interrupts when they
were previously configured. This is done by first checking to make
sure the previous value in QINT_[R|T]QCTL.MSIX_INDX is not 0, which
is used to represent the OICR in the VF's interrupt space. If the
MSIX_INDX is non-zero then enable the interrupt by setting the
QINT_[R|T]CTL.CAUSE_ENA bit to 1.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 48 +++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index c9c281167873..f1fdb4d4c826 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -2118,6 +2118,52 @@ static bool ice_vc_validate_vqs_bitmaps(struct virtchnl_queue_select *vqs)
 	return true;
 }
 
+/**
+ * ice_vf_ena_txq_interrupt - enable Tx queue interrupt via QINT_TQCTL
+ * @vsi: VSI of the VF to configure
+ * @q_idx: VF queue index used to determine the queue in the PF's space
+ */
+static void ice_vf_ena_txq_interrupt(struct ice_vsi *vsi, u32 q_idx)
+{
+	struct ice_hw *hw = &vsi->back->hw;
+	u32 pfq = vsi->txq_map[q_idx];
+	u32 reg;
+
+	reg = rd32(hw, QINT_TQCTL(pfq));
+
+	/* MSI-X index 0 in the VF's space is always for the OICR, which means
+	 * this is most likely a poll mode VF driver, so don't enable an
+	 * interrupt that was never configured via VIRTCHNL_OP_CONFIG_IRQ_MAP
+	 */
+	if (!(reg & QINT_TQCTL_MSIX_INDX_M))
+		return;
+
+	wr32(hw, QINT_TQCTL(pfq), reg | QINT_TQCTL_CAUSE_ENA_M);
+}
+
+/**
+ * ice_vf_ena_rxq_interrupt - enable Tx queue interrupt via QINT_RQCTL
+ * @vsi: VSI of the VF to configure
+ * @q_idx: VF queue index used to determine the queue in the PF's space
+ */
+static void ice_vf_ena_rxq_interrupt(struct ice_vsi *vsi, u32 q_idx)
+{
+	struct ice_hw *hw = &vsi->back->hw;
+	u32 pfq = vsi->rxq_map[q_idx];
+	u32 reg;
+
+	reg = rd32(hw, QINT_RQCTL(pfq));
+
+	/* MSI-X index 0 in the VF's space is always for the OICR, which means
+	 * this is most likely a poll mode VF driver, so don't enable an
+	 * interrupt that was never configured via VIRTCHNL_OP_CONFIG_IRQ_MAP
+	 */
+	if (!(reg & QINT_RQCTL_MSIX_INDX_M))
+		return;
+
+	wr32(hw, QINT_RQCTL(pfq), reg | QINT_RQCTL_CAUSE_ENA_M);
+}
+
 /**
  * ice_vc_ena_qs_msg
  * @vf: pointer to the VF info
@@ -2178,6 +2224,7 @@ static int ice_vc_ena_qs_msg(struct ice_vf *vf, u8 *msg)
 			goto error_param;
 		}
 
+		ice_vf_ena_rxq_interrupt(vsi, vf_q_id);
 		set_bit(vf_q_id, vf->rxq_ena);
 	}
 
@@ -2193,6 +2240,7 @@ static int ice_vc_ena_qs_msg(struct ice_vf *vf, u8 *msg)
 		if (test_bit(vf_q_id, vf->txq_ena))
 			continue;
 
+		ice_vf_ena_txq_interrupt(vsi, vf_q_id);
 		set_bit(vf_q_id, vf->txq_ena);
 	}
 
-- 
2.25.1



