Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA6E5488B6
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244615AbiFMKpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347299AbiFMKnv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:43:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FD3201A8;
        Mon, 13 Jun 2022 03:25:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E9C3B80E90;
        Mon, 13 Jun 2022 10:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59D1C34114;
        Mon, 13 Jun 2022 10:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115905;
        bh=9ythTDZkGeWLz6qsU2TVMuvmR0x6chpVk0Z79NBNNjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w/pG/8vfTb0+tpDwp4ra9ZsAYK2f588/Z8bq4kCuPauqe4U+J7GQbaAelsrYVb6kP
         WXqmhV/IdoMX4g9VcBbot+Ghvy4kz8pmcGSCzNNUZoa6MB3Ocp6GNE0rXXuN+QBeZI
         koqLHyLghxUVrHokfMRqEmSgDJbBjbWraSkQyKoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 063/218] drm/msm/hdmi: check return value after calling platform_get_resource_byname()
Date:   Mon, 13 Jun 2022 12:08:41 +0200
Message-Id: <20220613094921.683399799@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
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
index 17e069a133a4..0df62c9c2856 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -148,6 +148,10 @@ static struct hdmi *msm_hdmi_init(struct platform_device *pdev)
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



