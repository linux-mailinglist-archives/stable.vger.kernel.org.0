Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCA8586AA6
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234659AbiHAMTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234612AbiHAMTH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:19:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C744AD52;
        Mon,  1 Aug 2022 04:59:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82145B810A2;
        Mon,  1 Aug 2022 11:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16BAC433D6;
        Mon,  1 Aug 2022 11:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355190;
        bh=yO3CaGRwBI7Rn5j6BPCcopt6ebHPTjp9F/DFuzNxKrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5gw2QkVJ6k22vQNsaomZ3GE1W3LpH4w5pmCTNv5yD6GkxH58Q9MRVlwhosOCZ5jC
         506MPJJFVvW0mlUyUscMtzge80ka2FANJtP+4DMkVW5FwlcmqbrTbiHHasqKMc9mEd
         78UlqOjKWiSJH6/tjoLBCtcFJLzlPiq69wC7dxpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sunil Goutham <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 68/88] octeontx2-pf: cn10k: Fix egress ratelimit configuration
Date:   Mon,  1 Aug 2022 13:47:22 +0200
Message-Id: <20220801114141.152206983@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
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

From: Sunil Goutham <sgoutham@marvell.com>

[ Upstream commit b354eaeec8637d87003945439209251d76a2bb95 ]

NIX_AF_TLXX_PIR/CIR register format has changed from OcteonTx2
to CN10K. CN10K supports larger burst size. Fix burst exponent
and burst mantissa configuration for CN10K.

Also fixed 'maxrate' from u32 to u64 since 'police.rate_bytes_ps'
passed by stack is also u64.

Fixes: e638a83f167e ("octeontx2-pf: TC_MATCHALL egress ratelimiting offload")
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/nic/otx2_tc.c  | 76 ++++++++++++++-----
 1 file changed, 55 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index a3d720b1b32c..e64318c110fd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -28,6 +28,9 @@
 #define MAX_RATE_EXPONENT		0x0FULL
 #define MAX_RATE_MANTISSA		0xFFULL
 
+#define CN10K_MAX_BURST_MANTISSA	0x7FFFULL
+#define CN10K_MAX_BURST_SIZE		8453888ULL
+
 /* Bitfields in NIX_TLX_PIR register */
 #define TLX_RATE_MANTISSA		GENMASK_ULL(8, 1)
 #define TLX_RATE_EXPONENT		GENMASK_ULL(12, 9)
@@ -35,6 +38,9 @@
 #define TLX_BURST_MANTISSA		GENMASK_ULL(36, 29)
 #define TLX_BURST_EXPONENT		GENMASK_ULL(40, 37)
 
+#define CN10K_TLX_BURST_MANTISSA	GENMASK_ULL(43, 29)
+#define CN10K_TLX_BURST_EXPONENT	GENMASK_ULL(47, 44)
+
 struct otx2_tc_flow_stats {
 	u64 bytes;
 	u64 pkts;
@@ -77,33 +83,42 @@ int otx2_tc_alloc_ent_bitmap(struct otx2_nic *nic)
 }
 EXPORT_SYMBOL(otx2_tc_alloc_ent_bitmap);
 
-static void otx2_get_egress_burst_cfg(u32 burst, u32 *burst_exp,
-				      u32 *burst_mantissa)
+static void otx2_get_egress_burst_cfg(struct otx2_nic *nic, u32 burst,
+				      u32 *burst_exp, u32 *burst_mantissa)
 {
+	int max_burst, max_mantissa;
 	unsigned int tmp;
 
+	if (is_dev_otx2(nic->pdev)) {
+		max_burst = MAX_BURST_SIZE;
+		max_mantissa = MAX_BURST_MANTISSA;
+	} else {
+		max_burst = CN10K_MAX_BURST_SIZE;
+		max_mantissa = CN10K_MAX_BURST_MANTISSA;
+	}
+
 	/* Burst is calculated as
 	 * ((256 + BURST_MANTISSA) << (1 + BURST_EXPONENT)) / 256
 	 * Max supported burst size is 130,816 bytes.
 	 */
-	burst = min_t(u32, burst, MAX_BURST_SIZE);
+	burst = min_t(u32, burst, max_burst);
 	if (burst) {
 		*burst_exp = ilog2(burst) ? ilog2(burst) - 1 : 0;
 		tmp = burst - rounddown_pow_of_two(burst);
-		if (burst < MAX_BURST_MANTISSA)
+		if (burst < max_mantissa)
 			*burst_mantissa = tmp * 2;
 		else
 			*burst_mantissa = tmp / (1ULL << (*burst_exp - 7));
 	} else {
 		*burst_exp = MAX_BURST_EXPONENT;
-		*burst_mantissa = MAX_BURST_MANTISSA;
+		*burst_mantissa = max_mantissa;
 	}
 }
 
-static void otx2_get_egress_rate_cfg(u32 maxrate, u32 *exp,
+static void otx2_get_egress_rate_cfg(u64 maxrate, u32 *exp,
 				     u32 *mantissa, u32 *div_exp)
 {
-	unsigned int tmp;
+	u64 tmp;
 
 	/* Rate calculation by hardware
 	 *
@@ -132,21 +147,44 @@ static void otx2_get_egress_rate_cfg(u32 maxrate, u32 *exp,
 	}
 }
 
-static int otx2_set_matchall_egress_rate(struct otx2_nic *nic, u32 burst, u32 maxrate)
+static u64 otx2_get_txschq_rate_regval(struct otx2_nic *nic,
+				       u64 maxrate, u32 burst)
 {
-	struct otx2_hw *hw = &nic->hw;
-	struct nix_txschq_config *req;
 	u32 burst_exp, burst_mantissa;
 	u32 exp, mantissa, div_exp;
+	u64 regval = 0;
+
+	/* Get exponent and mantissa values from the desired rate */
+	otx2_get_egress_burst_cfg(nic, burst, &burst_exp, &burst_mantissa);
+	otx2_get_egress_rate_cfg(maxrate, &exp, &mantissa, &div_exp);
+
+	if (is_dev_otx2(nic->pdev)) {
+		regval = FIELD_PREP(TLX_BURST_EXPONENT, (u64)burst_exp) |
+				FIELD_PREP(TLX_BURST_MANTISSA, (u64)burst_mantissa) |
+				FIELD_PREP(TLX_RATE_DIVIDER_EXPONENT, div_exp) |
+				FIELD_PREP(TLX_RATE_EXPONENT, exp) |
+				FIELD_PREP(TLX_RATE_MANTISSA, mantissa) | BIT_ULL(0);
+	} else {
+		regval = FIELD_PREP(CN10K_TLX_BURST_EXPONENT, (u64)burst_exp) |
+				FIELD_PREP(CN10K_TLX_BURST_MANTISSA, (u64)burst_mantissa) |
+				FIELD_PREP(TLX_RATE_DIVIDER_EXPONENT, div_exp) |
+				FIELD_PREP(TLX_RATE_EXPONENT, exp) |
+				FIELD_PREP(TLX_RATE_MANTISSA, mantissa) | BIT_ULL(0);
+	}
+
+	return regval;
+}
+
+static int otx2_set_matchall_egress_rate(struct otx2_nic *nic,
+					 u32 burst, u64 maxrate)
+{
+	struct otx2_hw *hw = &nic->hw;
+	struct nix_txschq_config *req;
 	int txschq, err;
 
 	/* All SQs share the same TL4, so pick the first scheduler */
 	txschq = hw->txschq_list[NIX_TXSCH_LVL_TL4][0];
 
-	/* Get exponent and mantissa values from the desired rate */
-	otx2_get_egress_burst_cfg(burst, &burst_exp, &burst_mantissa);
-	otx2_get_egress_rate_cfg(maxrate, &exp, &mantissa, &div_exp);
-
 	mutex_lock(&nic->mbox.lock);
 	req = otx2_mbox_alloc_msg_nix_txschq_cfg(&nic->mbox);
 	if (!req) {
@@ -157,11 +195,7 @@ static int otx2_set_matchall_egress_rate(struct otx2_nic *nic, u32 burst, u32 ma
 	req->lvl = NIX_TXSCH_LVL_TL4;
 	req->num_regs = 1;
 	req->reg[0] = NIX_AF_TL4X_PIR(txschq);
-	req->regval[0] = FIELD_PREP(TLX_BURST_EXPONENT, burst_exp) |
-			 FIELD_PREP(TLX_BURST_MANTISSA, burst_mantissa) |
-			 FIELD_PREP(TLX_RATE_DIVIDER_EXPONENT, div_exp) |
-			 FIELD_PREP(TLX_RATE_EXPONENT, exp) |
-			 FIELD_PREP(TLX_RATE_MANTISSA, mantissa) | BIT_ULL(0);
+	req->regval[0] = otx2_get_txschq_rate_regval(nic, maxrate, burst);
 
 	err = otx2_sync_mbox_msg(&nic->mbox);
 	mutex_unlock(&nic->mbox.lock);
@@ -230,7 +264,7 @@ static int otx2_tc_egress_matchall_install(struct otx2_nic *nic,
 	struct netlink_ext_ack *extack = cls->common.extack;
 	struct flow_action *actions = &cls->rule->action;
 	struct flow_action_entry *entry;
-	u32 rate;
+	u64 rate;
 	int err;
 
 	err = otx2_tc_validate_flow(nic, actions, extack);
@@ -256,7 +290,7 @@ static int otx2_tc_egress_matchall_install(struct otx2_nic *nic,
 		}
 		/* Convert bytes per second to Mbps */
 		rate = entry->police.rate_bytes_ps * 8;
-		rate = max_t(u32, rate / 1000000, 1);
+		rate = max_t(u64, rate / 1000000, 1);
 		err = otx2_set_matchall_egress_rate(nic, entry->police.burst, rate);
 		if (err)
 			return err;
-- 
2.35.1



