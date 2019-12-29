Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4FF512C799
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730646AbfL2RoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:44:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:52196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730643AbfL2RoM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:44:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5D4B21D7E;
        Sun, 29 Dec 2019 17:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641452;
        bh=ZpwxICIACp40Jb3AmxQbD4EaVFCPBbcl+RoJtG9I554=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJuMV0Pqa8bFgIRIeuJ8ZL7oZoyu2LZRQDXtUedtw2utQs2nNrTFDBKyqI84oCk6Q
         86AOlDChOx/2Mzbtg+Y6g+MTeRa8FXHoNhYQ8wCa+rQ+gfO+4Wa9BEwkE33nChmBB1
         m8IOC8VQ5cV7dk7IQaDLG6csgbfWqFEkB7NZZX2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Mihail Atanassov <mihail.atanassov@arm.com>,
        "James Qian Wang (Arm Technology China)" <james.qian.wang@arm.com>,
        Ayan kumar halder <ayan.halder@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 072/434] drm/komeda: Workaround for broken FLIP_COMPLETE timestamps
Date:   Sun, 29 Dec 2019 18:22:05 +0100
Message-Id: <20191229172706.453100740@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mihail Atanassov <Mihail.Atanassov@arm.com>

[ Upstream commit f59769c52cd7d158df53487ec2936f5592073340 ]

When initially turning a crtc on, drm_reset_vblank_timestamp will
set the vblank timestamp to 0 for any driver that doesn't provide
a ->get_vblank_timestamp() hook.

Unfortunately, the FLIP_COMPLETE event depends on that timestamp,
and the only way to regenerate a valid one is to have vblank
interrupts enabled and have a valid in-ISR call to
drm_crtc_handle_vblank.

Additionally, if the user doesn't request vblanks but _does_ request
FLIP_COMPLETE events, we still don't have a good timestamp: it'll be the
same stamp as the last vblank one.

Work around the issue by always enabling vblanks when the CRTC is on.
Reducing the amount of time that PL0 has to be unmasked would be nice to
fix at a later time.

Changes since v1 [https://patchwork.freedesktop.org/patch/331727/]:
 - moved drm_crtc_vblank_put call to the ->atomic_disable() hook

Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>
Signed-off-by: Mihail Atanassov <mihail.atanassov@arm.com>
Reviewed-by: James Qian Wang (Arm Technology China) <james.qian.wang@arm.com>
Signed-off-by: Ayan kumar halder <ayan.halder@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191001142121.13939-1-mihail.atanassov@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/display/komeda/komeda_crtc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c b/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c
index 624d257da20f..52c42569a111 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c
@@ -250,6 +250,7 @@ komeda_crtc_atomic_enable(struct drm_crtc *crtc,
 {
 	komeda_crtc_prepare(to_kcrtc(crtc));
 	drm_crtc_vblank_on(crtc);
+	WARN_ON(drm_crtc_vblank_get(crtc));
 	komeda_crtc_do_flush(crtc, old);
 }
 
@@ -319,6 +320,7 @@ komeda_crtc_atomic_disable(struct drm_crtc *crtc,
 		}
 	}
 
+	drm_crtc_vblank_put(crtc);
 	drm_crtc_vblank_off(crtc);
 	komeda_crtc_unprepare(kcrtc);
 }
-- 
2.20.1



