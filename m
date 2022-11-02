Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5058661598D
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbiKBDNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbiKBDNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:13:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A7E22BD5
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:13:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE27CB82063
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97A0C433D7;
        Wed,  2 Nov 2022 03:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358778;
        bh=lUC5X3iSFGZQmbNEdUfRZ/ahLgK0KyzBUvTQ9XIl5jY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nUcUf8ApCQDmNVt9ZUlAlPPGVIZawz4x68m99yxNCM79BSAMbbj+OE3f0aqodKGkd
         SNhMl45RylYsDEr/+tfL56Dyzn6Mz4j2oTeOKjZPPeM/lV8ueTQs/opSn4u5cBqAfL
         Q/Gm7YepLJC+o3KFk8zzWv+Mwe4F1z0gAVzC7Vm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>
Subject: [PATCH 5.10 24/91] drm/msm/dp: fix IRQ lifetime
Date:   Wed,  2 Nov 2022 03:33:07 +0100
Message-Id: <20221102022055.734505041@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
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
@@ -1201,7 +1201,7 @@ int dp_display_request_irq(struct msm_dp
 		return -EINVAL;
 	}
 
-	rc = devm_request_irq(&dp->pdev->dev, dp->irq,
+	rc = devm_request_irq(dp_display->drm_dev->dev, dp->irq,
 			dp_display_irq_handler,
 			IRQF_TRIGGER_HIGH, "dp_display_isr", dp);
 	if (rc < 0) {


