Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D755418F6
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376274AbiFGVSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380674AbiFGVQk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:16:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA2E21F989;
        Tue,  7 Jun 2022 11:55:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14BA961311;
        Tue,  7 Jun 2022 18:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BBBDC385A2;
        Tue,  7 Jun 2022 18:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628158;
        bh=UVrRQ7UUGdZgqTTfy/Jr0X61/9B2DuEKbjBLSnF3gKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VrjOr1N6miuLMcMR/So6H688DvkYssGsbA6ERfkfB5vOOpjYGKjMOZl0gAgEp9sDq
         DH5Det4QhOwYfEyGvQAv18ylPcZ8ueSHLjljVvk/F6Pb5o2cdfOkpghzK+/KBHgCeK
         9pRX6MLMPUEerNIdZaOR0nWn6yvFKkQJOt6T66Dw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hari Bathini <hbathini@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 226/879] powerpc/fadump: Fix fadump to work with a different endian capture kernel
Date:   Tue,  7 Jun 2022 18:55:44 +0200
Message-Id: <20220607165009.413391321@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hari Bathini <hbathini@linux.ibm.com>

[ Upstream commit b74196af372f7cb4902179009265fe63ac81824f ]

Dump capture would fail if capture kernel is not of the endianess as the
production kernel, because the in-memory data structure (struct
opal_fadump_mem_struct) shared across production kernel and capture
kernel assumes the same endianess for both the kernels, which doesn't
have to be true always. Fix it by having a well-defined endianess for
struct opal_fadump_mem_struct.

Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/161902744901.86147.14719228311655123526.stgit@hbathini
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/opal-fadump.c | 94 +++++++++++---------
 arch/powerpc/platforms/powernv/opal-fadump.h | 10 +--
 2 files changed, 57 insertions(+), 47 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/opal-fadump.c b/arch/powerpc/platforms/powernv/opal-fadump.c
index c8ad057c7221..9d74d3950a52 100644
--- a/arch/powerpc/platforms/powernv/opal-fadump.c
+++ b/arch/powerpc/platforms/powernv/opal-fadump.c
@@ -60,7 +60,7 @@ void __init opal_fadump_dt_scan(struct fw_dump *fadump_conf, u64 node)
 	addr = be64_to_cpu(addr);
 	pr_debug("Kernel metadata addr: %llx\n", addr);
 	opal_fdm_active = (void *)addr;
-	if (opal_fdm_active->registered_regions == 0)
+	if (be16_to_cpu(opal_fdm_active->registered_regions) == 0)
 		return;
 
 	ret = opal_mpipl_query_tag(OPAL_MPIPL_TAG_BOOT_MEM, &addr);
@@ -95,17 +95,17 @@ static int opal_fadump_unregister(struct fw_dump *fadump_conf);
 static void opal_fadump_update_config(struct fw_dump *fadump_conf,
 				      const struct opal_fadump_mem_struct *fdm)
 {
-	pr_debug("Boot memory regions count: %d\n", fdm->region_cnt);
+	pr_debug("Boot memory regions count: %d\n", be16_to_cpu(fdm->region_cnt));
 
 	/*
 	 * The destination address of the first boot memory region is the
 	 * destination address of boot memory regions.
 	 */
-	fadump_conf->boot_mem_dest_addr = fdm->rgn[0].dest;
+	fadump_conf->boot_mem_dest_addr = be64_to_cpu(fdm->rgn[0].dest);
 	pr_debug("Destination address of boot memory regions: %#016llx\n",
 		 fadump_conf->boot_mem_dest_addr);
 
-	fadump_conf->fadumphdr_addr = fdm->fadumphdr_addr;
+	fadump_conf->fadumphdr_addr = be64_to_cpu(fdm->fadumphdr_addr);
 }
 
 /*
@@ -126,9 +126,9 @@ static void __init opal_fadump_get_config(struct fw_dump *fadump_conf,
 	fadump_conf->boot_memory_size = 0;
 
 	pr_debug("Boot memory regions:\n");
-	for (i = 0; i < fdm->region_cnt; i++) {
-		base = fdm->rgn[i].src;
-		size = fdm->rgn[i].size;
+	for (i = 0; i < be16_to_cpu(fdm->region_cnt); i++) {
+		base = be64_to_cpu(fdm->rgn[i].src);
+		size = be64_to_cpu(fdm->rgn[i].size);
 		pr_debug("\t[%03d] base: 0x%lx, size: 0x%lx\n", i, base, size);
 
 		fadump_conf->boot_mem_addr[i] = base;
@@ -143,7 +143,7 @@ static void __init opal_fadump_get_config(struct fw_dump *fadump_conf,
 	 * Start address of reserve dump area (permanent reservation) for
 	 * re-registering FADump after dump capture.
 	 */
-	fadump_conf->reserve_dump_area_start = fdm->rgn[0].dest;
+	fadump_conf->reserve_dump_area_start = be64_to_cpu(fdm->rgn[0].dest);
 
 	/*
 	 * Rarely, but it can so happen that system crashes before all
@@ -155,13 +155,14 @@ static void __init opal_fadump_get_config(struct fw_dump *fadump_conf,
 	 * Hope the memory that could not be preserved only has pages
 	 * that are usually filtered out while saving the vmcore.
 	 */
-	if (fdm->region_cnt > fdm->registered_regions) {
+	if (be16_to_cpu(fdm->region_cnt) > be16_to_cpu(fdm->registered_regions)) {
 		pr_warn("Not all memory regions were saved!!!\n");
 		pr_warn("  Unsaved memory regions:\n");
-		i = fdm->registered_regions;
-		while (i < fdm->region_cnt) {
+		i = be16_to_cpu(fdm->registered_regions);
+		while (i < be16_to_cpu(fdm->region_cnt)) {
 			pr_warn("\t[%03d] base: 0x%llx, size: 0x%llx\n",
-				i, fdm->rgn[i].src, fdm->rgn[i].size);
+				i, be64_to_cpu(fdm->rgn[i].src),
+				be64_to_cpu(fdm->rgn[i].size));
 			i++;
 		}
 
@@ -170,7 +171,7 @@ static void __init opal_fadump_get_config(struct fw_dump *fadump_conf,
 	}
 
 	fadump_conf->boot_mem_top = (fadump_conf->boot_memory_size + hole_size);
-	fadump_conf->boot_mem_regs_cnt = fdm->region_cnt;
+	fadump_conf->boot_mem_regs_cnt = be16_to_cpu(fdm->region_cnt);
 	opal_fadump_update_config(fadump_conf, fdm);
 }
 
@@ -178,35 +179,38 @@ static void __init opal_fadump_get_config(struct fw_dump *fadump_conf,
 static void opal_fadump_init_metadata(struct opal_fadump_mem_struct *fdm)
 {
 	fdm->version = OPAL_FADUMP_VERSION;
-	fdm->region_cnt = 0;
-	fdm->registered_regions = 0;
-	fdm->fadumphdr_addr = 0;
+	fdm->region_cnt = cpu_to_be16(0);
+	fdm->registered_regions = cpu_to_be16(0);
+	fdm->fadumphdr_addr = cpu_to_be64(0);
 }
 
 static u64 opal_fadump_init_mem_struct(struct fw_dump *fadump_conf)
 {
 	u64 addr = fadump_conf->reserve_dump_area_start;
+	u16 reg_cnt;
 	int i;
 
 	opal_fdm = __va(fadump_conf->kernel_metadata);
 	opal_fadump_init_metadata(opal_fdm);
 
 	/* Boot memory regions */
+	reg_cnt = be16_to_cpu(opal_fdm->region_cnt);
 	for (i = 0; i < fadump_conf->boot_mem_regs_cnt; i++) {
-		opal_fdm->rgn[i].src	= fadump_conf->boot_mem_addr[i];
-		opal_fdm->rgn[i].dest	= addr;
-		opal_fdm->rgn[i].size	= fadump_conf->boot_mem_sz[i];
+		opal_fdm->rgn[i].src	= cpu_to_be64(fadump_conf->boot_mem_addr[i]);
+		opal_fdm->rgn[i].dest	= cpu_to_be64(addr);
+		opal_fdm->rgn[i].size	= cpu_to_be64(fadump_conf->boot_mem_sz[i]);
 
-		opal_fdm->region_cnt++;
+		reg_cnt++;
 		addr += fadump_conf->boot_mem_sz[i];
 	}
+	opal_fdm->region_cnt = cpu_to_be16(reg_cnt);
 
 	/*
 	 * Kernel metadata is passed to f/w and retrieved in capture kerenl.
 	 * So, use it to save fadump header address instead of calculating it.
 	 */
-	opal_fdm->fadumphdr_addr = (opal_fdm->rgn[0].dest +
-				    fadump_conf->boot_memory_size);
+	opal_fdm->fadumphdr_addr = cpu_to_be64(be64_to_cpu(opal_fdm->rgn[0].dest) +
+					       fadump_conf->boot_memory_size);
 
 	opal_fadump_update_config(fadump_conf, opal_fdm);
 
@@ -269,18 +273,21 @@ static u64 opal_fadump_get_bootmem_min(void)
 static int opal_fadump_register(struct fw_dump *fadump_conf)
 {
 	s64 rc = OPAL_PARAMETER;
+	u16 registered_regs;
 	int i, err = -EIO;
 
-	for (i = 0; i < opal_fdm->region_cnt; i++) {
+	registered_regs = be16_to_cpu(opal_fdm->registered_regions);
+	for (i = 0; i < be16_to_cpu(opal_fdm->region_cnt); i++) {
 		rc = opal_mpipl_update(OPAL_MPIPL_ADD_RANGE,
-				       opal_fdm->rgn[i].src,
-				       opal_fdm->rgn[i].dest,
-				       opal_fdm->rgn[i].size);
+				       be64_to_cpu(opal_fdm->rgn[i].src),
+				       be64_to_cpu(opal_fdm->rgn[i].dest),
+				       be64_to_cpu(opal_fdm->rgn[i].size));
 		if (rc != OPAL_SUCCESS)
 			break;
 
-		opal_fdm->registered_regions++;
+		registered_regs++;
 	}
+	opal_fdm->registered_regions = cpu_to_be16(registered_regs);
 
 	switch (rc) {
 	case OPAL_SUCCESS:
@@ -291,7 +298,8 @@ static int opal_fadump_register(struct fw_dump *fadump_conf)
 	case OPAL_RESOURCE:
 		/* If MAX regions limit in f/w is hit, warn and proceed. */
 		pr_warn("%d regions could not be registered for MPIPL as MAX limit is reached!\n",
-			(opal_fdm->region_cnt - opal_fdm->registered_regions));
+			(be16_to_cpu(opal_fdm->region_cnt) -
+			 be16_to_cpu(opal_fdm->registered_regions)));
 		fadump_conf->dump_registered = 1;
 		err = 0;
 		break;
@@ -312,7 +320,7 @@ static int opal_fadump_register(struct fw_dump *fadump_conf)
 	 * If some regions were registered before OPAL_MPIPL_ADD_RANGE
 	 * OPAL call failed, unregister all regions.
 	 */
-	if ((err < 0) && (opal_fdm->registered_regions > 0))
+	if ((err < 0) && (be16_to_cpu(opal_fdm->registered_regions) > 0))
 		opal_fadump_unregister(fadump_conf);
 
 	return err;
@@ -328,7 +336,7 @@ static int opal_fadump_unregister(struct fw_dump *fadump_conf)
 		return -EIO;
 	}
 
-	opal_fdm->registered_regions = 0;
+	opal_fdm->registered_regions = cpu_to_be16(0);
 	fadump_conf->dump_registered = 0;
 	return 0;
 }
@@ -563,19 +571,20 @@ static void opal_fadump_region_show(struct fw_dump *fadump_conf,
 	else
 		fdm_ptr = opal_fdm;
 
-	for (i = 0; i < fdm_ptr->region_cnt; i++) {
+	for (i = 0; i < be16_to_cpu(fdm_ptr->region_cnt); i++) {
 		/*
 		 * Only regions that are registered for MPIPL
 		 * would have dump data.
 		 */
 		if ((fadump_conf->dump_active) &&
-		    (i < fdm_ptr->registered_regions))
-			dumped_bytes = fdm_ptr->rgn[i].size;
+		    (i < be16_to_cpu(fdm_ptr->registered_regions)))
+			dumped_bytes = be64_to_cpu(fdm_ptr->rgn[i].size);
 
 		seq_printf(m, "DUMP: Src: %#016llx, Dest: %#016llx, ",
-			   fdm_ptr->rgn[i].src, fdm_ptr->rgn[i].dest);
+			   be64_to_cpu(fdm_ptr->rgn[i].src),
+			   be64_to_cpu(fdm_ptr->rgn[i].dest));
 		seq_printf(m, "Size: %#llx, Dumped: %#llx bytes\n",
-			   fdm_ptr->rgn[i].size, dumped_bytes);
+			   be64_to_cpu(fdm_ptr->rgn[i].size), dumped_bytes);
 	}
 
 	/* Dump is active. Show reserved area start address. */
@@ -624,6 +633,7 @@ void __init opal_fadump_dt_scan(struct fw_dump *fadump_conf, u64 node)
 {
 	const __be32 *prop;
 	unsigned long dn;
+	__be64 be_addr;
 	u64 addr = 0;
 	int i, len;
 	s64 ret;
@@ -680,13 +690,13 @@ void __init opal_fadump_dt_scan(struct fw_dump *fadump_conf, u64 node)
 	if (!prop)
 		return;
 
-	ret = opal_mpipl_query_tag(OPAL_MPIPL_TAG_KERNEL, &addr);
-	if ((ret != OPAL_SUCCESS) || !addr) {
+	ret = opal_mpipl_query_tag(OPAL_MPIPL_TAG_KERNEL, &be_addr);
+	if ((ret != OPAL_SUCCESS) || !be_addr) {
 		pr_err("Failed to get Kernel metadata (%lld)\n", ret);
 		return;
 	}
 
-	addr = be64_to_cpu(addr);
+	addr = be64_to_cpu(be_addr);
 	pr_debug("Kernel metadata addr: %llx\n", addr);
 
 	opal_fdm_active = __va(addr);
@@ -697,14 +707,14 @@ void __init opal_fadump_dt_scan(struct fw_dump *fadump_conf, u64 node)
 	}
 
 	/* Kernel regions not registered with f/w for MPIPL */
-	if (opal_fdm_active->registered_regions == 0) {
+	if (be16_to_cpu(opal_fdm_active->registered_regions) == 0) {
 		opal_fdm_active = NULL;
 		return;
 	}
 
-	ret = opal_mpipl_query_tag(OPAL_MPIPL_TAG_CPU, &addr);
-	if (addr) {
-		addr = be64_to_cpu(addr);
+	ret = opal_mpipl_query_tag(OPAL_MPIPL_TAG_CPU, &be_addr);
+	if (be_addr) {
+		addr = be64_to_cpu(be_addr);
 		pr_debug("CPU metadata addr: %llx\n", addr);
 		opal_cpu_metadata = __va(addr);
 	}
diff --git a/arch/powerpc/platforms/powernv/opal-fadump.h b/arch/powerpc/platforms/powernv/opal-fadump.h
index f1e9ecf548c5..3f715efb0aa6 100644
--- a/arch/powerpc/platforms/powernv/opal-fadump.h
+++ b/arch/powerpc/platforms/powernv/opal-fadump.h
@@ -31,14 +31,14 @@
  * OPAL FADump kernel metadata
  *
  * The address of this structure will be registered with f/w for retrieving
- * and processing during crash dump.
+ * in the capture kernel to process the crash dump.
  */
 struct opal_fadump_mem_struct {
 	u8	version;
 	u8	reserved[3];
-	u16	region_cnt;		/* number of regions */
-	u16	registered_regions;	/* Regions registered for MPIPL */
-	u64	fadumphdr_addr;
+	__be16	region_cnt;		/* number of regions */
+	__be16	registered_regions;	/* Regions registered for MPIPL */
+	__be64	fadumphdr_addr;
 	struct opal_mpipl_region	rgn[FADUMP_MAX_MEM_REGS];
 } __packed;
 
@@ -135,7 +135,7 @@ static inline void opal_fadump_read_regs(char *bufp, unsigned int regs_cnt,
 	for (i = 0; i < regs_cnt; i++, bufp += reg_entry_size) {
 		reg_entry = (struct hdat_fadump_reg_entry *)bufp;
 		val = (cpu_endian ? be64_to_cpu(reg_entry->reg_val) :
-		       reg_entry->reg_val);
+		       (u64)(reg_entry->reg_val));
 		opal_fadump_set_regval_regnum(regs,
 					      be32_to_cpu(reg_entry->reg_type),
 					      be32_to_cpu(reg_entry->reg_num),
-- 
2.35.1



