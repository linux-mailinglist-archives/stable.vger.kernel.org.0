Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECC44541A6A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379675AbiFGVdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380954AbiFGVb3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:31:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E6622C486;
        Tue,  7 Jun 2022 12:03:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2240FB82182;
        Tue,  7 Jun 2022 19:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8712FC385A2;
        Tue,  7 Jun 2022 19:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628622;
        bh=8paB4wn84GkOCOxCrWhsa4YIQJLs/1Aq5n//Q6bQ/TA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=adxfJJLxUXnPG+LqcxEPiKOukq/n9Jsh2vKvQmHQT2t1ODHTIjDe95Q/dcAnw67Z4
         NZizUn2/Rd/HBORsfzt45C1cpEEVl3bP56F3u0Xvy6Okw1D70ixGB2Hgm/bA5oWAUF
         9SvoUQFF8J8ux2MEeButS8zknsRfSRpsNOVxGOmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Polimera <quic_vpolimer@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 396/879] drm/msm/disp/dpu1: avoid clearing hw interrupts if hw_intr is null during drm uninit
Date:   Tue,  7 Jun 2022 18:58:34 +0200
Message-Id: <20220607165014.359122289@linuxfoundation.org>
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

[ Upstream commit 01013ba9bbddc62f7d011163cebfd7ed06bb698b ]

If edp modeset init is failed due to panel being not ready and
probe defers during drm bind, avoid clearing irqs and dereference
hw_intr when hw_intr is null.

BUG: Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000

Call trace:
 dpu_core_irq_uninstall+0x50/0xb0
 dpu_irq_uninstall+0x18/0x24
 msm_drm_uninit+0xd8/0x16c
 msm_drm_bind+0x580/0x5fc
 try_to_bring_up_master+0x168/0x1c0
 __component_add+0xb4/0x178
 component_add+0x1c/0x28
 dp_display_probe+0x38c/0x400
 platform_probe+0xb0/0xd0
 really_probe+0xcc/0x2c8
 __driver_probe_device+0xbc/0xe8
 driver_probe_device+0x48/0xf0
 __device_attach_driver+0xa0/0xc8
 bus_for_each_drv+0x8c/0xd8
 __device_attach+0xc4/0x150
 device_initial_probe+0x1c/0x28

Changes in V2:
- Update commit message and coreect fixes tag.

Fixes: f25f656608e3 ("drm/msm/dpu: merge struct dpu_irq into struct dpu_hw_intr")
Signed-off-by: Vinod Polimera <quic_vpolimer@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/484430/
Link: https://lore.kernel.org/r/1651509846-4842-1-git-send-email-quic_vpolimer@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
index c61b5b283f08..cf9aa06ab8bd 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
@@ -599,6 +599,9 @@ void dpu_core_irq_uninstall(struct dpu_kms *dpu_kms)
 {
 	int i;
 
+	if (!dpu_kms->hw_intr)
+		return;
+
 	pm_runtime_get_sync(&dpu_kms->pdev->dev);
 	for (i = 0; i < dpu_kms->hw_intr->total_irqs; i++)
 		if (!list_empty(&dpu_kms->hw_intr->irq_cb_tbl[i]))
-- 
2.35.1



