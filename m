Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C2E540ACB
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234487AbiFGSXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352319AbiFGSRC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:17:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E3C813FD;
        Tue,  7 Jun 2022 10:51:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82111B82340;
        Tue,  7 Jun 2022 17:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00464C385A5;
        Tue,  7 Jun 2022 17:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624280;
        bh=AI/iVe3KrISAP57OND7nI90CL8ueWm70r7ufJnFkhww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MFqjKqKjW3fGCeKCDGkfi4ndl/nr3vShriXZiluHxQRWqAgvoMk193yUTTb3+8cLv
         QEvA5tvp4KVlNrCsxTMgjnmcodVKxSRl4PMcyeRcgsnwenFur5vj9oihNkvYXnhZ3j
         7dZkCDX6gipjHllmafAu2VJAEWUe7HFmZhcYwsm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 271/667] drm/msm/hdmi: check return value after calling platform_get_resource_byname()
Date:   Tue,  7 Jun 2022 18:58:56 +0200
Message-Id: <20220607164942.914189510@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit a36e506711548df923ceb7ec9f6001375be799a5 ]

It will cause null-ptr-deref if platform_get_resource_byname() returns NULL,
we need check the return value.

Fixes: c6a57a50ad56 ("drm/msm/hdmi: add hdmi hdcp support (V3)")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/482992/
Link: https://lore.kernel.org/r/20220422032227.2991553-1-yangyingliang@huawei.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index d5a80fa3e625..c3d95e7af1e4 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -144,6 +144,10 @@ static struct hdmi *msm_hdmi_init(struct platform_device *pdev)
 	/* HDCP needs physical address of hdmi register */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
 		config->mmio_name);
+	if (!res) {
+		ret = -EINVAL;
+		goto fail;
+	}
 	hdmi->mmio_phy_addr = res->start;
 
 	hdmi->qfprom_mmio = msm_ioremap(pdev,
-- 
2.35.1



