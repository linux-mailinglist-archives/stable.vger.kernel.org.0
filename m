Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA8E371CE4
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233861AbhECQ5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:57:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234808AbhECQy5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:54:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 165D56194B;
        Mon,  3 May 2021 16:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060142;
        bh=T/BvDwoZpQY0GmXYsh1qNJ/JP9je+BpWPB9PItA6alc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kd3SEJdlAFRFHqIczFWRd7B9UZSpsBzB4m6KI6TZK6rqL+nmJ8BIzJn32QUo7cyRQ
         2fNsy3VqfHR8JFOlQo2ofoC1q9yD+XfCarQSzgLk9HQo5O5BXauc5hKd4wUydRryCG
         7w2prFxmy3YxhD5BXwxZLDhzUfgfYa2ylPY7GwAbfEflR0sqM1PtJZ/y7uKeRP5JtQ
         in/l/hN7o7zDPse+icywrQ/aUuxHVt6K0QzwtOnGITC9iveI8VZpfZEwNmeQVAZzJy
         XbQQTX/NK5PXThtTF9Go7vA4nBQTJ4PZF1HJDeLiU5Gaa5R5g5YuyR6HhW6kOuEDq7
         4n53mFIXAU/8Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lyude Paul <lyude@redhat.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 12/31] drm/bridge/analogix/anx78xx: Cleanup on error in anx78xx_bridge_attach()
Date:   Mon,  3 May 2021 12:41:45 -0400
Message-Id: <20210503164204.2854178-12-sashal@kernel.org>
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
index a5a690dd44c2..176ad7a7756e 100644
--- a/drivers/gpu/drm/bridge/analogix-anx78xx.c
+++ b/drivers/gpu/drm/bridge/analogix-anx78xx.c
@@ -1038,7 +1038,7 @@ static int anx78xx_bridge_attach(struct drm_bridge *bridge)
 				 DRM_MODE_CONNECTOR_DisplayPort);
 	if (err) {
 		DRM_ERROR("Failed to initialize connector: %d\n", err);
-		return err;
+		goto aux_unregister;
 	}
 
 	drm_connector_helper_add(&anx78xx->connector,
@@ -1050,16 +1050,21 @@ static int anx78xx_bridge_attach(struct drm_bridge *bridge)
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

