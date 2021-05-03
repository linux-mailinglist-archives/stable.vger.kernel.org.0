Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C28371ABF
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbhECQlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:41:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232158AbhECQjM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:39:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEF1A61364;
        Mon,  3 May 2021 16:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059830;
        bh=9PNRs/NqtnqsZodPRpjt5A1cV1aiyd4RkqOemCQ4w8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rz0Yx8DIXbPm9+A+H2QvK9549KPfd9QSHo+I3j7lc+aRSGKgWGKzYwg5FPLDknVn7
         oKJRTVFLA9e+XDWFWw15MCu334VK56It/lKC2+cgw68sjV9I44VZLpd/CqFsUO81AI
         Ts4zuKtfhkFoBgHDuiLXt6tc71LGeAvvSIw9hGqUjnY4y9aZDGL0AONxGYmiFb3Dpd
         wwFxqmBhacIQo09zcxaJwlCOYcbfvQO+fe/iI241Y+Jd2z6QAHjUTc99bijmycw3IO
         98Ckaz+Vbs0gej31UTcYuLjY/3bDKmO1jHemcxpfMb8FyxP+zLWjNsnGdpkGfAsN2p
         2E2838FBF3SRw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Eric Yang <eric.yang2@amd.com>,
        Qingqing Zhuo <Qingqing.Zhuo@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.11 006/115] drm/amd/display: Fix MPC OGAM power on/off sequence
Date:   Mon,  3 May 2021 12:35:10 -0400
Message-Id: <20210503163700.2852194-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163700.2852194-1-sashal@kernel.org>
References: <20210503163700.2852194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 737b2b536a30a467c405d75f2287e17828838a13 ]

[Why]
Color corruption can occur on bootup into a login
manager that applies a non-linear gamma LUT because
the LUT may not actually be powered on before writing.

It's cleared on the next full pipe reprogramming as
we switch to LUTB from LUTA and the pipe accessing
the LUT has taken it out of light sleep mode.

[How]
The MPCC_OGAM_MEM_PWR_FORCE register does not force
the current power mode when set to 0. It only forces
when set light sleep, deep sleep or shutdown.

The register to actually force power on and ignore
sleep modes is MPCC_OGAM_MEM_PWR_DIS - a value of 0
will enable power requests and a value of 1 will
disable them.

When PWR_FORCE!=0 is combined with PWR_DIS=0 then
MPCC OGAM memory is forced into the state specified
by the force bits.

If PWR_FORCE is 0 then it respects the mode specified
by MPCC_OGAM_MEM_LOW_PWR_MODE if the RAM LUT is not
in use.

We set that bit to shutdown on low power, but otherwise
it inherits from bootup defaults.

So for the fix:

1. Update the sequence to "force" power on when needed

We can use MPCC_OGAM_MEM_PWR_DIS for this to turn on the
memory even when the block is in bypass and pending to be
enabled for the next frame.

We need this for both low power enabled or disabled.

If we don't set this then we can run into issues when we
first program the LUT from bootup.

2. Don't apply FORCE_SEL

Once we enable power requests with DIS=0 we run into the
issue of the RAM being forced into light sleep and being
unusable for display output. Leave this 0 like we used to
for DCN20.

3. Rely on MPCC OGAM init to determine light sleep/deep sleep

MPC low power debug mode isn't enabled on any ASIC currently
but we'll respect the setting determined during init if it
is.

Lightly tested as working with IGT tests and desktop color
adjustment.

4. Change the MPC resource default for DCN30

It was interleaving the dcn20 and dcn30 versions before
depending on the sequence.

5. REG_WAIT for it to be on whenever we're powering up the
memory

Otherwise we can write register values too early and we'll
get corruption.

Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Eric Yang <eric.yang2@amd.com>
Acked-by: Qingqing Zhuo <Qingqing.Zhuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dcn30/dcn30_mpc.c  | 24 ++++++++++---------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_mpc.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_mpc.c
index 3e6f76096119..a7598356f37d 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_mpc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_mpc.c
@@ -143,16 +143,18 @@ static void mpc3_power_on_ogam_lut(
 {
 	struct dcn30_mpc *mpc30 = TO_DCN30_MPC(mpc);
 
-	if (mpc->ctx->dc->debug.enable_mem_low_power.bits.mpc) {
-		// Force power on
-		REG_UPDATE(MPCC_MEM_PWR_CTRL[mpcc_id], MPCC_OGAM_MEM_PWR_DIS, power_on == true ? 1:0);
-		// Wait for confirmation when powering on
-		if (power_on)
-			REG_WAIT(MPCC_MEM_PWR_CTRL[mpcc_id], MPCC_OGAM_MEM_PWR_STATE, 0, 10, 10);
-	} else {
-		REG_SET(MPCC_MEM_PWR_CTRL[mpcc_id], 0,
-				MPCC_OGAM_MEM_PWR_FORCE, power_on == true ? 0 : 1);
-	}
+	/*
+	 * Powering on: force memory active so the LUT can be updated.
+	 * Powering off: allow entering memory low power mode
+	 *
+	 * Memory low power mode is controlled during MPC OGAM LUT init.
+	 */
+	REG_UPDATE(MPCC_MEM_PWR_CTRL[mpcc_id],
+		   MPCC_OGAM_MEM_PWR_DIS, power_on != 0);
+
+	/* Wait for memory to be powered on - we won't be able to write to it otherwise. */
+	if (power_on)
+		REG_WAIT(MPCC_MEM_PWR_CTRL[mpcc_id], MPCC_OGAM_MEM_PWR_STATE, 0, 10, 10);
 }
 
 static void mpc3_configure_ogam_lut(
@@ -1427,7 +1429,7 @@ const struct mpc_funcs dcn30_mpc_funcs = {
 	.acquire_rmu = mpcc3_acquire_rmu,
 	.program_3dlut = mpc3_program_3dlut,
 	.release_rmu = mpcc3_release_rmu,
-	.power_on_mpc_mem_pwr = mpc20_power_on_ogam_lut,
+	.power_on_mpc_mem_pwr = mpc3_power_on_ogam_lut,
 	.get_mpc_out_mux = mpc1_get_mpc_out_mux,
 
 };
-- 
2.30.2

