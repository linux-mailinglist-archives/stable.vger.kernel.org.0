Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0813BCC9C
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbhGFLTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:19:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232665AbhGFLSv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:18:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAE9661C74;
        Tue,  6 Jul 2021 11:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570172;
        bh=oWnmd/UJFwruZAvf/2/WizP7J0qUKfh90AqYVxpouk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dZLGv4Y/uGS+56B1cjgiKDzl09781/8gFIun6G2cx2IfV8eVgBpjK1k3rBWfm/Glw
         heuwtrHdS6QxAoR2tvQn/4Xy1xTOkL2gGT4ucta8uYWJqEJL24vbbG29V70CpQ43kg
         kwrLTbgNeCGDOY0C7pNJB3cp44JrSXdo7+DNcJtnP2SURbI8HocrFwNP9KL9ha7I9T
         1FX/ezA9LEThImtVgq3ukY60LgXyzlsM/GY3XeIuvH1JS5+S+sh8H59DCjmaGj2wDA
         hITuGZGGVGAjKGiNH04XtfenDwOpCBPf6Pjze7vVD37Gl3uxtDok/g2P8dhC8v8/AO
         kyqlRks9hhNrw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Stempen <vladimir.stempen@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 091/189] drm/amd/display: Release MST resources on switch from MST to SST
Date:   Tue,  6 Jul 2021 07:12:31 -0400
Message-Id: <20210706111409.2058071-91-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Stempen <vladimir.stempen@amd.com>

[ Upstream commit 3f8518b60c10aa96f3efa38a967a0b4eb9211ac0 ]

[why]
When OS overrides training link training parameters
for MST device to SST mode, MST resources are not
released and leak of the resource may result crash and
incorrect MST discovery during following hot plugs.

[how]
Retaining sink object to be reused by SST link and
releasing MST  resources.

Signed-off-by: Vladimir Stempen <vladimir.stempen@amd.com>
Reviewed-by: Wenjing Liu <Wenjing.Liu@amd.com>
Acked-by: Stylon Wang <stylon.wang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 3ff3d9e90983..f26ed50a9660 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -1784,6 +1784,8 @@ static void set_dp_mst_mode(struct dc_link *link, bool mst_enable)
 		link->type = dc_connection_single;
 		link->local_sink = link->remote_sinks[0];
 		link->local_sink->sink_signal = SIGNAL_TYPE_DISPLAY_PORT;
+		dc_sink_retain(link->local_sink);
+		dm_helpers_dp_mst_stop_top_mgr(link->ctx, link);
 	} else if (mst_enable == true &&
 			link->type == dc_connection_single &&
 			link->remote_sinks[0] != NULL) {
-- 
2.30.2

