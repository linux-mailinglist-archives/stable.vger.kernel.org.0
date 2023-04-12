Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D656DEE2C
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbjDLIlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbjDLIkD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:40:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4327A93
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:39:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66C0F62903
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF9AC433EF;
        Wed, 12 Apr 2023 08:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288684;
        bh=rTbVBiDxwXKoO3n5y3bycOfOdi6uE10OYRf01EnNi3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZRzQFPSVkY07yHJlHK1s4JMWHCncJEhQrVyccRuun0q98685wqn21Z0jsgXsUoOpD
         e64RJyMDzSz5QUOcrH68KsIo92lImOA/487WqGkV4p17ffa34lJB5NeW63wfxhqU0b
         nXlxbuZEIk2wkbSGzZNwHVRg3KHwHuGgMFlnz7b8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Steve Clevenger <scclevenger@os.amperecomputing.com>,
        Mike Leach <mike.leach@linaro.org>,
        James Clark <james.clark@arm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 5.15 71/93] coresight: etm4x: Do not access TRCIDR1 for identification
Date:   Wed, 12 Apr 2023 10:34:12 +0200
Message-Id: <20230412082826.117642770@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

commit 735e7b30a53a1679c050cddb73f5e5316105d2e3 upstream.

CoreSight ETM4x architecture clearly provides ways to identify a device
via registers in the "Management" class, TRCDEVARCH and TRCDEVTYPE. These
registers can be accessed without the Trace domain being powered on.
We additionally added TRCIDR1 as fallback in order to cover for any
ETMs that may not have implemented TRCDEVARCH. So far, nobody has
reported hitting a WARNING we placed to catch such systems.

Also, more importantly it is problematic to access TRCIDR1, which is a
"Trace" register via MMIO access, without clearing the OSLK. But we cannot
mess with the OSLK until we know for sure that this is an ETMv4 device.
Thus, this kind of creates a chicken and egg problem unnecessarily for
systems "which are compliant" to the ETMv4 architecture.

Let us remove the TRCIDR1 fall back check and rely only on TRCDEVARCH.

Fixes: 8b94db1edaee ("coresight: etm4x: Use TRCDEVARCH for component discovery")
Cc: stable@vger.kernel.org
Reported-by: Steve Clevenger <scclevenger@os.amperecomputing.com>
Link: https://lore.kernel.org/all/143540e5623d4c7393d24833f2b80600d8d745d2.1677881753.git.scclevenger@os.amperecomputing.com/
Cc: Mike Leach <mike.leach@linaro.org>
Cc: James Clark <james.clark@arm.com>
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20230321104530.1547136-1-suzuki.poulose@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c |   22 ++++++++-------------
 drivers/hwtracing/coresight/coresight-etm4x.h      |   20 +++++--------------
 2 files changed, 15 insertions(+), 27 deletions(-)

--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -951,25 +951,21 @@ static bool etm4_init_iomem_access(struc
 				   struct csdev_access *csa)
 {
 	u32 devarch = readl_relaxed(drvdata->base + TRCDEVARCH);
-	u32 idr1 = readl_relaxed(drvdata->base + TRCIDR1);
 
 	/*
 	 * All ETMs must implement TRCDEVARCH to indicate that
-	 * the component is an ETMv4. To support any broken
-	 * implementations we fall back to TRCIDR1 check, which
-	 * is not really reliable.
+	 * the component is an ETMv4. Even though TRCIDR1 also
+	 * contains the information, it is part of the "Trace"
+	 * register and must be accessed with the OSLK cleared,
+	 * with MMIO. But we cannot touch the OSLK until we are
+	 * sure this is an ETM. So rely only on the TRCDEVARCH.
 	 */
-	if ((devarch & ETM_DEVARCH_ID_MASK) == ETM_DEVARCH_ETMv4x_ARCH) {
-		drvdata->arch = etm_devarch_to_arch(devarch);
-	} else {
-		pr_warn("CPU%d: ETM4x incompatible TRCDEVARCH: %x, falling back to TRCIDR1\n",
-			smp_processor_id(), devarch);
-
-		if (ETM_TRCIDR1_ARCH_MAJOR(idr1) != ETM_TRCIDR1_ARCH_ETMv4)
-			return false;
-		drvdata->arch = etm_trcidr_to_arch(idr1);
+	if ((devarch & ETM_DEVARCH_ID_MASK) != ETM_DEVARCH_ETMv4x_ARCH) {
+		pr_warn_once("TRCDEVARCH doesn't match ETMv4 architecture\n");
+		return false;
 	}
 
+	drvdata->arch = etm_devarch_to_arch(devarch);
 	*csa = CSDEV_ACCESS_IOMEM(drvdata->base);
 	return true;
 }
--- a/drivers/hwtracing/coresight/coresight-etm4x.h
+++ b/drivers/hwtracing/coresight/coresight-etm4x.h
@@ -669,14 +669,12 @@
  * TRCDEVARCH	- CoreSight architected register
  *                - Bits[15:12] - Major version
  *                - Bits[19:16] - Minor version
- * TRCIDR1	- ETM architected register
- *                - Bits[11:8] - Major version
- *                - Bits[7:4]  - Minor version
- * We must rely on TRCDEVARCH for the version information,
- * however we don't want to break the support for potential
- * old implementations which might not implement it. Thus
- * we fall back to TRCIDR1 if TRCDEVARCH is not implemented
- * for memory mapped components.
+ *
+ * We must rely only on TRCDEVARCH for the version information. Even though,
+ * TRCIDR1 also provides the architecture version, it is a "Trace" register
+ * and as such must be accessed only with Trace power domain ON. This may
+ * not be available at probe time.
+ *
  * Now to make certain decisions easier based on the version
  * we use an internal representation of the version in the
  * driver, as follows :
@@ -702,12 +700,6 @@ static inline u8 etm_devarch_to_arch(u32
 				ETM_DEVARCH_REVISION(devarch));
 }
 
-static inline u8 etm_trcidr_to_arch(u32 trcidr1)
-{
-	return ETM_ARCH_VERSION(ETM_TRCIDR1_ARCH_MAJOR(trcidr1),
-				ETM_TRCIDR1_ARCH_MINOR(trcidr1));
-}
-
 enum etm_impdef_type {
 	ETM4_IMPDEF_HISI_CORE_COMMIT,
 	ETM4_IMPDEF_FEATURE_MAX,


