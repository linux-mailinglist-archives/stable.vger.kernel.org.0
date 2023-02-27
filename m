Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00D056A3929
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbjB0C6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbjB0C6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:58:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB3E7A96;
        Sun, 26 Feb 2023 18:58:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7A12B80D1E;
        Mon, 27 Feb 2023 02:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0078AC4339E;
        Mon, 27 Feb 2023 02:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463879;
        bh=PQNw72DCGaZXLXmZzkGwEP0TtMW72AT5i8oK2oJciKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HxwvgBjWfPEF51yf03QjDt8NFpNx+/B/yxyXOTGhoUsvqKgLe4AW0SfcKXj46hpNw
         cbWlH8OLrH0LwRrtvBpzoGDOjFCfQC45zLjqYUhPgM9NRFO+dPqnhoh93kLCMlz/e4
         xKSg2oArXy8u9HhtO2VUEv5TG9pnCxygWvbCHXCYEr+DUuPRsgu1Bnr24tUojNXybH
         18XsdxkmUvh+0iYRJoyyF2ia7mQbBee1SUwrteRZgyMe0nayO48ow4Vt4/pstzwAmg
         7KSzZjrk5BZL/1m/rYC9SO9zEeEtRRt7fwDo2XuA3a/7BlDOBRXlyPty6/ddzELIlp
         oRIv/KZXqPAVg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robdclark@gmail.com,
        airlied@gmail.com, daniel@ffwll.ch, marijn.suijten@somainline.org,
        vkoul@kernel.org, dianders@chromium.org, marex@denx.de,
        vladimir.lypak@gmail.com, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 03/10] drm/msm/dsi: Add missing check for alloc_ordered_workqueue
Date:   Sun, 26 Feb 2023 21:11:00 -0500
Message-Id: <20230227021110.1053474-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227021110.1053474-1-sashal@kernel.org>
References: <20230227021110.1053474-1-sashal@kernel.org>
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
index 56cfa0a03fd5b..059578faa1c6d 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1883,6 +1883,9 @@ int msm_dsi_host_init(struct msm_dsi *msm_dsi)
 
 	/* setup workqueue */
 	msm_host->workqueue = alloc_ordered_workqueue("dsi_drm_work", 0);
+	if (!msm_host->workqueue)
+		return -ENOMEM;
+
 	INIT_WORK(&msm_host->err_work, dsi_err_worker);
 	INIT_WORK(&msm_host->hpd_work, dsi_hpd_worker);
 
-- 
2.39.0

