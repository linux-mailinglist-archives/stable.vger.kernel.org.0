Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F05450FBC
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241989AbhKOSgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:36:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:42248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242236AbhKOSe7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:34:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3812C63345;
        Mon, 15 Nov 2021 18:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999250;
        bh=3qFoeYw7sSYFRQnAVOgSOBo35uH9Ku6Kt7gT7S5MEzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SC+LPKXlkpZiz6L9wBvLSUB7PKO658BtV4tu03fqr3T9reYyRGTFw0v+SqPIWbHZ0
         X3FPgjNk1TNd95tpoEh10+lues7yrZcFNID8r1qdnl544+uxbxNvqMlaof0m/D+1sq
         ldEVa5/u6JTVLwEifvwPGasWSgtxoxqcVtVyANCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aric Cyr <aric.cyr@amd.com>,
        Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Jimmy Kizito <Jimmy.Kizito@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 230/849] drm/amd/display: Fix null pointer dereference for encoders
Date:   Mon, 15 Nov 2021 17:55:13 +0100
Message-Id: <20211115165427.983178534@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 3c8da3665a274..7b418f3f9291c 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -4681,7 +4681,7 @@ enum dc_status dp_set_fec_ready(struct dc_link *link, bool ready)
 				link_enc->funcs->fec_set_ready(link_enc, true);
 				link->fec_state = dc_link_fec_ready;
 			} else {
-				link_enc->funcs->fec_set_ready(link->link_enc, false);
+				link_enc->funcs->fec_set_ready(link_enc, false);
 				link->fec_state = dc_link_fec_not_ready;
 				dm_error("dpcd write failed to set fec_ready");
 			}
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index 75fa4adcf5f40..da7c906ba5eb5 100644
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



