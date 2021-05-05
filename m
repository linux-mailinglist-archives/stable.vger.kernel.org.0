Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBEFE374420
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235485AbhEEQzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:55:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235909AbhEEQw3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:52:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 408286196A;
        Wed,  5 May 2021 16:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232685;
        bh=mt2R+8JS1xLAN56xbzwOwags2O8P8O8k/TJCfgL04mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qLH+Y/djmswn9NV5JhLd8h5IL1ApwjQVQdR9rTSrNizvZEgm9su17Rv0rip9WQf5Z
         3Zg4+QNyydaJ4JnxPiFZth8UocjXMdTEtiQBdfWP2mwO0yMAuQVBlU+ajfHMemigAD
         0+tG8ldAmomzwvLzPqlJByDitOfFLK5dwxAhIiUsp3zIQ+61gE4De/tU/NWvJ+2ZOb
         RVRtSbtg8GxCAnDZ+mA0hEGcSxJ3Blgz2jnuQchSSRE7Ha6kb8+2+BKrKtxNLerSTL
         CN7t3KSepNJ0kF7/557IqNaPBSXVRWnN/iUV2HDVsmgWUBnNeDOymGhjWEtvqWNupp
         6l/2wr8JWQo+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anthony Wang <anthony1.wang@amd.com>,
        Bindu Ramamurthy <bindur12@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 52/85] drm/amd/display: Force vsync flip when reconfiguring MPCC
Date:   Wed,  5 May 2021 12:36:15 -0400
Message-Id: <20210505163648.3462507-52-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
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
index ffb21196bf59..b82c6f2cd986 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2503,6 +2503,10 @@ static void commit_planes_for_stream(struct dc *dc,
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

