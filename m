Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5100371C17
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbhECQvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233135AbhECQtJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:49:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F697616EB;
        Mon,  3 May 2021 16:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060010;
        bh=N4Is+K2p0kwejxQBZnAf2tk+XHiNxnIvQ7kV3g9fcwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U9IlPujYi4t9WcGe/F2vwhqXCS0bUcJog8XQIAeHSZyDF/y/fHogcb1suqJCLobwt
         qfdtUg9aA+jIKSMa32XRxENRUhAqHC8+ihi0l8PDpIJVBWc9wyYpk0kEhrPUha5lHe
         3HUf5P61LOc8+cabWxQfDJ95cdyp+SClKe2rJlpv/9Ea2njRUhcCfHN/vcnkxSVM+z
         Z+aqk3YWB6I9c1IUhJRMYyPn8r/l21l1Zv0K7ijFzlidTjmCwsdWdrQDT6+IW+1vYz
         7x/RwwlPVaE0KYTSKHUnIx9ieAqob0+EziAgeOOSxvGDhm3OtVeJgVBFsYydOwRiuD
         soRVLGE8d4vag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lyude Paul <lyude@redhat.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 19/57] drm/bridge/analogix/anx78xx: Cleanup on error in anx78xx_bridge_attach()
Date:   Mon,  3 May 2021 12:39:03 -0400
Message-Id: <20210503163941.2853291-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
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
 drivers/gpu/drm/bridge/analogix-anx78xx.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix-anx78xx.c b/drivers/gpu/drm/bridge/analogix-anx78xx.c
index fcbad1ed865a..3ddeee3cc5a2 100644
--- a/drivers/gpu/drm/bridge/analogix-anx78xx.c
+++ b/drivers/gpu/drm/bridge/analogix-anx78xx.c
@@ -1026,7 +1026,7 @@ static int anx78xx_bridge_attach(struct drm_bridge *bridge)
 				 DRM_MODE_CONNECTOR_DisplayPort);
 	if (err) {
 		DRM_ERROR("Failed to initialize connector: %d\n", err);
-		return err;
+		goto aux_unregister;
 	}
 
 	drm_connector_helper_add(&anx78xx->connector,
@@ -1038,16 +1038,21 @@ static int anx78xx_bridge_attach(struct drm_bridge *bridge)
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

