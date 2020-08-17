Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B021F247657
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730022AbgHQP2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:28:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730019AbgHQP2m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:28:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2CAF233CF;
        Mon, 17 Aug 2020 15:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678121;
        bh=JrYOhwWwwmrReXwB+ZeyDYHuIP3lqKqROWwbKCFhgOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G6G3hS/yzj9jpcf5dQnbsJCcgsOFcPTAKvn9t6vVbOxL9oY8AaZDL2FggLJ+23P40
         EmKaP7k/Y5gmHdGp8YTxNEC6vovO7qKwptBm4pE5YsLXUZq4egncZxsa3F0T+QPVF8
         Se4r3NFyr7Wgrqto3OlFxNT8e6kne4KoPcqjBeSs=
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
Subject: [PATCH 5.8 218/464] drm/stm: repair runtime power management
Date:   Mon, 17 Aug 2020 17:12:51 +0200
Message-Id: <20200817143844.245721026@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
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
index f894968d6e452..3f590d916e916 100644
--- a/drivers/gpu/drm/stm/ltdc.c
+++ b/drivers/gpu/drm/stm/ltdc.c
@@ -423,9 +423,12 @@ static void ltdc_crtc_atomic_enable(struct drm_crtc *crtc,
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



