Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D6D2E178D
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgLWDLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:11:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:45452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727794AbgLWCSI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B500223139;
        Wed, 23 Dec 2020 02:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689818;
        bh=nA1IdGe3B+/2p3KYi1kkF0FwnQzejUL02uJ+uHEq1uE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BwZXr/2zBRZQLixaFMzoSAf/LULe5lvCzLHSMkdMH6dk2Wtand3K+OpSoCQL+8T4b
         cVNM/yaJeZo+J6tvZJbZltC7Bda38Ra0BC6YCsm9K/Hi9h6BTPJ82c/0px2XzjnOC0
         dzs+eTAkPm3psI8hnBbA7FCCq5QZ4ahYiFlzPf1o9I9+7P8oo/y4syEgq9Pz/WtFa3
         16WQYVxPQMQ3sQgdFopKmsJ1RGbqqldEzdceZT5iuC78MGiOR+71NdSfMFMYr7oInA
         d4hiNH6L+tq7EGT8589D1zP5J0e3YT4VbO8rLDI6ZN2P3ELyGoY9gLWrMVV0rz9FIe
         I9vyL7nwkqWew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Hersen Wu <hersenxs.wu@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 024/217] drm/amd/display: fix recout calculation for left side clip
Date:   Tue, 22 Dec 2020 21:13:13 -0500
Message-Id: <20201223021626.2790791-24-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>

[ Upstream commit 84aef2ab0977199784671295a07043191233d7c7 ]

Recout calculation does not corrrectly handle plane
clip rect that extends beyond the left most border
of stream source rect. This change adds handling by
truncating the invisible clip rect.

Signed-off-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Reviewed-by: Hersen Wu <hersenxs.wu@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 59d48cf819ea8..6d606cc32b09e 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -796,6 +796,8 @@ static void calculate_recout(struct pipe_ctx *pipe_ctx)
 	} else
 		data->recout.x = 0;
 
+	if (stream->src.x > surf_clip.x)
+		surf_clip.width -= stream->src.x - surf_clip.x;
 	data->recout.width = surf_clip.width * stream->dst.width / stream->src.width;
 	if (data->recout.width + data->recout.x > stream->dst.x + stream->dst.width)
 		data->recout.width = stream->dst.x + stream->dst.width - data->recout.x;
@@ -804,6 +806,8 @@ static void calculate_recout(struct pipe_ctx *pipe_ctx)
 	if (stream->src.y < surf_clip.y)
 		data->recout.y += (surf_clip.y - stream->src.y) * stream->dst.height
 						/ stream->src.height;
+	else if (stream->src.y > surf_clip.y)
+		surf_clip.height -= stream->src.y - surf_clip.y;
 
 	data->recout.height = surf_clip.height * stream->dst.height / stream->src.height;
 	if (data->recout.height + data->recout.y > stream->dst.y + stream->dst.height)
-- 
2.27.0

