Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98FD24EF4C8
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348976AbiDAPE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349131AbiDAOzD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:55:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2958F2963CC;
        Fri,  1 Apr 2022 07:43:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8481FB82370;
        Fri,  1 Apr 2022 14:43:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AFFCC340EE;
        Fri,  1 Apr 2022 14:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824182;
        bh=q/+ewae8Ri6srJhRAceDtcO/mVUUjehSSEurl26zdHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ReNwQnNAZuWwu0Gcz8gs07gItstToGRaAoPG3xL0UNAlpBisnB/og7aBcGuwJOvFp
         m/vbaHQi2rtH4eiowrvgL/uv75bHh2CCB/Qc58I5hHfNFKr3lOtDchVEHSfB9j8WYd
         hR7rTkK2BlyR3L8lOwm//tpxUZ14kRilR4IJcOhBUyzYIg/VJjPAZqPI0aR3Xu1GmD
         6C5px9K/LGb1r5aKp0sxUPzMI1CTk/MSbKEqfvv+OhyyPrRXy6ihPP8+BAKRE8N5Fh
         nKUatwg9LEofb4AqBVjJkVNDSLmj23EU7p5hmQzMsnhz6nOa/fPlWIkpgibr2vQDJ1
         toeNzqbAV9t+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sourabh Jain <sourabhjain@linux.ibm.com>,
        Abdul haleem <abdhalee@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, nathanl@linux.ibm.com,
        ajd@linux.ibm.com, aik@ozlabs.ru, rafael.j.wysocki@intel.com,
        adobriyan@gmail.com, npiggin@gmail.com,
        christophe.leroy@csgroup.eu, arnd@arndb.de,
        akpm@linux-foundation.org, nick.child@ibm.com, rppt@kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 19/65] powerpc: Set crashkernel offset to mid of RMA region
Date:   Fri,  1 Apr 2022 10:41:20 -0400
Message-Id: <20220401144206.1953700-19-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144206.1953700-1-sashal@kernel.org>
References: <20220401144206.1953700-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sourabh Jain <sourabhjain@linux.ibm.com>

[ Upstream commit 7c5ed82b800d8615cdda00729e7b62e5899f0b13 ]

On large config LPARs (having 192 and more cores), Linux fails to boot
due to insufficient memory in the first memblock. It is due to the
memory reservation for the crash kernel which starts at 128MB offset of
the first memblock. This memory reservation for the crash kernel doesn't
leave enough space in the first memblock to accommodate other essential
system resources.

The crash kernel start address was set to 128MB offset by default to
ensure that the crash kernel get some memory below the RMA region which
is used to be of size 256MB. But given that the RMA region size can be
512MB or more, setting the crash kernel offset to mid of RMA size will
leave enough space for the kernel to allocate memory for other system
resources.

Since the above crash kernel offset change is only applicable to the LPAR
platform, the LPAR feature detection is pushed before the crash kernel
reservation. The rest of LPAR specific initialization will still
be done during pseries_probe_fw_features as usual.

This patch is dependent on changes to paca allocation for boot CPU. It
expect boot CPU to discover 1T segment support which is introduced by
the patch posted here:
https://lists.ozlabs.org/pipermail/linuxppc-dev/2022-January/239175.html

Reported-by: Abdul haleem <abdhalee@linux.vnet.ibm.com>
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220204085601.107257-1-sourabhjain@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/rtas.c |  6 ++++++
 arch/powerpc/kexec/core.c  | 15 +++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index cccb32cf0e08..cf421eb7f90d 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -1296,6 +1296,12 @@ int __init early_init_dt_scan_rtas(unsigned long node,
 	entryp = of_get_flat_dt_prop(node, "linux,rtas-entry", NULL);
 	sizep  = of_get_flat_dt_prop(node, "rtas-size", NULL);
 
+#ifdef CONFIG_PPC64
+	/* need this feature to decide the crashkernel offset */
+	if (of_get_flat_dt_prop(node, "ibm,hypertas-functions", NULL))
+		powerpc_firmware_features |= FW_FEATURE_LPAR;
+#endif
+
 	if (basep && entryp && sizep) {
 		rtas.base = *basep;
 		rtas.entry = *entryp;
diff --git a/arch/powerpc/kexec/core.c b/arch/powerpc/kexec/core.c
index 56da5eb2b923..80c79cb5010c 100644
--- a/arch/powerpc/kexec/core.c
+++ b/arch/powerpc/kexec/core.c
@@ -147,11 +147,18 @@ void __init reserve_crashkernel(void)
 	if (!crashk_res.start) {
 #ifdef CONFIG_PPC64
 		/*
-		 * On 64bit we split the RMO in half but cap it at half of
-		 * a small SLB (128MB) since the crash kernel needs to place
-		 * itself and some stacks to be in the first segment.
+		 * On the LPAR platform place the crash kernel to mid of
+		 * RMA size (512MB or more) to ensure the crash kernel
+		 * gets enough space to place itself and some stack to be
+		 * in the first segment. At the same time normal kernel
+		 * also get enough space to allocate memory for essential
+		 * system resource in the first segment. Keep the crash
+		 * kernel starts at 128MB offset on other platforms.
 		 */
-		crashk_res.start = min(0x8000000ULL, (ppc64_rma_size / 2));
+		if (firmware_has_feature(FW_FEATURE_LPAR))
+			crashk_res.start = ppc64_rma_size / 2;
+		else
+			crashk_res.start = min(0x8000000ULL, (ppc64_rma_size / 2));
 #else
 		crashk_res.start = KDUMP_KERNELBASE;
 #endif
-- 
2.34.1

