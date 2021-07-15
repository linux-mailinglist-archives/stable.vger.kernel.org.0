Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446B63CA6B8
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238617AbhGOSuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240220AbhGOStW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:49:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8DAA613E7;
        Thu, 15 Jul 2021 18:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374789;
        bh=jO5Fj70J6WChwvRJpFbt2jPnAaDfe3lQtKl/fuYcpQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ub0lWyuIZyQKKbOgNxxYVQUwo8H+x3bIW9WBO73Hh2IX5oNLM6TByo+L/dkV8iucP
         WEXCehTFmM2Ik0DWT0NrabgrP3CVIj10y3JOXEDddDtHG+g5U5paZ8nRWVq0EFDiWJ
         mygyH1aSYpiQOR8hv46rAnsVc/BEsVFEWIOpn4Cw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mateusz Kwiatkowski <kfyatek+publicgit@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/215] drm/vc4: Fix clock source for VEC PixelValve on BCM2711
Date:   Thu, 15 Jul 2021 20:36:39 +0200
Message-Id: <20210715182603.747555360@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
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
index 1d2416d466a3..7062d0e6fe76 100644
--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -1001,7 +1001,7 @@ static const struct vc4_pv_data bcm2711_pv3_data = {
 	.fifo_depth = 64,
 	.pixels_per_clock = 1,
 	.encoder_types = {
-		[0] = VC4_ENCODER_TYPE_VEC,
+		[PV_CONTROL_CLK_SELECT_VEC] = VC4_ENCODER_TYPE_VEC,
 	},
 };
 
-- 
2.30.2



