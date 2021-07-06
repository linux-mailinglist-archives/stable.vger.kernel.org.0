Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 568493BD4D3
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 14:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238211AbhGFMRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 08:17:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234644AbhGFLb4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:31:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77E2D61D03;
        Tue,  6 Jul 2021 11:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570563;
        bh=jO5Fj70J6WChwvRJpFbt2jPnAaDfe3lQtKl/fuYcpQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m0NYHeCTrQ1Jf6/LdZ8hUqiu7AMgXwFZUpFzloMoW6ODzF7W8M7IfAJ/l0VnmijMi
         AqrIrfctA4Rov1NO4ETK2NgRao3KazGhguKcX8FIIPuSJ3IOAAUcyIS+VtpfMYqQ0V
         TXaRc3ZwHcV7xXeFZqMYkEVCO2ZB6LUZ8IG1lLVWi61jsCQaBlaS7lYbV+gMIIgyIK
         uz6UFz/N1vpyAA9k4FovMGOStDdWfn+Sf6SPsznkhBBjQPxfBnynbqZyFL1XAfzlNE
         vnLBRWegnAsoIbU6jfR8CqZERbMWSFETZRkR5sd6mUeUd/qjrWj7aawZISdMlov3Zn
         rLX2FeGKdKbVw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mateusz Kwiatkowski <kfyatek+publicgit@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 030/137] drm/vc4: Fix clock source for VEC PixelValve on BCM2711
Date:   Tue,  6 Jul 2021 07:20:16 -0400
Message-Id: <20210706112203.2062605-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
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

