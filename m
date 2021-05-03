Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0793A371A12
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbhECQig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:38:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231755AbhECQhm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:37:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63477613C3;
        Mon,  3 May 2021 16:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059785;
        bh=vb6VDooaNHkVvhir+UqLWaY9ZvgfOpWnyHLq/XDcXTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ezwAGW03FkhsSejAAqhtsA6GN4bk6vKLyi34l9cDkpK4bBLArgzauObyTahzkqEsz
         Y9pShfNGC1fqQ2+nhsLM6c0QfYp7WlbU1ktVuO2fFUWvzP4nd3N0nxrh1gGFfpRewP
         a2mJsI5CiLVt0syBP4Pz+YEZDLtsWe19eowhGNQIfIyXN5UvO5bwnhUm+tx6f9ojON
         o6d1L0VsAl9BFTPDa86t2Z1IsQLeC/84yYS+TsZ1NE7Ld+z4BcycNXG1lN029gDsm8
         u61fS4CBYtskFldvvDXj3+0uXOntZM/h7pbdG6vGhOM0NZIo8PQMOdnWg1mUNJY+27
         PhQqWZZXlVzQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lyude Paul <lyude@redhat.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 046/134] drm/bridge/analogix/anx78xx: Cleanup on error in anx78xx_bridge_attach()
Date:   Mon,  3 May 2021 12:33:45 -0400
Message-Id: <20210503163513.2851510-46-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163513.2851510-1-sashal@kernel.org>
References: <20210503163513.2851510-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

[ Upstream commit 212ee8db84600f7b279b8645c62a112bff310995 ]

Just another issue I noticed while correcting usages of
drm_dp_aux_init()/drm_dp_aux_register() around the tree. If any of the
steps in anx78xx_bridge_attach() fail, we end up leaking resources. So,
let's fix that (and fix leaking a DP AUX adapter in the process) by
unrolling on errors.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210219215326.2227596-10-lyude@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/analogix-anx78xx.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/analogix-anx78xx.c b/drivers/gpu/drm/bridge/analogix/analogix-anx78xx.c
index fbfe0cc89ba4..bcc778f680a8 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix-anx78xx.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix-anx78xx.c
@@ -918,7 +918,7 @@ static int anx78xx_bridge_attach(struct drm_bridge *bridge,
 				 DRM_MODE_CONNECTOR_DisplayPort);
 	if (err) {
 		DRM_ERROR("Failed to initialize connector: %d\n", err);
-		return err;
+		goto aux_unregister;
 	}
 
 	drm_connector_helper_add(&anx78xx->connector,
@@ -930,16 +930,21 @@ static int anx78xx_bridge_attach(struct drm_bridge *bridge,
 					   bridge->encoder);
 	if (err) {
 		DRM_ERROR("Failed to link up connector to encoder: %d\n", err);
-		return err;
+		goto connector_cleanup;
 	}
 
 	err = drm_connector_register(&anx78xx->connector);
 	if (err) {
 		DRM_ERROR("Failed to register connector: %d\n", err);
-		return err;
+		goto connector_cleanup;
 	}
 
 	return 0;
+connector_cleanup:
+	drm_connector_cleanup(&anx78xx->connector);
+aux_unregister:
+	drm_dp_aux_unregister(&anx78xx->aux);
+	return err;
 }
 
 static enum drm_mode_status
-- 
2.30.2

