Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAEA554921A
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380070AbiFMN50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381127AbiFMN4I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:56:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0EE87A22;
        Mon, 13 Jun 2022 04:36:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1B06B80ECA;
        Mon, 13 Jun 2022 11:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29E9C34114;
        Mon, 13 Jun 2022 11:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120196;
        bh=WOZZ81gRLciIhVRawU+i1v+Da6F8SDjqNSRRDxrrypA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gx/h2CvMe8w5T19lU7gp6M6ajEkj2vzA6gmHLbN7zjVC9glERyVz7ZfLtarx4wlAO
         PCHYgZxkiPXZE72Gbd4AJRZs9FxAVPYP4E9nEzUPVFUVr9kwaH71tTG9u4bPnIfVLe
         62mFld0WWfwCQ7Xb4+TxbDTZnQjwJ3SgkKurNYcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 265/339] drm/amd/display: Check zero planes for OTG disable W/A on clock change
Date:   Mon, 13 Jun 2022 12:11:30 +0200
Message-Id: <20220613094934.686145142@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 66a197203794339b028eedfa880bff9367fce783 ]

[Why]
A display clock change hang can occur when switching between DIO and HPO
enabled modes during the optimize_bandwidth in dc_commit_state_no_check
call.

This happens when going from 4k120 8bpc 420 to 4k144 10bpc 444.

Display clock in the DIO case is 1200MHz, but pixel rate is 600MHz
because the pixel format is 420.

Display clock in the HPO case is less (800MHz?) because of ODM combine
which results in a smaller divider.

The DIO is still active in prepare but not active in the optimize which
results in the hang occuring.

During this change there are no planes on the stream so it's safe to
apply the workaround, but dpms_off = false and signal type is not
virtual.

[How]
Check for plane_count == 0, no planes on the stream.

It's easiest to check pipe->plane_state == NULL as an equivalent check
rather than trying to search for the stream status in the context
associated with the stream, so let's do that.

The primary, non MPO pipe should not have a NULL plane state.

Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c | 3 ++-
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn316/dcn316_clk_mgr.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
index 8be4c1970628..3bf2ab2ff7f8 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
@@ -91,7 +91,8 @@ static void dcn315_disable_otg_wa(struct clk_mgr *clk_mgr_base, bool disable)
 
 		if (pipe->top_pipe || pipe->prev_odm_pipe)
 			continue;
-		if (pipe->stream && (pipe->stream->dpms_off || dc_is_virtual_signal(pipe->stream->signal))) {
+		if (pipe->stream && (pipe->stream->dpms_off || pipe->plane_state == NULL ||
+				     dc_is_virtual_signal(pipe->stream->signal))) {
 			if (disable)
 				pipe->stream_res.tg->funcs->immediate_disable_crtc(pipe->stream_res.tg);
 			else
diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn316/dcn316_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn316/dcn316_clk_mgr.c
index 3121dd2d2a91..fc3af81ed6c6 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn316/dcn316_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn316/dcn316_clk_mgr.c
@@ -122,7 +122,8 @@ static void dcn316_disable_otg_wa(struct clk_mgr *clk_mgr_base, bool disable)
 
 		if (pipe->top_pipe || pipe->prev_odm_pipe)
 			continue;
-		if (pipe->stream && (pipe->stream->dpms_off || dc_is_virtual_signal(pipe->stream->signal))) {
+		if (pipe->stream && (pipe->stream->dpms_off || pipe->plane_state == NULL ||
+				     dc_is_virtual_signal(pipe->stream->signal))) {
 			if (disable)
 				pipe->stream_res.tg->funcs->immediate_disable_crtc(pipe->stream_res.tg);
 			else
-- 
2.35.1



