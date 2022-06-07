Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5892F541ABA
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380096AbiFGVhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381043AbiFGVg1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:36:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BBD22FA2D;
        Tue,  7 Jun 2022 12:04:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28F7AB82182;
        Tue,  7 Jun 2022 19:04:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DAFC385A2;
        Tue,  7 Jun 2022 19:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628686;
        bh=18FgYgxpK/GSh/zk3qboJruba3KYu3wZkoqWO2P5yoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fUp1mxikn5sLH9RAR3Hvkv5NK1z+HJg5wL89t8338OKk5soCyikfEhM5wa2HI6OFK
         lHNTuCJbwQMxgnVIHEObVbsXn2GjEiL6HdxXlrIHnPIi0xctthH7AkL4O9Yx9JNy9M
         yh8aCj4QT/UvkYUazkBLIqNn4tt/Ti1KxaKFXF48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Polimera <quic_vpolimer@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 368/879] drm/msm/disp/dpu1: set vbif hw config to NULL to avoid use after memory free during pm runtime resume
Date:   Tue,  7 Jun 2022 18:58:06 +0200
Message-Id: <20220607165013.554997161@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinod Polimera <quic_vpolimer@quicinc.com>

[ Upstream commit fa5186b279ecf44b14fb435540d2065be91cb1ed ]

BUG: Unable to handle kernel paging request at virtual address 006b6b6b6b6b6be3

Call trace:
  dpu_vbif_init_memtypes+0x40/0xb8
  dpu_runtime_resume+0xcc/0x1c0
  pm_generic_runtime_resume+0x30/0x44
  __genpd_runtime_resume+0x68/0x7c
  genpd_runtime_resume+0x134/0x258
  __rpm_callback+0x98/0x138
  rpm_callback+0x30/0x88
  rpm_resume+0x36c/0x49c
  __pm_runtime_resume+0x80/0xb0
  dpu_core_irq_uninstall+0x30/0xb0
  dpu_irq_uninstall+0x18/0x24
  msm_drm_uninit+0xd8/0x16c

Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Signed-off-by: Vinod Polimera <quic_vpolimer@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/483255/
Link: https://lore.kernel.org/r/1650857213-30075-1-git-send-email-quic_vpolimer@quicinc.com
[DB: fixed Fixes tag]
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
index e29796c4f27b..ad13a9423601 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
@@ -793,8 +793,10 @@ static void _dpu_kms_hw_destroy(struct dpu_kms *dpu_kms)
 		for (i = 0; i < dpu_kms->catalog->vbif_count; i++) {
 			u32 vbif_idx = dpu_kms->catalog->vbif[i].id;
 
-			if ((vbif_idx < VBIF_MAX) && dpu_kms->hw_vbif[vbif_idx])
+			if ((vbif_idx < VBIF_MAX) && dpu_kms->hw_vbif[vbif_idx]) {
 				dpu_hw_vbif_destroy(dpu_kms->hw_vbif[vbif_idx]);
+				dpu_kms->hw_vbif[vbif_idx] = NULL;
+			}
 		}
 	}
 
-- 
2.35.1



