Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37CE61F2BD9
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbgFHXR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:17:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:39980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730555AbgFHXR4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:17:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA9BF2085B;
        Mon,  8 Jun 2020 23:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658276;
        bh=g3sscGhPq9hLVmx658tAsrUj80UrMHlDSMwYPWU6Ecw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hpyVo0R2QwBTmADYYKeZaTIe1ytenBwy4ToGUc6prGREGjbAbM0kKdcm3SQIEgfp4
         TuoeTgOLS1bqVo2H+OCaIVZpAJ13637Scb622q/tsWmDlzknJR/32KLZIbV+PRem4m
         gNNmMBeelFxe2Z9Exx8D3qgF7PDant83GQk5p61Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bernard Zhao <bernard@vivo.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 282/606] drm/meson: pm resume add return errno branch
Date:   Mon,  8 Jun 2020 19:06:47 -0400
Message-Id: <20200608231211.3363633-282-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bernard Zhao <bernard@vivo.com>

[ Upstream commit c54a8f1f329197d83d941ad84c4aa38bf282cbbd ]

pm_resump api did not handle drm_mode_config_helper_resume error.
This change add handle to return drm_mode_config_helper_resume`s
error number. This code logic is aligned with api pm_suspend.
After this change, the code maybe a bit readable.

Signed-off-by: Bernard Zhao <bernard@vivo.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200428131747.2099-1-bernard@vivo.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_drv.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/meson/meson_drv.c b/drivers/gpu/drm/meson/meson_drv.c
index b5f5eb7b4bb9..8c2e1b47e81a 100644
--- a/drivers/gpu/drm/meson/meson_drv.c
+++ b/drivers/gpu/drm/meson/meson_drv.c
@@ -412,9 +412,7 @@ static int __maybe_unused meson_drv_pm_resume(struct device *dev)
 	if (priv->afbcd.ops)
 		priv->afbcd.ops->init(priv);
 
-	drm_mode_config_helper_resume(priv->drm);
-
-	return 0;
+	return drm_mode_config_helper_resume(priv->drm);
 }
 
 static int compare_of(struct device *dev, void *data)
-- 
2.25.1

