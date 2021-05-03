Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF419371D15
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbhECQ57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:57:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235109AbhECQzs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:55:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AF6161960;
        Mon,  3 May 2021 16:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060184;
        bh=WIG76CGyIA9+uNWOP0/XMmM5VeQlHgJifmN66r/pMnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JREYbyMqKKGtsblIBwe4UD9MLfUxACKss0lUJMDTrnikVKZ44jY/TvKDHKxqZl7fN
         6GaKlr3DSI6QmsNU8yzx5pspln6kKZ7Dy+SbfcS3dozUzs8mhATNq9Yb9J6mQuPgop
         N7qsyHCRNAWZXGMTqC3pXwsFMm0jLTyDit208rdb5XaItU0ZKTSrvUZf1MMcRYQmAD
         HO4StreqVQNJ6BtK8sBF46knXYYlT/LPL/HnGmhaTxNFYAN3kCQgMGj3toAlTIzVEJ
         RlQum77VQco4fj5ZvTDhNXpUCi+vcyaRv/perXtX6plT1bwwvEAM7x0ycW6ZzYlRGF
         u/FI+t1kfw2GA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lyude Paul <lyude@redhat.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.9 08/24] drm/bridge/analogix/anx78xx: Setup encoder before registering connector
Date:   Mon,  3 May 2021 12:42:36 -0400
Message-Id: <20210503164252.2854487-8-sashal@kernel.org>
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
index eb97e88a103c..16babacb7cf0 100644
--- a/drivers/gpu/drm/bridge/analogix-anx78xx.c
+++ b/drivers/gpu/drm/bridge/analogix-anx78xx.c
@@ -1045,12 +1045,6 @@ static int anx78xx_bridge_attach(struct drm_bridge *bridge)
 	drm_connector_helper_add(&anx78xx->connector,
 				 &anx78xx_connector_helper_funcs);
 
-	err = drm_connector_register(&anx78xx->connector);
-	if (err) {
-		DRM_ERROR("Failed to register connector: %d\n", err);
-		return err;
-	}
-
 	anx78xx->connector.polled = DRM_CONNECTOR_POLL_HPD;
 
 	err = drm_mode_connector_attach_encoder(&anx78xx->connector,
@@ -1060,6 +1054,12 @@ static int anx78xx_bridge_attach(struct drm_bridge *bridge)
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

