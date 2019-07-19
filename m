Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6836DE1D
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732900AbfGSEIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:08:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732970AbfGSEIP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:08:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFBCE2082E;
        Fri, 19 Jul 2019 04:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509294;
        bh=U0e1hfcszPJLc7pIVa6axSW23a8D+Vk7pOBpIP1Z8SI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xgTde1aWedT764FgkoMqkmzAH6DrMpZQYGfBK+abI9gV+aZ16tjzoX1sqAMb2GsuV
         UWCREZtuPcAsrEZoSRkEe3osGLRHgPtmW1V+NWWf22YXgD+LNBrhEtQ1wCidfenXgi
         UlIKt5OqBYcl+Wp3CtMUT2QBmOmRgkwh1LpjlLeo=
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
Subject: [PATCH AUTOSEL 4.19 020/101] drm/crc-debugfs: User irqsafe spinlock in drm_crtc_add_crc_entry
Date:   Fri, 19 Jul 2019 00:06:11 -0400
Message-Id: <20190719040732.17285-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040732.17285-1-sashal@kernel.org>
References: <20190719040732.17285-1-sashal@kernel.org>
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
index 99961192bf03..a334a82fcb36 100644
--- a/drivers/gpu/drm/drm_debugfs_crc.c
+++ b/drivers/gpu/drm/drm_debugfs_crc.c
@@ -379,8 +379,9 @@ int drm_crtc_add_crc_entry(struct drm_crtc *crtc, bool has_frame,
 	struct drm_crtc_crc *crc = &crtc->crc;
 	struct drm_crtc_crc_entry *entry;
 	int head, tail;
+	unsigned long flags;
 
-	spin_lock(&crc->lock);
+	spin_lock_irqsave(&crc->lock, flags);
 
 	/* Caller may not have noticed yet that userspace has stopped reading */
 	if (!crc->entries) {
@@ -411,7 +412,7 @@ int drm_crtc_add_crc_entry(struct drm_crtc *crtc, bool has_frame,
 	head = (head + 1) & (DRM_CRC_ENTRIES_NR - 1);
 	crc->head = head;
 
-	spin_unlock(&crc->lock);
+	spin_unlock_irqrestore(&crc->lock, flags);
 
 	wake_up_interruptible(&crc->wq);
 
-- 
2.20.1

