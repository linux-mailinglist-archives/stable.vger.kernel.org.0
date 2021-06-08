Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F763A031F
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237746AbhFHTNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:13:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235628AbhFHTK7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:10:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40B1C61946;
        Tue,  8 Jun 2021 18:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178128;
        bh=Dp1EPiip/BTr/HItxcE1JOOTWQBE6o2x3mvbNoE5kpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YDVRhud1LMpoVbc661pqP/eJ6/zYDmoqEWO+zmyu1/FCGKIGtZeJd5T95njTQ5r9e
         d4H8Jx+nP0btWmOQcX0WW0aBhTXqFWuo48UA6mVNZV1Pyp7ozCe1wt8EoDEcFR3kcn
         LqasNRril6FdiWaKGmZ2XGB3/nmnmfSJtskQhmg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brett Creeley <brett.creeley@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 053/161] ice: Fix VFR issues for AVF drivers that expect ATQLEN cleared
Date:   Tue,  8 Jun 2021 20:26:23 +0200
Message-Id: <20210608175947.261433049@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

[ Upstream commit 8679f07a9922068b9b6be81b632f52cac45d1b91 ]

Some AVF drivers expect the VF_MBX_ATQLEN register to be cleared for any
type of VFR/VFLR. Fix this by clearing the VF_MBX_ATQLEN register at the
same time as VF_MBX_ARQLEN.

Fixes: 82ba01282cf8 ("ice: clear VF ARQLEN register on reset")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h  |  1 +
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 12 +++++++-----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 093a1818a392..1998821896c0 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -31,6 +31,7 @@
 #define PF_FW_ATQLEN_ATQOVFL_M			BIT(29)
 #define PF_FW_ATQLEN_ATQCRIT_M			BIT(30)
 #define VF_MBX_ARQLEN(_VF)			(0x0022BC00 + ((_VF) * 4))
+#define VF_MBX_ATQLEN(_VF)			(0x0022A800 + ((_VF) * 4))
 #define PF_FW_ATQLEN_ATQENABLE_M		BIT(31)
 #define PF_FW_ATQT				0x00080400
 #define PF_MBX_ARQBAH				0x0022E400
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 1f38a8d0c525..0f2a4d48574e 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -435,13 +435,15 @@ static void ice_trigger_vf_reset(struct ice_vf *vf, bool is_vflr, bool is_pfr)
 	 */
 	clear_bit(ICE_VF_STATE_INIT, vf->vf_states);
 
-	/* VF_MBX_ARQLEN is cleared by PFR, so the driver needs to clear it
-	 * in the case of VFR. If this is done for PFR, it can mess up VF
-	 * resets because the VF driver may already have started cleanup
-	 * by the time we get here.
+	/* VF_MBX_ARQLEN and VF_MBX_ATQLEN are cleared by PFR, so the driver
+	 * needs to clear them in the case of VFR/VFLR. If this is done for
+	 * PFR, it can mess up VF resets because the VF driver may already
+	 * have started cleanup by the time we get here.
 	 */
-	if (!is_pfr)
+	if (!is_pfr) {
 		wr32(hw, VF_MBX_ARQLEN(vf->vf_id), 0);
+		wr32(hw, VF_MBX_ATQLEN(vf->vf_id), 0);
+	}
 
 	/* In the case of a VFLR, the HW has already reset the VF and we
 	 * just need to clean up, so don't hit the VFRTRIG register.
-- 
2.30.2



