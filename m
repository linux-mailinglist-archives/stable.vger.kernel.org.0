Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 781705405E0
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346634AbiFGRcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347166AbiFGRaH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:30:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57D5108A80;
        Tue,  7 Jun 2022 10:25:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B9766141D;
        Tue,  7 Jun 2022 17:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38603C36AFF;
        Tue,  7 Jun 2022 17:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622757;
        bh=DrIiPpMyur8d0DVsLb71NwvOM01mDrmNo4xX57fS2nI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rf0yH6ZrvxHLmQVVFEW7P4Pzjnpd27WZS2+FLFulGU0nGF5vt0CLk/IqB16MGO0K8
         TwW93nekjBcebvh1mZa8bkoo8iTFoJ+xrOOG4eWfi5ZxF+lmu0Zh/XRIZ6qnnykyRM
         ELBAuJOrkcKeyxA++OcCpN4KDvdnjfXVbfLkuIyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Polimera <quic_vpolimer@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 173/452] drm/msm/disp/dpu1: set vbif hw config to NULL to avoid use after memory free during pm runtime resume
Date:   Tue,  7 Jun 2022 19:00:30 +0200
Message-Id: <20220607164913.717262423@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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
index 08e082d0443a..b05ff46d773d 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
@@ -678,8 +678,10 @@ static void _dpu_kms_hw_destroy(struct dpu_kms *dpu_kms)
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



