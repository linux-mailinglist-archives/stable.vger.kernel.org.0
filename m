Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6D0383283
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240799AbhEQOsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:48:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239257AbhEQOq1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:46:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 559F8613B4;
        Mon, 17 May 2021 14:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261300;
        bh=OT2xe5sXKYsd7f39Gy+N4bEwk5BTrFNQS8/sq9zd/uQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JeowxsEJykWK3JEMHzWLGy+5yZj4f+xUGCBJ4wDTAB9dvhQeXWB6LZauiAzlwf9d5
         x69y1X6imHJZwNvnHuQi2gnx17EeTJR0VLa1S1IAut19rGtpN0NA579Z7IifXyXH6L
         Gm7fqU+8dWypF2vaBGsM93JiGtRYeYTcF6XfpzA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Wang <anthony1.wang@amd.com>,
        Bindu Ramamurthy <bindur12@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 075/329] drm/amd/display: Force vsync flip when reconfiguring MPCC
Date:   Mon, 17 May 2021 15:59:46 +0200
Message-Id: <20210517140304.627331742@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ccac86347315..2d4f8780922e 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2528,6 +2528,10 @@ static void commit_planes_for_stream(struct dc *dc,
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



