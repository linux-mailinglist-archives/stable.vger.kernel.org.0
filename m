Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C3E487821
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 14:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347519AbiAGNVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 08:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238705AbiAGNVd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 08:21:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03679C061245
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 05:21:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C21F1B82553
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 13:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1632BC36AE5;
        Fri,  7 Jan 2022 13:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641561690;
        bh=EWrysZOPxOXUCjwMhDrF/CXkHV+2be6kGrpsqLD0mtU=;
        h=Subject:To:Cc:From:Date:From;
        b=jf3vgwHLbgBMPbcFrgx9q0UtPi0yJmbLXd0Pmtsg/DWIgdY+8VrEPTwEX7h1eSz7D
         YoEmM13fesSClOyo9cMsXLlyfsPuJj5yvS3c58UllhKfSqytxZLKr1AuCbgXKzcr7v
         f/gamFYUaw5dWpZKdOSUdl2VEm+oTgDVeWBBVO2g=
Subject: FAILED: patch "[PATCH] iavf: Fix limit of total number of queues to active queues of" failed to apply to 4.19-stable tree
To:     karen.sornek@intel.com, anthony.l.nguyen@intel.com,
        ashwin.vijayavel@intel.com, konrad0.jankowski@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 Jan 2022 14:21:27 +0100
Message-ID: <164156168783230@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b712941c8085e638bb92456e866ed3de4404e3d5 Mon Sep 17 00:00:00 2001
From: Karen Sornek <karen.sornek@intel.com>
Date: Wed, 1 Sep 2021 09:21:46 +0200
Subject: [PATCH] iavf: Fix limit of total number of queues to active queues of
 VF

In the absence of this validation, if the user requests to
configure queues more than the enabled queues, it results in
sending the requested number of queues to the kernel stack
(due to the asynchronous nature of VF response), in which
case the stack might pick a queue to transmit that is not
enabled and result in Tx hang. Fix this bug by
limiting the total number of queues allocated for VF to
active queues of VF.

Fixes: d5b33d024496 ("i40evf: add ndo_setup_tc callback to i40evf")
Signed-off-by: Ashwin Vijayavel <ashwin.vijayavel@intel.com>
Signed-off-by: Karen Sornek <karen.sornek@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 4e7c04047f91..e4439b095533 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2708,8 +2708,11 @@ static int iavf_validate_ch_config(struct iavf_adapter *adapter,
 		total_max_rate += tx_rate;
 		num_qps += mqprio_qopt->qopt.count[i];
 	}
-	if (num_qps > IAVF_MAX_REQ_QUEUES)
+	if (num_qps > adapter->num_active_queues) {
+		dev_err(&adapter->pdev->dev,
+			"Cannot support requested number of queues\n");
 		return -EINVAL;
+	}
 
 	ret = iavf_validate_tx_bandwidth(adapter, total_max_rate);
 	return ret;

