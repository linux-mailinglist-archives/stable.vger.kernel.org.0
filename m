Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82D837FB08
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732083AbfHBNgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:36:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393305AbfHBNUN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:20:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD0FC2173E;
        Fri,  2 Aug 2019 13:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752012;
        bh=a7cc0qIF7OBAKtAeI32olxn86HEJddZqs8H8D7st0jE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xHXcOvUXOk/NwkpZ0gx+/8tqLoGauvB577sISgKzdT5lKaaizg/yzpWE4+OeHGRfY
         t4cBHoR78aJqRfM3ixppV8jDfRV1DpvzkL4aA8haCuP+MBlQtXsmthByTJTSoD/a8H
         gPkkufRPZuNK61pL7baPUyoKu5lxNqrFErnhETJA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Murton Liu <murton.liu@amd.com>, Tony Cheng <Tony.Cheng@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 17/76] drm/amd/display: Clock does not lower in Updateplanes
Date:   Fri,  2 Aug 2019 09:18:51 -0400
Message-Id: <20190802131951.11600-17-sashal@kernel.org>
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

From: Murton Liu <murton.liu@amd.com>

[ Upstream commit 492d9ec244923420af96db6b69ad7d575859aa92 ]

[why]
We reset the optimized_required in atomic_plane_disable
flag immediately after it is set in atomic_plane_disconnect, causing us to
never have flag set during next flip in UpdatePlanes.

[how]
Optimize directly after each time plane is removed.

Signed-off-by: Murton Liu <murton.liu@amd.com>
Reviewed-by: Tony Cheng <Tony.Cheng@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index 9e4d70a0055e1..c7b4c3048b71d 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -2416,6 +2416,12 @@ static void dcn10_apply_ctx_for_surface(
 		if (removed_pipe[i])
 			dcn10_disable_plane(dc, &dc->current_state->res_ctx.pipe_ctx[i]);
 
+	for (i = 0; i < dc->res_pool->pipe_count; i++)
+		if (removed_pipe[i]) {
+			dc->hwss.optimize_bandwidth(dc, context);
+			break;
+		}
+
 	if (dc->hwseq->wa.DEGVIDCN10_254)
 		hubbub1_wm_change_req_wa(dc->res_pool->hubbub);
 }
-- 
2.20.1

