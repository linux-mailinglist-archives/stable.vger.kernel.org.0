Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44FC3247366
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388551AbgHQSzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:55:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730911AbgHQPvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:51:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7400208B3;
        Mon, 17 Aug 2020 15:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679468;
        bh=G1OvFEXrou1OJyh/zOo3R3BvFhcRVwtwoYVL1FhzfHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DnX9422z/TZdcNBww480J/8EQgWZ+feQJVs+RTiFrYaLToarJusoeLPH3BzNsFCeX
         /ehlCdrXvxDBj8w7vQ6xT1xWcJVX32DOv8cJ6CpFHyGLM7cLL7h5foH/YbTz2h4pFp
         2+y+1EQoWHD5KTa+BwCwbI/yP85ZcTDUFEnL6M9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        =?UTF-8?q?Yannick=20Fertr=C3=A9?= <yannick.fertre@st.com>,
        Philippe Cornu <philippe.cornu@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Vincent Abriou <vincent.abriou@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Gaignard <benjamin.gaignard@st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 192/393] drm/stm: repair runtime power management
Date:   Mon, 17 Aug 2020 17:14:02 +0200
Message-Id: <20200817143828.935241948@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit ebd267b2e3c25d5f93a08528b47c036569eb8744 ]

Add missing pm_runtime_get_sync() into ltdc_crtc_atomic_enable() to
match pm_runtime_put_sync() in ltdc_crtc_atomic_disable(), otherwise
the LTDC might suspend via runtime PM, disable clock, and then fail
to resume later on.

The test which triggers it is roughly -- run qt5 application which
uses eglfs platform and etnaviv, stop the application, sleep for 15
minutes, run the application again. This leads to a timeout waiting
for vsync, because the LTDC has suspended, but did not resume.

Fixes: 35ab6cfbf211 ("drm/stm: support runtime power management")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Yannick Fertré <yannick.fertre@st.com>
Cc: Philippe Cornu <philippe.cornu@st.com>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: Vincent Abriou <vincent.abriou@st.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Acked-by: Philippe Cornu <philippe.cornu@st.com>
Tested-by: Yannick Fertre <yannick.fertre@st.com>
Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200229221649.90813-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/stm/ltdc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/stm/ltdc.c b/drivers/gpu/drm/stm/ltdc.c
index df585fe64f614..60ffe5bbc1294 100644
--- a/drivers/gpu/drm/stm/ltdc.c
+++ b/drivers/gpu/drm/stm/ltdc.c
@@ -425,9 +425,12 @@ static void ltdc_crtc_atomic_enable(struct drm_crtc *crtc,
 				    struct drm_crtc_state *old_state)
 {
 	struct ltdc_device *ldev = crtc_to_ltdc(crtc);
+	struct drm_device *ddev = crtc->dev;
 
 	DRM_DEBUG_DRIVER("\n");
 
+	pm_runtime_get_sync(ddev->dev);
+
 	/* Sets the background color value */
 	reg_write(ldev->regs, LTDC_BCCR, BCCR_BCBLACK);
 
-- 
2.25.1



