Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8172F4EF0B5
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348218AbiDAOhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347617AbiDAOdO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:33:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063C7258454;
        Fri,  1 Apr 2022 07:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF996B8240E;
        Fri,  1 Apr 2022 14:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEEBC340F2;
        Fri,  1 Apr 2022 14:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823414;
        bh=WTCcys5M8nuJoEQ48767Pm3nH88jdDikgQW3uQHmsBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uWSaF+HYWEPOWcPQfwg4QgtUG5XgsnGvm9w12pU5LpzgriJyajLNCk6tRwRwaPzBC
         RFaOzX6hO6tvhrvxhMOpyJLzjxoGb+WMITAdhajzLZPpDNJTgkNkLgNeqxs6XklUOp
         Dc3jBH5VWHndSoWuLYz2wjoKiBhSCf2FwZB5t2uz1ojfe+jl2Sjis+L7jsncpYAanH
         w4NtV66Ap6b1PCupHMbYnqi6AoYTTCHbTgNNKF8aPZOTjoxYq8lApxjklFxdXxMMcV
         sOJO0Rv0ymuA4UrY2EBhM+ES2Gc+Hz1EOwEl1f2HRCw2Bez/vtqQiWAfIK6sBFRd7S
         IRl+uYgZWsJJw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Thompson <daniel.thompson@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robdclark@gmail.com,
        sean@poorly.run, airlied@linux.ie, daniel@ffwll.ch,
        quic_abhinavk@quicinc.com, swboyd@chromium.org,
        bjorn.andersson@linaro.org, jonathan@marek.ca,
        quic_jesszhan@quicinc.com, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.17 083/149] drm/msm/dsi: Remove spurious IRQF_ONESHOT flag
Date:   Fri,  1 Apr 2022 10:24:30 -0400
Message-Id: <20220401142536.1948161-83-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Daniel Thompson <daniel.thompson@linaro.org>

[ Upstream commit 24b176d8827d167ac3b379317f60c0985f6e95aa ]

Quoting the header comments, IRQF_ONESHOT is "Used by threaded interrupts
which need to keep the irq line disabled until the threaded handler has
been run.". When applied to an interrupt that doesn't request a threaded
irq then IRQF_ONESHOT has a lesser known (undocumented?) side effect,
which it to disable the forced threading of irqs (and for "normal" kernels
it is a nop). In this case I can find no evidence that suppressing forced
threading is intentional. Had it been intentional then a driver must adopt
the raw_spinlock API in order to avoid deadlocks on PREEMPT_RT kernels
(and avoid calling any kernel API that uses regular spinlocks).

Fix this by removing the spurious additional flag.

This change is required for my Snapdragon 7cx Gen2 tablet to boot-to-GUI
with PREEMPT_RT enabled.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20220201174734.196718-2-daniel.thompson@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 6b3ced4aaaf5..3a3f53f0c8ae 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1877,7 +1877,7 @@ int msm_dsi_host_init(struct msm_dsi *msm_dsi)
 
 	/* do not autoenable, will be enabled later */
 	ret = devm_request_irq(&pdev->dev, msm_host->irq, dsi_host_irq,
-			IRQF_TRIGGER_HIGH | IRQF_ONESHOT | IRQF_NO_AUTOEN,
+			IRQF_TRIGGER_HIGH | IRQF_NO_AUTOEN,
 			"dsi_isr", msm_host);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to request IRQ%u: %d\n",
-- 
2.34.1

