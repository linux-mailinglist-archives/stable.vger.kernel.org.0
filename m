Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EECD371ABA
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbhECQkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:40:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232177AbhECQjO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:39:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13F17613BB;
        Mon,  3 May 2021 16:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059836;
        bh=VUsUoSoPL5v+qZayowjA+mySGwhYA3TEbe5Rg7Vt3YI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JcU0M8V7+hrTS/KXjj+/7Uy5HDrmdB05EcYVVLzdzX4RlDWTBPj9VvJ1oROOyGdky
         voXuBh6bQ5Kd64yFACKTaaZJnciaSnOcEgEoiUaSvo48u6z6NzCxbZzKQ818W42WLs
         AkWedfAmyh4jG0dsE069CpExuKq38bBTQA2fW3DsyVwtPbgWZIeU2ZedeyrrT5qfYX
         XVawuC13/q8QqOuYw62OpJEIvt9XXWvjw9Zx5yWf2cSW6UhTQiyZwDGYkPBkoXQBGj
         n6SkMEa7UnxFqy+TLNQwSNXbs+8vftDvNpkD/Lr+WHtKkrjVVmK6PIgHyZJGyNOrWJ
         gZ7CaJ6QzU8wg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wyatt Wood <wyatt.wood@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Anthony Koo <Anthony.Koo@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.11 010/115] drm/amd/display: Return invalid state if GPINT times out
Date:   Mon,  3 May 2021 12:35:14 -0400
Message-Id: <20210503163700.2852194-10-sashal@kernel.org>
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

From: Wyatt Wood <wyatt.wood@amd.com>

[ Upstream commit 8039bc7130ef4206a58e4dc288621bc97eba08eb ]

[Why]
GPINT timeout is causing PSR_STATE_0 to be returned when it shouldn't.
We must guarantee that PSR is fully disabled before doing hw programming
on driver-side.

[How]
Return invalid state if GPINT command times out. Let existing retry
logic send the GPINT until successful.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Wyatt Wood <wyatt.wood@amd.com>
Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c b/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c
index 17e84f34ceba..e0b195cad9ce 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c
@@ -81,13 +81,18 @@ static void dmub_psr_get_state(struct dmub_psr *dmub, enum dc_psr_state *state)
 {
 	struct dmub_srv *srv = dmub->ctx->dmub_srv->dmub;
 	uint32_t raw_state;
+	enum dmub_status status = DMUB_STATUS_INVALID;
 
 	// Send gpint command and wait for ack
-	dmub_srv_send_gpint_command(srv, DMUB_GPINT__GET_PSR_STATE, 0, 30);
-
-	dmub_srv_get_gpint_response(srv, &raw_state);
-
-	*state = convert_psr_state(raw_state);
+	status = dmub_srv_send_gpint_command(srv, DMUB_GPINT__GET_PSR_STATE, 0, 30);
+
+	if (status == DMUB_STATUS_OK) {
+		// GPINT was executed, get response
+		dmub_srv_get_gpint_response(srv, &raw_state);
+		*state = convert_psr_state(raw_state);
+	} else
+		// Return invalid state when GPINT times out
+		*state = 0xFF;
 }
 
 /**
-- 
2.30.2

