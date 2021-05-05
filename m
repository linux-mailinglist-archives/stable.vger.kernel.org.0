Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6222374279
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235688AbhEEQq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:46:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235877AbhEEQpJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:45:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA4E66194A;
        Wed,  5 May 2021 16:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232553;
        bh=Wp3+YQJhrtqVAsgzmljKiy39v00gAqygm5XilgEOPdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D7yTEQShB9oGvdrpArC9utQjbSqIzzbKo+Be6+0gNzDVqmn8ZDyRoFRTWdy+VyAdy
         RdEQV69STg+uTd7gHAcWzRi5yr43uAXZ92IHvUdvlh/k4BKU6ISkgR6HaOOfd+VZZ/
         pdHMjhz9eI6yCRVW9V0LTGT1182WOwm+2nvNMOfPLSwFV29ThP4Quyz+UE7Jw3Nf38
         aYf33y2A3W+Y16b8D/77nIvTHYikVdVwFjOU1zfEBhMGCAb+H/JO/35+b20LHeBKE7
         lwU5mAmXM1uDGN0YDxetXNWGQ9oovE8hXWsulrEqolI6Ogg6s1n7X3nbBt8FPF7n2M
         ZNVFrsq/sbJwA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anthony Wang <anthony1.wang@amd.com>,
        Bindu Ramamurthy <bindur12@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.11 068/104] drm/amd/display: Force vsync flip when reconfiguring MPCC
Date:   Wed,  5 May 2021 12:33:37 -0400
Message-Id: <20210505163413.3461611-68-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anthony Wang <anthony1.wang@amd.com>

[ Upstream commit 56d63782af9bbd1271bff1422a6a013123eade4d ]

[Why]
Underflow observed when disabling PIP overlay in-game when
vsync is disabled, due to OTC master lock not working with
game pipe which is immediate flip.

[How]
When performing a full update, override flip_immediate value
to false for all planes, so that flip occurs on vsync.

Signed-off-by: Anthony Wang <anthony1.wang@amd.com>
Acked-by: Bindu Ramamurthy <bindur12@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 58eb0d69873a..1eb5bf0b3979 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2527,6 +2527,10 @@ static void commit_planes_for_stream(struct dc *dc,
 						plane_state->triplebuffer_flips = true;
 				}
 			}
+			if (update_type == UPDATE_TYPE_FULL) {
+				/* force vsync flip when reconfiguring pipes to prevent underflow */
+				plane_state->flip_immediate = false;
+			}
 		}
 	}
 
-- 
2.30.2

