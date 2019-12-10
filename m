Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 310D31199D6
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfLJVIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:08:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:56426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727947AbfLJVIq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:08:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93D2C24684;
        Tue, 10 Dec 2019 21:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012125;
        bh=5EhyCug/9vprCrA0ONIhYKS5pO1gYpNAEwSkpe81XlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MXc4yRo0xZT7Ab+373jz10x8xrJCRk575Gs9R3/IDZY0EMZUtoj3vXXF7Wg0MtHtk
         hDXirvn4TdqQueHeQ06A5Qfucdh0h3VJyQTcxhRS/512CxMrcW+R1L63QSfipFpaCM
         bqS/+98E+wl8HhTS31uKzWE1J5+UHUw3nmJgazw8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aric Cyr <aric.cyr@amd.com>, Anthony Koo <Anthony.Koo@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 095/350] drm/amd/display: Properly round nominal frequency for SPD
Date:   Tue, 10 Dec 2019 16:03:20 -0500
Message-Id: <20191210210735.9077-56-sashal@kernel.org>
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

From: Aric Cyr <aric.cyr@amd.com>

[ Upstream commit c59802313e84bede954235b3a5dd0dd5325f49c5 ]

[Why]
Some displays rely on the SPD verticle frequency maximum value.
Must round the calculated refresh rate to the nearest integer.

[How]
Round the nominal calculated refresh rate to the nearest whole
integer.

Signed-off-by: Aric Cyr <aric.cyr@amd.com>
Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/modules/freesync/freesync.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
index ec70c9b12e1aa..0978c698f0f85 100644
--- a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
+++ b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
@@ -743,6 +743,10 @@ void mod_freesync_build_vrr_params(struct mod_freesync *mod_freesync,
 	nominal_field_rate_in_uhz =
 			mod_freesync_calc_nominal_field_rate(stream);
 
+	/* Rounded to the nearest Hz */
+	nominal_field_rate_in_uhz = 1000000ULL *
+			div_u64(nominal_field_rate_in_uhz + 500000, 1000000);
+
 	min_refresh_in_uhz = in_config->min_refresh_in_uhz;
 	max_refresh_in_uhz = in_config->max_refresh_in_uhz;
 
@@ -996,14 +1000,13 @@ unsigned long long mod_freesync_calc_nominal_field_rate(
 			const struct dc_stream_state *stream)
 {
 	unsigned long long nominal_field_rate_in_uhz = 0;
+	unsigned int total = stream->timing.h_total * stream->timing.v_total;
 
-	/* Calculate nominal field rate for stream */
+	/* Calculate nominal field rate for stream, rounded up to nearest integer */
 	nominal_field_rate_in_uhz = stream->timing.pix_clk_100hz / 10;
 	nominal_field_rate_in_uhz *= 1000ULL * 1000ULL * 1000ULL;
-	nominal_field_rate_in_uhz = div_u64(nominal_field_rate_in_uhz,
-						stream->timing.h_total);
-	nominal_field_rate_in_uhz = div_u64(nominal_field_rate_in_uhz,
-						stream->timing.v_total);
+
+	nominal_field_rate_in_uhz =	div_u64(nominal_field_rate_in_uhz, total);
 
 	return nominal_field_rate_in_uhz;
 }
-- 
2.20.1

