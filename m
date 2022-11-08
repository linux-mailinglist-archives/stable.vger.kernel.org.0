Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF25F621400
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234793AbiKHN4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:56:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234717AbiKHN4S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:56:18 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEF060EB1
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:56:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8984BCE1B8E
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56748C433C1;
        Tue,  8 Nov 2022 13:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915774;
        bh=FSL8b5DpvXELjvIQPr6TJp+EHDEOZc5nux3wnxmsLn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uOwX9ywgix8D4rBkOi8r6n2kJiOUJdvThIsqiXi8VeD38LqGlhdh5LGtn65FvunWk
         RKUkXAR4fd2+EbAVsBlPzLRJi/7/Nl29qxOTAWcHGsejUWJ/qNm2GFwJPxTZCv/483
         FgPtWJfRUFxekcD/xtHBBk0H5td/vU0rTABahlfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/118] drm/msm/hdmi: Remove spurious IRQF_ONESHOT flag
Date:   Tue,  8 Nov 2022 14:38:45 +0100
Message-Id: <20221108133342.726441273@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Thompson <daniel.thompson@linaro.org>

[ Upstream commit 088604d37e23e9ec01a501d0e3630bc4f02027a0 ]

Quoting the header comments, IRQF_ONESHOT is "Used by threaded interrupts
which need to keep the irq line disabled until the threaded handler has
been run.". When applied to an interrupt that doesn't request a threaded
irq then IRQF_ONESHOT has a lesser known (undocumented?) side effect,
which it to disable the forced threading of irqs. For "normal" kernels
if there is no thread_fn then IRQF_ONESHOT is a nop.

In this case disabling forced threading is not appropriate because the
driver calls wake_up_all() (via msm_hdmi_i2c_irq) and also directly uses
the regular spinlock API for locking (in msm_hdmi_hdcp_irq() ). Neither
of these APIs can be called from no-thread interrupt handlers on
PREEMPT_RT systems.

Fix this by removing IRQF_ONESHOT.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20220201174734.196718-3-daniel.thompson@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Stable-dep-of: 152d394842bb ("drm/msm/hdmi: fix IRQ lifetime")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index 47796e12b432..28823fd94f9f 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -327,7 +327,7 @@ int msm_hdmi_modeset_init(struct hdmi *hdmi,
 	}
 
 	ret = devm_request_irq(&pdev->dev, hdmi->irq,
-			msm_hdmi_irq, IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+			msm_hdmi_irq, IRQF_TRIGGER_HIGH,
 			"hdmi_isr", hdmi);
 	if (ret < 0) {
 		DRM_DEV_ERROR(dev->dev, "failed to request IRQ%u: %d\n",
-- 
2.35.1



