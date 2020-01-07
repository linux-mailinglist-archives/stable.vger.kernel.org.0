Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82890133115
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 21:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgAGU5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:57:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:54590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727592AbgAGU52 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:57:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2211E2081E;
        Tue,  7 Jan 2020 20:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430647;
        bh=uqHxD+2OSmIuTXyB391CppfgqjnldoliToKaoB41u3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wph45ApUDKe5JkL2e6Zoo4luShdWeFtCf+/mw5Xu1kZCuPNah0aoKF74ZeQcMXb+B
         vfOtwScG6ywmwadsYQMn5P8RLkCI/OwerBHgu5ltYD/6E4qHLqr0qn2Cxw0dHi1Q3Y
         nILsxvFL609XH85ifE4IKWj4T/oOy9NBQLWXxDGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 038/191] drm/nouveau/kms/nv50-: fix panel scaling
Date:   Tue,  7 Jan 2020 21:52:38 +0100
Message-Id: <20200107205335.035106704@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit 3d1890ef8023e61934e070021b06cc9f417260c0 ]

Under certain circumstances, encoder atomic_check() can be entered
without adjusted_mode having been reset to the same as mode, which
confuses the scaling logic and can lead to a misprogrammed display.

Fix this by checking against the user-provided mode directly.

Link: https://bugs.freedesktop.org/show_bug.cgi?id=108615
Link: https://gitlab.freedesktop.org/xorg/driver/xf86-video-nouveau/issues/464
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index b5b1a34f896f..d735ea7e2d88 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -326,9 +326,9 @@ nv50_outp_atomic_check_view(struct drm_encoder *encoder,
 			 * same size as the native one (e.g. different
 			 * refresh rate)
 			 */
-			if (adjusted_mode->hdisplay == native_mode->hdisplay &&
-			    adjusted_mode->vdisplay == native_mode->vdisplay &&
-			    adjusted_mode->type & DRM_MODE_TYPE_DRIVER)
+			if (mode->hdisplay == native_mode->hdisplay &&
+			    mode->vdisplay == native_mode->vdisplay &&
+			    mode->type & DRM_MODE_TYPE_DRIVER)
 				break;
 			mode = native_mode;
 			asyc->scaler.full = true;
-- 
2.20.1



