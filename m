Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD8D540C00
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbiFGSdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352495AbiFGSbC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:31:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596C117B87F;
        Tue,  7 Jun 2022 10:56:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBB72B82372;
        Tue,  7 Jun 2022 17:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45647C385A5;
        Tue,  7 Jun 2022 17:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624579;
        bh=HQLfXi5VClokbUvWbIwBneJQw4BcuwFWA1nTon43szk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HgxocYdUJpHWAf1RiiVXL7SBrbXy7/HmnIev+kIAjXslIDCtiCdmUT3s1ynUAxx2Y
         7AAkxe+CvTm0mkv/Fa2tvKr7Rf01DIevB94ZPDh7LnD8pMsTQiY3rGTEwK9AHXpk/u
         BttGSRCcw+9LStClyl4Ny90NYMiNiOzuiV4QHrKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Rob Clark <robdclark@gmail.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 351/667] drm/msm/dpu: handle pm_runtime_get_sync() errors in bind path
Date:   Tue,  7 Jun 2022 19:00:16 +0200
Message-Id: <20220607164945.285394943@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

From: Abhinav Kumar <quic_abhinavk@quicinc.com>

[ Upstream commit 64b22a0da12adb571c01edd671ee43634ebd7e41 ]

If there are errors while trying to enable the pm in the
bind path, it will lead to unclocked access of hw revision
register thereby crashing the device.

This will not address why the pm_runtime_get_sync() fails
but at the very least we should be able to prevent the
crash by handling the error and bailing out earlier.

changes in v2:
	- use pm_runtime_resume_and_get() instead of
	  pm_runtime_get_sync()

Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Rob Clark <robdclark@gmail.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/486721/
Link: https://lore.kernel.org/r/20220518223407.26147-1-quic_abhinavk@quicinc.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
index 33ce6720dfae..2870b0ffe1eb 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
@@ -1001,7 +1001,9 @@ static int dpu_kms_hw_init(struct msm_kms *kms)
 
 	dpu_kms_parse_data_bus_icc_path(dpu_kms);
 
-	pm_runtime_get_sync(&dpu_kms->pdev->dev);
+	rc = pm_runtime_resume_and_get(&dpu_kms->pdev->dev);
+	if (rc < 0)
+		goto error;
 
 	dpu_kms->core_rev = readl_relaxed(dpu_kms->mmio + 0x0);
 
-- 
2.35.1



