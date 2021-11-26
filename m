Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6E545E541
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 03:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358445AbhKZClQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:41:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:48184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357840AbhKZCjO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:39:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E889C61212;
        Fri, 26 Nov 2021 02:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894031;
        bh=KWxXtW72Tj7fGimpSt36yqmxv90yxBqm44E4kmS6tPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TvWZ1/5GXv1XQb2M7BYcdxSgGjNiX34N+lUUyLAT8Cu9PsjDc6CVbBkl7PGLNjR4w
         xEn/2Nox+glHpHGhpz75feN/JWb9UcqyXAOrfAckxhGqblIN+OF5eVNVZnZRskJPs9
         Srf2AuhZtVhM9V/CEOsg95J0CNzL67jR5SV1dIyUjpo+ENs0sEaLLUBFwnS+9f8yfm
         2NossODChhXOz73sZe1QzszoOOMe0OXT3gAK/IZw0btOkn0p6m2Ig7jbc7wJtvZq7e
         UvNOTEZL62/ejGHFfyik69CQSdREfRtY0nT0P+LgNuhcp+zJ72a7CG5DeiWLK0fLAI
         OVongqvRatWAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Braha <julianbraha@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>, mripard@kernel.org,
        wens@csie.org, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 04/28] drm/sun4i: fix unmet dependency on RESET_CONTROLLER for PHY_SUN6I_MIPI_DPHY
Date:   Thu, 25 Nov 2021 21:33:19 -0500
Message-Id: <20211126023343.442045-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023343.442045-1-sashal@kernel.org>
References: <20211126023343.442045-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Braha <julianbraha@gmail.com>

[ Upstream commit bb162bb2b4394108c8f055d1b115735331205e28 ]

When PHY_SUN6I_MIPI_DPHY is selected, and RESET_CONTROLLER
is not selected, Kbuild gives the following warning:

WARNING: unmet direct dependencies detected for PHY_SUN6I_MIPI_DPHY
  Depends on [n]: (ARCH_SUNXI [=n] || COMPILE_TEST [=y]) && HAS_IOMEM [=y] && COMMON_CLK [=y] && RESET_CONTROLLER [=n]
  Selected by [y]:
  - DRM_SUN6I_DSI [=y] && HAS_IOMEM [=y] && DRM_SUN4I [=y]

This is because DRM_SUN6I_DSI selects PHY_SUN6I_MIPI_DPHY
without selecting or depending on RESET_CONTROLLER, despite
PHY_SUN6I_MIPI_DPHY depending on RESET_CONTROLLER.

These unmet dependency bugs were detected by Kismet,
a static analysis tool for Kconfig. Please advise if this
is not the appropriate solution.

v2:
Fixed indentation to match the rest of the file.

Signed-off-by: Julian Braha <julianbraha@gmail.com>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20211109032351.43322-1-julianbraha@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/sun4i/Kconfig b/drivers/gpu/drm/sun4i/Kconfig
index 5755f0432e774..8c796de53222c 100644
--- a/drivers/gpu/drm/sun4i/Kconfig
+++ b/drivers/gpu/drm/sun4i/Kconfig
@@ -46,6 +46,7 @@ config DRM_SUN6I_DSI
 	default MACH_SUN8I
 	select CRC_CCITT
 	select DRM_MIPI_DSI
+	select RESET_CONTROLLER
 	select PHY_SUN6I_MIPI_DPHY
 	help
 	  Choose this option if you want have an Allwinner SoC with
-- 
2.33.0

