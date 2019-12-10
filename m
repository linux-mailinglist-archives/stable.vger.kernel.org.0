Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFD38119303
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbfLJVF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:05:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:49912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727462AbfLJVEl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:04:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33B3D222C4;
        Tue, 10 Dec 2019 21:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576011881;
        bh=wGLr9TQaZb4mysbQ1RUTvwzfb1gr3SQoaCDKmcFNx0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KaWGeyDSwgZYLhj5P2hXYJa3/NZWSlei7a2H4ZytYFpJduEBYU+nDhEZKuzl2wciu
         09PFR8cWN2jAM94I0xGiO6qBnrSugH8IsOcCZ9PtFMv49EtqVxelaB3U1xNLzN0Lmq
         euQFHXAkYD0NYzsYYks3S6gNlWycksIntVaY+c+8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mihail Atanassov <Mihail.Atanassov@arm.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Mihail Atanassov <mihail.atanassov@arm.com>,
        James Qian Wang <james.qian.wang@arm.com>,
        Ayan kumar halder <ayan.halder@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 032/350] drm/komeda: Workaround for broken FLIP_COMPLETE timestamps
Date:   Tue, 10 Dec 2019 15:58:44 -0500
Message-Id: <20191210210402.8367-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210402.8367-1-sashal@kernel.org>
References: <20191210210402.8367-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 624d257da20f8..52c42569a111f 100644
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

