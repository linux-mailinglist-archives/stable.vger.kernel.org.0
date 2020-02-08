Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE1315663A
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgBHSc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:32:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34424 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727927AbgBHS3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:47 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrM-0003hn-Rk; Sat, 08 Feb 2020 18:29:41 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrK-000CUW-AJ; Sat, 08 Feb 2020 18:29:38 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Alex Deucher" <alexander.deucher@amd.com>,
        "Sam Bobroff" <sbobroff@linux.ibm.com>
Date:   Sat, 08 Feb 2020 18:20:56 +0000
Message-ID: <lsq.1581185941.841230449@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 117/148] drm/radeon: fix bad DMA from INTERRUPT_CNTL2
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Bobroff <sbobroff@linux.ibm.com>

commit 62d91dd2851e8ae2ca552f1b090a3575a4edf759 upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/cik.c  | 4 ++--
 drivers/gpu/drm/radeon/r600.c | 4 ++--
 drivers/gpu/drm/radeon/si.c   | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -6875,8 +6875,8 @@ static int cik_irq_init(struct radeon_de
 	}
 
 	/* setup interrupt control */
-	/* XXX this should actually be a bus address, not an MC address. same on older asics */
-	WREG32(INTERRUPT_CNTL2, rdev->ih.gpu_addr >> 8);
+	/* set dummy read address to dummy page address */
+	WREG32(INTERRUPT_CNTL2, rdev->dummy_page.addr >> 8);
 	interrupt_cntl = RREG32(INTERRUPT_CNTL);
 	/* IH_DUMMY_RD_OVERRIDE=0 - dummy read disabled with msi, enabled without msi
 	 * IH_DUMMY_RD_OVERRIDE=1 - dummy read controlled by IH_DUMMY_RD_EN
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -3427,8 +3427,8 @@ int r600_irq_init(struct radeon_device *
 	}
 
 	/* setup interrupt control */
-	/* set dummy read address to ring address */
-	WREG32(INTERRUPT_CNTL2, rdev->ih.gpu_addr >> 8);
+	/* set dummy read address to dummy page address */
+	WREG32(INTERRUPT_CNTL2, rdev->dummy_page.addr >> 8);
 	interrupt_cntl = RREG32(INTERRUPT_CNTL);
 	/* IH_DUMMY_RD_OVERRIDE=0 - dummy read disabled with msi, enabled without msi
 	 * IH_DUMMY_RD_OVERRIDE=1 - dummy read controlled by IH_DUMMY_RD_EN
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -5749,8 +5749,8 @@ static int si_irq_init(struct radeon_dev
 	}
 
 	/* setup interrupt control */
-	/* set dummy read address to ring address */
-	WREG32(INTERRUPT_CNTL2, rdev->ih.gpu_addr >> 8);
+	/* set dummy read address to dummy page address */
+	WREG32(INTERRUPT_CNTL2, rdev->dummy_page.addr >> 8);
 	interrupt_cntl = RREG32(INTERRUPT_CNTL);
 	/* IH_DUMMY_RD_OVERRIDE=0 - dummy read disabled with msi, enabled without msi
 	 * IH_DUMMY_RD_OVERRIDE=1 - dummy read controlled by IH_DUMMY_RD_EN

