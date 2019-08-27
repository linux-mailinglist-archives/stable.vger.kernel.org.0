Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB339E0B2
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732225AbfH0IE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:04:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732640AbfH0IEz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:04:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82A0C206BA;
        Tue, 27 Aug 2019 08:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893094;
        bh=crjlqMoDAtHaJ0EO+4rd6JDfLo9OA5+Po6RyYPRh/d0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OTA86i9z9CgmrOxRM71c9zl2FtFDx3vCE4eN8UjQfkJCC7st4ziXHdu5nO6/J+4eS
         RJIxhLiJ7MmvNsk43dEBdRWDAxPA6kQZW1NzvsG7x3nHz4gXZI/to5rcH01AgZRnpk
         ycPaBjtm3PY6DaPbCZITO4BOvmpiklMi/pr9PZJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Tom St Denis <tom.stdenis@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.2 119/162] drm/amdgpu/gfx9: update pg_flags after determining if gfx off is possible
Date:   Tue, 27 Aug 2019 09:50:47 +0200
Message-Id: <20190827072742.587018671@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 98f58ada2d37e68125c056f1fc005748251879c2 upstream.

We need to set certain power gating flags after we determine
if the firmware version is sufficient to support gfxoff.
Previously we set the pg flags in early init, but we later
we might have disabled gfxoff if the firmware versions didn't
support it.  Move adding the additional pg flags after we
determine whether or not to support gfxoff.

Fixes: 005440066f92 ("drm/amdgpu: enable gfxoff again on raven series (v2)")
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Tom St Denis <tom.stdenis@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c |    4 ++++
 drivers/gpu/drm/amd/amdgpu/soc15.c    |    5 -----
 2 files changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -596,6 +596,10 @@ static void gfx_v9_0_check_if_need_gfxof
 		    (adev->gfx.rlc_feature_version < 1) ||
 		    !adev->gfx.rlc.is_rlc_v2_1)
 			adev->pm.pp_feature &= ~PP_GFXOFF_MASK;
+		if (adev->pm.pp_feature & PP_GFXOFF_MASK)
+			adev->pg_flags |= AMD_PG_SUPPORT_GFX_PG |
+				AMD_PG_SUPPORT_CP |
+				AMD_PG_SUPPORT_RLC_SMU_HS;
 		break;
 	default:
 		break;
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -949,11 +949,6 @@ static int soc15_common_early_init(void
 
 			adev->pg_flags = AMD_PG_SUPPORT_SDMA | AMD_PG_SUPPORT_VCN;
 		}
-
-		if (adev->pm.pp_feature & PP_GFXOFF_MASK)
-			adev->pg_flags |= AMD_PG_SUPPORT_GFX_PG |
-				AMD_PG_SUPPORT_CP |
-				AMD_PG_SUPPORT_RLC_SMU_HS;
 		break;
 	default:
 		/* FIXME: not supported yet */


