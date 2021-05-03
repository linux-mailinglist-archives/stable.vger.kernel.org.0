Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F848371D19
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234565AbhECQ6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:58:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235144AbhECQzv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:55:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1FDB61968;
        Mon,  3 May 2021 16:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060185;
        bh=Jfb5JeDNXq6MV6xxiZm35fU9ECYIkOD6TvYYV7P1sFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E42aGjpWUzvpc795+n77zPX7btmeCRrn+ShRmEn/asElUSYscQ4/qarL1cXHLDUhy
         NS5bhAzd38LcUYT0Vkk0E+dtrGNEpijUlo4rpN1Cx2Ef2g4W766KQxAMkoyuUj1sOO
         1zXC5t52qn9/wqupR/yoBtR7dXxyrPKj4OLjHHi8Zg5QMasxZEWaXYhrM2NH1Zb/7q
         ZYZMDv9YIwJC3WrXBuUJz4mgeSjJz02xgSKFY+uLz9Uyz9ZcoO70iEjcUBIMVsmX/Y
         jap8BdafONLZqVLtlUh1oBKR7OY+q3a5/22EU2RPTpSbn8dVa3JcR993u89dQJOxz7
         1YlNuFhmYVrtw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lyude Paul <lyude@redhat.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.9 09/24] drm/bridge/analogix/anx78xx: Cleanup on error in anx78xx_bridge_attach()
Date:   Mon,  3 May 2021 12:42:37 -0400
Message-Id: <20210503164252.2854487-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164252.2854487-1-sashal@kernel.org>
References: <20210503164252.2854487-1-sashal@kernel.org>
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
index 16babacb7cf0..5a1121af6664 100644
--- a/drivers/gpu/drm/bridge/analogix-anx78xx.c
+++ b/drivers/gpu/drm/bridge/analogix-anx78xx.c
@@ -1039,7 +1039,7 @@ static int anx78xx_bridge_attach(struct drm_bridge *bridge)
 				 DRM_MODE_CONNECTOR_DisplayPort);
 	if (err) {
 		DRM_ERROR("Failed to initialize connector: %d\n", err);
-		return err;
+		goto aux_unregister;
 	}
 
 	drm_connector_helper_add(&anx78xx->connector,
@@ -1051,16 +1051,21 @@ static int anx78xx_bridge_attach(struct drm_bridge *bridge)
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
 
 static bool anx78xx_bridge_mode_fixup(struct drm_bridge *bridge,
-- 
2.30.2

