Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B81D4204F0
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 13:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbfEPLjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 07:39:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727398AbfEPLjq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 07:39:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED1942087E;
        Thu, 16 May 2019 11:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558006785;
        bh=BPwRZglwF9J+rpzxhoY1p4JujbqmzpsKuEcas2nSRh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cULI1kG9imt9xvSq0oqlgMWGfdJfmejIm2Y0M36MNZx7LbOZBgYnuxV7ZtNkwYt+Y
         NuqMKTXXJXmHlfNZRom8SbCQKcc7isksajbxnYalrGYuJPqaBEIQ2h+5M7Lt7G2SbR
         Ipe64InrQ39S/i02gcYKzNjkj8/IpU7lE2RxY4c0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 5.0 09/34] ARC: PAE40: don't panic and instead turn off hw ioc
Date:   Thu, 16 May 2019 07:39:06 -0400
Message-Id: <20190516113932.8348-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516113932.8348-1-sashal@kernel.org>
References: <20190516113932.8348-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

[ Upstream commit 99bd5fcc505d65ea9c60619202f0b2d926eabbe9 ]

HSDK currently panics when built for HIGHMEM/ARC_HAS_PAE40 because ioc
is enabled with default which doesn't work for the 2 non contiguous
memory nodes. So get PAE working by disabling ioc instead.

Tested with !PAE40 by forcing @ioc_enable=0 and running the glibc
testsuite over ssh

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/mm/cache.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/arc/mm/cache.c b/arch/arc/mm/cache.c
index 4135abec3fb09..63e6e65046992 100644
--- a/arch/arc/mm/cache.c
+++ b/arch/arc/mm/cache.c
@@ -113,10 +113,24 @@ static void read_decode_cache_bcr_arcv2(int cpu)
 	}
 
 	READ_BCR(ARC_REG_CLUSTER_BCR, cbcr);
-	if (cbcr.c)
+	if (cbcr.c) {
 		ioc_exists = 1;
-	else
+
+		/*
+		 * As for today we don't support both IOC and ZONE_HIGHMEM enabled
+		 * simultaneously. This happens because as of today IOC aperture covers
+		 * only ZONE_NORMAL (low mem) and any dma transactions outside this
+		 * region won't be HW coherent.
+		 * If we want to use both IOC and ZONE_HIGHMEM we can use
+		 * bounce_buffer to handle dma transactions to HIGHMEM.
+		 * Also it is possible to modify dma_direct cache ops or increase IOC
+		 * aperture size if we are planning to use HIGHMEM without PAE.
+		 */
+		if (IS_ENABLED(CONFIG_HIGHMEM) || is_pae40_enabled())
+			ioc_enable = 0;
+	} else {
 		ioc_enable = 0;
+	}
 
 	/* HS 2.0 didn't have AUX_VOL */
 	if (cpuinfo_arc700[cpu].core.family > 0x51) {
@@ -1158,19 +1172,6 @@ noinline void __init arc_ioc_setup(void)
 	if (!ioc_enable)
 		return;
 
-	/*
-	 * As for today we don't support both IOC and ZONE_HIGHMEM enabled
-	 * simultaneously. This happens because as of today IOC aperture covers
-	 * only ZONE_NORMAL (low mem) and any dma transactions outside this
-	 * region won't be HW coherent.
-	 * If we want to use both IOC and ZONE_HIGHMEM we can use
-	 * bounce_buffer to handle dma transactions to HIGHMEM.
-	 * Also it is possible to modify dma_direct cache ops or increase IOC
-	 * aperture size if we are planning to use HIGHMEM without PAE.
-	 */
-	if (IS_ENABLED(CONFIG_HIGHMEM))
-		panic("IOC and HIGHMEM can't be used simultaneously");
-
 	/* Flush + invalidate + disable L1 dcache */
 	__dc_disable();
 
-- 
2.20.1

