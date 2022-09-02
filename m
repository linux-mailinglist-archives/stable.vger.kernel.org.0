Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 208A65AB05B
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237908AbiIBMxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237832AbiIBMwM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:52:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02A7E3C15;
        Fri,  2 Sep 2022 05:37:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09656B82ADC;
        Fri,  2 Sep 2022 12:36:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51248C433D6;
        Fri,  2 Sep 2022 12:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122176;
        bh=bjudZrNeUpvg5Lss11TNiew6QgCwcwuADvT+V+h6Z04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ahxpi54yCNQxaoH3zJ4dYIuDXL+z0OXX3JE+fxqc8nkkz6cQpqBliDfRVS2Rv9h0i
         w7aBrklwiXCrDJsrsKgukB0zATjFXE+6c9hhVJCzV2JjmF2e5HRmFpi2dv61Jap4Aw
         6BDaQwaZyHXR+Tk77L5NqjIuab944CAwIhPOc/pA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Koo <Anthony.Koo@amd.com>,
        Tom Chung <chiahsuan.chung@amd.com>,
        Chiawen Huang <chiawen.huang@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 37/72] drm/amd/display: Device flash garbage before get in OS
Date:   Fri,  2 Sep 2022 14:19:13 +0200
Message-Id: <20220902121406.001515134@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e3a62873c0e70..d9ab279915355 100644
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



