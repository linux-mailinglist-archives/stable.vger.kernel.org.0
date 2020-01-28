Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA0A014B88D
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbgA1OYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:24:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:51710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732766AbgA1OYv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:24:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70D542468A;
        Tue, 28 Jan 2020 14:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221489;
        bh=krkpRTJjaq0aPRrGNgYXqjuGQlifAOUX/tNFEfRm/jU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fj9F/5kwalY8V1+oj8vzJqab96lw7EXIdnmlPNMFEWqsCUAtBJXiVPd0S8yL83cyM
         o+QNpHbyVbZQpKh7O+VsAHIlfmyQOvn19zEEXM+0ucooVysKJRVoBGQAYKefVoqYRm
         z+g8wO258hiE7nCGAoIEX0NoLiYe5Sq5GBdoGErQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Bobroff <sbobroff@linux.ibm.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 228/271] drm/radeon: fix bad DMA from INTERRUPT_CNTL2
Date:   Tue, 28 Jan 2020 15:06:17 +0100
Message-Id: <20200128135909.551165717@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sam Bobroff <sbobroff@linux.ibm.com>

[ Upstream commit 62d91dd2851e8ae2ca552f1b090a3575a4edf759 ]

The INTERRUPT_CNTL2 register expects a valid DMA address, but is
currently set with a GPU MC address.  This can cause problems on
systems that detect the resulting DMA read from an invalid address
(found on a Power8 guest).

Instead, use the DMA address of the dummy page because it will always
be safe.

Fixes: d8f60cfc9345 ("drm/radeon/kms: Add support for interrupts on r6xx/r7xx chips (v3)")
Fixes: 25a857fbe973 ("drm/radeon/kms: add support for interrupts on SI")
Fixes: a59781bbe528 ("drm/radeon: add support for interrupts on CIK (v5)")
Signed-off-by: Sam Bobroff <sbobroff@linux.ibm.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/cik.c  | 4 ++--
 drivers/gpu/drm/radeon/r600.c | 4 ++--
 drivers/gpu/drm/radeon/si.c   | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index b99f3e59011c1..5fcb5869a4891 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -7026,8 +7026,8 @@ static int cik_irq_init(struct radeon_device *rdev)
 	}
 
 	/* setup interrupt control */
-	/* XXX this should actually be a bus address, not an MC address. same on older asics */
-	WREG32(INTERRUPT_CNTL2, rdev->ih.gpu_addr >> 8);
+	/* set dummy read address to dummy page address */
+	WREG32(INTERRUPT_CNTL2, rdev->dummy_page.addr >> 8);
 	interrupt_cntl = RREG32(INTERRUPT_CNTL);
 	/* IH_DUMMY_RD_OVERRIDE=0 - dummy read disabled with msi, enabled without msi
 	 * IH_DUMMY_RD_OVERRIDE=1 - dummy read controlled by IH_DUMMY_RD_EN
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index f2eac6b6c46a3..9569c35f8766a 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -3697,8 +3697,8 @@ int r600_irq_init(struct radeon_device *rdev)
 	}
 
 	/* setup interrupt control */
-	/* set dummy read address to ring address */
-	WREG32(INTERRUPT_CNTL2, rdev->ih.gpu_addr >> 8);
+	/* set dummy read address to dummy page address */
+	WREG32(INTERRUPT_CNTL2, rdev->dummy_page.addr >> 8);
 	interrupt_cntl = RREG32(INTERRUPT_CNTL);
 	/* IH_DUMMY_RD_OVERRIDE=0 - dummy read disabled with msi, enabled without msi
 	 * IH_DUMMY_RD_OVERRIDE=1 - dummy read controlled by IH_DUMMY_RD_EN
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index b75d809c292e3..919d389869ceb 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -6018,8 +6018,8 @@ static int si_irq_init(struct radeon_device *rdev)
 	}
 
 	/* setup interrupt control */
-	/* set dummy read address to ring address */
-	WREG32(INTERRUPT_CNTL2, rdev->ih.gpu_addr >> 8);
+	/* set dummy read address to dummy page address */
+	WREG32(INTERRUPT_CNTL2, rdev->dummy_page.addr >> 8);
 	interrupt_cntl = RREG32(INTERRUPT_CNTL);
 	/* IH_DUMMY_RD_OVERRIDE=0 - dummy read disabled with msi, enabled without msi
 	 * IH_DUMMY_RD_OVERRIDE=1 - dummy read controlled by IH_DUMMY_RD_EN
-- 
2.20.1



