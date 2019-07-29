Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9531F7950A
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388795AbfG2TiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:38:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388437AbfG2TiB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:38:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E96DC2171F;
        Mon, 29 Jul 2019 19:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429080;
        bh=KJf2K2UdkZTGt+0mCo4df6+uIaLto5eUYkcRQ8ZM+Rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e/hPW1vwK1CB+RKtrY0TBiJNfHtnjkYKclF7WLLFS9zsy3Wez9h2MLcrxvSSzIyc9
         M51B79wW3mx3d5BtMoZqzzO5IIN7hadk3DXJnzvrUEYERvb9jss6kpmkTXVctTEp8Y
         xNdO6j/Ywxzd6UPvvKvhn0yT7ajf5TcX9u8gYs+0=
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
Subject: [PATCH 4.14 279/293] drm/crc-debugfs: Also sprinkle irqrestore over early exits
Date:   Mon, 29 Jul 2019 21:22:50 +0200
Message-Id: <20190729190845.641798943@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
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
index f689c75474e5..2901b7944068 100644
--- a/drivers/gpu/drm/drm_debugfs_crc.c
+++ b/drivers/gpu/drm/drm_debugfs_crc.c
@@ -366,7 +366,7 @@ int drm_crtc_add_crc_entry(struct drm_crtc *crtc, bool has_frame,
 
 	/* Caller may not have noticed yet that userspace has stopped reading */
 	if (!crc->entries) {
-		spin_unlock(&crc->lock);
+		spin_unlock_irqrestore(&crc->lock, flags);
 		return -EINVAL;
 	}
 
@@ -377,7 +377,7 @@ int drm_crtc_add_crc_entry(struct drm_crtc *crtc, bool has_frame,
 		bool was_overflow = crc->overflow;
 
 		crc->overflow = true;
-		spin_unlock(&crc->lock);
+		spin_unlock_irqrestore(&crc->lock, flags);
 
 		if (!was_overflow)
 			DRM_ERROR("Overflow of CRC buffer, userspace reads too slow.\n");
-- 
2.20.1



