Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95223378826
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239017AbhEJLUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:20:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234752AbhEJLJG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:09:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3D2861075;
        Mon, 10 May 2021 11:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644695;
        bh=WtgBg4aqoSGF1AHZavDT1Gbq04vx8og/vxKkPVDIwTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zc5SDvi4dW6yE1OvqH3ZyhhOx5IUiP89MRC8CWIiYhhgWf2E35T328db58WzKpFLL
         KOgpgr8m9/fTnrAJsCY+OG5JSS2RpwVgn5EVlR6XhX8HKU6yTMSPhFvObdbGZs+PiW
         PAl0ZiiVtLp6EqraRqwamu6q4URKnsjBJIBZdy1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Sierra <alex.sierra@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 185/384] drm/amdgpu: enable 48-bit IH timestamp counter
Date:   Mon, 10 May 2021 12:19:34 +0200
Message-Id: <20210510102020.990125855@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Sierra <alex.sierra@amd.com>

[ Upstream commit 9a9c59a8f4f4478d5951eb0bded1d17b936aad6e ]

By default this timestamp is 32 bit counter. It gets
overflowed in around 10 minutes.

Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vega20_ih.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vega20_ih.c b/drivers/gpu/drm/amd/amdgpu/vega20_ih.c
index 75b06e1964ab..86dcf448e0c2 100644
--- a/drivers/gpu/drm/amd/amdgpu/vega20_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/vega20_ih.c
@@ -104,6 +104,8 @@ static int vega20_ih_toggle_ring_interrupts(struct amdgpu_device *adev,
 
 	tmp = RREG32(ih_regs->ih_rb_cntl);
 	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, RB_ENABLE, (enable ? 1 : 0));
+	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, RB_GPU_TS_ENABLE, 1);
+
 	/* enable_intr field is only valid in ring0 */
 	if (ih == &adev->irq.ih)
 		tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, ENABLE_INTR, (enable ? 1 : 0));
-- 
2.30.2



