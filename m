Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC8C95F95BB
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbiJJAWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbiJJAVT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:21:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F943912A;
        Sun,  9 Oct 2022 16:55:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E299D60C9B;
        Sun,  9 Oct 2022 23:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44218C433C1;
        Sun,  9 Oct 2022 23:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359740;
        bh=qmVEbOkpk+LA8I1hlZC30Ru65c14HXPYd60NGXATpGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D5SvagtbzuNKj2oUI9cl6qsXJJYLVDlqhcXTLaF7Rg62YAl3zkff96HVO13OsWTxB
         lHk7wy/ghPe64zs+HoEcRzgkyfSW79R3JvBw1GJG+dqB24CiXFcqBXJ+wtugI4f+u2
         Pfkng+WMvHySQGhkx7k17bbdceDGjN5N761SWuVIgoBn8Prnps4Qhs9JgyVdAv5lrO
         ozNC5fAsxx9VPFQKNgca6nYPfuE6TQ6qVxw2MC3rrIK4xzKu8PxFAvO+2B7ZRQq58U
         pngecp/xTpMkikvM3txfRsv0QYeWWsHDG3erFh2X4fT/2Q/CeahiZAW37kjgsZVhjr
         gjLOmGZSZ8C+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, Alvin.Lee2@amd.com, Pavle.Kotarac@amd.com,
        alex.hung@amd.com, hersenwu@amd.com, hanghong.ma@amd.com,
        paul.hsieh@amd.com, Jimmy.Kizito@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 25/25] drm/amd/display: fix array-bounds error in dc_stream_remove_writeback()
Date:   Sun,  9 Oct 2022 19:54:25 -0400
Message-Id: <20221009235426.1231313-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009235426.1231313-1-sashal@kernel.org>
References: <20221009235426.1231313-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hamza Mahfooz <hamza.mahfooz@amd.com>

[ Upstream commit 5d8c3e836fc224dfe633e41f7f2856753b39a905 ]

Address the following error:
drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_stream.c: In function ‘dc_stream_remove_writeback’:
drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_stream.c:527:55: error: array subscript [0, 0] is outside array bounds of ‘struct dc_writeback_info[1]’ [-Werror=array-bounds]
  527 |                                 stream->writeback_info[j] = stream->writeback_info[i];
      |                                 ~~~~~~~~~~~~~~~~~~~~~~^~~
In file included from ./drivers/gpu/drm/amd/amdgpu/../display/dc/dc.h:1269,
                 from ./drivers/gpu/drm/amd/amdgpu/../display/dc/inc/core_types.h:29,
                 from ./drivers/gpu/drm/amd/amdgpu/../display/dc/basics/dc_common.h:29,
                 from drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_stream.c:27:
./drivers/gpu/drm/amd/amdgpu/../display/dc/dc_stream.h:241:34: note: while referencing ‘writeback_info’
  241 |         struct dc_writeback_info writeback_info[MAX_DWB_PIPES];
      |

Currently, we aren't checking to see if j remains within
writeback_info[]'s bounds. So, add a check to make sure that we aren't
overflowing the buffer.

Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_stream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_stream.c b/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
index f0f54f4d3d9b..1f1f3d3c8884 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
@@ -519,7 +519,7 @@ bool dc_stream_remove_writeback(struct dc *dc,
 	}
 
 	/* remove writeback info for disabled writeback pipes from stream */
-	for (i = 0, j = 0; i < stream->num_wb_info; i++) {
+	for (i = 0, j = 0; i < stream->num_wb_info && j < MAX_DWB_PIPES; i++) {
 		if (stream->writeback_info[i].wb_enabled) {
 			if (i != j)
 				/* trim the array */
-- 
2.35.1

