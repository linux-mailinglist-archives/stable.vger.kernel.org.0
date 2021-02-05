Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8562C31144B
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbhBEWDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:03:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:44976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232849AbhBEOyw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:54:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F4BB65020;
        Fri,  5 Feb 2021 14:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534270;
        bh=D/tlQgjXAB4nMKA/FtiIDvM7nFaD0RUkXeM/gFAlG8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KlEMS4/gnnlIqMk8f6fYFWCz4u81AV+IJGXT4AKMdPMqYilxYX8EZgjuzsF/lRPLH
         phdw2dC3nDJGVFtISUWB86K/zj5dcnB8Dgx+01+EPpXcNPQGL6IN+4pqYsP2SwSZ7B
         sMgT+kSOxZkttK082chXftqbTlDfDeanUEeC91jI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Eric Yang <eric.yang2@amd.com>,
        Anson Jacob <anson.jacob@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 49/57] drm/amd/display: Use hardware sequencer functions for PG control
Date:   Fri,  5 Feb 2021 15:07:15 +0100
Message-Id: <20210205140658.082559773@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit c74f865f14318217350aa33363577cb95b06eb82 ]

[Why & How]
These can differ per ASIC or not be present. Don't call the dcn20 ones
directly but rather the ones defined by the ASIC init table.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Eric Yang <eric.yang2@amd.com>
Acked-by: Anson Jacob <anson.jacob@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/dcn10/dcn10_hw_sequencer.c  | 18 ++++++++++++++----
 .../gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |  9 +++++++--
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index d0f3bf953d027..0d1e7b56fb395 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -646,8 +646,13 @@ static void power_on_plane(
 	if (REG(DC_IP_REQUEST_CNTL)) {
 		REG_SET(DC_IP_REQUEST_CNTL, 0,
 				IP_REQUEST_EN, 1);
-		hws->funcs.dpp_pg_control(hws, plane_id, true);
-		hws->funcs.hubp_pg_control(hws, plane_id, true);
+
+		if (hws->funcs.dpp_pg_control)
+			hws->funcs.dpp_pg_control(hws, plane_id, true);
+
+		if (hws->funcs.hubp_pg_control)
+			hws->funcs.hubp_pg_control(hws, plane_id, true);
+
 		REG_SET(DC_IP_REQUEST_CNTL, 0,
 				IP_REQUEST_EN, 0);
 		DC_LOG_DEBUG(
@@ -1079,8 +1084,13 @@ void dcn10_plane_atomic_power_down(struct dc *dc,
 	if (REG(DC_IP_REQUEST_CNTL)) {
 		REG_SET(DC_IP_REQUEST_CNTL, 0,
 				IP_REQUEST_EN, 1);
-		hws->funcs.dpp_pg_control(hws, dpp->inst, false);
-		hws->funcs.hubp_pg_control(hws, hubp->inst, false);
+
+		if (hws->funcs.dpp_pg_control)
+			hws->funcs.dpp_pg_control(hws, dpp->inst, false);
+
+		if (hws->funcs.hubp_pg_control)
+			hws->funcs.hubp_pg_control(hws, hubp->inst, false);
+
 		dpp->funcs->dpp_reset(dpp);
 		REG_SET(DC_IP_REQUEST_CNTL, 0,
 				IP_REQUEST_EN, 0);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 01530e686f437..f1e9b3b06b924 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1069,8 +1069,13 @@ static void dcn20_power_on_plane(
 	if (REG(DC_IP_REQUEST_CNTL)) {
 		REG_SET(DC_IP_REQUEST_CNTL, 0,
 				IP_REQUEST_EN, 1);
-		dcn20_dpp_pg_control(hws, pipe_ctx->plane_res.dpp->inst, true);
-		dcn20_hubp_pg_control(hws, pipe_ctx->plane_res.hubp->inst, true);
+
+		if (hws->funcs.dpp_pg_control)
+			hws->funcs.dpp_pg_control(hws, pipe_ctx->plane_res.dpp->inst, true);
+
+		if (hws->funcs.hubp_pg_control)
+			hws->funcs.hubp_pg_control(hws, pipe_ctx->plane_res.hubp->inst, true);
+
 		REG_SET(DC_IP_REQUEST_CNTL, 0,
 				IP_REQUEST_EN, 0);
 		DC_LOG_DEBUG(
-- 
2.27.0



