Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9232268FE
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730668AbgGTQXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:23:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732893AbgGTQEs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:04:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F41C20734;
        Mon, 20 Jul 2020 16:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261087;
        bh=gY7M0vHhcIvdmRdJ5D1OZsFINYfqQm6+7Tw5ej3VREQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uq5N5tSoHfZOw01btgiM11rZ/lLIRDmX5lJs8AGDYyf3Z/uJJdLdGRUnB+Rp8lt76
         PupVg6Lu721wnyyy1P+5sJ7V2wvT0BUnaL0NAbmBzkO4sPU/z1D2FR4mxm5OCEojzj
         3UDcQx9CQe5pjZOlZ43O31Z955Tw63yUkLkah5Eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Le Ma <le.ma@amd.com>,
        Xiaojie Yuan <xiaojie.yuan@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 205/215] drm/amdgpu/sdma5: fix wptr overwritten in ->get_wptr()
Date:   Mon, 20 Jul 2020 17:38:07 +0200
Message-Id: <20200720152829.915314645@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaojie Yuan <xiaojie.yuan@amd.com>

commit 05051496b2622e4d12e2036b35165969aa502f89 upstream.

"u64 *wptr" points to the the wptr value in write back buffer and
"*wptr = (*wptr) >> 2;" results in the value being overwritten each time
when ->get_wptr() is called.

umr uses /sys/kernel/debug/dri/0/amdgpu_ring_sdma0 to get rptr/wptr and
decode ring content and it is affected by this issue.

fix and simplify the logic similar as sdma_v4_0_ring_get_wptr().

v2: fix for sdma5.2 as well
v3: drop sdma 5.2 changes for 5.8 and stable

Suggested-by: Le Ma <le.ma@amd.com>
Signed-off-by: Xiaojie Yuan <xiaojie.yuan@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c |   26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
@@ -286,30 +286,20 @@ static uint64_t sdma_v5_0_ring_get_rptr(
 static uint64_t sdma_v5_0_ring_get_wptr(struct amdgpu_ring *ring)
 {
 	struct amdgpu_device *adev = ring->adev;
-	u64 *wptr = NULL;
-	uint64_t local_wptr = 0;
+	u64 wptr;
 
 	if (ring->use_doorbell) {
 		/* XXX check if swapping is necessary on BE */
-		wptr = ((u64 *)&adev->wb.wb[ring->wptr_offs]);
-		DRM_DEBUG("wptr/doorbell before shift == 0x%016llx\n", *wptr);
-		*wptr = (*wptr) >> 2;
-		DRM_DEBUG("wptr/doorbell after shift == 0x%016llx\n", *wptr);
+		wptr = READ_ONCE(*((u64 *)&adev->wb.wb[ring->wptr_offs]));
+		DRM_DEBUG("wptr/doorbell before shift == 0x%016llx\n", wptr);
 	} else {
-		u32 lowbit, highbit;
-
-		wptr = &local_wptr;
-		lowbit = RREG32(sdma_v5_0_get_reg_offset(adev, ring->me, mmSDMA0_GFX_RB_WPTR)) >> 2;
-		highbit = RREG32(sdma_v5_0_get_reg_offset(adev, ring->me, mmSDMA0_GFX_RB_WPTR_HI)) >> 2;
-
-		DRM_DEBUG("wptr [%i]high== 0x%08x low==0x%08x\n",
-				ring->me, highbit, lowbit);
-		*wptr = highbit;
-		*wptr = (*wptr) << 32;
-		*wptr |= lowbit;
+		wptr = RREG32(sdma_v5_0_get_reg_offset(adev, ring->me, mmSDMA0_GFX_RB_WPTR_HI));
+		wptr = wptr << 32;
+		wptr |= RREG32(sdma_v5_0_get_reg_offset(adev, ring->me, mmSDMA0_GFX_RB_WPTR));
+		DRM_DEBUG("wptr before shift [%i] wptr == 0x%016llx\n", ring->me, wptr);
 	}
 
-	return *wptr;
+	return wptr >> 2;
 }
 
 /**


