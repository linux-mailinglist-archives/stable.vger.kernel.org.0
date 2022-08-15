Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022B1594829
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354251AbiHOXoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354520AbiHOXmV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:42:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C5249B55;
        Mon, 15 Aug 2022 13:13:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5277ACE12C5;
        Mon, 15 Aug 2022 20:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26897C433C1;
        Mon, 15 Aug 2022 20:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594412;
        bh=9cNYoEL/pFRwrFe386RPcdfHQW1f0WHWMaVyWU8qZYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Smw2AueF3hjAekMX05Zxo4wQXjugvp/01Z8W3uVbwZYNsGRsPHB4wxCmJgdzpXgWK
         7j4gxNN9HGgRz236G820vTtmnhfRu+boKn9+FIsClxBkG+ikfxFeKhxMETvcDtdP9S
         SIa+XPQGoDYAQZay+wyrcXlUWKp7Hlm/vNS0whzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0437/1157] drm/msm/dpu: fix maxlinewidth for writeback block
Date:   Mon, 15 Aug 2022 19:56:33 +0200
Message-Id: <20220815180457.118455673@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Abhinav Kumar <quic_abhinavk@quicinc.com>

[ Upstream commit a370cc392e075de5a4b7f3fb27cdeec0d70b5893 ]

Writeback block for sm8250 was using the default maxlinewidth
of 2048. But this is not right as it supports upto 4096.

This should have no effect on most resolutions as we are
still limiting upto maxlinewidth of SSPP for adding the modes.

Fix the maxlinewidth for writeback block on sm8250.

changes in v3:
	- correct the Fixes tag

Fixes: 53324b99bd7b ("drm/msm/dpu: add writeback blocks to the sm8250 DPU catalog")
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/489887/
Link: https://lore.kernel.org/r/1655406084-17407-2-git-send-email-quic_abhinavk@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
index 400ebceb56bb..dd7537e32f88 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
@@ -1285,7 +1285,7 @@ static const struct dpu_intf_cfg qcm2290_intf[] = {
  * Writeback blocks config
  *************************************************************/
 #define WB_BLK(_name, _id, _base, _features, _clk_ctrl, \
-		__xin_id, vbif_id, _reg, _wb_done_bit) \
+		__xin_id, vbif_id, _reg, _max_linewidth, _wb_done_bit) \
 	{ \
 	.name = _name, .id = _id, \
 	.base = _base, .len = 0x2c8, \
@@ -1295,13 +1295,13 @@ static const struct dpu_intf_cfg qcm2290_intf[] = {
 	.clk_ctrl = _clk_ctrl, \
 	.xin_id = __xin_id, \
 	.vbif_idx = vbif_id, \
-	.maxlinewidth = DEFAULT_DPU_LINE_WIDTH, \
+	.maxlinewidth = _max_linewidth, \
 	.intr_wb_done = DPU_IRQ_IDX(_reg, _wb_done_bit) \
 	}
 
 static const struct dpu_wb_cfg sm8250_wb[] = {
 	WB_BLK("wb_2", WB_2, 0x65000, WB_SM8250_MASK, DPU_CLK_CTRL_WB2, 6,
-			VBIF_RT, MDP_SSPP_TOP0_INTR, 4),
+			VBIF_RT, MDP_SSPP_TOP0_INTR, 4096, 4),
 };
 
 /*************************************************************
-- 
2.35.1



