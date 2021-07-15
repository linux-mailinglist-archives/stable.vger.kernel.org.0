Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664503CA87A
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241920AbhGOTBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:01:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242355AbhGOS7i (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:59:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59C78613DD;
        Thu, 15 Jul 2021 18:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375400;
        bh=XrNhZrT/so2mBc0pNO1Elrniy1r5sRuyCJAA5Pv1jJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SnRvS1UwZXKPeyTextWn4GW7oc+ldJvD+OjGKsvHt1Xe9WruqBpo7sbtrwJd3MfMC
         Ks+YfgnXfCw/U7psycT+brhgDXHbn03B9F33G9ZGkmexJhYUmwA/ipnkXHI6MjljGy
         WdiaoLXj/zXEbH8SPssEcXhxYY7vmr9yFXaKRROw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mateusz Kwiatkowski <kfyatek+publicgit@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 029/242] drm/vc4: Fix clock source for VEC PixelValve on BCM2711
Date:   Thu, 15 Jul 2021 20:36:31 +0200
Message-Id: <20210715182557.051336121@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mateusz Kwiatkowski <kfyatek+publicgit@gmail.com>

[ Upstream commit fc7a8abcee2225d6279ff785d33e24d70c738c6e ]

On the BCM2711 (Raspberry Pi 4), the VEC is actually connected to
output 2 of pixelvalve3.

NOTE: This contradicts the Broadcom docs, but has been empirically
tested and confirmed by Raspberry Pi firmware devs.

Signed-off-by: Mateusz Kwiatkowski <kfyatek+publicgit@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210520150344.273900-2-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_crtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_crtc.c b/drivers/gpu/drm/vc4/vc4_crtc.c
index 1f36b67cd6ce..e0fd9b74baae 100644
--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -1035,7 +1035,7 @@ static const struct vc4_pv_data bcm2711_pv3_data = {
 	.fifo_depth = 64,
 	.pixels_per_clock = 1,
 	.encoder_types = {
-		[0] = VC4_ENCODER_TYPE_VEC,
+		[PV_CONTROL_CLK_SELECT_VEC] = VC4_ENCODER_TYPE_VEC,
 	},
 };
 
-- 
2.30.2



