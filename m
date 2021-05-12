Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C2537CD49
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238060AbhELQx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:53:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243752AbhELQmB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DECC661440;
        Wed, 12 May 2021 16:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835602;
        bh=bSf42bCePGUSgVIp5N5QBmHqc1gV8ozRK/XnUzjymxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r8pvG0lIXlZWdxVuvsAce4WC+KrwCQJH/oAXWTiuZmPO7hWaer5ptXQ0MuHkZq5J9
         kL8IZXM6WtNgpM6/MbJCy4tA8BCHMJLaym+Mh8gXOfE2ac5uDs6yZfa8JLPKeEiyCU
         +thzdsLM7Fzm19vyPTLdM4XmYBUehsjOLcm420Qw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Ser <contact@emersion.fr>,
        Harry Wentland <harry.wentland@amd.com>,
        Sefa Eyeoglu <contact@scrumplex.net>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 409/677] drm/amd/display: check fb of primary plane
Date:   Wed, 12 May 2021 16:47:35 +0200
Message-Id: <20210512144850.924637608@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sefa Eyeoglu <contact@scrumplex.net>

[ Upstream commit 7df4ceb60fa9a3c5160cfd5b696657291934a2c9 ]

Sometimes the primary plane might not be initialized (yet), which
causes dm_check_crtc_cursor to divide by zero.
Apparently a weird state before a S3-suspend causes the aforementioned
divide-by-zero error when resuming from S3.  This was explained in
bug 212293 on Bugzilla.

To avoid this divide-by-zero error we check if the primary plane's fb
isn't NULL.  If it's NULL the src_w and src_h attributes will be 0,
which would cause a divide-by-zero.

This fixes Bugzilla report 212293
Bug: https://bugzilla.kernel.org/show_bug.cgi?id=212293

Fixes: 12f4849a1cfd69f3 ("drm/amd/display: check cursor scaling")
Reviewed-by: Simon Ser <contact@emersion.fr>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Sefa Eyeoglu <contact@scrumplex.net>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 2e42cdea6927..71e07ebc8f88 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9295,7 +9295,8 @@ static int dm_check_crtc_cursor(struct drm_atomic_state *state,
 
 	new_cursor_state = drm_atomic_get_new_plane_state(state, crtc->cursor);
 	new_primary_state = drm_atomic_get_new_plane_state(state, crtc->primary);
-	if (!new_cursor_state || !new_primary_state || !new_cursor_state->fb) {
+	if (!new_cursor_state || !new_primary_state ||
+	    !new_cursor_state->fb || !new_primary_state->fb) {
 		return 0;
 	}
 
-- 
2.30.2



