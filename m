Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC190323D85
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234764AbhBXNNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:13:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:58436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235710AbhBXNFC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:05:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDA2864F7E;
        Wed, 24 Feb 2021 12:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171243;
        bh=nmhDbiLN8SzIZcd7G6hoQrejKrrv37qolNba8EO8YvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nZZ7TxMR+fWHUiWtMqUjN2mGUaWlOFsLYOiZv161wMgBSAsDDRapENvrYSLDa3sCX
         aj0GSFIIKp3un3kaYzuX1jlopNKdMU1P/aaZiH5Mr4vYOFD+DRKSXZBSLSsfpnAkKm
         c/5RVQ7lu8gUzd75lnOTAWxDg4iM63v/YTXo21fPrp5WMKbkzqsSib3qgev4hBTzfU
         YCi3j+KMsrnGxCzoSh8A+VVWANUFGoV6i7dJqoHgp2lw+td96dYSWEv+AhLKVGgjOq
         mddVumyfwnXlrZExowrcjzrak3zNeHGz1F5s6Fwx7DXInfCYiWQmo2RGjyZcY/V9dB
         oVlUo7dx2AG0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Defang Bo <bodefang@126.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 17/40] drm/amdgpu: Add check to prevent IH overflow
Date:   Wed, 24 Feb 2021 07:53:17 -0500
Message-Id: <20210224125340.483162-17-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125340.483162-1-sashal@kernel.org>
References: <20210224125340.483162-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
index 1dca0cabc326a..13520d173296f 100644
--- a/drivers/gpu/drm/amd/amdgpu/cz_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/cz_ih.c
@@ -193,19 +193,30 @@ static u32 cz_ih_get_wptr(struct amdgpu_device *adev,
 
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
index a13dd9a51149a..7d165f024f072 100644
--- a/drivers/gpu/drm/amd/amdgpu/iceland_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/iceland_ih.c
@@ -193,19 +193,29 @@ static u32 iceland_ih_get_wptr(struct amdgpu_device *adev,
 
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
index e40140bf6699c..db0a3bda13fbe 100644
--- a/drivers/gpu/drm/amd/amdgpu/tonga_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/tonga_ih.c
@@ -195,19 +195,30 @@ static u32 tonga_ih_get_wptr(struct amdgpu_device *adev,
 
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
2.27.0

