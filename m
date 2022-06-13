Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223DD5492D0
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242067AbiFMKTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242282AbiFMKSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:18:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0896ADF00;
        Mon, 13 Jun 2022 03:16:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99A0E614BF;
        Mon, 13 Jun 2022 10:16:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A144FC34114;
        Mon, 13 Jun 2022 10:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115366;
        bh=iT6aY+Ql7xXTk66FgNAFEfbUcnt+A+eNFO9WQN8pcgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zGmh/rOcejdUc6pYlVW8+/W91xTotb6A9Ac+jKSUaWJtw+akHScHYhlzQvrjBAsLw
         zprYc4yyZ5izwsE6WS+y28lKZH4SxHWk7SLLeYN1RQ/o+WLjUxjRBHK+LwtaDpEbKC
         O3oEdJ5rjAuW5ev0C6Ly0Z+0qLOib8r3Ie9hT77k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 048/167] drm/msm/hdmi: check return value after calling platform_get_resource_byname()
Date:   Mon, 13 Jun 2022 12:08:42 +0200
Message-Id: <20220613094852.247380218@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
References: <20220613094840.720778945@linuxfoundation.org>
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
index a968cad509c2..48ab46726707 100644
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



