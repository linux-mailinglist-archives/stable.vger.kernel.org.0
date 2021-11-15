Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF43451261
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbhKOTfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:35:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:44628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233111AbhKOTRS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:17:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5132D632AD;
        Mon, 15 Nov 2021 18:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000581;
        bh=fWuWmIPGI5GtDA01JmYFFBJuPO5kD7ENMC6lsgU3Hmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eBSM9zvXNjEp6xgI87YbrguGjxXSCDOnBwyI6N20EScYZhS6NFAJ7pm/ztMTVIrEZ
         d4Z8hFNTfsnf58RivIZxlkpf19lehS5yCwCOimIpyTQE2ERj49FTVxiC7DcRwZF9RH
         KRyJZ4TelSeXGE7/eyh8sE192LwRHMPOX8qMm4dk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Ser <contact@emersion.fr>,
        "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 681/849] drm/plane-helper: fix uninitialized variable reference
Date:   Mon, 15 Nov 2021 18:02:44 +0100
Message-Id: <20211115165443.309460013@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 3aae7ea522f23..c3f2292dc93d5 100644
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



