Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBE9010BB16
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732496AbfK0VJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:09:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732163AbfK0VJ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:09:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BD3521555;
        Wed, 27 Nov 2019 21:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888967;
        bh=6YjIlvrjlHFvFis+zWcLOUFPiAJ5dPDRjNY2ThD78pA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=di4j2gxRFgZz0P3ehO9zFGeC2UubIOTpGyFNuKAwrqvIL85GRBeugCZeSxIw1cbef
         Ad7auQVlwi/A3ibX9JO0Vtowavd48qJqVnuHW4Iq6wDOcFot8x5G4v75wiLnGDmulN
         S5o/Yjwuv58QuwRVDF3eRlUen9oOmzdR9zhZR4uQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.3 31/95] drm/amdgpu: disable gfxoff on original raven
Date:   Wed, 27 Nov 2019 21:31:48 +0100
Message-Id: <20191127202856.900583154@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 941a0a7945c39f36a16634bc65c2649a1b94eee1 upstream.

There are still combinations of sbios and firmware that
are not stable.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=204689
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -596,8 +596,13 @@ static void gfx_v9_0_check_if_need_gfxof
 	case CHIP_VEGA20:
 		break;
 	case CHIP_RAVEN:
-		if (!(adev->rev_id >= 0x8 || adev->pdev->device == 0x15d8)
-			&&((adev->gfx.rlc_fw_version != 106 &&
+		/* Disable GFXOFF on original raven.  There are combinations
+		 * of sbios and platforms that are not stable.
+		 */
+		if (!(adev->rev_id >= 0x8 || adev->pdev->device == 0x15d8))
+			adev->pm.pp_feature &= ~PP_GFXOFF_MASK;
+		else if (!(adev->rev_id >= 0x8 || adev->pdev->device == 0x15d8)
+			 &&((adev->gfx.rlc_fw_version != 106 &&
 			     adev->gfx.rlc_fw_version < 531) ||
 			    (adev->gfx.rlc_fw_version == 53815) ||
 			    (adev->gfx.rlc_feature_version < 1) ||


