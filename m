Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 014FE6E012
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbfGSD6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:58:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:57718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728021AbfGSD6Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:58:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D958921855;
        Fri, 19 Jul 2019 03:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508704;
        bh=WHIAtgyJYC88kgwu3EEgozkb3ZlqsrWEkHRoC+MFPxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nPEedqKcc/f+Kmro42wBG0DsF0HlqPkc+8IOvjhnHOck9UdVWkkGfQOwMe0lf+bv7
         69P5UtWZXL+xYFjjGbeGUroPyBoSlFDqWnLeQW+cLetrL6iTKVXsDirMYdS6qmt9kz
         W52gYQ8uVrdCfrq3CHAUhyv8N0OCmUdRZprDm4+E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Emil Velikov <emil.velikov@collabora.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 042/171] drm/crc-debugfs: Also sprinkle irqrestore over early exits
Date:   Thu, 18 Jul 2019 23:54:33 -0400
Message-Id: <20190719035643.14300-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

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
index 1a6a5b78e30f..fde298d9f510 100644
--- a/drivers/gpu/drm/drm_debugfs_crc.c
+++ b/drivers/gpu/drm/drm_debugfs_crc.c
@@ -395,7 +395,7 @@ int drm_crtc_add_crc_entry(struct drm_crtc *crtc, bool has_frame,
 
 	/* Caller may not have noticed yet that userspace has stopped reading */
 	if (!crc->entries) {
-		spin_unlock(&crc->lock);
+		spin_unlock_irqrestore(&crc->lock, flags);
 		return -EINVAL;
 	}
 
@@ -406,7 +406,7 @@ int drm_crtc_add_crc_entry(struct drm_crtc *crtc, bool has_frame,
 		bool was_overflow = crc->overflow;
 
 		crc->overflow = true;
-		spin_unlock(&crc->lock);
+		spin_unlock_irqrestore(&crc->lock, flags);
 
 		if (!was_overflow)
 			DRM_ERROR("Overflow of CRC buffer, userspace reads too slow.\n");
-- 
2.20.1

