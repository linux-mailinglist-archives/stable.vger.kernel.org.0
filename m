Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55E86B4B08
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234260AbjCJPaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234162AbjCJP3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:29:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70A6515DA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:18:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 764626197F
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E406C433A4;
        Fri, 10 Mar 2023 14:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459897;
        bh=Jq5PD/8pF/W8fAe2diH5ny8ln+MUEP/FGZzcRbZ1JqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sAg7wDmIHjr2aGvkSiEFnW2pXNV94Xghp9G2sVlioHYKUWh32KNqmqni8tGsEqqSM
         yeRocmp9i5fZ4ccTC7rO90vCzEwakgBtPbl9/clrWhcseaBqVcJjoCJKNIPWkZBeO1
         iJ4N8UbcXVirQ/jy3RB8XqRjULIkSJewtXAzXAW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 157/529] drm/msm/hdmi: Add missing check for alloc_ordered_workqueue
Date:   Fri, 10 Mar 2023 14:35:00 +0100
Message-Id: <20230310133812.230317137@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit afe4cb96153a0d8003e4e4ebd91b5c543e10df84 ]

Add check for the return value of alloc_ordered_workqueue as it may return
NULL pointer and cause NULL pointer dereference in `hdmi_hdcp.c` and
`hdmi_hpd.c`.

Fixes: c6a57a50ad56 ("drm/msm/hdmi: add hdmi hdcp support (V3)")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/517211/
Link: https://lore.kernel.org/r/20230106023011.3985-1-jiasheng@iscas.ac.cn
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index efb14043a6ec4..bee208773beec 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -264,6 +264,10 @@ static struct hdmi *msm_hdmi_init(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 
 	hdmi->workq = alloc_ordered_workqueue("msm_hdmi", 0);
+	if (!hdmi->workq) {
+		ret = -ENOMEM;
+		goto fail;
+	}
 
 	hdmi->i2c = msm_hdmi_i2c_init(hdmi);
 	if (IS_ERR(hdmi->i2c)) {
-- 
2.39.2



