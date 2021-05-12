Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE78037C965
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhELQS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:18:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233001AbhELQIg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:08:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B62761D32;
        Wed, 12 May 2021 15:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833980;
        bh=T0ofBlRmITfTrq8t2umcL5RsPFvcecYrVF0mNnNVBq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ON8iUeYcUTjK5WDiyHZSgeVVJT+27QL/yO0nkVaLr8m7UCrtL1aKVT88Qb3jXRmoE
         dCk/QTthkO5LFySNkwjjfIJ+Befu+KraNttDuXWqG7qwDlzSVPOn4iqhlDlAEsec4J
         hLF9jKsiWe2SLNBE40PMyPAEJ/K36XJX9JcVGDCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Ser <contact@emersion.fr>,
        Harry Wentland <harry.wentland@amd.com>,
        Sefa Eyeoglu <contact@scrumplex.net>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 362/601] drm/amd/display: check fb of primary plane
Date:   Wed, 12 May 2021 16:47:19 +0200
Message-Id: <20210512144839.725711912@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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
index d7d2cf8b53f4..36898ae63f30 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9119,7 +9119,8 @@ static int dm_check_crtc_cursor(struct drm_atomic_state *state,
 
 	new_cursor_state = drm_atomic_get_new_plane_state(state, crtc->cursor);
 	new_primary_state = drm_atomic_get_new_plane_state(state, crtc->primary);
-	if (!new_cursor_state || !new_primary_state || !new_cursor_state->fb) {
+	if (!new_cursor_state || !new_primary_state ||
+	    !new_cursor_state->fb || !new_primary_state->fb) {
 		return 0;
 	}
 
-- 
2.30.2



