Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4D63CAAE9
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244400AbhGOTQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:16:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244747AbhGOTPN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:15:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5D8E61406;
        Thu, 15 Jul 2021 19:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376276;
        bh=Xq9+RcqxqciyxgEScOP8qdfipj9wOF0O4LK0toNgIu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qcTCJU3uqBx9nUYa8hFAHfhAqa1oRn42A0899HsLkcAJj5bXPv/2Wf/1DlCOuHNfP
         Ccv/QAjPRpJ3j13z2YM7DqkLNCAvfXD6Y3Su6pCdbD6IHRY2Wg6OktOlil8FzAz3WE
         DJ24jjcvnCcv5LBR42DhDXMsFbhWWZGMRyKjMp3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        "H . Nikolaus Schaller" <hns@goldelico.com>
Subject: [PATCH 5.13 200/266] drm/ingenic: Fix pixclock rate for 24-bit serial panels
Date:   Thu, 15 Jul 2021 20:39:15 +0200
Message-Id: <20210715182645.600691101@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit 60a6b73dd821e98fe958b2a83393ccd724b306b1 upstream.

When using a 24-bit panel on a 8-bit serial bus, the pixel clock
requested by the panel has to be multiplied by 3, since the subpixels
are shifted sequentially.

The code (in ingenic_drm_encoder_atomic_check) already computed
crtc_state->adjusted_mode->crtc_clock accordingly, but clk_set_rate()
used crtc_state->adjusted_mode->clock instead.

Fixes: 28ab7d35b6e0 ("drm/ingenic: Properly compute timings when using a 3x8-bit panel")
Cc: stable@vger.kernel.org # v5.10
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Tested-by: H. Nikolaus Schaller <hns@goldelico.com>	# CI20/jz4780 (HDMI) and Alpha400/jz4730 (LCD)
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20210323144008.166248-1-paul@crapouillou.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/ingenic/ingenic-drm-drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
@@ -342,7 +342,7 @@ static void ingenic_drm_crtc_atomic_flus
 	if (priv->update_clk_rate) {
 		mutex_lock(&priv->clk_mutex);
 		clk_set_rate(priv->pix_clk,
-			     crtc_state->adjusted_mode.clock * 1000);
+			     crtc_state->adjusted_mode.crtc_clock * 1000);
 		priv->update_clk_rate = false;
 		mutex_unlock(&priv->clk_mutex);
 	}


