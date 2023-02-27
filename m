Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74E86A3897
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbjB0CbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbjB0CbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:31:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C996B1EBDE;
        Sun, 26 Feb 2023 18:28:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5296ACE0F4C;
        Mon, 27 Feb 2023 02:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F1EC433EF;
        Mon, 27 Feb 2023 02:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463772;
        bh=bJsrmwNRnazNjOb4CR0aliKEV+9KZrk49a1BvMKGwbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pqXjNQr35h7wNvPySG71mXHbXdqCb9hg2QoukyWw8grXs6GgmbJnRx819g+vBUiYk
         7esqIs6Y3ORGXfhwReHoDICvpdZ7Oswinj8UUHMZohJWJo72XLD9E1txzixGmaNEYF
         IHwtRoYIST+SStrVGsqzxw/reFTy32TGemvSzwFAeWMwsjBLbTIDDq/kNVj4AYM8Rt
         U+RCOm1ULkSYi7o6LPSOfThcGFxrm/3TTNFmCW6GCf64bEZZo3b1R+xpUeceXSdnvA
         nOeW3RtlDSqHQZI1ytMw6AFX8TndzQp6HEJ51WjiDQUiTDM+7jNHtp2hoNS4mRWCxA
         K5nRjfBggm/Uw==
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
Subject: [PATCH AUTOSEL 5.15 11/25] drm/msm/dsi: Add missing check for alloc_ordered_workqueue
Date:   Sun, 26 Feb 2023 21:08:34 -0500
Message-Id: <20230227020855.1051605-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020855.1051605-1-sashal@kernel.org>
References: <20230227020855.1051605-1-sashal@kernel.org>
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
index eb60ce125a1fc..d3ec4d67a9a35 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1929,6 +1929,9 @@ int msm_dsi_host_init(struct msm_dsi *msm_dsi)
 
 	/* setup workqueue */
 	msm_host->workqueue = alloc_ordered_workqueue("dsi_drm_work", 0);
+	if (!msm_host->workqueue)
+		return -ENOMEM;
+
 	INIT_WORK(&msm_host->err_work, dsi_err_worker);
 	INIT_WORK(&msm_host->hpd_work, dsi_hpd_worker);
 
-- 
2.39.0

