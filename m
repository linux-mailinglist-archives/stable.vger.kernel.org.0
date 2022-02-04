Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22F904A954E
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 09:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352704AbiBDIkE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 03:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357148AbiBDIkB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 03:40:01 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC35C06173D
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 00:40:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 946BECE21D8
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 08:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E44C004E1;
        Fri,  4 Feb 2022 08:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643963998;
        bh=Emcl7/F0Kwx1ILxcnnyxPyv0mK7UPL7P8Rx57w28yJg=;
        h=Subject:To:Cc:From:Date:From;
        b=a2FazNUgaosLmybTTEbf+MpcS2t/skgaBNWARmr8AT5da1cyEDi1hlEcQ6tYQLG1+
         GJdFadqAZ2E0XflNwsIE79sODONUWkNlb6Rh82KC6/n+RAXqLTZUqI+eCTiOuEeSRq
         Ar9FjdsjjQgpU8ePDyakTOOh8ix5t8Yb/KFypNpE=
Subject: FAILED: patch "[PATCH] i40e: Fix reset bw limit when DCB enabled with 1 TC" failed to apply to 5.4-stable tree
To:     jedrzej.jagielski@intel.com, alexandr.lobakin@intel.com,
        anthony.l.nguyen@intel.com, imam.hassan.reza.biswas@intel.com,
        sylwesterx.dziedziuch@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Feb 2022 09:39:46 +0100
Message-ID: <1643963986198236@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3d2504663c41104b4359a15f35670cfa82de1bbf Mon Sep 17 00:00:00 2001
From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Date: Tue, 14 Dec 2021 10:08:22 +0000
Subject: [PATCH] i40e: Fix reset bw limit when DCB enabled with 1 TC

There was an AQ error I40E_AQ_RC_EINVAL when trying
to reset bw limit as part of bw allocation setup.
This was caused by trying to reset bw limit with
DCB enabled. Bw limit should not be reset when
DCB is enabled. The code was relying on the pf->flags
to check if DCB is enabled but if only 1 TC is available
this flag will not be set even though DCB is enabled.
Add a check for number of TC and if it is 1
don't try to reset bw limit even if pf->flags shows
DCB as disabled.

Fixes: fa38e30ac73f ("i40e: Fix for Tx timeouts when interface is brought up if DCB is enabled")
Suggested-by: Alexander Lobakin <alexandr.lobakin@intel.com> # Flatten the condition
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Tested-by: Imam Hassan Reza Biswas <imam.hassan.reza.biswas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index f70c478dafdb..5cb4dc69fe87 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -5372,7 +5372,15 @@ static int i40e_vsi_configure_bw_alloc(struct i40e_vsi *vsi, u8 enabled_tc,
 	/* There is no need to reset BW when mqprio mode is on.  */
 	if (pf->flags & I40E_FLAG_TC_MQPRIO)
 		return 0;
-	if (!vsi->mqprio_qopt.qopt.hw && !(pf->flags & I40E_FLAG_DCB_ENABLED)) {
+
+	if (!vsi->mqprio_qopt.qopt.hw) {
+		if (pf->flags & I40E_FLAG_DCB_ENABLED)
+			goto skip_reset;
+
+		if (IS_ENABLED(CONFIG_I40E_DCB) &&
+		    i40e_dcb_hw_get_num_tc(&pf->hw) == 1)
+			goto skip_reset;
+
 		ret = i40e_set_bw_limit(vsi, vsi->seid, 0);
 		if (ret)
 			dev_info(&pf->pdev->dev,
@@ -5380,6 +5388,8 @@ static int i40e_vsi_configure_bw_alloc(struct i40e_vsi *vsi, u8 enabled_tc,
 				 vsi->seid);
 		return ret;
 	}
+
+skip_reset:
 	memset(&bw_data, 0, sizeof(bw_data));
 	bw_data.tc_valid_bits = enabled_tc;
 	for (i = 0; i < I40E_MAX_TRAFFIC_CLASS; i++)

