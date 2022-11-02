Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71D046158EB
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbiKBDBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbiKBDBC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:01:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5A122BD6
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:01:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19FC3617BB
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:01:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A30C433D7;
        Wed,  2 Nov 2022 03:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358060;
        bh=Qi4E2WLVFBRD6CAq6Cm05ezMz6GOnSdgY30B1zJzsLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0hbiXmVpPdpUfcE2M+/8R3AO+BFlXfR10Z6D5+D0oGHEUATrlsIrds2uVRjOe7mYl
         dHos9S+qA9gmvSKyTXKypGu2A63SU1JbttW/sEFtljlshE8lEWYdE2x+zx+5zvAbN0
         Ip3GL74nDFq4rlO+63PmvBXwIytUO3Pt//RJh0jU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>
Subject: [PATCH 5.15 034/132] drm/msm/dp: fix IRQ lifetime
Date:   Wed,  2 Nov 2022 03:32:20 +0100
Message-Id: <20221102022100.529985008@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

commit a79343dcaba4b11adb57350e0b6426906a9b658e upstream.

Device-managed resources allocated post component bind must be tied to
the lifetime of the aggregate DRM device or they will not necessarily be
released when binding of the aggregate device is deferred.

This is specifically true for the DP IRQ, which will otherwise remain
requested so that the next bind attempt fails when requesting the IRQ a
second time.

Since commit c3bf8e21b38a ("drm/msm/dp: Add eDP support via aux_bus")
this can happen when the aux-bus panel driver has not yet been loaded so
that probe is deferred.

Fix this by tying the device-managed lifetime of the DP IRQ to the DRM
device so that it is released when bind fails.

Fixes: c943b4948b58 ("drm/msm/dp: add displayPort driver support")
Cc: stable@vger.kernel.org      # 5.10
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/502679/
Link: https://lore.kernel.org/r/20220913085320.8577-6-johan+linaro@kernel.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -1229,7 +1229,7 @@ int dp_display_request_irq(struct msm_dp
 		return -EINVAL;
 	}
 
-	rc = devm_request_irq(&dp->pdev->dev, dp->irq,
+	rc = devm_request_irq(dp_display->drm_dev->dev, dp->irq,
 			dp_display_irq_handler,
 			IRQF_TRIGGER_HIGH, "dp_display_isr", dp);
 	if (rc < 0) {


