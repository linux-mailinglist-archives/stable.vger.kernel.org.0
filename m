Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86128613054
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 07:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiJaGc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 02:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiJaGc2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 02:32:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF7B7646
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 23:32:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EE5A60FD9
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 06:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E63C433C1;
        Mon, 31 Oct 2022 06:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667197946;
        bh=34XMsxBlxEmGZDtoaX2/+Y5A9qA2NHp5kfP91/Bfoz4=;
        h=Subject:To:Cc:From:Date:From;
        b=WOCFrRHq+ULA8b+fRRHwQwAdX4jMfTPPZIw/CtwAOjbeNi4qJ8FOVo2KN1ZdxetXH
         Kpmp/0Kp8STIHtOL3M6LcjmRzDUN+24yXc3t0+49FSUn0gUFtrwYw3Gl7cG855gi0O
         7M0lGKHgRFCxdZoqIOFl0Qz4KugbCjjgBFK7ddaI=
Subject: FAILED: patch "[PATCH] drm/msm/hdmi: fix IRQ lifetime" failed to apply to 5.10-stable tree
To:     johan+linaro@kernel.org, dmitry.baryshkov@linaro.org,
        quic_abhinavk@quicinc.com, quic_khsieh@quicinc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Oct 2022 07:33:16 +0100
Message-ID: <166719799675195@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

152d394842bb ("drm/msm/hdmi: fix IRQ lifetime")
088604d37e23 ("drm/msm/hdmi: Remove spurious IRQF_ONESHOT flag")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 152d394842bb564148e68b92486a87db0bf54859 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan+linaro@kernel.org>
Date: Tue, 13 Sep 2022 10:53:18 +0200
Subject: [PATCH] drm/msm/hdmi: fix IRQ lifetime

Device-managed resources allocated post component bind must be tied to
the lifetime of the aggregate DRM device or they will not necessarily be
released when binding of the aggregate device is deferred.

This is specifically true for the HDMI IRQ, which will otherwise remain
requested so that the next bind attempt fails when requesting the IRQ a
second time.

Fix this by tying the device-managed lifetime of the HDMI IRQ to the DRM
device so that it is released when bind fails.

Fixes: 067fef372c73 ("drm/msm/hdmi: refactor bind/init")
Cc: stable@vger.kernel.org      # 3.19
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/502666/
Link: https://lore.kernel.org/r/20220913085320.8577-9-johan+linaro@kernel.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index a0ed6aa8e4e1..f28fb21e3891 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -344,7 +344,7 @@ int msm_hdmi_modeset_init(struct hdmi *hdmi,
 		goto fail;
 	}
 
-	ret = devm_request_irq(&pdev->dev, hdmi->irq,
+	ret = devm_request_irq(dev->dev, hdmi->irq,
 			msm_hdmi_irq, IRQF_TRIGGER_HIGH,
 			"hdmi_isr", hdmi);
 	if (ret < 0) {

