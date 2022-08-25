Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6EC25A05BD
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbiHYBev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbiHYBer (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:34:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39991B76;
        Wed, 24 Aug 2022 18:34:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE958B826C6;
        Thu, 25 Aug 2022 01:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9FFC433D6;
        Thu, 25 Aug 2022 01:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391282;
        bh=yNrF37xl4SIiS1ML8HYlB+YP3QAwylGrbARyAhcG6B8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IFIz2Mjmak3wR4GUl3laq84TYni0/wiiZXWRmK8jCWyENoNcaHcbS6f+UjK7/8qjG
         V5rnJ+LrHa1vwRBn084srLIyLEU1ZQ+t+blRKeo0WXlRohKzn7T8WsgSbk40mmsBD1
         RUCsha18smFyfNZWlWEj+CRdj+0kV94naLcZ/hiP6JLoPFToEgyMFrYhmaSFsgi+HD
         1oEDLRSYxfCXTUfzgZzQwIAodUlrwSicA+JQyedwnHJrQEnAyS/577rXeVSiA3h3Ng
         +Irke+w9fX5Xho+UBil2LYOWXcK1IIG/ZSe/4Qp3OjFEV82mG0bnmIr5VUPExA+Ui6
         CLymlTcM+qL/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chiawen Huang <chiawen.huang@amd.com>,
        Anthony Koo <Anthony.Koo@amd.com>,
        Tom Chung <chiahsuan.chung@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, alex.hung@amd.com, Yi-Ling.Chen2@amd.com,
        Roman.Li@amd.com, mwen@igalia.com, hanghong.ma@amd.com,
        dingchen.zhang@amd.com, Jerry.Zuo@amd.com,
        agustin.gutierrez@amd.com, duncan.ma@amd.com, dale.zhao@amd.com,
        isabbasso@riseup.net, Sungjoon.Kim@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 06/38] drm/amd/display: Device flash garbage before get in OS
Date:   Wed, 24 Aug 2022 21:33:29 -0400
Message-Id: <20220825013401.22096-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013401.22096-1-sashal@kernel.org>
References: <20220825013401.22096-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chiawen Huang <chiawen.huang@amd.com>

[ Upstream commit 9c580e8f6cd6524d4e2c3490c440110526f7ddd6 ]

[Why]
Enabling stream with tg lock makes config settings
pending causing the garbage until tg unlock.

[How]
Keep the original lock mechanism
The driver doesn't lock tg if plane_state is null.

Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Chiawen Huang <chiawen.huang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index e3a62873c0e7..d9ab27991535 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -108,6 +108,7 @@ void dcn10_lock_all_pipes(struct dc *dc,
 		 */
 		if (pipe_ctx->top_pipe ||
 		    !pipe_ctx->stream ||
+		    !pipe_ctx->plane_state ||
 		    !tg->funcs->is_tg_enabled(tg))
 			continue;
 
-- 
2.35.1

