Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4983744FA
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236684AbhEERDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 13:03:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235984AbhEEQ6D (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:58:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E474F619A7;
        Wed,  5 May 2021 16:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232775;
        bh=vn7zkopesvAyX5w7u5CReiYqmV5eST2UEUgHhxkC5AU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OMzYdahz/E6tNUfupD+BZaS/lvnrCqc3mQ1HSMxPp4IzLi99P+dQgfVwRyYtkg66m
         VNPFMt4p4U/7W9R45HV3F3DLUWVJT/weyQJi1RBw+rCwVQ0ranPbv992elA+y8jW3J
         8WMOaA/kPjHpIutNE4K/5GAfqQPCElAVp0wW0Q2/eqR6+svxoSr8KYAAChelml/hpG
         a8A5rWlG42IJn5GdFi5m8K0vY3j5zbBXzrtOns/Xq1ofevdMN8vhnUoVytVb6J+rRy
         4CRenqvQLmXaSGrDTa2iYt6cug+KvjKpXl0GGx3g2KVqZRj0kDU81TNPzu2wz2fovd
         +kJeXMEgOMw0g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anthony Wang <anthony1.wang@amd.com>,
        Bindu Ramamurthy <bindur12@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 26/46] drm/amd/display: Force vsync flip when reconfiguring MPCC
Date:   Wed,  5 May 2021 12:38:36 -0400
Message-Id: <20210505163856.3463279-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163856.3463279-1-sashal@kernel.org>
References: <20210505163856.3463279-1-sashal@kernel.org>
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
index 68d56a91d44b..7e52510e0997 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2049,6 +2049,10 @@ static void commit_planes_for_stream(struct dc *dc,
 						plane_state->triplebuffer_flips = true;
 				}
 			}
+			if (update_type == UPDATE_TYPE_FULL) {
+				/* force vsync flip when reconfiguring pipes to prevent underflow */
+				plane_state->flip_immediate = false;
+			}
 		}
 	}
 #endif
-- 
2.30.2

