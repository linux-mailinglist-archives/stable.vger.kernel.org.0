Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6093450F47E
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245422AbiDZIhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345009AbiDZIgN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:36:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C96E86E04;
        Tue, 26 Apr 2022 01:28:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 929ED617D2;
        Tue, 26 Apr 2022 08:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EAEC385AC;
        Tue, 26 Apr 2022 08:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961738;
        bh=1E4YVsX4sfzbfahEXFBQWmZddIkEUtBXiE74i1htdqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F9RlLq27+LvT/tTacCn/oI6cmC8N3YJFJDE9gjboaFsw1knoCSjmlmze7mytDbkic
         g0ixYMK9aZH3kslAj5MVcOUvLICgz5IIec/sumjWCO/HZvene7fBuHTyjG5rIVLrXy
         /JZXL61Rry/DZm6FGWGWCEUXobXEsqD92dlVITSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dima Ruinskiy <dima.ruinskiy@intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 14/62] igc: Fix infinite loop in release_swfw_sync
Date:   Tue, 26 Apr 2022 10:20:54 +0200
Message-Id: <20220426081737.635922091@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081737.209637816@linuxfoundation.org>
References: <20220426081737.209637816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

[ Upstream commit 907862e9aef75bf89e2b265efcc58870be06081e ]

An infinite loop may occur if we fail to acquire the HW semaphore,
which is needed for resource release.
This will typically happen if the hardware is surprise-removed.
At this stage there is nothing to do, except log an error and quit.

Fixes: c0071c7aa5fe ("igc: Add HW initialization code")
Suggested-by: Dima Ruinskiy <dima.ruinskiy@intel.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_i225.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_i225.c b/drivers/net/ethernet/intel/igc/igc_i225.c
index ed5d09c11c38..79252ca9e213 100644
--- a/drivers/net/ethernet/intel/igc/igc_i225.c
+++ b/drivers/net/ethernet/intel/igc/igc_i225.c
@@ -156,8 +156,15 @@ void igc_release_swfw_sync_i225(struct igc_hw *hw, u16 mask)
 {
 	u32 swfw_sync;
 
-	while (igc_get_hw_semaphore_i225(hw))
-		; /* Empty */
+	/* Releasing the resource requires first getting the HW semaphore.
+	 * If we fail to get the semaphore, there is nothing we can do,
+	 * except log an error and quit. We are not allowed to hang here
+	 * indefinitely, as it may cause denial of service or system crash.
+	 */
+	if (igc_get_hw_semaphore_i225(hw)) {
+		hw_dbg("Failed to release SW_FW_SYNC.\n");
+		return;
+	}
 
 	swfw_sync = rd32(IGC_SW_FW_SYNC);
 	swfw_sync &= ~mask;
-- 
2.35.1



