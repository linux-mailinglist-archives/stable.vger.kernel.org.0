Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DABD45BE09
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242900AbhKXMoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:44:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:48796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345183AbhKXMlD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:41:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05DC4611F0;
        Wed, 24 Nov 2021 12:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756668;
        bh=gWtQHpOiNRgSjDr0JFWmO3NMdrBmzHFoY14LzpTbFpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eWhOk6sQt6GKFveB38lV7dBCAODvPsTErFsmfKymmd6VGwtpTkvkqh4Qn4laBZvUX
         fI4ivSEg0fzdkIHavHa9TBQUzJwhvzwi6asObimUCvuVJ7s3jxrhFmjri6ztUHVaWl
         o8y3kQIu8EYXZ4yWarTiK5X+lcHhesS7Efmxhbqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Ser <contact@emersion.fr>,
        "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 163/251] drm/plane-helper: fix uninitialized variable reference
Date:   Wed, 24 Nov 2021 12:56:45 +0100
Message-Id: <20211124115715.932687024@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
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
index 06aee1741e96a..6d57bc01b531f 100644
--- a/drivers/gpu/drm/drm_plane_helper.c
+++ b/drivers/gpu/drm/drm_plane_helper.c
@@ -243,7 +243,6 @@ int drm_plane_helper_check_update(struct drm_plane *plane,
 		.crtc_w = drm_rect_width(dst),
 		.crtc_h = drm_rect_height(dst),
 		.rotation = rotation,
-		.visible = *visible,
 	};
 	int ret;
 
-- 
2.33.0



