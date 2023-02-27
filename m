Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7AAA6A369B
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjB0CDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:03:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjB0CDD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:03:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2055113D58;
        Sun, 26 Feb 2023 18:02:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B84760CF9;
        Mon, 27 Feb 2023 02:02:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CA2C433EF;
        Mon, 27 Feb 2023 02:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463350;
        bh=DVf1owl9PG8lHLbeynhccmcJN+TFk0IBBZSEKPXqKsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PT5rzq/msA1tASm7jn1kVoKHZS4xJNqjy2WGlDYaUznouGGXd/RuXVsNfZHK26P+T
         lG6uIWT168eXcsvDJoU0LF5WAsTnWWxvJwaVTIy5XiT+q0Bc3KpGnGCRrAOsXIoZsP
         O+Kx3Diym/TWGfCDScJFo2iZ4KEFgYOA1ow7KNnFqSmCCbSiYpAhOb8tpM8wXWNmPE
         Jhy5GuCdoTQ96EkeVGmP/Vtcq8OQqOjASciGATBjpHTT2fLcJFxTGDT8Om/oPmri4k
         15zb9fPk3v75PygVL8gkfEF/ZTVZ66TRDOROLCODNc8zDQiiN5MBM1M4cWKNHWckkt
         YkEdH0gI7Mdlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robdclark@gmail.com,
        airlied@gmail.com, daniel@ffwll.ch, marijn.suijten@somainline.org,
        vkoul@kernel.org, dianders@chromium.org, vladimir.lypak@gmail.com,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.2 24/60] drm/msm/dsi: Add missing check for alloc_ordered_workqueue
Date:   Sun, 26 Feb 2023 21:00:09 -0500
Message-Id: <20230227020045.1045105-24-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020045.1045105-1-sashal@kernel.org>
References: <20230227020045.1045105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 115906ca7b535afb1fe7b5406c566ccd3873f82b ]

Add check for the return value of alloc_ordered_workqueue as it may return
NULL pointer and cause NULL pointer dereference.

Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/517646/
Link: https://lore.kernel.org/r/20230110021651.12770-1-jiasheng@iscas.ac.cn
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 89aadd3b3202b..f167a45f1fbdd 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1977,6 +1977,9 @@ int msm_dsi_host_init(struct msm_dsi *msm_dsi)
 
 	/* setup workqueue */
 	msm_host->workqueue = alloc_ordered_workqueue("dsi_drm_work", 0);
+	if (!msm_host->workqueue)
+		return -ENOMEM;
+
 	INIT_WORK(&msm_host->err_work, dsi_err_worker);
 
 	msm_dsi->id = msm_host->id;
-- 
2.39.0

