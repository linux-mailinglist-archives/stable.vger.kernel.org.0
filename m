Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B77401A54EA
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgDKXIU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:08:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727269AbgDKXIU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:08:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EF6A20708;
        Sat, 11 Apr 2020 23:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646500;
        bh=HTk2LAY6m/2PMyKiWa3R+YV94N6VTF94/lp0Bd3u8mQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=epjX8Tu8mE9rd0C9egezR8ANqYz/pJ50ZP1J3WwjvjrcEY0XepXP00I5V/TXTo2vQ
         jGX6ZgIRZXut82Y259429UsT4lQo9aa8YV3wacNCGiVap/wCfRKDGgY37D8Qah91zw
         Pr2zX6db6+ofV2o9zh4YmRdkPy6+B83rl6DbNj0Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Emil Velikov <emil.velikov@collabora.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.5 061/121] drm/crc: Actually allow to change the crc source
Date:   Sat, 11 Apr 2020 19:06:06 -0400
Message-Id: <20200411230706.23855-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
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

[ Upstream commit 3cb6d8e5cf9811a62e27f366fd1c05f90310a8fd ]

Oops.

Fixes: 9edbf1fa600a ("drm: Add API for capturing frame CRCs")
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Emil Velikov <emil.velikov@collabora.com>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190821203835.18314-1-daniel.vetter@ffwll.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_debugfs_crc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_debugfs_crc.c b/drivers/gpu/drm/drm_debugfs_crc.c
index 2ece2957da1af..6b20da279bc7f 100644
--- a/drivers/gpu/drm/drm_debugfs_crc.c
+++ b/drivers/gpu/drm/drm_debugfs_crc.c
@@ -367,7 +367,7 @@ void drm_debugfs_crtc_crc_add(struct drm_crtc *crtc)
 
 	crc_ent = debugfs_create_dir("crc", crtc->debugfs_entry);
 
-	debugfs_create_file("control", S_IRUGO, crc_ent, crtc,
+	debugfs_create_file("control", S_IRUGO | S_IWUSR, crc_ent, crtc,
 			    &drm_crtc_crc_control_fops);
 	debugfs_create_file("data", S_IRUGO, crc_ent, crtc,
 			    &drm_crtc_crc_data_fops);
-- 
2.20.1

