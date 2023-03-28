Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C351E6CC39C
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbjC1Ozn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233544AbjC1Ozn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:55:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A98DBE6
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:55:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBF0EB81D77
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192B0C433EF;
        Tue, 28 Mar 2023 14:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015339;
        bh=AhKZeW1kP5KyMlZufFL9M2/BCDQj5XPVmrPtge7ixa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AxTkDtbEo331B7CcRBgrUNtcn0dADhc4zNSO6p4Hv11NZal6BMBTQOoPDkvVPB5is
         FI7X9fItDAytT/0z+DRpo4YSyBTMiTsLe2CPJlgtrTMR8Yj06wygJoU081AM9u4wv7
         C3mj3Cp2d0ZTztktSnGQsMwE9/ZMxSLhoacPB6d8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Konrad Dybcio <konrad.dybcio@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Georgi Djakov <djakov@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/224] interconnect: qcom: qcm2290: Fix MASTER_SNOC_BIMC_NRT
Date:   Tue, 28 Mar 2023 16:39:59 +0200
Message-Id: <20230328142617.351911604@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 633a12fda6536a1a17bcea29502e777e86a4547e ]

Due to what seems to be a copy-paste error, the _NRT master was
identical to the _RT master, which should not be the case.. Fix it
using the values available from the downstream kernel [1].

[1] https://android.googlesource.com/kernel/msm-extra/devicetree/+/refs/heads/android-msm-bramble-4.19-android11-qpr1/qcom/scuba-bus.dtsi#127
Fixes: 1a14b1ac3935 ("interconnect: qcom: Add QCM2290 driver support")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Link: https://lore.kernel.org/r/20230103142120.15605-1-konrad.dybcio@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/qcm2290.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/interconnect/qcom/qcm2290.c b/drivers/interconnect/qcom/qcm2290.c
index 0da612d6398c5..a29cdb4fac03f 100644
--- a/drivers/interconnect/qcom/qcm2290.c
+++ b/drivers/interconnect/qcom/qcm2290.c
@@ -147,9 +147,9 @@ static struct qcom_icc_node mas_snoc_bimc_nrt = {
 	.name = "mas_snoc_bimc_nrt",
 	.buswidth = 16,
 	.qos.ap_owned = true,
-	.qos.qos_port = 2,
+	.qos.qos_port = 3,
 	.qos.qos_mode = NOC_QOS_MODE_BYPASS,
-	.mas_rpm_id = 163,
+	.mas_rpm_id = 164,
 	.slv_rpm_id = -1,
 	.num_links = ARRAY_SIZE(mas_snoc_bimc_nrt_links),
 	.links = mas_snoc_bimc_nrt_links,
-- 
2.39.2



