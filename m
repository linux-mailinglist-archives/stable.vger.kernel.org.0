Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0C9979535
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389071AbfG2Tj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:39:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389063AbfG2Tj4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:39:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29947217D4;
        Mon, 29 Jul 2019 19:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429195;
        bh=VmvEGOAIMGzuEZ0t5dd6qzEQ7ri/t5Em8QVNVLWiVxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EpI1H7SNAdFK6vJYPf6FhuMHPtOQJAio1NqAf3IT+OLfwmTwznFvIOPn81yLXGoh5
         97lw/kRhc9510guguqAy3ej1D0tCsXZJGUUNXInRmJyd8qn4RCmPbhJ8dTfjcDb6kY
         yJ19VmK4ePfXBq6aeDOJN9Y2h8RZNjRPj9EwHDII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Emil Velikov <emil.velikov@collabora.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 021/113] drm/crc-debugfs: Also sprinkle irqrestore over early exits
Date:   Mon, 29 Jul 2019 21:21:48 +0200
Message-Id: <20190729190700.902426445@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
References: <20190729190655.455345569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d99004d7201aa653658ff2390d6e516567c96ebc ]

I. was. blind.

Caught with vkms, which has some really slow crc computation function.

Fixes: 1882018a70e0 ("drm/crc-debugfs: User irqsafe spinlock in drm_crtc_add_crc_entry")
Cc: Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Emil Velikov <emil.velikov@collabora.com>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Emil Velikov <emil.velikov@collabora.com>
Reviewed-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190606211544.5389-1-daniel.vetter@ffwll.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_debugfs_crc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_debugfs_crc.c b/drivers/gpu/drm/drm_debugfs_crc.c
index a334a82fcb36..c88e5ff41add 100644
--- a/drivers/gpu/drm/drm_debugfs_crc.c
+++ b/drivers/gpu/drm/drm_debugfs_crc.c
@@ -385,7 +385,7 @@ int drm_crtc_add_crc_entry(struct drm_crtc *crtc, bool has_frame,
 
 	/* Caller may not have noticed yet that userspace has stopped reading */
 	if (!crc->entries) {
-		spin_unlock(&crc->lock);
+		spin_unlock_irqrestore(&crc->lock, flags);
 		return -EINVAL;
 	}
 
@@ -396,7 +396,7 @@ int drm_crtc_add_crc_entry(struct drm_crtc *crtc, bool has_frame,
 		bool was_overflow = crc->overflow;
 
 		crc->overflow = true;
-		spin_unlock(&crc->lock);
+		spin_unlock_irqrestore(&crc->lock, flags);
 
 		if (!was_overflow)
 			DRM_ERROR("Overflow of CRC buffer, userspace reads too slow.\n");
-- 
2.20.1



