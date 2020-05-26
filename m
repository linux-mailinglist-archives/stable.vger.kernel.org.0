Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D9B1C8559
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 11:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgEGJGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 05:06:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:55524 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgEGJGo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 05:06:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8D349ACB1;
        Thu,  7 May 2020 09:06:45 +0000 (UTC)
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     airlied@redhat.com, daniel@ffwll.ch, kraxel@redhat.com,
        sam@ravnborg.org, emil.velikov@collabora.com, cogarre@gmail.com
Cc:     dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org
Subject: [PATCH v3] drm/ast: Don't check new mode if CRTC is being disabled
Date:   Thu,  7 May 2020 11:06:40 +0200
Message-Id: <20200507090640.21561-1-tzimmermann@suse.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Suspending failed because there's no mode if the CRTC is being
disabled. Early-out in this case. This fixes runtime PM for ast.

v3:
	* fixed commit message
v2:
	* added Tested-by/Reported-by tags
	* added Fixes tags and CC (Sam)
	* improved comment

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reported-by: Cary Garrett <cogarre@gmail.com>
Tested-by: Cary Garrett <cogarre@gmail.com>
Fixes: b48e1b6ffd28 ("drm/ast: Add CRTC helpers for atomic modesetting")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: <stable@vger.kernel.org> # v5.6+
---
 drivers/gpu/drm/ast/ast_mode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
index 7a9f20a2fd303..0cbbb21edb4e1 100644
--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -801,6 +801,9 @@ static int ast_crtc_helper_atomic_check(struct drm_crtc *crtc,
 		return -EINVAL;
 	}
 
+	if (!state->enable)
+		return 0; /* no mode checks if CRTC is being disabled */
+
 	ast_state = to_ast_crtc_state(state);
 
 	format = ast_state->format;
-- 
2.26.0

