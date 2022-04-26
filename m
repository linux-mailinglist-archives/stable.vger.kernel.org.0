Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F0450F637
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236497AbiDZIrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347072AbiDZIpq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:45:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB87843AD7;
        Tue, 26 Apr 2022 01:37:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 04B67CE1BC9;
        Tue, 26 Apr 2022 08:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F68C385A0;
        Tue, 26 Apr 2022 08:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962234;
        bh=jESHIf0DUJpfwTSjPeAvmSihahXEUxYM6R7jE+M0Y+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1nQL5YtCsmBzsWMit+yQR3rwoCOnf6R/sna8YBx/5msxl87fLrjhHxwGHqtCx+rvD
         CzYaQv2k87ex04K23b+rtztNu8Tv/BSCdpekeGm4/seGl3ZKH4qAYrxQWwX0w3GE3/
         zgFjXsD+0qWQ40Ll1KE5Q08wHj637GebFPQKLNSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dima Ruinskiy <dima.ruinskiy@intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/124] igc: Fix infinite loop in release_swfw_sync
Date:   Tue, 26 Apr 2022 10:20:30 +0200
Message-Id: <20220426081748.132334626@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
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
index b6807e16eea9..a0e2a404d535 100644
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



