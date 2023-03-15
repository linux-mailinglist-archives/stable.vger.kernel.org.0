Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491366BB282
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbjCOMgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbjCOMgc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:36:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C095A9CFF7
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:35:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 791A561D13
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91826C433EF;
        Wed, 15 Mar 2023 12:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883726;
        bh=pdQdeDz0toLuvF8rbBREGEyOZC9uSuOto5GEK2ahxAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=slkEexorkD5SA8X3KY1U8tSEM82k8WhqA3ax5VhHJkYHh2KK2rTIPYnrtd5gJUPex
         bisCJqb31+vEvdnEPKxArjpreR3pnpHMw0g9sAGH/b3y5ECuhtz//q4wV7t15f0hZa
         pQFbnMa2RZgcunIqd5yO4wKap6xZrnn0w/C3bZKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/143] drm/msm/dpu: fix len of sc7180 ctl blocks
Date:   Wed, 15 Mar 2023 13:12:47 +0100
Message-Id: <20230315115742.997326117@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit ce6bd00abc220e9edf10986234fadba6462b4abf ]

Change sc7180's ctl block len to 0x1dc.

Fixes: 7bdc0c4b8126 ("msm:disp:dpu1: add support for display for SC7180 target")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/522210/
Link: https://lore.kernel.org/r/20230211231259.1308718-5-dmitry.baryshkov@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
index e3f1661b84609..48fedd3f182e6 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
@@ -607,19 +607,19 @@ static const struct dpu_ctl_cfg sdm845_ctl[] = {
 static const struct dpu_ctl_cfg sc7180_ctl[] = {
 	{
 	.name = "ctl_0", .id = CTL_0,
-	.base = 0x1000, .len = 0xE4,
+	.base = 0x1000, .len = 0x1dc,
 	.features = BIT(DPU_CTL_ACTIVE_CFG),
 	.intr_start = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR2, 9),
 	},
 	{
 	.name = "ctl_1", .id = CTL_1,
-	.base = 0x1200, .len = 0xE4,
+	.base = 0x1200, .len = 0x1dc,
 	.features = BIT(DPU_CTL_ACTIVE_CFG),
 	.intr_start = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR2, 10),
 	},
 	{
 	.name = "ctl_2", .id = CTL_2,
-	.base = 0x1400, .len = 0xE4,
+	.base = 0x1400, .len = 0x1dc,
 	.features = BIT(DPU_CTL_ACTIVE_CFG),
 	.intr_start = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR2, 11),
 	},
-- 
2.39.2



