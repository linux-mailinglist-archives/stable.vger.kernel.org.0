Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5541C42906F
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238312AbhJKOJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:09:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238735AbhJKOGQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:06:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77FB76120C;
        Mon, 11 Oct 2021 14:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960809;
        bh=B6996kXnxMLT6HqdNkz9KRfNv0sHeHp8ZYGNF+MNoPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sp9lto8zI4fx26rCRFbc763EkjUp+AKLJXH1gRRJDUKjJt3ZiUB84WQwWCvFHQC0d
         VFrMFPzmc/AfzMZKQZuqeauQyXG/wu6pOQxtwoLSsxhibeaVS31LGcZ7QK8EObssXF
         wCHnsvlDYnJDPPWFIBWwhgW78Av1jOXGZjE8Wb0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Greg Ungerer <gerg@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 072/151] MIPS: Revert "add support for buggy MT7621S core detection"
Date:   Mon, 11 Oct 2021 15:45:44 +0200
Message-Id: <20211011134520.176672284@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>

[ Upstream commit 740da9d7ca4e25f5d87db9f80d75432681b61305 ]

This reverts commit 6decd1aad15f56b169217789630a0098b496de0e. CPULAUNCH
register is not set properly by some bootloaders, causing a regression
until a bootloader change is made, which is hard if not impossible on
some embedded devices. Revert the change until a more robust core
detection mechanism that works on MT7621S routers such as Netgear R6220
as well as platforms like Digi EX15 can be made.

Link: https://lore.kernel.org/lkml/4d9e3b39-7caa-d372-5d7b-42dcec36fec7@kernel.org
Fixes: 6decd1aad15f ("MIPS: add support for buggy MT7621S core detection")
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Acked-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Acked-by: Greg Ungerer <gerg@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/mips-cps.h | 23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/arch/mips/include/asm/mips-cps.h b/arch/mips/include/asm/mips-cps.h
index 35fb8ee6dd33..fd43d876892e 100644
--- a/arch/mips/include/asm/mips-cps.h
+++ b/arch/mips/include/asm/mips-cps.h
@@ -10,8 +10,6 @@
 #include <linux/io.h>
 #include <linux/types.h>
 
-#include <asm/mips-boards/launch.h>
-
 extern unsigned long __cps_access_bad_size(void)
 	__compiletime_error("Bad size for CPS accessor");
 
@@ -167,30 +165,11 @@ static inline uint64_t mips_cps_cluster_config(unsigned int cluster)
  */
 static inline unsigned int mips_cps_numcores(unsigned int cluster)
 {
-	unsigned int ncores;
-
 	if (!mips_cm_present())
 		return 0;
 
 	/* Add one before masking to handle 0xff indicating no cores */
-	ncores = (mips_cps_cluster_config(cluster) + 1) & CM_GCR_CONFIG_PCORES;
-
-	if (IS_ENABLED(CONFIG_SOC_MT7621)) {
-		struct cpulaunch *launch;
-
-		/*
-		 * Ralink MT7621S SoC is single core, but the GCR_CONFIG method
-		 * always reports 2 cores. Check the second core's LAUNCH_FREADY
-		 * flag to detect if the second core is missing. This method
-		 * only works before the core has been started.
-		 */
-		launch = (struct cpulaunch *)CKSEG0ADDR(CPULAUNCH);
-		launch += 2; /* MT7621 has 2 VPEs per core */
-		if (!(launch->flags & LAUNCH_FREADY))
-			ncores = 1;
-	}
-
-	return ncores;
+	return (mips_cps_cluster_config(cluster) + 1) & CM_GCR_CONFIG_PCORES;
 }
 
 /**
-- 
2.33.0



