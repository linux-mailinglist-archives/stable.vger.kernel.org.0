Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE8375EA36A
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234423AbiIZLYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238116AbiIZLYL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:24:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 703175D137;
        Mon, 26 Sep 2022 03:40:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E80160AF5;
        Mon, 26 Sep 2022 10:39:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3C0C433C1;
        Mon, 26 Sep 2022 10:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188778;
        bh=R3RI6cq0w+ukOeOITM/rJ0hYlgjqtClrsv5cJfKOpsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hkHP/yLD8u835jXcB6ftfDTjiuE5CSlq+6YqF1kSeqitXM7Beti565wDP4O/iExfD
         QjVlyX0AN485FO9i4ytc5VA39Z3vNe4hx7nIDDiOtjSMYbKGjs3BkACfZQsDcIL9kk
         XDBVMBVWQ+hhNwxQrFdSxl+3tPlNS+eQKVRfWw/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Jaron <michalx.jaron@intel.com>,
        Andrii Staikov <andrii.staikov@intel.com>,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/148] i40e: Fix set max_tx_rate when it is lower than 1 Mbps
Date:   Mon, 26 Sep 2022 12:12:01 +0200
Message-Id: <20220926100759.319758583@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Jaron <michalx.jaron@intel.com>

[ Upstream commit 198eb7e1b81d8ba676d0f4f120c092032ae69a8e ]

While converting max_tx_rate from bytes to Mbps, this value was set to 0,
if the original value was lower than 125000 bytes (1 Mbps). This would
cause no transmission rate limiting to occur. This happened due to lack of
check of max_tx_rate against the 1 Mbps value for max_tx_rate and the
following division by 125000. Fix this issue by adding a helper
i40e_bw_bytes_to_mbits() which sets max_tx_rate to minimum usable value of
50 Mbps, if its value is less than 1 Mbps, otherwise do the required
conversion by dividing by 125000.

Fixes: 5ecae4120a6b ("i40e: Refactor VF BW rate limiting")
Signed-off-by: Michal Jaron <michalx.jaron@intel.com>
Signed-off-by: Andrii Staikov <andrii.staikov@intel.com>
Tested-by: Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 32 +++++++++++++++++----
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index ce6eea7a6002..5922520fdb01 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -5766,6 +5766,26 @@ static int i40e_get_link_speed(struct i40e_vsi *vsi)
 	}
 }
 
+/**
+ * i40e_bw_bytes_to_mbits - Convert max_tx_rate from bytes to mbits
+ * @vsi: Pointer to vsi structure
+ * @max_tx_rate: max TX rate in bytes to be converted into Mbits
+ *
+ * Helper function to convert units before send to set BW limit
+ **/
+static u64 i40e_bw_bytes_to_mbits(struct i40e_vsi *vsi, u64 max_tx_rate)
+{
+	if (max_tx_rate < I40E_BW_MBPS_DIVISOR) {
+		dev_warn(&vsi->back->pdev->dev,
+			 "Setting max tx rate to minimum usable value of 50Mbps.\n");
+		max_tx_rate = I40E_BW_CREDIT_DIVISOR;
+	} else {
+		do_div(max_tx_rate, I40E_BW_MBPS_DIVISOR);
+	}
+
+	return max_tx_rate;
+}
+
 /**
  * i40e_set_bw_limit - setup BW limit for Tx traffic based on max_tx_rate
  * @vsi: VSI to be configured
@@ -5788,10 +5808,10 @@ int i40e_set_bw_limit(struct i40e_vsi *vsi, u16 seid, u64 max_tx_rate)
 			max_tx_rate, seid);
 		return -EINVAL;
 	}
-	if (max_tx_rate && max_tx_rate < 50) {
+	if (max_tx_rate && max_tx_rate < I40E_BW_CREDIT_DIVISOR) {
 		dev_warn(&pf->pdev->dev,
 			 "Setting max tx rate to minimum usable value of 50Mbps.\n");
-		max_tx_rate = 50;
+		max_tx_rate = I40E_BW_CREDIT_DIVISOR;
 	}
 
 	/* Tx rate credits are in values of 50Mbps, 0 is disabled */
@@ -8082,9 +8102,9 @@ static int i40e_setup_tc(struct net_device *netdev, void *type_data)
 
 	if (i40e_is_tc_mqprio_enabled(pf)) {
 		if (vsi->mqprio_qopt.max_rate[0]) {
-			u64 max_tx_rate = vsi->mqprio_qopt.max_rate[0];
+			u64 max_tx_rate = i40e_bw_bytes_to_mbits(vsi,
+						  vsi->mqprio_qopt.max_rate[0]);
 
-			do_div(max_tx_rate, I40E_BW_MBPS_DIVISOR);
 			ret = i40e_set_bw_limit(vsi, vsi->seid, max_tx_rate);
 			if (!ret) {
 				u64 credits = max_tx_rate;
@@ -10829,10 +10849,10 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 	}
 
 	if (vsi->mqprio_qopt.max_rate[0]) {
-		u64 max_tx_rate = vsi->mqprio_qopt.max_rate[0];
+		u64 max_tx_rate = i40e_bw_bytes_to_mbits(vsi,
+						  vsi->mqprio_qopt.max_rate[0]);
 		u64 credits = 0;
 
-		do_div(max_tx_rate, I40E_BW_MBPS_DIVISOR);
 		ret = i40e_set_bw_limit(vsi, vsi->seid, max_tx_rate);
 		if (ret)
 			goto end_unlock;
-- 
2.35.1



