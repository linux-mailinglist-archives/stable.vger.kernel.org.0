Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C10A66AEF92
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbjCGSY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:24:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbjCGSXy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:23:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC43E9009D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:19:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F943B818EB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB163C433EF;
        Tue,  7 Mar 2023 18:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213165;
        bh=A+h3dc8XfRhEAWNacLa/Q01En3HasFvCGIPgoyoT7NU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XSfmKjQdFt3O1r0+4/OT71XvHl8ivYrTrHsXOa99ukZbLyntxM9x3qJ09ERDguZGo
         vhbGnzMFor/oQwsT4LBPQp7wYtVGtPZeeMHWkLRFo5BjBvdmB8BteAjI29L5J7sSyn
         SHVUbDor3Buvr0Q6Xhp+LVuNGJ0EZsjGmqwKTM/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Junhao He <hejunhao3@huawei.com>,
        Mike Leach <mike.leach@linaro.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 420/885] coresight: etm4x: Fix accesses to TRCSEQRSTEVR and TRCSEQSTR
Date:   Tue,  7 Mar 2023 17:55:54 +0100
Message-Id: <20230307170020.672737868@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junhao He <hejunhao3@huawei.com>

[ Upstream commit 589d928248b72f8377d45904a14bcf686aa8bbeb ]

The TRCSEQRSTEVR and TRCSEQSTR registers are not implemented if the
TRCIDR5.NUMSEQSTATE == 0. Skip accessing the registers in such cases.

Fixes: 2e1cdfe184b5 ("coresight-etm4x: Adding CoreSight ETM4x driver")
Signed-off-by: Junhao He <hejunhao3@huawei.com>
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20230114091632.60095-1-hejunhao3@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hwtracing/coresight/coresight-etm4x-core.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 80fefaba58eeb..c7a65d1524fcb 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -424,8 +424,10 @@ static int etm4_enable_hw(struct etmv4_drvdata *drvdata)
 		etm4x_relaxed_write32(csa, config->vipcssctlr, TRCVIPCSSCTLR);
 	for (i = 0; i < drvdata->nrseqstate - 1; i++)
 		etm4x_relaxed_write32(csa, config->seq_ctrl[i], TRCSEQEVRn(i));
-	etm4x_relaxed_write32(csa, config->seq_rst, TRCSEQRSTEVR);
-	etm4x_relaxed_write32(csa, config->seq_state, TRCSEQSTR);
+	if (drvdata->nrseqstate) {
+		etm4x_relaxed_write32(csa, config->seq_rst, TRCSEQRSTEVR);
+		etm4x_relaxed_write32(csa, config->seq_state, TRCSEQSTR);
+	}
 	etm4x_relaxed_write32(csa, config->ext_inp, TRCEXTINSELR);
 	for (i = 0; i < drvdata->nr_cntr; i++) {
 		etm4x_relaxed_write32(csa, config->cntrldvr[i], TRCCNTRLDVRn(i));
@@ -1631,8 +1633,10 @@ static int __etm4_cpu_save(struct etmv4_drvdata *drvdata)
 	for (i = 0; i < drvdata->nrseqstate - 1; i++)
 		state->trcseqevr[i] = etm4x_read32(csa, TRCSEQEVRn(i));
 
-	state->trcseqrstevr = etm4x_read32(csa, TRCSEQRSTEVR);
-	state->trcseqstr = etm4x_read32(csa, TRCSEQSTR);
+	if (drvdata->nrseqstate) {
+		state->trcseqrstevr = etm4x_read32(csa, TRCSEQRSTEVR);
+		state->trcseqstr = etm4x_read32(csa, TRCSEQSTR);
+	}
 	state->trcextinselr = etm4x_read32(csa, TRCEXTINSELR);
 
 	for (i = 0; i < drvdata->nr_cntr; i++) {
@@ -1760,8 +1764,10 @@ static void __etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 	for (i = 0; i < drvdata->nrseqstate - 1; i++)
 		etm4x_relaxed_write32(csa, state->trcseqevr[i], TRCSEQEVRn(i));
 
-	etm4x_relaxed_write32(csa, state->trcseqrstevr, TRCSEQRSTEVR);
-	etm4x_relaxed_write32(csa, state->trcseqstr, TRCSEQSTR);
+	if (drvdata->nrseqstate) {
+		etm4x_relaxed_write32(csa, state->trcseqrstevr, TRCSEQRSTEVR);
+		etm4x_relaxed_write32(csa, state->trcseqstr, TRCSEQSTR);
+	}
 	etm4x_relaxed_write32(csa, state->trcextinselr, TRCEXTINSELR);
 
 	for (i = 0; i < drvdata->nr_cntr; i++) {
-- 
2.39.2



