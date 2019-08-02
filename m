Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C40077F8A8
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393571AbfHBNVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:21:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393531AbfHBNVX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:21:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F4BE21849;
        Fri,  2 Aug 2019 13:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752082;
        bh=tfCEAaZ/7wP7IyWf1wpi3ulEwPG2rgB//jXsv3f5eC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OjjHyc4Xsh0LUSdZK2uXSM2L3Yz3mIpVS+KdJGYYDF7vcQNmDp/cFyzJuqoGhZ33k
         qStkfywsxo65kn52ymy/MrfaxvapY4hJzEAtEuErYRUp/afCi/HuhHMU3XMm9AGgRK
         VLhhUeLp8trzztoIptLXv9vkds7/PLEMeDR1a8nc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 43/76] drm: silence variable 'conn' set but not used
Date:   Fri,  2 Aug 2019 09:19:17 -0400
Message-Id: <20190802131951.11600-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit bbb6fc43f131f77fcb7ae8081f6d7c51396a2120 ]

The "struct drm_connector" iteration cursor from
"for_each_new_connector_in_state" is never used in atomic_remove_fb()
which generates a compilation warning,

drivers/gpu/drm/drm_framebuffer.c: In function 'atomic_remove_fb':
drivers/gpu/drm/drm_framebuffer.c:838:24: warning: variable 'conn' set
but not used [-Wunused-but-set-variable]

Silence it by marking "conn" __maybe_unused.

Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/1563822886-13570-1-git-send-email-cai@lca.pw
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_framebuffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_framebuffer.c b/drivers/gpu/drm/drm_framebuffer.c
index d8d75e25f6fb8..45f6f11a88a74 100644
--- a/drivers/gpu/drm/drm_framebuffer.c
+++ b/drivers/gpu/drm/drm_framebuffer.c
@@ -830,7 +830,7 @@ static int atomic_remove_fb(struct drm_framebuffer *fb)
 	struct drm_device *dev = fb->dev;
 	struct drm_atomic_state *state;
 	struct drm_plane *plane;
-	struct drm_connector *conn;
+	struct drm_connector *conn __maybe_unused;
 	struct drm_connector_state *conn_state;
 	int i, ret;
 	unsigned plane_mask;
-- 
2.20.1

