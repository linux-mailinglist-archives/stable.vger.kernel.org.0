Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B7C59A0CA
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351931AbiHSQSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352112AbiHSQPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:15:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52C2D9E82;
        Fri, 19 Aug 2022 08:58:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2538FB827F8;
        Fri, 19 Aug 2022 15:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8064DC433D6;
        Fri, 19 Aug 2022 15:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924722;
        bh=QMKF5bVMRZVUpXJgjMojWLmnupfyRAt7kEv0D6rMuNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wdRCN+pPTub35mEeey3g8sw09Lw6YBMy9h+c6K0niYNR7IhnPTSvUvQXfzIIPBSBv
         lg7lZCT0H28DeYSVc8x9v/xcjDMzZ+KvWa9QqAMvPRdLcDL+1/vX7wDhogSe7DiO2P
         YkGDb1sXncD9vPNC5QKjq57YsSbndbcZ7xuk1wa4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Jun Zhang <xuejun.zhang@intel.com>,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 262/545] iavf: Fix max_rate limiting
Date:   Fri, 19 Aug 2022 17:40:32 +0200
Message-Id: <20220819153841.059890609@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

[ Upstream commit ec60d54cb9a3d43a02c5612a03093c18233e6601 ]

Fix max_rate option in TC, check for proper quanta boundaries.
Check for minimum value provided and if it fits expected 50Mbps
quanta.

Without this patch, iavf could send settings for max_rate limiting
that would be accepted from by PF even the max_rate option is less
than expected 50Mbps quanta. It results in no rate limiting
on traffic as rate limiting will be floored to 0.

Example:
tc qdisc add dev $vf root mqprio num_tc 3 map 0 2 1 queues \
2@0 2@2 2@4 hw 1 mode channel shaper bw_rlimit \
max_rate 50Mbps 500Mbps 500Mbps

Should limit TC0 to circa 50 Mbps

tc qdisc add dev $vf root mqprio num_tc 3 map 0 2 1 queues \
2@0 2@2 2@4 hw 1 mode channel shaper bw_rlimit \
max_rate 0Mbps 100Kbit 500Mbps

Should return error

Fixes: d5b33d024496 ("i40evf: add ndo_setup_tc callback to i40evf")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Jun Zhang <xuejun.zhang@intel.com>
Tested-by: Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf.h      |  1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c | 25 +++++++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index ce1e2fb22e09..a994a2970ab2 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -86,6 +86,7 @@ struct iavf_vsi {
 #define IAVF_HKEY_ARRAY_SIZE ((IAVF_VFQF_HKEY_MAX_INDEX + 1) * 4)
 #define IAVF_HLUT_ARRAY_SIZE ((IAVF_VFQF_HLUT_MAX_INDEX + 1) * 4)
 #define IAVF_MBPS_DIVISOR	125000 /* divisor to convert to Mbps */
+#define IAVF_MBPS_QUANTA	50
 
 #define IAVF_VIRTCHNL_VF_RESOURCE_SIZE (sizeof(struct virtchnl_vf_resource) + \
 					(IAVF_MAX_VF_VSI * \
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index bd1fb3774769..a9cea7ccdd86 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2578,6 +2578,7 @@ static int iavf_validate_ch_config(struct iavf_adapter *adapter,
 				   struct tc_mqprio_qopt_offload *mqprio_qopt)
 {
 	u64 total_max_rate = 0;
+	u32 tx_rate_rem = 0;
 	int i, num_qps = 0;
 	u64 tx_rate = 0;
 	int ret = 0;
@@ -2592,12 +2593,32 @@ static int iavf_validate_ch_config(struct iavf_adapter *adapter,
 			return -EINVAL;
 		if (mqprio_qopt->min_rate[i]) {
 			dev_err(&adapter->pdev->dev,
-				"Invalid min tx rate (greater than 0) specified\n");
+				"Invalid min tx rate (greater than 0) specified for TC%d\n",
+				i);
 			return -EINVAL;
 		}
-		/*convert to Mbps */
+
+		/* convert to Mbps */
 		tx_rate = div_u64(mqprio_qopt->max_rate[i],
 				  IAVF_MBPS_DIVISOR);
+
+		if (mqprio_qopt->max_rate[i] &&
+		    tx_rate < IAVF_MBPS_QUANTA) {
+			dev_err(&adapter->pdev->dev,
+				"Invalid max tx rate for TC%d, minimum %dMbps\n",
+				i, IAVF_MBPS_QUANTA);
+			return -EINVAL;
+		}
+
+		(void)div_u64_rem(tx_rate, IAVF_MBPS_QUANTA, &tx_rate_rem);
+
+		if (tx_rate_rem != 0) {
+			dev_err(&adapter->pdev->dev,
+				"Invalid max tx rate for TC%d, not divisible by %d\n",
+				i, IAVF_MBPS_QUANTA);
+			return -EINVAL;
+		}
+
 		total_max_rate += tx_rate;
 		num_qps += mqprio_qopt->qopt.count[i];
 	}
-- 
2.35.1



