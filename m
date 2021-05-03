Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85315371C13
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbhECQvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232896AbhECQst (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:48:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C96B613C1;
        Mon,  3 May 2021 16:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060009;
        bh=eS273gei3xGe9tYr+x2MWS0uD8ncESfNV9l6GnaN0yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uh1fE10k4Noe0HTeefO6t+74tphJAlVwt2Fc1pu7k2WLS/97PFDtbGzdsw510Ms6H
         DvgXRa/GhIJ7rCTB4yvWBTP/lBnuYAZj4hLxxFTXAXRwroFapoyNi0iKIFrlhsEcza
         FoCgIf3MUmPeIgOTY/+VRwLs6C5V8Jgz/J8zEWUzNmrS2aNUei5i1uh0xAFYRswNT2
         LZV2UOnV5twe5YFRvDZV4qb2PKK9jFyiOrwGjrUOZQgekfWmRjwX19myX9Keibi7R1
         Fz0XjPSVds0tIr7M8xBufIB0Zr9KTEZrxAfOwb/SN5EZNaR9DufOywhbw6a9W1N4d9
         iQ66dCMWpTdIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lyude Paul <lyude@redhat.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 18/57] drm/bridge/analogix/anx78xx: Setup encoder before registering connector
Date:   Mon,  3 May 2021 12:39:02 -0400
Message-Id: <20210503163941.2853291-18-sashal@kernel.org>
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
 drivers/gpu/drm/bridge/analogix-anx78xx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix-anx78xx.c b/drivers/gpu/drm/bridge/analogix-anx78xx.c
index 56df07cdab68..fcbad1ed865a 100644
--- a/drivers/gpu/drm/bridge/analogix-anx78xx.c
+++ b/drivers/gpu/drm/bridge/analogix-anx78xx.c
@@ -1032,12 +1032,6 @@ static int anx78xx_bridge_attach(struct drm_bridge *bridge)
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
@@ -1047,6 +1041,12 @@ static int anx78xx_bridge_attach(struct drm_bridge *bridge)
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

