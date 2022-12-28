Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4668657C9D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbiL1PeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbiL1PeW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:34:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DA516488
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:34:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 637FC6156E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75971C433EF;
        Wed, 28 Dec 2022 15:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241660;
        bh=+jwCzEbmijGYDF6u/I/5dKAOYFtW41xjnpynBR2aAlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aSjYDaGBgeM4U3+yXZF8dJFoBJzAKW+6Wtle3kDcBnqi5qv7r9M13nrKCNJsv792n
         mvQyr9/Far85TEL8DKjy+0pdIAPGK6nr8Jcxspd2H9kF9hr1JdlwV3Iszl5ddYJ6+P
         1bqRnYVErAkNGXJ+q34D1ZMFvzJUa4iAfqwNDp/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0274/1146] drm/msm/hdmi: use devres helper for runtime PM management
Date:   Wed, 28 Dec 2022 15:30:13 +0100
Message-Id: <20221228144337.578711363@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit b964444b2b64ce182495731d830499d1c588ccf6 ]

Use devm_pm_runtime_enable() to enable runtime PM. This way its effect
will be reverted on device unbind/destruction.

Fixes: 6ed9ed484d04 ("drm/msm/hdmi: Set up runtime PM for HDMI")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/499647/
Link: https://lore.kernel.org/r/20220826093927.851597-2-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index f28fb21e3891..8cd5d50639a5 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -252,7 +252,7 @@ static struct hdmi *msm_hdmi_init(struct platform_device *pdev)
 	if (hdmi->hpd_gpiod)
 		gpiod_set_consumer_name(hdmi->hpd_gpiod, "HDMI_HPD");
 
-	pm_runtime_enable(&pdev->dev);
+	devm_pm_runtime_enable(&pdev->dev);
 
 	hdmi->workq = alloc_ordered_workqueue("msm_hdmi", 0);
 
-- 
2.35.1



