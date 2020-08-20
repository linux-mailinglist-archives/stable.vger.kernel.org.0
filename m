Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F63B24BC8E
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbgHTMs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:48:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728758AbgHTJpQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:45:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7214022BEA;
        Thu, 20 Aug 2020 09:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916650;
        bh=+kH4ogI01XWXBJxV5v3pH33kZ3F0o0zBZ5/4elUM6ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wmJTlJqHPZ/UbELE2YiRo116Zdpfe0ot9L2JskM2MDmUu/2Eh3rscuM4pdolMiC66
         5N/C5mVTBN+yE7C/K4lfB3FUm5W6es6XNDi/0MSFoSTs2g/d/MEz3iJIOMfbKTEikF
         1bA5P8qDH4azzmtBTiENRtALTUwW706rfk+M3uOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hersen Wu <hersenxs.wu@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>, Eryk Brol <eryk.brol@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.7 204/204] drm/amd/display: dchubbub p-state warning during surface planes switch
Date:   Thu, 20 Aug 2020 11:21:41 +0200
Message-Id: <20200820091616.369178049@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: hersen wu <hersenxs.wu@amd.com>

commit 8b0379a85762b516c7b46aed7dbf2a4947c00564 upstream.

[Why]
ramp_up_dispclk_with_dpp is to change dispclk, dppclk and dprefclk
according to bandwidth requirement. call stack: rv1_update_clocks -->
update_clocks --> dcn10_prepare_bandwidth / dcn10_optimize_bandwidth
--> prepare_bandwidth / optimize_bandwidth. before change dcn hw,
prepare_bandwidth will be called first to allow enough clock,
watermark for change, after end of dcn hw change, optimize_bandwidth
is executed to lower clock to save power for new dcn hw settings.

below is sequence of commit_planes_for_stream:
step 1: prepare_bandwidth - raise clock to have enough bandwidth
step 2: lock_doublebuffer_enable
step 3: pipe_control_lock(true) - make dchubp register change will
not take effect right way
step 4: apply_ctx_for_surface - program dchubp
step 5: pipe_control_lock(false) - dchubp register change take effect
step 6: optimize_bandwidth --> dc_post_update_surfaces_to_stream
for full_date, optimize clock to save power

at end of step 1, dcn clocks (dprefclk, dispclk, dppclk) may be
changed for new dchubp configuration. but real dcn hub dchubps are
still running with old configuration until end of step 5. this need
clocks settings at step 1 should not less than that before step 1.
this is checked by two conditions: 1. if (should_set_clock(safe_to_lower
, new_clocks->dispclk_khz, clk_mgr_base->clks.dispclk_khz) ||
new_clocks->dispclk_khz == clk_mgr_base->clks.dispclk_khz)
2. request_dpp_div = new_clocks->dispclk_khz > new_clocks->dppclk_khz

the second condition is based on new dchubp configuration. dppclk
for new dchubp may be different from dppclk before step 1.
for example, before step 1, dchubps are as below:
pipe 0: recout=(0,40,1920,980) viewport=(0,0,1920,979)
pipe 1: recout=(0,0,1920,1080) viewport=(0,0,1920,1080)
for dppclk for pipe0 need dppclk = dispclk

new dchubp pipe split configuration:
pipe 0: recout=(0,0,960,1080) viewport=(0,0,960,1080)
pipe 1: recout=(960,0,960,1080) viewport=(960,0,960,1080)
dppclk only needs dppclk = dispclk /2.

dispclk, dppclk are not lock by otg master lock. they take effect
after step 1. during this transition, dispclk are the same, but
dppclk is changed to half of previous clock for old dchubp
configuration between step 1 and step 6. This may cause p-state
warning intermittently.

[How]
for new_clocks->dispclk_khz == clk_mgr_base->clks.dispclk_khz, we
need make sure dppclk are not changed to less between step 1 and 6.
for new_clocks->dispclk_khz > clk_mgr_base->clks.dispclk_khz,
new display clock is raised, but we do not know ratio of
new_clocks->dispclk_khz and clk_mgr_base->clks.dispclk_khz,
new_clocks->dispclk_khz /2 does not guarantee equal or higher than
old dppclk. we could ignore power saving different between
dppclk = displck and dppclk = dispclk / 2 between step 1 and step 6.
as long as safe_to_lower = false, set dpclk = dispclk to simplify
condition check.

CC: Stable <stable@vger.kernel.org>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Eryk Brol <eryk.brol@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn10/rv1_clk_mgr.c |   69 ++++++++++++-
 1 file changed, 67 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn10/rv1_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn10/rv1_clk_mgr.c
@@ -85,12 +85,77 @@ static int rv1_determine_dppclk_threshol
 	return disp_clk_threshold;
 }
 
-static void ramp_up_dispclk_with_dpp(struct clk_mgr_internal *clk_mgr, struct dc *dc, struct dc_clocks *new_clocks)
+static void ramp_up_dispclk_with_dpp(
+		struct clk_mgr_internal *clk_mgr,
+		struct dc *dc,
+		struct dc_clocks *new_clocks,
+		bool safe_to_lower)
 {
 	int i;
 	int dispclk_to_dpp_threshold = rv1_determine_dppclk_threshold(clk_mgr, new_clocks);
 	bool request_dpp_div = new_clocks->dispclk_khz > new_clocks->dppclk_khz;
 
+	/* this function is to change dispclk, dppclk and dprefclk according to
+	 * bandwidth requirement. Its call stack is rv1_update_clocks -->
+	 * update_clocks --> dcn10_prepare_bandwidth / dcn10_optimize_bandwidth
+	 * --> prepare_bandwidth / optimize_bandwidth. before change dcn hw,
+	 * prepare_bandwidth will be called first to allow enough clock,
+	 * watermark for change, after end of dcn hw change, optimize_bandwidth
+	 * is executed to lower clock to save power for new dcn hw settings.
+	 *
+	 * below is sequence of commit_planes_for_stream:
+	 *
+	 * step 1: prepare_bandwidth - raise clock to have enough bandwidth
+	 * step 2: lock_doublebuffer_enable
+	 * step 3: pipe_control_lock(true) - make dchubp register change will
+	 * not take effect right way
+	 * step 4: apply_ctx_for_surface - program dchubp
+	 * step 5: pipe_control_lock(false) - dchubp register change take effect
+	 * step 6: optimize_bandwidth --> dc_post_update_surfaces_to_stream
+	 * for full_date, optimize clock to save power
+	 *
+	 * at end of step 1, dcn clocks (dprefclk, dispclk, dppclk) may be
+	 * changed for new dchubp configuration. but real dcn hub dchubps are
+	 * still running with old configuration until end of step 5. this need
+	 * clocks settings at step 1 should not less than that before step 1.
+	 * this is checked by two conditions: 1. if (should_set_clock(safe_to_lower
+	 * , new_clocks->dispclk_khz, clk_mgr_base->clks.dispclk_khz) ||
+	 * new_clocks->dispclk_khz == clk_mgr_base->clks.dispclk_khz)
+	 * 2. request_dpp_div = new_clocks->dispclk_khz > new_clocks->dppclk_khz
+	 *
+	 * the second condition is based on new dchubp configuration. dppclk
+	 * for new dchubp may be different from dppclk before step 1.
+	 * for example, before step 1, dchubps are as below:
+	 * pipe 0: recout=(0,40,1920,980) viewport=(0,0,1920,979)
+	 * pipe 1: recout=(0,0,1920,1080) viewport=(0,0,1920,1080)
+	 * for dppclk for pipe0 need dppclk = dispclk
+	 *
+	 * new dchubp pipe split configuration:
+	 * pipe 0: recout=(0,0,960,1080) viewport=(0,0,960,1080)
+	 * pipe 1: recout=(960,0,960,1080) viewport=(960,0,960,1080)
+	 * dppclk only needs dppclk = dispclk /2.
+	 *
+	 * dispclk, dppclk are not lock by otg master lock. they take effect
+	 * after step 1. during this transition, dispclk are the same, but
+	 * dppclk is changed to half of previous clock for old dchubp
+	 * configuration between step 1 and step 6. This may cause p-state
+	 * warning intermittently.
+	 *
+	 * for new_clocks->dispclk_khz == clk_mgr_base->clks.dispclk_khz, we
+	 * need make sure dppclk are not changed to less between step 1 and 6.
+	 * for new_clocks->dispclk_khz > clk_mgr_base->clks.dispclk_khz,
+	 * new display clock is raised, but we do not know ratio of
+	 * new_clocks->dispclk_khz and clk_mgr_base->clks.dispclk_khz,
+	 * new_clocks->dispclk_khz /2 does not guarantee equal or higher than
+	 * old dppclk. we could ignore power saving different between
+	 * dppclk = displck and dppclk = dispclk / 2 between step 1 and step 6.
+	 * as long as safe_to_lower = false, set dpclk = dispclk to simplify
+	 * condition check.
+	 * todo: review this change for other asic.
+	 **/
+	if (!safe_to_lower)
+		request_dpp_div = false;
+
 	/* set disp clk to dpp clk threshold */
 
 	clk_mgr->funcs->set_dispclk(clk_mgr, dispclk_to_dpp_threshold);
@@ -209,7 +274,7 @@ static void rv1_update_clocks(struct clk
 	/* program dispclk on = as a w/a for sleep resume clock ramping issues */
 	if (should_set_clock(safe_to_lower, new_clocks->dispclk_khz, clk_mgr_base->clks.dispclk_khz)
 			|| new_clocks->dispclk_khz == clk_mgr_base->clks.dispclk_khz) {
-		ramp_up_dispclk_with_dpp(clk_mgr, dc, new_clocks);
+		ramp_up_dispclk_with_dpp(clk_mgr, dc, new_clocks, safe_to_lower);
 		clk_mgr_base->clks.dispclk_khz = new_clocks->dispclk_khz;
 		send_request_to_lower = true;
 	}


