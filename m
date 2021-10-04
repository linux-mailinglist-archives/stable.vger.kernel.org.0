Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3DF1420F62
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237258AbhJDNeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:34:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237717AbhJDNca (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:32:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBC2163222;
        Mon,  4 Oct 2021 13:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353286;
        bh=6+VYVM9nwwbfjsk9g6tXGkz1O3WybeWbbzqwmQ4uYfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mk6cGibyS35YOT0jfew4Ht7EMSOB9bpzbgwK0Qpb5H+XN1YToNJ5onZxCskKa9+0E
         xyFhwAIAgPss7xFOeOxyiF11NVBlVyJ1xXrJzWyHNxpmKQNWwChnbKopgMfvmIA0kY
         4m83e/8Ti0L0vwTcdfT3m0tIxX72azTBoWCHGK44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Praful Swarnakar <Praful.Swarnakar@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 069/172] drm/amd/display: Fix Display Flicker on embedded panels
Date:   Mon,  4 Oct 2021 14:51:59 +0200
Message-Id: <20211004125047.216834835@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Praful Swarnakar <Praful.Swarnakar@amd.com>

commit 083fa05bbaf65a01866b5440031c822e32ad7510 upstream.

[Why]
ASSR is dependent on Signed PSP Verstage to enable Content
Protection for eDP panels. Unsigned PSP verstage is used
during development phase causing ASSR to FAIL.
As a result, link training is performed with
DP_PANEL_MODE_DEFAULT instead of DP_PANEL_MODE_EDP for
eDP panels that causes display flicker on some panels.

[How]
- Do not change panel mode, if ASSR is disabled
- Just report and continue to perform eDP link training
with right settings further.

Signed-off-by: Praful Swarnakar <Praful.Swarnakar@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -1813,14 +1813,13 @@ bool perform_link_training_with_retries(
 		if (panel_mode == DP_PANEL_MODE_EDP) {
 			struct cp_psp *cp_psp = &stream->ctx->cp_psp;
 
-			if (cp_psp && cp_psp->funcs.enable_assr) {
-				if (!cp_psp->funcs.enable_assr(cp_psp->handle, link)) {
-					/* since eDP implies ASSR on, change panel
-					 * mode to disable ASSR
-					 */
-					panel_mode = DP_PANEL_MODE_DEFAULT;
-				}
-			}
+			if (cp_psp && cp_psp->funcs.enable_assr)
+				/* ASSR is bound to fail with unsigned PSP
+				 * verstage used during devlopment phase.
+				 * Report and continue with eDP panel mode to
+				 * perform eDP link training with right settings
+				 */
+				cp_psp->funcs.enable_assr(cp_psp->handle, link);
 		}
 #endif
 


