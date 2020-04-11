Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C40A1A5899
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729542AbgDKXKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:10:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728995AbgDKXKX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:10:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63A76216FD;
        Sat, 11 Apr 2020 23:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646623;
        bh=ZXMzDijToI0Xp1tlWp3wP7ZbDdz7Yh1T+un0pHOH3tA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cHt2675JR0RR5xZqC7j3MU584QtfuGN1Ja8OTijfp2SHnxbJ5xH/Zvge04A7Mrb41
         bwOF/uIZ/VomXvH3fQbcEVeIwjFhlaZElR7DY6vlLsZEhst5amZOf1Xd6U9FGXFjRM
         pYYI3AUZdlb+0W0YE4/EXQcIp8f70VnHwlfjZBK8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aric Cyr <aric.cyr@amd.com>, Anthony Koo <Anthony.Koo@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 032/108] drm/amd/display: Only round InfoFrame refresh rates
Date:   Sat, 11 Apr 2020 19:08:27 -0400
Message-Id: <20200411230943.24951-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aric Cyr <aric.cyr@amd.com>

[ Upstream commit 3fc6376ed6f2f67bc9fb0c7a3cf07967d6aa6216 ]

[Why]
When calculating nominal refresh rates, don't round.
Only the VSIF needs to be rounded.

[How]
Revert rounding change for nominal and just round when forming the
FreeSync VSIF.

Signed-off-by: Aric Cyr <aric.cyr@amd.com>
Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Acked-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/freesync/freesync.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
index 7d67cb2c61f04..37090384c2302 100644
--- a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
+++ b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
@@ -520,12 +520,12 @@ static void build_vrr_infopacket_data(const struct mod_vrr_params *vrr,
 		infopacket->sb[6] |= 0x04;
 
 	/* PB7 = FreeSync Minimum refresh rate (Hz) */
-	infopacket->sb[7] = (unsigned char)(vrr->min_refresh_in_uhz / 1000000);
+	infopacket->sb[7] = (unsigned char)((vrr->min_refresh_in_uhz + 500000) / 1000000);
 
 	/* PB8 = FreeSync Maximum refresh rate (Hz)
 	 * Note: We should never go above the field rate of the mode timing set.
 	 */
-	infopacket->sb[8] = (unsigned char)(vrr->max_refresh_in_uhz / 1000000);
+	infopacket->sb[8] = (unsigned char)((vrr->max_refresh_in_uhz + 500000) / 1000000);
 
 
 	//FreeSync HDR
@@ -743,10 +743,6 @@ void mod_freesync_build_vrr_params(struct mod_freesync *mod_freesync,
 	nominal_field_rate_in_uhz =
 			mod_freesync_calc_nominal_field_rate(stream);
 
-	/* Rounded to the nearest Hz */
-	nominal_field_rate_in_uhz = 1000000ULL *
-			div_u64(nominal_field_rate_in_uhz + 500000, 1000000);
-
 	min_refresh_in_uhz = in_config->min_refresh_in_uhz;
 	max_refresh_in_uhz = in_config->max_refresh_in_uhz;
 
-- 
2.20.1

