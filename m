Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58088374174
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbhEEQiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:38:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234635AbhEEQgM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:36:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A94861451;
        Wed,  5 May 2021 16:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232394;
        bh=4N1VnSowxjtPzLGsyxOhhpjhKP9ydqUkpr6ef5+zdF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LOVSaMbNpIDzzOQVkMpwOCzkNwu0iN+luVSFKZ8CHAkABvwC1iKW7SlTrKIoZPfNr
         WuuwXPayygG5jvE/NMwsEwdC4vT76IwDO9wFUBF2cvLt+/W1reTPJquNd/nyH9XojG
         l0UUEWwIN0oPpd/WjjShwokH2t0fPSvMKqqMjhyx2wc39d3sH7k9HbFZhy3pd2uTbQ
         FpL4niE2Rf79MBfB4iYFAkyJh87wYPyXIKBXJTsFFXK1MHSLrDYgAd3wpgoPrlJ6Sw
         erp0tU8ISn0rJW+bYWGOkQDgmRZPnSocV+5M4yvKWpdfa9Dx4ikop3d3LuOFdrBXrs
         ++dVbRJYFW/9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anthony Wang <anthony1.wang@amd.com>,
        Bindu Ramamurthy <bindur12@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 077/116] drm/amd/display: Force vsync flip when reconfiguring MPCC
Date:   Wed,  5 May 2021 12:30:45 -0400
Message-Id: <20210505163125.3460440-77-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
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
index 8f8a13c7cf73..2673a7125603 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2545,6 +2545,10 @@ static void commit_planes_for_stream(struct dc *dc,
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

