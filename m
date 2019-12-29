Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 599BC12C7CD
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731123AbfL2Rqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:46:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:56720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731121AbfL2Rqn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:46:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7C64206A4;
        Sun, 29 Dec 2019 17:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641603;
        bh=VAktnDucK6425Kb0ZzoykzYzXO+ljRxDcVp+y1r1LN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mvBuMiHfaNct3wMozxlebFWnxLzwVX4w7caeT5rCBzSBN6pGpJ9zJ9MRw8lzBF4u7
         4pHqOO0FSb91uMwkffgjOnhc86XReQwsY7ZNukyBQXkzYKBnR+TAYYN78eFUam3x93
         /BeyzEKNTfBm+ZHZeU6KfUEf5V98l1jU0FtzCxI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aric Cyr <aric.cyr@amd.com>,
        Anthony Koo <Anthony.Koo@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 133/434] drm/amd/display: Properly round nominal frequency for SPD
Date:   Sun, 29 Dec 2019 18:23:06 +0100
Message-Id: <20191229172710.541820093@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ec70c9b12e1a..0978c698f0f8 100644
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



