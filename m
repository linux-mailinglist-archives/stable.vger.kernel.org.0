Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E01371B2B
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbhECQnk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:43:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232027AbhECQlq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:41:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4640861446;
        Mon,  3 May 2021 16:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059881;
        bh=WKJOu1QzUkiYpKL8N7jhFRleem9/iB0Nbx92nXy8Des=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vkw49XYs9k8qpUd/BkIcATJ9BeVZXVtvtKnTmwkI3S7HjOEwnw6gBfTesv/qpm9O6
         fbJ2JRuQzCr+h1t/Bx012Ou/T6Qbtj9z/ycKF76xjd5oFZsQ6yJIGp8ANwFQPjIQOC
         3NdO+gSSeffVfuoP2F6DPhTmG+MglFJc4NnlvjlJ8PDBQqnnZbkM/H0DRbt1GoNYp6
         KX64fAHvD34/gACjKWXQFuHW+ezKAMRaQcKNu30qpQFPNVjzINbjpJ+aWt2P1apxLM
         QDxvwJtg0Ne09iP1Py48c7ZXfGNYApq9qI3xshGXVxoVq4IODjgxZxFnRZATz/IzsU
         VV2O0Giw8y9TQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lyude Paul <lyude@redhat.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.11 040/115] drm/bridge/analogix/anx78xx: Setup encoder before registering connector
Date:   Mon,  3 May 2021 12:35:44 -0400
Message-Id: <20210503163700.2852194-40-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163700.2852194-1-sashal@kernel.org>
References: <20210503163700.2852194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

[ Upstream commit 9962849d0871f5e53d0e3b3d84561f8f2847fbf4 ]

Since encoder mappings for connectors are exposed to userspace, we should
be attaching the encoder before exposing the connector to userspace. Just a
drive-by fix for an issue I noticed while fixing up usages of
drm_dp_aux_init()/drm_dp_aux_register() across the tree.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210219215326.2227596-9-lyude@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/analogix-anx78xx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/analogix-anx78xx.c b/drivers/gpu/drm/bridge/analogix/analogix-anx78xx.c
index 81debd02c169..fbfe0cc89ba4 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix-anx78xx.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix-anx78xx.c
@@ -924,12 +924,6 @@ static int anx78xx_bridge_attach(struct drm_bridge *bridge,
 	drm_connector_helper_add(&anx78xx->connector,
 				 &anx78xx_connector_helper_funcs);
 
-	err = drm_connector_register(&anx78xx->connector);
-	if (err) {
-		DRM_ERROR("Failed to register connector: %d\n", err);
-		return err;
-	}
-
 	anx78xx->connector.polled = DRM_CONNECTOR_POLL_HPD;
 
 	err = drm_connector_attach_encoder(&anx78xx->connector,
@@ -939,6 +933,12 @@ static int anx78xx_bridge_attach(struct drm_bridge *bridge,
 		return err;
 	}
 
+	err = drm_connector_register(&anx78xx->connector);
+	if (err) {
+		DRM_ERROR("Failed to register connector: %d\n", err);
+		return err;
+	}
+
 	return 0;
 }
 
-- 
2.30.2

