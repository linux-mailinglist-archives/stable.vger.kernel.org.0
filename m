Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12443BCEFC
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234490AbhGFL1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:27:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234908AbhGFLZN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:25:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36B3E61D2F;
        Tue,  6 Jul 2021 11:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570352;
        bh=jsq9Lm87mEaGrOMSoJNKmgrmnj6vOX9jZw1y6QOjEsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VIzSFby6c8AR8/z8wnI6IjnRy+FnhloF/yDAYXm/fOsVyOU8Bpgtu2i+wLYZMKQ7X
         5ahqFJ7IGOwqpFh/wNXqg0docs23PWXWlrQXxeVi/A/uNRYJUfj6p0IA9e4kT9EfrM
         AvHbpx7mEq6xxaBcqS3NcJgIE94trQ7vvTv/ab3I3xVWfjWgQNywQpT2pKkC2D54S9
         132ZOzkYCLfKaXZ6lf/HRt0VlXt1kEXOvjbFJMwa8puK4/RdQmOyz+EncNjZjG0Q8x
         pJaO2AHiHj9h9aLCqyrIxXXxAlJ8ntIQ6py7O9Zlq5yuXekpsH1Fw+ePUB6YEvcWUn
         vGZooZdYkNDCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mateusz Kwiatkowski <kfyatek+publicgit@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 034/160] drm/vc4: Fix clock source for VEC PixelValve on BCM2711
Date:   Tue,  6 Jul 2021 07:16:20 -0400
Message-Id: <20210706111827.2060499-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 76657dcdf9b0..665ddf8f347f 100644
--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -994,7 +994,7 @@ static const struct vc4_pv_data bcm2711_pv3_data = {
 	.fifo_depth = 64,
 	.pixels_per_clock = 1,
 	.encoder_types = {
-		[0] = VC4_ENCODER_TYPE_VEC,
+		[PV_CONTROL_CLK_SELECT_VEC] = VC4_ENCODER_TYPE_VEC,
 	},
 };
 
-- 
2.30.2

