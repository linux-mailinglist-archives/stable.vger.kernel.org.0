Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD699694930
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbjBMO5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:57:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbjBMO4r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:56:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39A91CF60
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:56:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0E2BB8125F
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:56:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF1CC433EF;
        Mon, 13 Feb 2023 14:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300176;
        bh=Uxf6qeGIMm47LXudlsrg9lzLg0OoDgUNwgt72gXcQHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E0y9RMZZTD8xWgywZT8NIkrVME5FFluOARIXrKWsKxjTOFaHk+JVxrKkjV3jkDNci
         ltu6X6n1cH6gp6N9V2ijR5V1ajlgbZJBxQGITgaEGJGx8pZcKKsfMT5hY3+dWEbKld
         JRbAu+348RnK056+qFOxNHRvSKvSRzNlrVsQUXFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>, Jeff Moyer <jmoyer@redhat.com>,
        Yu Zhao <yuzhao@google.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.1 093/114] nvdimm: Support sizeof(struct page) > MAX_STRUCT_PAGE_SIZE
Date:   Mon, 13 Feb 2023 15:48:48 +0100
Message-Id: <20230213144746.968931099@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

commit c91d713630848460de8669e6570307b7e559863b upstream.

Commit 6e9f05dc66f9 ("libnvdimm/pfn_dev: increase MAX_STRUCT_PAGE_SIZE")

...updated MAX_STRUCT_PAGE_SIZE to account for sizeof(struct page)
potentially doubling in the case of CONFIG_KMSAN=y. Unfortunately this
doubles the amount of capacity stolen from user addressable capacity for
everyone, regardless of whether they are using the debug option. Revert
that change, mandate that MAX_STRUCT_PAGE_SIZE never exceed 64, but
allow for debug scenarios to proceed with creating debug sized page maps
with a compile option to support debug scenarios.

Note that this only applies to cases where the page map is permanent,
i.e. stored in a reservation of the pmem itself ("--map=dev" in "ndctl
create-namespace" terms). For the "--map=mem" case, since the allocation
is ephemeral for the lifespan of the namespace, there are no explicit
restriction. However, the implicit restriction, of having enough
available "System RAM" to store the page map for the typically large
pmem, still applies.

Fixes: 6e9f05dc66f9 ("libnvdimm/pfn_dev: increase MAX_STRUCT_PAGE_SIZE")
Cc: <stable@vger.kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Reported-by: Jeff Moyer <jmoyer@redhat.com>
Acked-by: Yu Zhao <yuzhao@google.com>
Link: https://lore.kernel.org/r/167467815773.463042.7022545814443036382.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvdimm/Kconfig    | 19 ++++++++++++++++++
 drivers/nvdimm/nd.h       |  2 +-
 drivers/nvdimm/pfn_devs.c | 42 +++++++++++++++++++++++++--------------
 3 files changed, 47 insertions(+), 16 deletions(-)

diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 79d93126453d..77b06d54cc62 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -102,6 +102,25 @@ config NVDIMM_KEYS
 	depends on ENCRYPTED_KEYS
 	depends on (LIBNVDIMM=ENCRYPTED_KEYS) || LIBNVDIMM=m
 
+config NVDIMM_KMSAN
+	bool
+	depends on KMSAN
+	help
+	  KMSAN, and other memory debug facilities, increase the size of
+	  'struct page' to contain extra metadata. This collides with
+	  the NVDIMM capability to store a potentially
+	  larger-than-"System RAM" size 'struct page' array in a
+	  reservation of persistent memory rather than limited /
+	  precious DRAM. However, that reservation needs to persist for
+	  the life of the given NVDIMM namespace. If you are using KMSAN
+	  to debug an issue unrelated to NVDIMMs or DAX then say N to this
+	  option. Otherwise, say Y but understand that any namespaces
+	  (with the page array stored pmem) created with this build of
+	  the kernel will permanently reserve and strand excess
+	  capacity compared to the CONFIG_KMSAN=n case.
+
+	  Select N if unsure.
+
 config NVDIMM_TEST_BUILD
 	tristate "Build the unit test core"
 	depends on m
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 85ca5b4da3cf..ec5219680092 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -652,7 +652,7 @@ void devm_namespace_disable(struct device *dev,
 		struct nd_namespace_common *ndns);
 #if IS_ENABLED(CONFIG_ND_CLAIM)
 /* max struct page size independent of kernel config */
-#define MAX_STRUCT_PAGE_SIZE 128
+#define MAX_STRUCT_PAGE_SIZE 64
 int nvdimm_setup_pfn(struct nd_pfn *nd_pfn, struct dev_pagemap *pgmap);
 #else
 static inline int nvdimm_setup_pfn(struct nd_pfn *nd_pfn,
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 61af072ac98f..af7d9301520c 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -13,6 +13,8 @@
 #include "pfn.h"
 #include "nd.h"
 
+static const bool page_struct_override = IS_ENABLED(CONFIG_NVDIMM_KMSAN);
+
 static void nd_pfn_release(struct device *dev)
 {
 	struct nd_region *nd_region = to_nd_region(dev->parent);
@@ -758,12 +760,6 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 		return -ENXIO;
 	}
 
-	/*
-	 * Note, we use 64 here for the standard size of struct page,
-	 * debugging options may cause it to be larger in which case the
-	 * implementation will limit the pfns advertised through
-	 * ->direct_access() to those that are included in the memmap.
-	 */
 	start = nsio->res.start;
 	size = resource_size(&nsio->res);
 	npfns = PHYS_PFN(size - SZ_8K);
@@ -782,20 +778,33 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	}
 	end_trunc = start + size - ALIGN_DOWN(start + size, align);
 	if (nd_pfn->mode == PFN_MODE_PMEM) {
+		unsigned long page_map_size = MAX_STRUCT_PAGE_SIZE * npfns;
+
 		/*
 		 * The altmap should be padded out to the block size used
 		 * when populating the vmemmap. This *should* be equal to
 		 * PMD_SIZE for most architectures.
 		 *
-		 * Also make sure size of struct page is less than 128. We
-		 * want to make sure we use large enough size here so that
-		 * we don't have a dynamic reserve space depending on
-		 * struct page size. But we also want to make sure we notice
-		 * when we end up adding new elements to struct page.
+		 * Also make sure size of struct page is less than
+		 * MAX_STRUCT_PAGE_SIZE. The goal here is compatibility in the
+		 * face of production kernel configurations that reduce the
+		 * 'struct page' size below MAX_STRUCT_PAGE_SIZE. For debug
+		 * kernel configurations that increase the 'struct page' size
+		 * above MAX_STRUCT_PAGE_SIZE, the page_struct_override allows
+		 * for continuing with the capacity that will be wasted when
+		 * reverting to a production kernel configuration. Otherwise,
+		 * those configurations are blocked by default.
 		 */
-		BUILD_BUG_ON(sizeof(struct page) > MAX_STRUCT_PAGE_SIZE);
-		offset = ALIGN(start + SZ_8K + MAX_STRUCT_PAGE_SIZE * npfns, align)
-			- start;
+		if (sizeof(struct page) > MAX_STRUCT_PAGE_SIZE) {
+			if (page_struct_override)
+				page_map_size = sizeof(struct page) * npfns;
+			else {
+				dev_err(&nd_pfn->dev,
+					"Memory debug options prevent using pmem for the page map\n");
+				return -EINVAL;
+			}
+		}
+		offset = ALIGN(start + SZ_8K + page_map_size, align) - start;
 	} else if (nd_pfn->mode == PFN_MODE_RAM)
 		offset = ALIGN(start + SZ_8K, align) - start;
 	else
@@ -818,7 +827,10 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	pfn_sb->version_minor = cpu_to_le16(4);
 	pfn_sb->end_trunc = cpu_to_le32(end_trunc);
 	pfn_sb->align = cpu_to_le32(nd_pfn->align);
-	pfn_sb->page_struct_size = cpu_to_le16(MAX_STRUCT_PAGE_SIZE);
+	if (sizeof(struct page) > MAX_STRUCT_PAGE_SIZE && page_struct_override)
+		pfn_sb->page_struct_size = cpu_to_le16(sizeof(struct page));
+	else
+		pfn_sb->page_struct_size = cpu_to_le16(MAX_STRUCT_PAGE_SIZE);
 	pfn_sb->page_size = cpu_to_le32(PAGE_SIZE);
 	checksum = nd_sb_checksum((struct nd_gen_sb *) pfn_sb);
 	pfn_sb->checksum = cpu_to_le64(checksum);
-- 
2.39.1



