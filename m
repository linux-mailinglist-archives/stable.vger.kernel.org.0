Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48530451E22
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343998AbhKPAfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:45404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344590AbhKOTZD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F6C263370;
        Mon, 15 Nov 2021 19:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002828;
        bh=5y0/vxfNDk14O9Bui4RE6t2CJW+vp2VPQuXjp86//UU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jQ5RaQuuG5H5UfCw9PgX7uGugWk0+1+/ViKrzjY/blemdacW2qku3QMxfky0YhSEB
         h7buHeMSOuvDM2CX8iYZT67lVSOKojCNLSqn7xK7rilKJvH3btgBomdbBVvQIjoyeK
         QPShFzG+SRNxW9gaHHRSM3nJBPyFtfbS+vjBqCyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Ser <contact@emersion.fr>,
        "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 712/917] drm/plane-helper: fix uninitialized variable reference
Date:   Mon, 15 Nov 2021 18:03:27 +0100
Message-Id: <20211115165453.039743480@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Xu (Hello71) <alex_y_xu@yahoo.ca>

[ Upstream commit 7be28bd73f23e53d6e7f5fe891ba9503fc0c7210 ]

drivers/gpu/drm/drm_plane_helper.c: In function 'drm_primary_helper_update':
drivers/gpu/drm/drm_plane_helper.c:113:32: error: 'visible' is used uninitialized [-Werror=uninitialized]
  113 |         struct drm_plane_state plane_state = {
      |                                ^~~~~~~~~~~
drivers/gpu/drm/drm_plane_helper.c:178:14: note: 'visible' was declared here
  178 |         bool visible;
      |              ^~~~~~~
cc1: all warnings being treated as errors

visible is an output, not an input. in practice this use might turn out
OK but it's still UB.

Fixes: df86af9133b4 ("drm/plane-helper: Add drm_plane_helper_check_state()")
Reviewed-by: Simon Ser <contact@emersion.fr>
Signed-off-by: Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
Signed-off-by: Simon Ser <contact@emersion.fr>
Link: https://patchwork.freedesktop.org/patch/msgid/20211007063706.305984-1-alex_y_xu@yahoo.ca
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_plane_helper.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_plane_helper.c b/drivers/gpu/drm/drm_plane_helper.c
index 5b2d0ca03705c..838b32b70bce6 100644
--- a/drivers/gpu/drm/drm_plane_helper.c
+++ b/drivers/gpu/drm/drm_plane_helper.c
@@ -123,7 +123,6 @@ static int drm_plane_helper_check_update(struct drm_plane *plane,
 		.crtc_w = drm_rect_width(dst),
 		.crtc_h = drm_rect_height(dst),
 		.rotation = rotation,
-		.visible = *visible,
 	};
 	struct drm_crtc_state crtc_state = {
 		.crtc = crtc,
-- 
2.33.0



