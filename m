Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29732451391
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348432AbhKOTwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:52:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343654AbhKOTVd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC456614C8;
        Mon, 15 Nov 2021 18:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001834;
        bh=z9QwL5HwRKZ+/ViqNjUBwRoqcec4cU+9+jk6UoW8e88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jt9AMf+5wJxiPKkXYB6nmb15kBLjOUBPSy7dnh6MfPP7j6vkkUSQNbpnftco34VpL
         NGfcI2A9ihrXa/1vc6mcNI4sRMmomPfyNzGXCCy5gRRn7da+ApCnCVU2/SbUPp7Op6
         bt6FiyUtE2qfZt0HhROIoIutfCwGxCRtLR/IwaFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Iago Toral Quiroga <itoral@igalia.com>,
        Melissa Wen <mwen@igalia.com>,
        Melissa Wen <melissa.srw@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 337/917] drm/v3d: fix wait for TMU write combiner flush
Date:   Mon, 15 Nov 2021 17:57:12 +0100
Message-Id: <20211115165440.180197487@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Iago Toral Quiroga <itoral@igalia.com>

[ Upstream commit e4f868191138975f2fdf2f37c11318b47db4acc9 ]

The hardware sets the TMUWCF bit back to 0 when the TMU write
combiner flush completes so we should be checking for that instead
of the L2TFLS bit.

v2 (Melissa Wen):
  - Add Signed-off-by and Fixes tags.
  - Change the error message for the timeout to be more clear.

Fixes spurious Vulkan CTS failures in:
dEQP-VK.binding_model.descriptorset_random.*

Fixes: d223f98f02099 ("drm/v3d: Add support for compute shader dispatch.")
Signed-off-by: Iago Toral Quiroga <itoral@igalia.com>
Reviewed-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Melissa Wen <melissa.srw@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210915100507.3945-1-itoral@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_gem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/v3d/v3d_gem.c b/drivers/gpu/drm/v3d/v3d_gem.c
index 5689da118197e..772b5831bcc6f 100644
--- a/drivers/gpu/drm/v3d/v3d_gem.c
+++ b/drivers/gpu/drm/v3d/v3d_gem.c
@@ -197,8 +197,8 @@ v3d_clean_caches(struct v3d_dev *v3d)
 
 	V3D_CORE_WRITE(core, V3D_CTL_L2TCACTL, V3D_L2TCACTL_TMUWCF);
 	if (wait_for(!(V3D_CORE_READ(core, V3D_CTL_L2TCACTL) &
-		       V3D_L2TCACTL_L2TFLS), 100)) {
-		DRM_ERROR("Timeout waiting for L1T write combiner flush\n");
+		       V3D_L2TCACTL_TMUWCF), 100)) {
+		DRM_ERROR("Timeout waiting for TMU write combiner flush\n");
 	}
 
 	mutex_lock(&v3d->cache_clean_lock);
-- 
2.33.0



