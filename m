Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0CC498F9F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242945AbiAXTxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:53:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38884 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357360AbiAXTtw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:49:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CBBAB810AF;
        Mon, 24 Jan 2022 19:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D847C340E5;
        Mon, 24 Jan 2022 19:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053790;
        bh=Hh8VGhYGSCAAIyMqk/0C8kJdzgofq8D1WaPueErDi4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xvpXk4zjsBudtHWXmKClfPpYGFft4RVNuvkOT3RC85RHskFbpmdQ4SgwG198qGXUy
         hRrq8ljouMLlzHD/mTK2d+iolETRlX4YHbKopIlmtiMCeeAQpR4AbMYEq4cHyzCuuE
         y1UXP38m72e0OO3dH7zYUmTdKHwwt2rrvjjl0uUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernelbot <kernel-bot@kylinos.cn>,
        Jackie Liu <liuyun01@kylinos.cn>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 146/563] drm/msm/dp: displayPort driver need algorithm rational
Date:   Mon, 24 Jan 2022 19:38:31 +0100
Message-Id: <20220124184029.449876198@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jackie Liu <liuyun01@kylinos.cn>

[ Upstream commit 53d22794711ad630f40d59dd726bd260d77d585f ]

Let's select RATIONAL with dp driver. avoid like:

[...]
x86_64-linux-gnu-ld: drivers/gpu/drm/msm/dp/dp_catalog.o: in function `dp_catalog_ctrl_config_msa':
dp_catalog.c:(.text+0x57e): undefined reference to `rational_best_approximation'

Fixes: c943b4948b58 ("drm/msm/dp: add displayPort driver support")
Reported-by: kernelbot <kernel-bot@kylinos.cn>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Link: https://lore.kernel.org/r/20211110070950.3355597-2-liu.yun@linux.dev
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/msm/Kconfig b/drivers/gpu/drm/msm/Kconfig
index dabb4a1ccdcf7..1aad34b5ffd7f 100644
--- a/drivers/gpu/drm/msm/Kconfig
+++ b/drivers/gpu/drm/msm/Kconfig
@@ -60,6 +60,7 @@ config DRM_MSM_HDMI_HDCP
 config DRM_MSM_DP
 	bool "Enable DisplayPort support in MSM DRM driver"
 	depends on DRM_MSM
+	select RATIONAL
 	default y
 	help
 	  Compile in support for DP driver in MSM DRM driver. DP external
-- 
2.34.1



