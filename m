Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836E86157E1
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiKBCku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiKBCku (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:40:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64AA31FCF2
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:40:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08D57B82070
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0079C433D6;
        Wed,  2 Nov 2022 02:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356846;
        bh=Xk3UH9DcS44YKTrwdlnBBl3BoafMsh4owwttoKMvTpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L1i17r07JX7vE28XpxOWaEV+EAQz3MUivt3TsdyyAEIUyANjDjx6E+JgLIjxj7Cyb
         wBxzC4DZ3u5quMYpFex5o+09ZbAz518qbs7OEb/8D/abtDvZeVhnVOsEKJyaKMe0Fn
         76wLjREj0yGR1KKnPYhhRVMlTSWoyP6I20G+trLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>
Subject: [PATCH 6.0 070/240] drm/msm/hdmi: fix IRQ lifetime
Date:   Wed,  2 Nov 2022 03:30:45 +0100
Message-Id: <20221102022112.985075619@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
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

commit 152d394842bb564148e68b92486a87db0bf54859 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -344,7 +344,7 @@ int msm_hdmi_modeset_init(struct hdmi *h
 		goto fail;
 	}
 
-	ret = devm_request_irq(&pdev->dev, hdmi->irq,
+	ret = devm_request_irq(dev->dev, hdmi->irq,
 			msm_hdmi_irq, IRQF_TRIGGER_HIGH,
 			"hdmi_isr", hdmi);
 	if (ret < 0) {


