Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAC814BAA5
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729521AbgA1OOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:14:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:37188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729965AbgA1OOw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:14:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A44024681;
        Tue, 28 Jan 2020 14:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220890;
        bh=MZCeFH3/ZgirqDOHvX84LoqvRuoZtRFg7XS13nRFhF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZICSKNeO5aw1AdjG3MlgmTRjIkjxGOdtRYbhxuup1BwYHsgAO+05/+ZbL57r5qIQc
         jgF1/pTSebG1oIhTb1jNfHGyYsKpqxRb2IsLWkAMIVGr8PkObQ68A4DyXM1bYhmqTE
         MYB5sJOSw/zE9BmvK0GFMTrN3+AvL7Fh38PIOBxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Bobroff <sbobroff@linux.ibm.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 157/183] drm/radeon: fix bad DMA from INTERRUPT_CNTL2
Date:   Tue, 28 Jan 2020 15:06:16 +0100
Message-Id: <20200128135845.416012863@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
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
index 80b6d6e4721a1..7acde09c8e8fb 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -7372,8 +7372,8 @@ static int cik_irq_init(struct radeon_device *rdev)
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
index 0e20c08f8977f..2056224d0b3c4 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -3647,8 +3647,8 @@ int r600_irq_init(struct radeon_device *rdev)
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
index 5cf3a2cbc07e8..4128c98d9054e 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -6013,8 +6013,8 @@ static int si_irq_init(struct radeon_device *rdev)
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



