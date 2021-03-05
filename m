Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7BD32E851
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhCEM0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:26:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:60984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231183AbhCEMZs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:25:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C524165030;
        Fri,  5 Mar 2021 12:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947147;
        bh=7ecgypTl3pP47kt0FGxySLAkMds6E3NfuNIh8lu+A+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y6S+IfEtwMM6sFhSOI4VXnVNif5k6LzyOMIvnyA3Dl55QkiXnCMjky9NehGQOaAI9
         EKqQxZev1QD4dwuJtNkbE3vbcRkcenru0to7kQDLfypUm0Kx7vD23tiLrvfUV6prga
         omxkdRE8xEUaBNivWCOQfhdzLNnLw40LfyAxfBkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Defang Bo <bodefang@126.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 063/104] drm/amdgpu: Add check to prevent IH overflow
Date:   Fri,  5 Mar 2021 13:21:08 +0100
Message-Id: <20210305120906.271942650@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Defang Bo <bodefang@126.com>

[ Upstream commit e4180c4253f3f2da09047f5139959227f5cf1173 ]

Similar to commit <b82175750131>("drm/amdgpu: fix IH overflow on Vega10 v2").
When an ring buffer overflow happens the appropriate bit is set in the WPTR
register which is also written back to memory. But clearing the bit in the
WPTR doesn't trigger another memory writeback.

So what can happen is that we end up processing the buffer overflow over and
over again because the bit is never cleared. Resulting in a random system
lockup because of an infinite loop in an interrupt handler.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Defang Bo <bodefang@126.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/cz_ih.c      | 37 ++++++++++++++++---------
 drivers/gpu/drm/amd/amdgpu/iceland_ih.c | 36 +++++++++++++++---------
 drivers/gpu/drm/amd/amdgpu/tonga_ih.c   | 37 ++++++++++++++++---------
 3 files changed, 71 insertions(+), 39 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/cz_ih.c b/drivers/gpu/drm/amd/amdgpu/cz_ih.c
index da37f8a900af..307c01301c87 100644
--- a/drivers/gpu/drm/amd/amdgpu/cz_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/cz_ih.c
@@ -194,19 +194,30 @@ static u32 cz_ih_get_wptr(struct amdgpu_device *adev,
 
 	wptr = le32_to_cpu(*ih->wptr_cpu);
 
-	if (REG_GET_FIELD(wptr, IH_RB_WPTR, RB_OVERFLOW)) {
-		wptr = REG_SET_FIELD(wptr, IH_RB_WPTR, RB_OVERFLOW, 0);
-		/* When a ring buffer overflow happen start parsing interrupt
-		 * from the last not overwritten vector (wptr + 16). Hopefully
-		 * this should allow us to catchup.
-		 */
-		dev_warn(adev->dev, "IH ring buffer overflow (0x%08X, 0x%08X, 0x%08X)\n",
-			wptr, ih->rptr, (wptr + 16) & ih->ptr_mask);
-		ih->rptr = (wptr + 16) & ih->ptr_mask;
-		tmp = RREG32(mmIH_RB_CNTL);
-		tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 1);
-		WREG32(mmIH_RB_CNTL, tmp);
-	}
+	if (!REG_GET_FIELD(wptr, IH_RB_WPTR, RB_OVERFLOW))
+		goto out;
+
+	/* Double check that the overflow wasn't already cleared. */
+	wptr = RREG32(mmIH_RB_WPTR);
+
+	if (!REG_GET_FIELD(wptr, IH_RB_WPTR, RB_OVERFLOW))
+		goto out;
+
+	wptr = REG_SET_FIELD(wptr, IH_RB_WPTR, RB_OVERFLOW, 0);
+
+	/* When a ring buffer overflow happen start parsing interrupt
+	 * from the last not overwritten vector (wptr + 16). Hopefully
+	 * this should allow us to catchup.
+	 */
+	dev_warn(adev->dev, "IH ring buffer overflow (0x%08X, 0x%08X, 0x%08X)\n",
+		wptr, ih->rptr, (wptr + 16) & ih->ptr_mask);
+	ih->rptr = (wptr + 16) & ih->ptr_mask;
+	tmp = RREG32(mmIH_RB_CNTL);
+	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 1);
+	WREG32(mmIH_RB_CNTL, tmp);
+
+
+out:
 	return (wptr & ih->ptr_mask);
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/iceland_ih.c b/drivers/gpu/drm/amd/amdgpu/iceland_ih.c
index 37d8b6ca4dab..cc957471f31e 100644
--- a/drivers/gpu/drm/amd/amdgpu/iceland_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/iceland_ih.c
@@ -194,19 +194,29 @@ static u32 iceland_ih_get_wptr(struct amdgpu_device *adev,
 
 	wptr = le32_to_cpu(*ih->wptr_cpu);
 
-	if (REG_GET_FIELD(wptr, IH_RB_WPTR, RB_OVERFLOW)) {
-		wptr = REG_SET_FIELD(wptr, IH_RB_WPTR, RB_OVERFLOW, 0);
-		/* When a ring buffer overflow happen start parsing interrupt
-		 * from the last not overwritten vector (wptr + 16). Hopefully
-		 * this should allow us to catchup.
-		 */
-		dev_warn(adev->dev, "IH ring buffer overflow (0x%08X, 0x%08X, 0x%08X)\n",
-			 wptr, ih->rptr, (wptr + 16) & ih->ptr_mask);
-		ih->rptr = (wptr + 16) & ih->ptr_mask;
-		tmp = RREG32(mmIH_RB_CNTL);
-		tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 1);
-		WREG32(mmIH_RB_CNTL, tmp);
-	}
+	if (!REG_GET_FIELD(wptr, IH_RB_WPTR, RB_OVERFLOW))
+		goto out;
+
+	/* Double check that the overflow wasn't already cleared. */
+	wptr = RREG32(mmIH_RB_WPTR);
+
+	if (!REG_GET_FIELD(wptr, IH_RB_WPTR, RB_OVERFLOW))
+		goto out;
+
+	wptr = REG_SET_FIELD(wptr, IH_RB_WPTR, RB_OVERFLOW, 0);
+	/* When a ring buffer overflow happen start parsing interrupt
+	 * from the last not overwritten vector (wptr + 16). Hopefully
+	 * this should allow us to catchup.
+	 */
+	dev_warn(adev->dev, "IH ring buffer overflow (0x%08X, 0x%08X, 0x%08X)\n",
+		wptr, ih->rptr, (wptr + 16) & ih->ptr_mask);
+	ih->rptr = (wptr + 16) & ih->ptr_mask;
+	tmp = RREG32(mmIH_RB_CNTL);
+	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 1);
+	WREG32(mmIH_RB_CNTL, tmp);
+
+
+out:
 	return (wptr & ih->ptr_mask);
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/tonga_ih.c b/drivers/gpu/drm/amd/amdgpu/tonga_ih.c
index ce3319993b4b..249fcbee7871 100644
--- a/drivers/gpu/drm/amd/amdgpu/tonga_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/tonga_ih.c
@@ -196,19 +196,30 @@ static u32 tonga_ih_get_wptr(struct amdgpu_device *adev,
 
 	wptr = le32_to_cpu(*ih->wptr_cpu);
 
-	if (REG_GET_FIELD(wptr, IH_RB_WPTR, RB_OVERFLOW)) {
-		wptr = REG_SET_FIELD(wptr, IH_RB_WPTR, RB_OVERFLOW, 0);
-		/* When a ring buffer overflow happen start parsing interrupt
-		 * from the last not overwritten vector (wptr + 16). Hopefully
-		 * this should allow us to catchup.
-		 */
-		dev_warn(adev->dev, "IH ring buffer overflow (0x%08X, 0x%08X, 0x%08X)\n",
-			 wptr, ih->rptr, (wptr + 16) & ih->ptr_mask);
-		ih->rptr = (wptr + 16) & ih->ptr_mask;
-		tmp = RREG32(mmIH_RB_CNTL);
-		tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 1);
-		WREG32(mmIH_RB_CNTL, tmp);
-	}
+	if (!REG_GET_FIELD(wptr, IH_RB_WPTR, RB_OVERFLOW))
+		goto out;
+
+	/* Double check that the overflow wasn't already cleared. */
+	wptr = RREG32(mmIH_RB_WPTR);
+
+	if (!REG_GET_FIELD(wptr, IH_RB_WPTR, RB_OVERFLOW))
+		goto out;
+
+	wptr = REG_SET_FIELD(wptr, IH_RB_WPTR, RB_OVERFLOW, 0);
+
+	/* When a ring buffer overflow happen start parsing interrupt
+	 * from the last not overwritten vector (wptr + 16). Hopefully
+	 * this should allow us to catchup.
+	 */
+
+	dev_warn(adev->dev, "IH ring buffer overflow (0x%08X, 0x%08X, 0x%08X)\n",
+		wptr, ih->rptr, (wptr + 16) & ih->ptr_mask);
+	ih->rptr = (wptr + 16) & ih->ptr_mask;
+	tmp = RREG32(mmIH_RB_CNTL);
+	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 1);
+	WREG32(mmIH_RB_CNTL, tmp);
+
+out:
 	return (wptr & ih->ptr_mask);
 }
 
-- 
2.30.1



