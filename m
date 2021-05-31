Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C073960D4
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbhEaObo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:31:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233993AbhEaO3g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:29:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C54261C2B;
        Mon, 31 May 2021 13:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468916;
        bh=udF61iovPAdU6ur1TYq0jtlIjT3KUEKu/qIh0tV5UYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pIpwXDKs4Sb5sDxWm4Idi7SNhhs69WowucjBTmGqwf8J0j+aMUVbkjplDqsg0/sS2
         ZpNdX1d4xspVSGIGYGTf3LTSGcl/bKGvAyP+PnSyRtwhaQXQmwt2xbaQZW378ACcqP
         QPhyMHIeqVbdnXGwSuq4ktRlGV3xDJqReJ5AEqU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Piotr Skajewski <piotrx.skajewski@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 161/177] ixgbe: fix large MTU request from VF
Date:   Mon, 31 May 2021 15:15:18 +0200
Message-Id: <20210531130653.486039410@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

[ Upstream commit 63e39d29b3da02e901349f6cd71159818a4737a6 ]

Check that the MTU value requested by the VF is in the supported
range of MTUs before attempting to set the VF large packet enable,
otherwise reject the request. This also avoids unnecessary
register updates in the case of the 82599 controller.

Fixes: 872844ddb9e4 ("ixgbe: Enable jumbo frames support w/ SR-IOV")
Co-developed-by: Piotr Skajewski <piotrx.skajewski@intel.com>
Signed-off-by: Piotr Skajewski <piotrx.skajewski@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Co-developed-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index 537dfff585e0..47a920128760 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -467,12 +467,16 @@ static int ixgbe_set_vf_vlan(struct ixgbe_adapter *adapter, int add, int vid,
 	return err;
 }
 
-static s32 ixgbe_set_vf_lpe(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
+static int ixgbe_set_vf_lpe(struct ixgbe_adapter *adapter, u32 max_frame, u32 vf)
 {
 	struct ixgbe_hw *hw = &adapter->hw;
-	int max_frame = msgbuf[1];
 	u32 max_frs;
 
+	if (max_frame < ETH_MIN_MTU || max_frame > IXGBE_MAX_JUMBO_FRAME_SIZE) {
+		e_err(drv, "VF max_frame %d out of range\n", max_frame);
+		return -EINVAL;
+	}
+
 	/*
 	 * For 82599EB we have to keep all PFs and VFs operating with
 	 * the same max_frame value in order to avoid sending an oversize
@@ -533,12 +537,6 @@ static s32 ixgbe_set_vf_lpe(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
 		}
 	}
 
-	/* MTU < 68 is an error and causes problems on some kernels */
-	if (max_frame > IXGBE_MAX_JUMBO_FRAME_SIZE) {
-		e_err(drv, "VF max_frame %d out of range\n", max_frame);
-		return -EINVAL;
-	}
-
 	/* pull current max frame size from hardware */
 	max_frs = IXGBE_READ_REG(hw, IXGBE_MAXFRS);
 	max_frs &= IXGBE_MHADD_MFS_MASK;
@@ -1249,7 +1247,7 @@ static int ixgbe_rcv_msg_from_vf(struct ixgbe_adapter *adapter, u32 vf)
 		retval = ixgbe_set_vf_vlan_msg(adapter, msgbuf, vf);
 		break;
 	case IXGBE_VF_SET_LPE:
-		retval = ixgbe_set_vf_lpe(adapter, msgbuf, vf);
+		retval = ixgbe_set_vf_lpe(adapter, msgbuf[1], vf);
 		break;
 	case IXGBE_VF_SET_MACVLAN:
 		retval = ixgbe_set_vf_macvlan_msg(adapter, msgbuf, vf);
-- 
2.30.2



