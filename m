Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02945795EE
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390292AbfG2TrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:47:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390287AbfG2TrD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:47:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39FB8205F4;
        Mon, 29 Jul 2019 19:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429622;
        bh=2Px9ymgNTbeq+puEgqK5I+LQr4dA8DZ2DNbMkVJdFLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FbAjzzKmO91ccYTipWTwnTklLglxMYCIvfZmHkjmaeKgtdkz82b/o12A1VXheBsHN
         z7FUHdGTogHSikLKEsjbulLkDUr1le3N4NMpei4oJI0KkmQe0tMYCr18Bj9IVn34zE
         FSds74hnEoDtPX5eFFvjQ/dg7AgEc/9b4IDflD4Y=
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
Subject: [PATCH 5.2 043/215] drm/crc-debugfs: User irqsafe spinlock in drm_crtc_add_crc_entry
Date:   Mon, 29 Jul 2019 21:20:39 +0200
Message-Id: <20190729190747.977638588@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1882018a70e06376234133e69ede9dd743b4dbd9 ]

We can be called from any context, we need to be prepared.

Noticed this while hacking on vkms, which calls this function from a
normal worker. Which really upsets lockdep.

Cc: Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Emil Velikov <emil.velikov@collabora.com>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Reviewed-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190605194556.16744-1-daniel.vetter@ffwll.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_debugfs_crc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_debugfs_crc.c b/drivers/gpu/drm/drm_debugfs_crc.c
index 00e743153e94..1a6a5b78e30f 100644
--- a/drivers/gpu/drm/drm_debugfs_crc.c
+++ b/drivers/gpu/drm/drm_debugfs_crc.c
@@ -389,8 +389,9 @@ int drm_crtc_add_crc_entry(struct drm_crtc *crtc, bool has_frame,
 	struct drm_crtc_crc *crc = &crtc->crc;
 	struct drm_crtc_crc_entry *entry;
 	int head, tail;
+	unsigned long flags;
 
-	spin_lock(&crc->lock);
+	spin_lock_irqsave(&crc->lock, flags);
 
 	/* Caller may not have noticed yet that userspace has stopped reading */
 	if (!crc->entries) {
@@ -421,7 +422,7 @@ int drm_crtc_add_crc_entry(struct drm_crtc *crtc, bool has_frame,
 	head = (head + 1) & (DRM_CRC_ENTRIES_NR - 1);
 	crc->head = head;
 
-	spin_unlock(&crc->lock);
+	spin_unlock_irqrestore(&crc->lock, flags);
 
 	wake_up_interruptible(&crc->wq);
 
-- 
2.20.1



