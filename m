Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B41338DB91
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbfHNREm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:04:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728673AbfHNREm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:04:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C81B214DA;
        Wed, 14 Aug 2019 17:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802281;
        bh=b8t8g1ACQkvCxFBdeFia9t9I2vkxr4sZhptQsOoBZpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hM+m+es5SLJd+d8GyBHf5YF0izXt0emfJ6JeAcbh+OZPeHEmAq7P/o1C1ptjIRuzA
         FQxvzsIINqXaGZkQTgOEoecDsikTIcLC8QU2nfcTDEmRr4iF0KIN69yt1CrkiIt3H0
         OKqasv1bG5UFgh03hLWpZkWK0WeCGWak0YI7G/58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Murton Liu <murton.liu@amd.com>,
        Tony Cheng <Tony.Cheng@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 065/144] drm/amd/display: Clock does not lower in Updateplanes
Date:   Wed, 14 Aug 2019 19:00:21 +0200
Message-Id: <20190814165802.555579467@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



