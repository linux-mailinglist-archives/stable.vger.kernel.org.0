Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABFBD59039D
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238157AbiHKQ0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238122AbiHKQZ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:25:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99D23340F;
        Thu, 11 Aug 2022 09:06:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 129D7B82144;
        Thu, 11 Aug 2022 16:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB4AC433C1;
        Thu, 11 Aug 2022 16:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234011;
        bh=+NbcBoOn9FE7aY3UXpty4/oEfp5x3TeKqLDbDZbklKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BFRAlstSoZ2cufQaor9+8hctUF0keDq1Ms9tvC3tPV8v9npHc5TJQli77pR6EiK1F
         QRw0wT5uto0Tofsq+ZkoMT4okjmqODt6/vlTMcX0kIfzsi7+tB6ayEqRKNTncd7sR+
         MS7tGaZzcbhuQU5VggGdiHDR6oMyJMQOpw6jDieNWjK/KaikeJw2CFcDO8Yb6WVvjQ
         V9koi37A1kPfkcN3G8/jAEYmfBBvU5C6YhGoQTXFWBo3jEOZP7uXK3FXgF+3tbJ9s3
         EVHKwEeu1P33Rj1CmNikoGh81Tn+h98vQVlYwsYvzfMC1ZsUR93Xsy9YAYHt+Du/cm
         Cy2Ft3ThJNdUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rahul Kumar <rahul.kumar1@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, sunpeng.li@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, Anthony.Koo@amd.com, Aric.Cyr@amd.com,
        alex.hung@amd.com, Yi-Ling.Chen2@amd.com, Roman.Li@amd.com,
        mwen@igalia.com, hanghong.ma@amd.com, Jerry.Zuo@amd.com,
        agustin.gutierrez@amd.com, dale.zhao@amd.com, isabbasso@riseup.net,
        Sungjoon.Kim@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 29/46] drm/amdgpu/display/dc: Fix null pointer exception
Date:   Thu, 11 Aug 2022 12:03:53 -0400
Message-Id: <20220811160421.1539956-29-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811160421.1539956-1-sashal@kernel.org>
References: <20220811160421.1539956-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Kumar <rahul.kumar1@amd.com>

[ Upstream commit 1c4dae3e4639540fb567e570cc56a3c292afb6fe ]

We observed hard hang due to NULL derefrence This issue is seen after
running system all the time after two or three days

struct dc *dc = plane_state->ctx->dc; Randomly in long run we found
plane_state or plane_state->ctx is found NULL which causes exception.

BUG: kernel NULL pointer dereference, address: 0000000000000000
PF: supervisor read access in kernel mode
PF: error_code(0x0000) - not-present page
PGD 1dc7f2067 P4D 1dc7f2067 PUD 222c75067 PMD 0
Oops: 0000 [#1] SMP NOPTI
CPU: 5 PID: 29855 Comm: kworker/u16:4 ...
...
Workqueue: events_unbound commit_work [drm_kms_helper]
RIP: 0010:dcn10_update_pending_status+0x1f/0xee [amdgpu]
Code: 41 5f c3 0f 1f 44 00 00 b0 01 c3 0f 1f 44 00 00 41 55 41 54 55 53 48 8b 1f 4c 8b af f8 00 00 00 48 8b 83 88 03 00 00 48 85 db <4c> 8b 20 0f 84 bf 00 00 00 48 89 fd 48 8b bf b8 00 00 00 48 8b 07
RSP: 0018:ffff942941997ab8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff8d7fd98d2000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff8d7e3e87c708 RDI: ffff8d7f2d8c0690
RBP: ffff8d7f2d8c0000 R08: ffff942941997a34 R09: 00000000ffffffff
R10: 0000000000005000 R11: 00000000000000f0 R12: ffff8d7f2d8c0690
R13: ffff8d8035a41680 R14: 00000000000186a0 R15: ffff8d7f2d8c1dd8
FS:  0000000000000000(0000) GS:ffff8d8037340000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000148030000 CR4: 00000000003406e0
Call Trace:
 dc_commit_state+0x6a2/0x7f0 [amdgpu]
 amdgpu_dm_atomic_commit_tail+0x460/0x19bb [amdgpu]

Tested-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Rahul Kumar <rahul.kumar1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index 31a13daf4289..7172ec9a11d2 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -3308,7 +3308,7 @@ void dcn10_update_pending_status(struct pipe_ctx *pipe_ctx)
 	struct dc_plane_state *plane_state = pipe_ctx->plane_state;
 	struct timing_generator *tg = pipe_ctx->stream_res.tg;
 	bool flip_pending;
-	struct dc *dc = plane_state->ctx->dc;
+	struct dc *dc = pipe_ctx->stream->ctx->dc;
 
 	if (plane_state == NULL)
 		return;
-- 
2.35.1

