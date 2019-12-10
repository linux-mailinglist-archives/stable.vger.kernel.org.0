Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEF1119809
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730415AbfLJVf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:35:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:42030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730413AbfLJVfz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:35:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 410852465C;
        Tue, 10 Dec 2019 21:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013755;
        bh=Kz+VTdyHuLcHr1NQf8pq/oqyn8JEvrQiywBbtOd6lUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tbB9XUZeszhL6sNHtkY0hzf8wI9lV6YEV1rha6PrXtOWfGxKXwYwanqqwCcQdDN0S
         Ha3C5GQPJBxT/1cFuIb8IXZ9vBnwbiOIa6WWRr3bW3y4SHqA03AtojrRI4U+O4RJqu
         P5U1LmzxPyHy0HLhQn/+9MhurduteLH3JADq4aF0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sam Bobroff <sbobroff@linux.ibm.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 175/177] drm/amdgpu: fix bad DMA from INTERRUPT_CNTL2
Date:   Tue, 10 Dec 2019 16:32:19 -0500
Message-Id: <20191210213221.11921-175-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sam Bobroff <sbobroff@linux.ibm.com>

[ Upstream commit 3d0e3ce52ce3eb4b9de3caf9c38dbb5a4d3e13c3 ]

The INTERRUPT_CNTL2 register expects a valid DMA address, but is
currently set with a GPU MC address.  This can cause problems on
systems that detect the resulting DMA read from an invalid address
(found on a Power8 guest).

Instead, use the DMA address of the dummy page because it will always
be safe.

Fixes: 27ae10641e9c ("drm/amdgpu: add interupt handler implementation for si v3")
Signed-off-by: Sam Bobroff <sbobroff@linux.ibm.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/si_ih.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/si_ih.c b/drivers/gpu/drm/amd/amdgpu/si_ih.c
index 60dad63098a2a..e40a3fbc3e760 100644
--- a/drivers/gpu/drm/amd/amdgpu/si_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/si_ih.c
@@ -62,7 +62,8 @@ static int si_ih_irq_init(struct amdgpu_device *adev)
 	u64 wptr_off;
 
 	si_ih_disable_interrupts(adev);
-	WREG32(INTERRUPT_CNTL2, adev->irq.ih.gpu_addr >> 8);
+	/* set dummy read address to dummy page address */
+	WREG32(INTERRUPT_CNTL2, adev->dummy_page_addr >> 8);
 	interrupt_cntl = RREG32(INTERRUPT_CNTL);
 	interrupt_cntl &= ~IH_DUMMY_RD_OVERRIDE;
 	interrupt_cntl &= ~IH_REQ_NONSNOOP_EN;
-- 
2.20.1

