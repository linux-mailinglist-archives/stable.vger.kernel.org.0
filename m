Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 521496579BA
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbiL1PEH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:04:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233490AbiL1PED (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:04:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE6C12AFE
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:04:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC4D46154E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:04:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33B7C433D2;
        Wed, 28 Dec 2022 15:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239841;
        bh=JFjSUMXRaeqCM1nIHQ2yDky9nCdv67vn1vv6ltrX69Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W1UNrvCIrMlA1NJjakWYBfvpdPNG4OaKrFt2nW1kjRnELDUrFdrm37jnkzPywe9MV
         l/OauZd1s/3bmvPYADq6FF6PlDXXR3NTlFhJ/akBScaHyf9Epq09PsQUk2mrWQjo5A
         XfLlyAIyGcuFARN4tNJr3aGEqlaBiTypuSHTNGqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sumit Gupta <sumitg@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0049/1146] soc/tegra: cbb: Use correct master_id mask for CBB NOC in Tegra194
Date:   Wed, 28 Dec 2022 15:26:28 +0100
Message-Id: <20221228144331.495646121@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sumit Gupta <sumitg@nvidia.com>

[ Upstream commit 33af51a652191d7b9fe449563594b0bdbeb93c2a ]

In Tegra194 SoC, master_id bit range is different between cluster NOC
and CBB NOC. Currently same bit range is used which results in wrong
master_id value. Due to this, illegal accesses from the CCPLEX master
do not result in a crash as expected. Fix this by using the correct
range for the CBB NOC.

Finally, it is only necessary to extract the master_id when the
erd_mask_inband_err flag is set because when this is not set, a crash
is always triggered.

Fixes: b71344221466 ("soc/tegra: cbb: Add CBB 1.0 driver for Tegra194")
Fixes: fc2f151d2314 ("soc/tegra: cbb: Add driver for Tegra234 CBB 2.0")
Signed-off-by: Sumit Gupta <sumitg@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/cbb/tegra194-cbb.c | 14 +++++++-------
 drivers/soc/tegra/cbb/tegra234-cbb.c | 13 ++++++-------
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/soc/tegra/cbb/tegra194-cbb.c b/drivers/soc/tegra/cbb/tegra194-cbb.c
index 1ae0bd9a1ac1..2e952c6f7c9e 100644
--- a/drivers/soc/tegra/cbb/tegra194-cbb.c
+++ b/drivers/soc/tegra/cbb/tegra194-cbb.c
@@ -102,8 +102,6 @@
 #define CLUSTER_NOC_VQC GENMASK(17, 16)
 #define CLUSTER_NOC_MSTR_ID GENMASK(21, 18)
 
-#define USRBITS_MSTR_ID GENMASK(21, 18)
-
 #define CBB_ERR_OPC GENMASK(4, 1)
 #define CBB_ERR_ERRCODE GENMASK(10, 8)
 #define CBB_ERR_LEN1 GENMASK(27, 16)
@@ -2038,15 +2036,17 @@ static irqreturn_t tegra194_cbb_err_isr(int irq, void *data)
 					    smp_processor_id(), priv->noc->name, priv->res->start,
 					    irq);
 
-			mstr_id =  FIELD_GET(USRBITS_MSTR_ID, priv->errlog5) - 1;
 			is_fatal = print_errlog(NULL, priv, status);
 
 			/*
-			 * If illegal request is from CCPLEX(0x1)
-			 * initiator then call BUG() to crash system.
+			 * If illegal request is from CCPLEX(0x1) initiator
+			 * and error is fatal then call BUG() to crash system.
 			 */
-			if ((mstr_id == 0x1) && priv->noc->erd_mask_inband_err)
-				is_inband_err = 1;
+			if (priv->noc->erd_mask_inband_err) {
+				mstr_id =  FIELD_GET(CBB_NOC_MSTR_ID, priv->errlog5);
+				if (mstr_id == 0x1)
+					is_inband_err = 1;
+			}
 		}
 	}
 
diff --git a/drivers/soc/tegra/cbb/tegra234-cbb.c b/drivers/soc/tegra/cbb/tegra234-cbb.c
index 3528f9e15d5c..654c3d164606 100644
--- a/drivers/soc/tegra/cbb/tegra234-cbb.c
+++ b/drivers/soc/tegra/cbb/tegra234-cbb.c
@@ -92,7 +92,6 @@ struct tegra234_slave_lookup {
 struct tegra234_cbb_fabric {
 	const char *name;
 	phys_addr_t off_mask_erd;
-	bool erd_mask_inband_err;
 	const char * const *master_id;
 	unsigned int notifier_offset;
 	const struct tegra_cbb_error *errors;
@@ -525,14 +524,14 @@ static irqreturn_t tegra234_cbb_isr(int irq, void *data)
 			if (err)
 				goto unlock;
 
-			mstr_id =  FIELD_GET(USRBITS_MSTR_ID, priv->mn_user_bits);
-
 			/*
-			 * If illegal request is from CCPLEX(id:0x1) master then call BUG() to
-			 * crash system.
+			 * If illegal request is from CCPLEX(id:0x1) master then call WARN()
 			 */
-			if ((mstr_id == 0x1) && priv->fabric->off_mask_erd)
-				is_inband_err = 1;
+			if (priv->fabric->off_mask_erd) {
+				mstr_id =  FIELD_GET(USRBITS_MSTR_ID, priv->mn_user_bits);
+				if (mstr_id == 0x1)
+					is_inband_err = 1;
+			}
 		}
 	}
 
-- 
2.35.1



