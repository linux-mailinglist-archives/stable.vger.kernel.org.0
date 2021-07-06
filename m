Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5961C3BCB7D
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbhGFLRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:17:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231892AbhGFLQ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:16:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5321661C20;
        Tue,  6 Jul 2021 11:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570060;
        bh=5lNEDT8qos+QLc8MRVxXgKYOzcrK5fqrjXUcMPRfdMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NSbSsBsviB61XKXoBWYtR1Ue4YWqbRnGeuX5UXg7bUQp2NTK/4GlQrqvQ2PxR6L7t
         aD5QDX0VqSGL8mc9MUP5qRFOKmykCmnAH/YnkKjiBNU5PQ4trV5wBhbVWhRZFjAYjC
         li+CDSpXYTEpXwH0lrVkDkjSsIvSoWE2e7HmrnYUbT6WF5MoQpi9fEE/lnEmlCl6o9
         zE7771nWSTd7l3Uoh/U+pCW60VOphmhEBFNlYoZjQfOj55LsaYczZw9JYNv9K7Vehw
         vvAOqvDka2Lon6/bkmMPfb9J2lIwCGypt5eR7DKDa+rXjAZaehok1OPsQIKtTNWt56
         5f/uoVyohlklw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Park <Chris.Park@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Wayne Lin <waynelin@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 007/189] drm/amd/display: Fix BSOD with NULL check
Date:   Tue,  6 Jul 2021 07:11:07 -0400
Message-Id: <20210706111409.2058071-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Park <Chris.Park@amd.com>

[ Upstream commit b2d4b9f72fb14c1e6e4f0128964a84539a72d831 ]

[Why]
CLK mgr is null for server settings.

[How]
Guard the function with NULL check.

Signed-off-by: Chris Park <Chris.Park@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Wayne Lin <waynelin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index e57df2f6f824..a869702d77af 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -3274,7 +3274,7 @@ void dc_allow_idle_optimizations(struct dc *dc, bool allow)
 	if (dc->debug.disable_idle_power_optimizations)
 		return;
 
-	if (dc->clk_mgr->funcs->is_smu_present)
+	if (dc->clk_mgr != NULL && dc->clk_mgr->funcs->is_smu_present)
 		if (!dc->clk_mgr->funcs->is_smu_present(dc->clk_mgr))
 			return;
 
-- 
2.30.2

