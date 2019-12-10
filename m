Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F862119674
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfLJV1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:27:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729383AbfLJVZ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:25:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1647B20838;
        Tue, 10 Dec 2019 21:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013128;
        bh=/SVe0pXGAgiWiU2Aj/V5oelee8zM1PXTQwlxRsZFXfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=faz4JOax0bCt5FUiU9HVE5JPH/jOAo6gysdzyZBmcZfmXIf0icq9dAjLqmPUoOhPC
         hdZq7/vVBxSwAD+dOj6/WeoA6RH8GSvJMm9NLNAzcu+3Tm4qfEl0pL2uSR7y9waD8N
         cOjE1qCk53JbqJ+axlZUpc9tIWTjQsuG5lTnUjiY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Tsai <martin.tsai@amd.com>,
        Charlene Liu <Charlene.Liu@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 013/292] drm/amd/display: Handle virtual signal type in disable_link()
Date:   Tue, 10 Dec 2019 16:20:32 -0500
Message-Id: <20191210212511.11392-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210212511.11392-1-sashal@kernel.org>
References: <20191210212511.11392-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Tsai <martin.tsai@amd.com>

[ Upstream commit 616f5b65f1c02d3d6ae370644670d14c57de2fd8 ]

[Why]
The new implementation changed the behavior to allow process setMode
to DAL when DAL returns empty mode query for unplugged display.
This will trigger additional disable_link().
When unplug HDMI from MST dock, driver will update stream->signal to
"Virtual". disable_link() will call disable_output() if the signal type
is not DP and induce other displays on MST dock show black screen.

[How]
Don't need to process disable_output() if the signal type is virtual.

Signed-off-by: Martin Tsai <martin.tsai@amd.com>
Reviewed-by: Charlene Liu <Charlene.Liu@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index 355b4ba127966..90217cf83ce17 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -2157,8 +2157,10 @@ static void disable_link(struct dc_link *link, enum signal_type signal)
 			dp_set_fec_ready(link, false);
 		}
 #endif
-	} else
-		link->link_enc->funcs->disable_output(link->link_enc, signal);
+	} else {
+		if (signal != SIGNAL_TYPE_VIRTUAL)
+			link->link_enc->funcs->disable_output(link->link_enc, signal);
+	}
 
 	if (signal == SIGNAL_TYPE_DISPLAY_PORT_MST) {
 		/* MST disable link only when no stream use the link */
-- 
2.20.1

