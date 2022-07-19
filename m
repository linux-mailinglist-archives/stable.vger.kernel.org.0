Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258FB579E0C
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242293AbiGSM5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242173AbiGSM4m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:56:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037089A6B4;
        Tue, 19 Jul 2022 05:22:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91E6361632;
        Tue, 19 Jul 2022 12:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8CCC341C6;
        Tue, 19 Jul 2022 12:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233364;
        bh=921mvB/gIVMmZca84WRSiz80R1gD2ZDb922HQgrDXGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WYqmuqYnktmxrYhdHgNMefnnrGbdQWTw+gIkHkzQid04/RP+Cibk0hYmXVOcHUljJ
         lYvAGBq9Xa4SOTMl3oIPpjyYHgQB02PqtVxpa6NE2Oycxdgw4L949a+esijULWqGO0
         LhzVrmvb5H0SpomWGRxBjt28kCnjeWgek6tQUJU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 5.18 098/231] ice: change devlink code to read NVM in blocks
Date:   Tue, 19 Jul 2022 13:53:03 +0200
Message-Id: <20220719114722.961831691@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>

[ Upstream commit 7b6f9462a3234c35cf808453d39a074a04e71de1 ]

When creating a snapshot of the NVM the driver needs to read the entire
contents from the NVM and store it. The NVM reads are protected by a lock
that is shared between the driver and the firmware.

If the driver takes too long to read the entire NVM (which can happen on
some systems) then the firmware could reclaim the lock and cause subsequent
reads from the driver to fail.

We could fix this by increasing the timeout that we pass to the firmware,
but we could end up in the same situation again if the system is slow.
Instead have the driver break the reading of the NVM into blocks that are
small enough that we have confidence that the read will complete within the
timeout time, but large enough not to cause significant AQ overhead.

Fixes: dce730f17825 ("ice: add a devlink region for dumping NVM contents")
Signed-off-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 59 +++++++++++++-------
 1 file changed, 40 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 4a9de59121d8..31836bbdf813 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -792,6 +792,8 @@ void ice_devlink_destroy_vf_port(struct ice_vf *vf)
 	devlink_port_unregister(devlink_port);
 }
 
+#define ICE_DEVLINK_READ_BLK_SIZE (1024 * 1024)
+
 /**
  * ice_devlink_nvm_snapshot - Capture a snapshot of the NVM flash contents
  * @devlink: the devlink instance
@@ -818,8 +820,9 @@ static int ice_devlink_nvm_snapshot(struct devlink *devlink,
 	struct ice_pf *pf = devlink_priv(devlink);
 	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
-	void *nvm_data;
-	u32 nvm_size;
+	u8 *nvm_data, *tmp, i;
+	u32 nvm_size, left;
+	s8 num_blks;
 	int status;
 
 	nvm_size = hw->flash.flash_size;
@@ -827,26 +830,44 @@ static int ice_devlink_nvm_snapshot(struct devlink *devlink,
 	if (!nvm_data)
 		return -ENOMEM;
 
-	status = ice_acquire_nvm(hw, ICE_RES_READ);
-	if (status) {
-		dev_dbg(dev, "ice_acquire_nvm failed, err %d aq_err %d\n",
-			status, hw->adminq.sq_last_status);
-		NL_SET_ERR_MSG_MOD(extack, "Failed to acquire NVM semaphore");
-		vfree(nvm_data);
-		return status;
-	}
 
-	status = ice_read_flat_nvm(hw, 0, &nvm_size, nvm_data, false);
-	if (status) {
-		dev_dbg(dev, "ice_read_flat_nvm failed after reading %u bytes, err %d aq_err %d\n",
-			nvm_size, status, hw->adminq.sq_last_status);
-		NL_SET_ERR_MSG_MOD(extack, "Failed to read NVM contents");
+	num_blks = DIV_ROUND_UP(nvm_size, ICE_DEVLINK_READ_BLK_SIZE);
+	tmp = nvm_data;
+	left = nvm_size;
+
+	/* Some systems take longer to read the NVM than others which causes the
+	 * FW to reclaim the NVM lock before the entire NVM has been read. Fix
+	 * this by breaking the reads of the NVM into smaller chunks that will
+	 * probably not take as long. This has some overhead since we are
+	 * increasing the number of AQ commands, but it should always work
+	 */
+	for (i = 0; i < num_blks; i++) {
+		u32 read_sz = min_t(u32, ICE_DEVLINK_READ_BLK_SIZE, left);
+
+		status = ice_acquire_nvm(hw, ICE_RES_READ);
+		if (status) {
+			dev_dbg(dev, "ice_acquire_nvm failed, err %d aq_err %d\n",
+				status, hw->adminq.sq_last_status);
+			NL_SET_ERR_MSG_MOD(extack, "Failed to acquire NVM semaphore");
+			vfree(nvm_data);
+			return -EIO;
+		}
+
+		status = ice_read_flat_nvm(hw, i * ICE_DEVLINK_READ_BLK_SIZE,
+					   &read_sz, tmp, false);
+		if (status) {
+			dev_dbg(dev, "ice_read_flat_nvm failed after reading %u bytes, err %d aq_err %d\n",
+				read_sz, status, hw->adminq.sq_last_status);
+			NL_SET_ERR_MSG_MOD(extack, "Failed to read NVM contents");
+			ice_release_nvm(hw);
+			vfree(nvm_data);
+			return -EIO;
+		}
 		ice_release_nvm(hw);
-		vfree(nvm_data);
-		return status;
-	}
 
-	ice_release_nvm(hw);
+		tmp += read_sz;
+		left -= read_sz;
+	}
 
 	*data = nvm_data;
 
-- 
2.35.1



