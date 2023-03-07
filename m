Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 813AB6AE9ED
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbjCGR3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:29:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbjCGR2c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:28:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9778497B5B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:23:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35243614DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA21C433D2;
        Tue,  7 Mar 2023 17:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209827;
        bh=02vWBm+mhOMDWp7RWBi6DfF/rLZdRClP5gSKOq/mbpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DohE20YE7OhPUnW/QNtQk9CcLJfpfMjrBP/jWA5fdSxq7Qo5skfG5F/WnJiI9LeG2
         EEhLlvk8elGdK2XPfLhjwroofhOjn28am5s5jBN2IxwiYnyxpxMFXort15PQKJT64J
         0KJMlTuH6zL5lYhO9H6NNCwhm9irC25GwemYfnoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0344/1001] drm/msm/hdmi: Add missing check for alloc_ordered_workqueue
Date:   Tue,  7 Mar 2023 17:51:56 +0100
Message-Id: <20230307170036.390844043@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 97372bb241d89..4ad36bc8fe5ed 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -120,6 +120,10 @@ static int msm_hdmi_init(struct hdmi *hdmi)
 	int ret;
 
 	hdmi->workq = alloc_ordered_workqueue("msm_hdmi", 0);
+	if (!hdmi->workq) {
+		ret = -ENOMEM;
+		goto fail;
+	}
 
 	hdmi->i2c = msm_hdmi_i2c_init(hdmi);
 	if (IS_ERR(hdmi->i2c)) {
-- 
2.39.2



