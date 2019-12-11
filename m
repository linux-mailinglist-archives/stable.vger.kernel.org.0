Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 392A911AF2E
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730966AbfLKPLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:11:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:60292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730947AbfLKPLj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:11:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 895AE2173E;
        Wed, 11 Dec 2019 15:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077098;
        bh=9hkSsYRPRAWqxI8SaMw18ck/Ae/RkQLUV7K73205vVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KC1lg7Oz6x/g4zir1NTTFNWK60y5tmAkgthX42T01+adwhrm6V+YVOvr4xnhU3nDp
         UBVvA19LL1NZMrR6dlBTUNIqasviSzestuFwzSLl/ybgtZImn+Z323RMzuH0HDFqXy
         Z7sjCi9bMzV2A4Aip1pc3sB2KbbhFkY9EGT6+BPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>, linux-mips@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 016/105] MIPS: SGI-IP27: fix exception handler replication
Date:   Wed, 11 Dec 2019 16:05:05 +0100
Message-Id: <20191211150224.498621488@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>

[ Upstream commit 637346748245e94c877aa746e6fe0d7079b7736a ]

Commit 775b089aeffa ("MIPS: tlbex: Remove cpu_has_local_ebase") removed
generating tlb refill handlers for every CPU, which was needed for
generating per node exception handlers on IP27. Instead of resurrecting
(and fixing) refill handler generation, we simply copy all exception
vectors from the boot node to the other nodes. Also remove the config
option since the memory tradeoff for expection handler replication
is just 8k per node.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Signed-off-by: Paul Burton <paulburton@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Burton <paul.burton@mips.com>
Cc: James Hogan <jhogan@kernel.org>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/sgi-ip27/Kconfig       |  7 -------
 arch/mips/sgi-ip27/ip27-init.c   | 21 ++++++---------------
 arch/mips/sgi-ip27/ip27-memory.c |  4 ----
 3 files changed, 6 insertions(+), 26 deletions(-)

diff --git a/arch/mips/sgi-ip27/Kconfig b/arch/mips/sgi-ip27/Kconfig
index ef3847e7aee02..e5b6cadbec857 100644
--- a/arch/mips/sgi-ip27/Kconfig
+++ b/arch/mips/sgi-ip27/Kconfig
@@ -38,10 +38,3 @@ config REPLICATE_KTEXT
 	  Say Y here to enable replicating the kernel text across multiple
 	  nodes in a NUMA cluster.  This trades memory for speed.
 
-config REPLICATE_EXHANDLERS
-	bool "Exception handler replication support"
-	depends on SGI_IP27
-	help
-	  Say Y here to enable replicating the kernel exception handlers
-	  across multiple nodes in a NUMA cluster. This trades memory for
-	  speed.
diff --git a/arch/mips/sgi-ip27/ip27-init.c b/arch/mips/sgi-ip27/ip27-init.c
index 066b33f50bcc4..db58ebf02870f 100644
--- a/arch/mips/sgi-ip27/ip27-init.c
+++ b/arch/mips/sgi-ip27/ip27-init.c
@@ -69,23 +69,14 @@ static void per_hub_init(cnodeid_t cnode)
 
 	hub_rtc_init(cnode);
 
-#ifdef CONFIG_REPLICATE_EXHANDLERS
-	/*
-	 * If this is not a headless node initialization,
-	 * copy over the caliased exception handlers.
-	 */
-	if (get_compact_nodeid() == cnode) {
-		extern char except_vec2_generic, except_vec3_generic;
-		extern void build_tlb_refill_handler(void);
-
-		memcpy((void *)(CKSEG0 + 0x100), &except_vec2_generic, 0x80);
-		memcpy((void *)(CKSEG0 + 0x180), &except_vec3_generic, 0x80);
-		build_tlb_refill_handler();
-		memcpy((void *)(CKSEG0 + 0x100), (void *) CKSEG0, 0x80);
-		memcpy((void *)(CKSEG0 + 0x180), &except_vec3_generic, 0x100);
+	if (nasid) {
+		/* copy exception handlers from first node to current node */
+		memcpy((void *)NODE_OFFSET_TO_K0(nasid, 0),
+		       (void *)CKSEG0, 0x200);
 		__flush_cache_all();
+		/* switch to node local exception handlers */
+		REMOTE_HUB_S(nasid, PI_CALIAS_SIZE, PI_CALIAS_SIZE_8K);
 	}
-#endif
 }
 
 void per_cpu_init(void)
diff --git a/arch/mips/sgi-ip27/ip27-memory.c b/arch/mips/sgi-ip27/ip27-memory.c
index fb077a9475756..8624a885d95bf 100644
--- a/arch/mips/sgi-ip27/ip27-memory.c
+++ b/arch/mips/sgi-ip27/ip27-memory.c
@@ -332,11 +332,7 @@ static void __init mlreset(void)
 		 * thinks it is a node 0 address.
 		 */
 		REMOTE_HUB_S(nasid, PI_REGION_PRESENT, (region_mask | 1));
-#ifdef CONFIG_REPLICATE_EXHANDLERS
-		REMOTE_HUB_S(nasid, PI_CALIAS_SIZE, PI_CALIAS_SIZE_8K);
-#else
 		REMOTE_HUB_S(nasid, PI_CALIAS_SIZE, PI_CALIAS_SIZE_0);
-#endif
 
 #ifdef LATER
 		/*
-- 
2.20.1



