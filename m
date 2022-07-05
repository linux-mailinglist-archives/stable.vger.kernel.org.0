Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F197566E2E
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237399AbiGEMb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237991AbiGEM0x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:26:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833E31903F;
        Tue,  5 Jul 2022 05:19:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A21FB817D7;
        Tue,  5 Jul 2022 12:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E71C341C7;
        Tue,  5 Jul 2022 12:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023556;
        bh=BC4FmKCgrjD525c56OJFhwPcTeuAUarXhmva6CJfH+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qm2RIFKu7pSyOeprBSDP9NbdB6rIx3R0lZn6hGxmU55+tslyr9O0th45A4i+W1nrt
         LhlfTSmL6g6lUqo9xzM8XMYuGXNBQLjamaslCayaWslr1cN04caY4J/tB6d81nLH7s
         UjXr2xaNkCWQE6IoNo0+5yilWrahOl0ioJ1mKlRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Yacoub <markyacoub@chromium.org>,
        Jessica Zhang <quic_jesszhan@quicinc.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 082/102] drm/msm/dpu: Increment vsync_cnt before waking up userspace
Date:   Tue,  5 Jul 2022 13:58:48 +0200
Message-Id: <20220705115620.738471178@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit c28d76d360f9f7af1f910342bde27939873bc45e ]

The 'vsync_cnt' is used to count the number of frames for a crtc.
Unfortunately, we increment the count after waking up userspace via
dpu_crtc_vblank_callback() calling drm_crtc_handle_vblank().
drm_crtc_handle_vblank() wakes up userspace processes that have called
drm_wait_vblank_ioctl(), and if that ioctl is expecting the count to
increase it won't.

Increment the count before calling into the drm APIs so that we don't
have to worry about ordering the increment with anything else in drm.
This fixes a software video decode test that fails to see frame counts
increase on Trogdor boards.

Cc: Mark Yacoub <markyacoub@chromium.org>
Cc: Jessica Zhang <quic_jesszhan@quicinc.com>
Fixes: 885455d6bf82 ("drm/msm: Change dpu_crtc_get_vblank_counter to use vsync count.")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Jessica Zhang <quic_jesszhan@quicinc.com> # Trogdor (sc7180)
Patchwork: https://patchwork.freedesktop.org/patch/490531/
Link: https://lore.kernel.org/r/20220622023855.2970913-1-swboyd@chromium.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index 3940b9c6323b..fffd2ef897a0 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -1187,12 +1187,13 @@ static void dpu_encoder_vblank_callback(struct drm_encoder *drm_enc,
 	DPU_ATRACE_BEGIN("encoder_vblank_callback");
 	dpu_enc = to_dpu_encoder_virt(drm_enc);
 
+	atomic_inc(&phy_enc->vsync_cnt);
+
 	spin_lock_irqsave(&dpu_enc->enc_spinlock, lock_flags);
 	if (dpu_enc->crtc)
 		dpu_crtc_vblank_callback(dpu_enc->crtc);
 	spin_unlock_irqrestore(&dpu_enc->enc_spinlock, lock_flags);
 
-	atomic_inc(&phy_enc->vsync_cnt);
 	DPU_ATRACE_END("encoder_vblank_callback");
 }
 
-- 
2.35.1



