Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4BB328FD0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242520AbhCAT61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:58:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:55194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240452AbhCATpg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:45:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7B4365030;
        Mon,  1 Mar 2021 17:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618894;
        bh=THcye7fJji3pbGpNmY481FFDCt6rSaLVJjbuLCA3Bp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nhBZGrCJmmILZoUy0vig/B8sTjXdowPJEz0Td+qT47vIKcuSxJK97SVvi49N3uDfz
         3Ti869ZVbdnIBcAAJC2abd4t0xcwM9HQpLwowXstI1tQejwum+6fmhdN4zHh2OOZdg
         7nUD5t319HqwS3IDjA4vyeCVvVrklUxEh+ylpCV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Dom Cobley <popcornmix@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 229/663] drm/vc4: hdmi: Move hdmi reset to bind
Date:   Mon,  1 Mar 2021 17:07:57 +0100
Message-Id: <20210301161153.136672182@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dom Cobley <popcornmix@gmail.com>

[ Upstream commit 902dc5c19a8fecd3113dd41cc601b34557bdede9 ]

The hdmi reset got moved to a later point in the commit 9045e91a476b
("drm/vc4: hdmi: Add reset callback").

However, the reset now occurs after vc4_hdmi_cec_init and so tramples
the setup of registers like HDMI_CEC_CNTRL_1

This only affects pi0-3 as on pi4 the cec registers are in a separate
block

Fixes: 9045e91a476b ("drm/vc4: hdmi: Add reset callback")
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Dom Cobley <popcornmix@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Tested-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Link: https://patchwork.freedesktop.org/patch/msgid/20210111142309.193441-3-maxime@cerno.tech
(cherry picked from commit 7155334f15f360f5c98391c5c7e12af4c13395c4)
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index db06f52de9d91..1b2b5e3986ebd 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -661,9 +661,6 @@ static void vc4_hdmi_encoder_pre_crtc_configure(struct drm_encoder *encoder)
 		return;
 	}
 
-	if (vc4_hdmi->variant->reset)
-		vc4_hdmi->variant->reset(vc4_hdmi);
-
 	if (vc4_hdmi->variant->phy_init)
 		vc4_hdmi->variant->phy_init(vc4_hdmi, mode);
 
@@ -1744,6 +1741,9 @@ static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
 	vc4_hdmi->disable_wifi_frequencies =
 		of_property_read_bool(dev->of_node, "wifi-2.4ghz-coexistence");
 
+	if (vc4_hdmi->variant->reset)
+		vc4_hdmi->variant->reset(vc4_hdmi);
+
 	pm_runtime_enable(dev);
 
 	drm_simple_encoder_init(drm, encoder, DRM_MODE_ENCODER_TMDS);
-- 
2.27.0



