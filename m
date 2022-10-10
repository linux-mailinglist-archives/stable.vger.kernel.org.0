Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29AC85F99CF
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbiJJHRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232307AbiJJHQx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:16:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD005F236;
        Mon, 10 Oct 2022 00:10:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1BA960E9C;
        Mon, 10 Oct 2022 07:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA22C433D6;
        Mon, 10 Oct 2022 07:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385741;
        bh=78pDdmUUoG5H2aYN979n9Ka348bWLEmrB9jrOrOhNOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n8vT/pUVmiOVAQRYnwrTIvMMiB++JLJi2TCK1kNG3FOMWRK1M2VEvFQEuwhtDoqeq
         R4r44uKin/t7QlSD9wjYWJ9wuGM6ze4HBWR8WOP+nAQpANfoOSKVAGaDaPZOZ1JBen
         JSTxh1HpD27wVCGaitJMVx9XYySRB7DMOADGYZTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Charlene Liu <Charlene.Liu@amd.com>,
        Wayne Lin <wayne.lin@amd.com>, zhikzhai <zhikai.zhai@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 27/37] drm/amd/display: skip audio setup when audio stream is enabled
Date:   Mon, 10 Oct 2022 09:05:46 +0200
Message-Id: <20221010070331.998147874@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070331.211113813@linuxfoundation.org>
References: <20221010070331.211113813@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhikzhai <zhikai.zhai@amd.com>

[ Upstream commit 65fbfb02c2734cacffec5e3f492e1b4f1dabcf98 ]

[why]
We have minimal pipe split transition method to avoid pipe
allocation outage.However, this method will invoke audio setup
which cause audio output stuck once pipe reallocate.

[how]
skip audio setup for pipelines which audio stream has been enabled

Reviewed-by: Charlene Liu <Charlene.Liu@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: zhikzhai <zhikai.zhai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
index 62d595ded866..46d7e75e4553 100644
--- a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
@@ -2108,7 +2108,8 @@ static void dce110_setup_audio_dto(
 			continue;
 		if (pipe_ctx->stream->signal != SIGNAL_TYPE_HDMI_TYPE_A)
 			continue;
-		if (pipe_ctx->stream_res.audio != NULL) {
+		if (pipe_ctx->stream_res.audio != NULL &&
+			pipe_ctx->stream_res.audio->enabled == false) {
 			struct audio_output audio_output;
 
 			build_audio_output(context, pipe_ctx, &audio_output);
@@ -2156,7 +2157,8 @@ static void dce110_setup_audio_dto(
 			if (!dc_is_dp_signal(pipe_ctx->stream->signal))
 				continue;
 
-			if (pipe_ctx->stream_res.audio != NULL) {
+			if (pipe_ctx->stream_res.audio != NULL &&
+				pipe_ctx->stream_res.audio->enabled == false) {
 				struct audio_output audio_output;
 
 				build_audio_output(context, pipe_ctx, &audio_output);
-- 
2.35.1



