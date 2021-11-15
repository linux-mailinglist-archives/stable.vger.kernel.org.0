Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F4C45210E
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359375AbhKPA5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:57:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:44628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245621AbhKOTUv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 317F263298;
        Mon, 15 Nov 2021 18:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001484;
        bh=knCY6D7aCB+BkrG8V+oWIX0tCtUxpWh8jsn5yxxGT9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XmDRL+OW3XOsghFdl3DEvh5/Kmr2kcWMEezHUFKWyEwXRnvHYjlncMbcg/8DHaZ8O
         yqHchgf9QzwEXuD4VlZunvy0xgdgRqi6GpwZToAjFg/ts8uS+tsipB2gZMf327T9dc
         /gMM2Lq0n4gJ/DsBcRmZROgQsyopP2ZYpKZ2xZoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aric Cyr <aric.cyr@amd.com>,
        Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Jimmy Kizito <Jimmy.Kizito@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 209/917] drm/amd/display: Fix null pointer dereference for encoders
Date:   Mon, 15 Nov 2021 17:55:04 +0100
Message-Id: <20211115165435.883812536@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jimmy Kizito <Jimmy.Kizito@amd.com>

[ Upstream commit 60f39edd897ea134a4ddb789a6795681691c3183 ]

[Why]
Links which are dynamically assigned link encoders have their link
encoder set to NULL.

[How]
Check that a pointer to a link_encoder object is non-NULL before using
it.

Reviewed-by: Aric Cyr <aric.cyr@amd.com>
Reviewed-by: Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Jimmy Kizito <Jimmy.Kizito@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c          | 2 +-
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 6d655e158267a..61c18637f84dc 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -4690,7 +4690,7 @@ enum dc_status dp_set_fec_ready(struct dc_link *link, bool ready)
 				link_enc->funcs->fec_set_ready(link_enc, true);
 				link->fec_state = dc_link_fec_ready;
 			} else {
-				link_enc->funcs->fec_set_ready(link->link_enc, false);
+				link_enc->funcs->fec_set_ready(link_enc, false);
 				link->fec_state = dc_link_fec_not_ready;
 				dm_error("dpcd write failed to set fec_ready");
 			}
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index df8a7718a85fc..3af49cdf89ebd 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -1522,7 +1522,7 @@ void dcn10_power_down_on_boot(struct dc *dc)
 		for (i = 0; i < dc->link_count; i++) {
 			struct dc_link *link = dc->links[i];
 
-			if (link->link_enc->funcs->is_dig_enabled &&
+			if (link->link_enc && link->link_enc->funcs->is_dig_enabled &&
 					link->link_enc->funcs->is_dig_enabled(link->link_enc) &&
 					dc->hwss.power_down) {
 				dc->hwss.power_down(dc);
-- 
2.33.0



