Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC0D371CE6
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbhECQ5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:57:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234805AbhECQy5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:54:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9A916194E;
        Mon,  3 May 2021 16:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060141;
        bh=wzI+3BMgLfQxHwEx0Ch9VfsmOyy/39Yuk0A4wmNir6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z6MENbNaBgV5eBuCvyq6xzrYQNksEMaHY7TvhM0KGZwNGGaPk38suQXVuyBBsrrVC
         HgI68SZs1S9dt1XfVaPDNjMHtcHMn8ZKaDnLPU0tYPk2pvtTz99BqLqLlXV6Crf0N7
         KardtriHc9eAhTgJfOJGmZDXZ2u7QGZuoQT51WB5Y/Ho6h2KcB3bKWL/P2n2pfuI0x
         jsDmGCU9tfrNnQizu6YNg4/FLBowfR56fS6ex3Ihw8BSg7/GkAohxoOJoPuO12VMFX
         aYacvx81Gf3TdQ+pnEfd5Rh1cCrYCuHYBdmzDD9RgbQiXZpuOGXpVWkdj5okOf5sFG
         Ryqyrq2MdkWhQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lyude Paul <lyude@redhat.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 11/31] drm/bridge/analogix/anx78xx: Setup encoder before registering connector
Date:   Mon,  3 May 2021 12:41:44 -0400
Message-Id: <20210503164204.2854178-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164204.2854178-1-sashal@kernel.org>
References: <20210503164204.2854178-1-sashal@kernel.org>
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
index cd2bfd7bf048..a5a690dd44c2 100644
--- a/drivers/gpu/drm/bridge/analogix-anx78xx.c
+++ b/drivers/gpu/drm/bridge/analogix-anx78xx.c
@@ -1044,12 +1044,6 @@ static int anx78xx_bridge_attach(struct drm_bridge *bridge)
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
@@ -1059,6 +1053,12 @@ static int anx78xx_bridge_attach(struct drm_bridge *bridge)
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

