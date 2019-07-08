Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A914462473
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389738AbfGHPm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:42:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:52322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728834AbfGHPY7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:24:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F2B92173C;
        Mon,  8 Jul 2019 15:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599498;
        bh=Ty4aiqji0oUjcxojs8aLHf5ZYylEYqKOuDuYN2qOtUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sW/vQYMmCjavUtOHqNXpQFCwzKpSw9CIIDdUAmwnOhGFYQakLTXEnFcEMLzj1zH87
         KeCHg5MnAQm4xjHl1/unGCRE62SIckhqgVybPz4quYT+B0Z90U1f3prNfks8AiVs5d
         08ZCtRRHFJkiHkAmbyfdbxmCJOp4zihrHiX3h7T8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Huang Rui <ray.huang@amd.com>
Subject: [PATCH 4.14 35/56] drm/amdgpu/gfx9: use reset default for PA_SC_FIFO_SIZE
Date:   Mon,  8 Jul 2019 17:13:27 +0200
Message-Id: <20190708150523.171670023@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150514.376317156@linuxfoundation.org>
References: <20190708150514.376317156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 25f09f858835b0e9a06213811031190a17d8ab78 upstream.

Recommended by the hw team.

Reviewed-and-Tested-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c |   19 -------------------
 1 file changed, 19 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1534,25 +1534,6 @@ static void gfx_v9_0_gpu_init(struct amd
 	mutex_unlock(&adev->srbm_mutex);
 
 	gfx_v9_0_init_compute_vmid(adev);
-
-	mutex_lock(&adev->grbm_idx_mutex);
-	/*
-	 * making sure that the following register writes will be broadcasted
-	 * to all the shaders
-	 */
-	gfx_v9_0_select_se_sh(adev, 0xffffffff, 0xffffffff, 0xffffffff);
-
-	WREG32_SOC15(GC, 0, mmPA_SC_FIFO_SIZE,
-		   (adev->gfx.config.sc_prim_fifo_size_frontend <<
-			PA_SC_FIFO_SIZE__SC_FRONTEND_PRIM_FIFO_SIZE__SHIFT) |
-		   (adev->gfx.config.sc_prim_fifo_size_backend <<
-			PA_SC_FIFO_SIZE__SC_BACKEND_PRIM_FIFO_SIZE__SHIFT) |
-		   (adev->gfx.config.sc_hiz_tile_fifo_size <<
-			PA_SC_FIFO_SIZE__SC_HIZ_TILE_FIFO_SIZE__SHIFT) |
-		   (adev->gfx.config.sc_earlyz_tile_fifo_size <<
-			PA_SC_FIFO_SIZE__SC_EARLYZ_TILE_FIFO_SIZE__SHIFT));
-	mutex_unlock(&adev->grbm_idx_mutex);
-
 }
 
 static void gfx_v9_0_wait_for_rlc_serdes(struct amdgpu_device *adev)


