Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788A6328EFF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241672AbhCATlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:41:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:50722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241610AbhCATcu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:32:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1601D6517F;
        Mon,  1 Mar 2021 17:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618590;
        bh=DX675dF+c7aBs0VPMu0flNiJY7T+22HCjl74IRur11U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FZXYaqvNbehkmdLTVp3lKZvOJKOpG7aMYRqphuDcwNbvMvrUcdJWsC0KDL0TV0ofO
         9UvMO2eo59wvdawwAjyTfcsnviaIhFWELqDAr0BSUgRCgAimFuMVfoHwKHgy6SIQAm
         vyq+i/qrSyQGA3HuJpaTD7YzylIHLJUBQdj8DI5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 143/663] drm/vc4: hdmi: Take into account the clock doubling flag in atomic_check
Date:   Mon,  1 Mar 2021 17:06:31 +0100
Message-Id: <20210301161148.843440907@linuxfoundation.org>
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

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 320e84dc6111ecc1c957e2b186d4d2bafee6bde2 ]

Commit 63495f6b4aed ("drm/vc4: hdmi: Make sure our clock rate is within
limits") was intended to compute the pixel rate to make sure we remain
within the boundaries of what the hardware can provide.

However, unlike what mode_valid was checking for, we forgot to take
into account the clock doubling flag that can be set for modes. Let's
honor that flag if it's there.

Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Reported-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Fixes: 63495f6b4aed ("drm/vc4: hdmi: Make sure our clock rate is within limits")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20201215154243.540115-4-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index eaba98e15de46..db06f52de9d91 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -791,6 +791,9 @@ static int vc4_hdmi_encoder_atomic_check(struct drm_encoder *encoder,
 		pixel_rate = mode->clock * 1000;
 	}
 
+	if (mode->flags & DRM_MODE_FLAG_DBLCLK)
+		pixel_rate = pixel_rate * 2;
+
 	if (pixel_rate > vc4_hdmi->variant->max_pixel_clock)
 		return -EINVAL;
 
-- 
2.27.0



