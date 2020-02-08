Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1A641565E4
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgBHS3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:29:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34678 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727960AbgBHS3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:49 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrO-0003jq-U8; Sat, 08 Feb 2020 18:29:43 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrM-000CWd-MB; Sat, 08 Feb 2020 18:29:40 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Meelis Roos" <mroos@linux.ee>,
        "Michel =?UTF-8?Q?D=C3=A4nzer?=" <mdaenzer@redhat.com>,
        "Alex Deucher" <alexander.deucher@amd.com>
Date:   Sat, 08 Feb 2020 18:21:14 +0000
Message-ID: <lsq.1581185941.15711959@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 135/148] drm/radeon: fix r1xx/r2xx register checker
 for POT textures
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 008037d4d972c9c47b273e40e52ae34f9d9e33e7 upstream.

Shift and mask were reversed.  Noticed by chance.

Tested-by: Meelis Roos <mroos@linux.ee>
Reviewed-by: Michel Dänzer <mdaenzer@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/r100.c | 4 ++--
 drivers/gpu/drm/radeon/r200.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -1810,8 +1810,8 @@ static int r100_packet0_check(struct rad
 			track->textures[i].use_pitch = 1;
 		} else {
 			track->textures[i].use_pitch = 0;
-			track->textures[i].width = 1 << ((idx_value >> RADEON_TXFORMAT_WIDTH_SHIFT) & RADEON_TXFORMAT_WIDTH_MASK);
-			track->textures[i].height = 1 << ((idx_value >> RADEON_TXFORMAT_HEIGHT_SHIFT) & RADEON_TXFORMAT_HEIGHT_MASK);
+			track->textures[i].width = 1 << ((idx_value & RADEON_TXFORMAT_WIDTH_MASK) >> RADEON_TXFORMAT_WIDTH_SHIFT);
+			track->textures[i].height = 1 << ((idx_value & RADEON_TXFORMAT_HEIGHT_MASK) >> RADEON_TXFORMAT_HEIGHT_SHIFT);
 		}
 		if (idx_value & RADEON_TXFORMAT_CUBIC_MAP_ENABLE)
 			track->textures[i].tex_coord_type = 2;
--- a/drivers/gpu/drm/radeon/r200.c
+++ b/drivers/gpu/drm/radeon/r200.c
@@ -473,8 +473,8 @@ int r200_packet0_check(struct radeon_cs_
 			track->textures[i].use_pitch = 1;
 		} else {
 			track->textures[i].use_pitch = 0;
-			track->textures[i].width = 1 << ((idx_value >> RADEON_TXFORMAT_WIDTH_SHIFT) & RADEON_TXFORMAT_WIDTH_MASK);
-			track->textures[i].height = 1 << ((idx_value >> RADEON_TXFORMAT_HEIGHT_SHIFT) & RADEON_TXFORMAT_HEIGHT_MASK);
+			track->textures[i].width = 1 << ((idx_value & RADEON_TXFORMAT_WIDTH_MASK) >> RADEON_TXFORMAT_WIDTH_SHIFT);
+			track->textures[i].height = 1 << ((idx_value & RADEON_TXFORMAT_HEIGHT_MASK) >> RADEON_TXFORMAT_HEIGHT_SHIFT);
 		}
 		if (idx_value & R200_TXFORMAT_LOOKUP_DISABLE)
 			track->textures[i].lookup_disable = true;

