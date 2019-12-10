Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 993C0119A4B
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfLJVve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:51:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:54942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727699AbfLJVIC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:08:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3080224691;
        Tue, 10 Dec 2019 21:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012081;
        bh=eS9xvF9rq5NfJcNEJkfhvmpa8K7NKLijEPXsZ/nbijw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZZUJEbmqlgu0VdrBoDEALQomMBux8FUppITGZeExTINrBlHJRwsv1pEekHZfgaD7
         uZFGcaE2TeH9Ksp0LcWiKO3sK/RyYvF45a+pOhrBG5jnS01ssHJA1u2K8MyNJL5rAa
         hhpCRjv9LFtHE/KLjxLwY9Z1ieGZILwT3CPPv7SU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Raul E Rangel <rrangel@chromium.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 060/350] drm/amd/display: fix struct init in update_bounding_box
Date:   Tue, 10 Dec 2019 16:02:45 -0500
Message-Id: <20191210210735.9077-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raul E Rangel <rrangel@chromium.org>

[ Upstream commit 960b6f4f2d2e96d5f7ffe2854e0040b46cafbd36 ]

dcn20_resource.c:2636:9: error: missing braces around initializer [-Werror=missing-braces]
  struct _vcs_dpi_voltage_scaling_st calculated_states[MAX_CLOCK_LIMIT_STATES] = {0};
         ^

Fixes: 7ed4e6352c16f ("drm/amd/display: Add DCN2 HW Sequencer and Resource")

Signed-off-by: Raul E Rangel <rrangel@chromium.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
index ebe67c34dabf6..78b2cc2e122fc 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -3041,7 +3041,7 @@ static void cap_soc_clocks(
 static void update_bounding_box(struct dc *dc, struct _vcs_dpi_soc_bounding_box_st *bb,
 		struct pp_smu_nv_clock_table *max_clocks, unsigned int *uclk_states, unsigned int num_states)
 {
-	struct _vcs_dpi_voltage_scaling_st calculated_states[MAX_CLOCK_LIMIT_STATES] = {0};
+	struct _vcs_dpi_voltage_scaling_st calculated_states[MAX_CLOCK_LIMIT_STATES];
 	int i;
 	int num_calculated_states = 0;
 	int min_dcfclk = 0;
@@ -3049,6 +3049,8 @@ static void update_bounding_box(struct dc *dc, struct _vcs_dpi_soc_bounding_box_
 	if (num_states == 0)
 		return;
 
+	memset(calculated_states, 0, sizeof(calculated_states));
+
 	if (dc->bb_overrides.min_dcfclk_mhz > 0)
 		min_dcfclk = dc->bb_overrides.min_dcfclk_mhz;
 	else
-- 
2.20.1

