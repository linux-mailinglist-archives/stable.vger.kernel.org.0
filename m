Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEBFC49A03C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1577773AbiAXXEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:04:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382661AbiAXW4E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:56:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44224C055AA9;
        Mon, 24 Jan 2022 13:11:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AC59B8123A;
        Mon, 24 Jan 2022 21:11:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE66C340E5;
        Mon, 24 Jan 2022 21:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058670;
        bh=Wjq8KJMxSK1M36zLBibg6MlMLF1ZI3aYOkSq2/bc0Lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Msj8iebwpRksyHWuDo3gNlIS4uHSMK0Z6e4RBWjLLu17+NE16jxMKzeVyh78ClQNJ
         55dsENO4COZD3ZxAcL/wVlt2IaI2jc/mlngn/iZwUqKZCcpsvRfUjyqUTmflWgK77v
         HmJ0cT5W/V3v2ceUh7SEL3Y24wuTiM2dmGOjv+EY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0363/1039] drm/amd/display: fix dereference before NULL check
Date:   Mon, 24 Jan 2022 19:35:52 +0100
Message-Id: <20220124184137.484891008@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit f28cad86ada1a7345d7bbd379bef5a8babfa791b ]

The "plane_state" pointer was access before checking if it was NULL.

Avoid a possible NULL pointer dereference by accessing the plane
address after the check.

Addresses-Coverity-ID: 1493892 ("Dereference before null check")
Fixes: 3f68c01be9a22 ("drm/amd/display: add cyan_skillfish display support")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn201/dcn201_hwseq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn201/dcn201_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn201/dcn201_hwseq.c
index cfd09b3f705e9..fe22530242d2e 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn201/dcn201_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn201/dcn201_hwseq.c
@@ -134,11 +134,12 @@ void dcn201_update_plane_addr(const struct dc *dc, struct pipe_ctx *pipe_ctx)
 	PHYSICAL_ADDRESS_LOC addr;
 	struct dc_plane_state *plane_state = pipe_ctx->plane_state;
 	struct dce_hwseq *hws = dc->hwseq;
-	struct dc_plane_address uma = plane_state->address;
+	struct dc_plane_address uma;
 
 	if (plane_state == NULL)
 		return;
 
+	uma = plane_state->address;
 	addr_patched = patch_address_for_sbs_tb_stereo(pipe_ctx, &addr);
 
 	plane_address_in_gpu_space_to_uma(hws, &uma);
-- 
2.34.1



