Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7C89A9127
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390351AbfIDSNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:13:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390346AbfIDSNs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:13:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D05A208E4;
        Wed,  4 Sep 2019 18:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620827;
        bh=CSRHk86gh5WIy5DIPkqYlXmBSEzXVknhxkEwMMZeuSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CSCetijhJDItUGbKzHbuImpXpkSc8oRb1Ko3yKRPifpzRlruhsb5OI11FrJodvbAm
         u6ps7+9LkYaFHEpsmvXecia12qOomu65596Vy7Ppoc3z/RIoZWwOvfPhXGoVrM3yyj
         +JWsnZet3PrhQk6QJJn1mPKN5wFwHfHm9yJjzNco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Aaron Liu <aaron.liu@amd.com>
Subject: [PATCH 5.2 111/143] drm/amdgpu: fix GFXOFF on Picasso and Raven2
Date:   Wed,  4 Sep 2019 19:54:14 +0200
Message-Id: <20190904175318.740365280@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Liu <aaron.liu@amd.com>

commit 41940ff50f6c347f3541163702566cd526200d98 upstream.

For picasso(adev->pdev->device == 0x15d8)&raven2(adev->rev_id >= 0x8),
firmware is sufficient to support gfxoff.
In commit 98f58ada2d37e, for picasso&raven2,
return directly and cause gfxoff disabled.

Fixes: 98f58ada2d37 ("drm/amdgpu/gfx9: update pg_flags after determining if gfx off is possible")
Reviewed-by: Huang Rui <ray.huang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Aaron Liu <aaron.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -588,14 +588,14 @@ static void gfx_v9_0_check_if_need_gfxof
 	case CHIP_VEGA20:
 		break;
 	case CHIP_RAVEN:
-		if (adev->rev_id >= 0x8 || adev->pdev->device == 0x15d8)
-			break;
-		if ((adev->gfx.rlc_fw_version != 106 &&
-		     adev->gfx.rlc_fw_version < 531) ||
-		    (adev->gfx.rlc_fw_version == 53815) ||
-		    (adev->gfx.rlc_feature_version < 1) ||
-		    !adev->gfx.rlc.is_rlc_v2_1)
+		if (!(adev->rev_id >= 0x8 || adev->pdev->device == 0x15d8)
+			&&((adev->gfx.rlc_fw_version != 106 &&
+			     adev->gfx.rlc_fw_version < 531) ||
+			    (adev->gfx.rlc_fw_version == 53815) ||
+			    (adev->gfx.rlc_feature_version < 1) ||
+			    !adev->gfx.rlc.is_rlc_v2_1))
 			adev->pm.pp_feature &= ~PP_GFXOFF_MASK;
+
 		if (adev->pm.pp_feature & PP_GFXOFF_MASK)
 			adev->pg_flags |= AMD_PG_SUPPORT_GFX_PG |
 				AMD_PG_SUPPORT_CP |


