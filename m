Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C425F3ED618
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240413AbhHPNQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:16:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240342AbhHPNPM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:15:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A83DE6112D;
        Mon, 16 Aug 2021 13:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119557;
        bh=rx4pw91cp/z+GwPLnPfwVP9fP09/FNWaRcikO0NpLMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OkiBAi3yQIUtNXy0cVQwNXH2p7HYhIr5icqPIinmkg/stavHA7Cir5B2WnERm0fZJ
         V9Ki+PeJdNn341iIAlFY95ctfB18Vy9ncvsQwCvyjTotgyh2NAE2Xtxa8WVT6KM0p0
         RHyTrFa5znXUDhCbSTzZAYRI1FFVDpTKzO3tUBnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 073/151] ice: Stop processing VF messages during teardown
Date:   Mon, 16 Aug 2021 15:01:43 +0200
Message-Id: <20210816125446.483461915@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

[ Upstream commit c503e63200c679e362afca7aca9d3dc63a0f45ed ]

When VFs are setup and torn down in quick succession, it is possible
that a VF is torn down by the PF while the VF's virtchnl requests are
still in the PF's mailbox ring. Processing the VF's virtchnl request
when the VF itself doesn't exist results in undefined behavior. Fix
this by adding a check to stop processing virtchnl requests when VF
teardown is in progress.

Fixes: ddf30f7ff840 ("ice: Add handler to configure SR-IOV")
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice.h             | 1 +
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 2924c67567b8..13ffa3f6a521 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -226,6 +226,7 @@ enum ice_pf_state {
 	ICE_VFLR_EVENT_PENDING,
 	ICE_FLTR_OVERFLOW_PROMISC,
 	ICE_VF_DIS,
+	ICE_VF_DEINIT_IN_PROGRESS,
 	ICE_CFG_BUSY,
 	ICE_SERVICE_SCHED,
 	ICE_SERVICE_DIS,
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 97a46c616aca..671902d9fc35 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -615,6 +615,8 @@ void ice_free_vfs(struct ice_pf *pf)
 	struct ice_hw *hw = &pf->hw;
 	unsigned int tmp, i;
 
+	set_bit(ICE_VF_DEINIT_IN_PROGRESS, pf->state);
+
 	if (!pf->vf)
 		return;
 
@@ -680,6 +682,7 @@ void ice_free_vfs(struct ice_pf *pf)
 				i);
 
 	clear_bit(ICE_VF_DIS, pf->state);
+	clear_bit(ICE_VF_DEINIT_IN_PROGRESS, pf->state);
 	clear_bit(ICE_FLAG_SRIOV_ENA, pf->flags);
 }
 
@@ -4292,6 +4295,10 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 	struct device *dev;
 	int err = 0;
 
+	/* if de-init is underway, don't process messages from VF */
+	if (test_bit(ICE_VF_DEINIT_IN_PROGRESS, pf->state))
+		return;
+
 	dev = ice_pf_to_dev(pf);
 	if (ice_validate_vf_id(pf, vf_id)) {
 		err = -EINVAL;
-- 
2.30.2



