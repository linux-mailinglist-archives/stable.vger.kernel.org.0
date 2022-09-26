Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32C45EA200
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237119AbiIZLAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237392AbiIZK7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:59:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABE75D0D0;
        Mon, 26 Sep 2022 03:31:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00877B8055F;
        Mon, 26 Sep 2022 10:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5DCC4347C;
        Mon, 26 Sep 2022 10:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188272;
        bh=uhqoITq+XhalWrNScsmOeHbns08dlDJAGwZq0nuQlTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KubViqF0DYYjZLx8sx083/FUce547fS1dwLhpkx9wqE5vYnHsrV4Hg42ZpBSoH1UA
         Evcp+GlDDzqvRC9LClFoFlhliuFaqsDF4XFqSKZPMtiA0x9Ml19JPtTjinMVM2Ah/j
         8qEThOCiMd83ff+jcuDvkEHbkFHSRAEvUne3So98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/141] net: ipa: kill IPA_TABLE_ENTRY_SIZE
Date:   Mon, 26 Sep 2022 12:12:03 +0200
Message-Id: <20220926100757.945940387@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 4ea29143ebe6c453f5fddc80ffe4ed046f44aa3a ]

Entries in an IPA route or filter table are 64-bit little-endian
addresses, each of which refers to a routing or filtering rule.

The format of these table slots are fixed, but IPA_TABLE_ENTRY_SIZE
is used to define their size.  This symbol doesn't really add value,
and I think it unnecessarily obscures what a table entry *is*.

So get rid of IPA_TABLE_ENTRY_SIZE, and just use sizeof(__le64) in
its place throughout the code.

Update the comments in "ipa_table.c" to provide a little better
explanation of these table slots.

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: cf412ec33325 ("net: ipa: properly limit modem routing table use")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_cmd.c   |  2 +-
 drivers/net/ipa/ipa_qmi.c   | 10 +++----
 drivers/net/ipa/ipa_table.c | 59 +++++++++++++++++++++----------------
 drivers/net/ipa/ipa_table.h |  3 --
 4 files changed, 39 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index a47378b7d9b2..dc94ce035655 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -154,7 +154,7 @@ static void ipa_cmd_validate_build(void)
 	 * of entries, as and IPv4 and IPv6 route tables have the same number
 	 * of entries.
 	 */
-#define TABLE_SIZE	(TABLE_COUNT_MAX * IPA_TABLE_ENTRY_SIZE)
+#define TABLE_SIZE	(TABLE_COUNT_MAX * sizeof(__le64))
 #define TABLE_COUNT_MAX	max_t(u32, IPA_ROUTE_COUNT_MAX, IPA_FILTER_COUNT_MAX)
 	BUILD_BUG_ON(TABLE_SIZE > field_max(IP_FLTRT_FLAGS_HASH_SIZE_FMASK));
 	BUILD_BUG_ON(TABLE_SIZE > field_max(IP_FLTRT_FLAGS_NHASH_SIZE_FMASK));
diff --git a/drivers/net/ipa/ipa_qmi.c b/drivers/net/ipa/ipa_qmi.c
index 1a87a49538c5..fea61657867e 100644
--- a/drivers/net/ipa/ipa_qmi.c
+++ b/drivers/net/ipa/ipa_qmi.c
@@ -308,12 +308,12 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 	mem = &ipa->mem[IPA_MEM_V4_ROUTE];
 	req.v4_route_tbl_info_valid = 1;
 	req.v4_route_tbl_info.start = ipa->mem_offset + mem->offset;
-	req.v4_route_tbl_info.count = mem->size / IPA_TABLE_ENTRY_SIZE;
+	req.v4_route_tbl_info.count = mem->size / sizeof(__le64);
 
 	mem = &ipa->mem[IPA_MEM_V6_ROUTE];
 	req.v6_route_tbl_info_valid = 1;
 	req.v6_route_tbl_info.start = ipa->mem_offset + mem->offset;
-	req.v6_route_tbl_info.count = mem->size / IPA_TABLE_ENTRY_SIZE;
+	req.v6_route_tbl_info.count = mem->size / sizeof(__le64);
 
 	mem = &ipa->mem[IPA_MEM_V4_FILTER];
 	req.v4_filter_tbl_start_valid = 1;
@@ -352,8 +352,7 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 		req.v4_hash_route_tbl_info_valid = 1;
 		req.v4_hash_route_tbl_info.start =
 				ipa->mem_offset + mem->offset;
-		req.v4_hash_route_tbl_info.count =
-				mem->size / IPA_TABLE_ENTRY_SIZE;
+		req.v4_hash_route_tbl_info.count = mem->size / sizeof(__le64);
 	}
 
 	mem = &ipa->mem[IPA_MEM_V6_ROUTE_HASHED];
@@ -361,8 +360,7 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 		req.v6_hash_route_tbl_info_valid = 1;
 		req.v6_hash_route_tbl_info.start =
 			ipa->mem_offset + mem->offset;
-		req.v6_hash_route_tbl_info.count =
-			mem->size / IPA_TABLE_ENTRY_SIZE;
+		req.v6_hash_route_tbl_info.count = mem->size / sizeof(__le64);
 	}
 
 	mem = &ipa->mem[IPA_MEM_V4_FILTER_HASHED];
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 087bcae29cc7..bada98d7360c 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -27,28 +27,38 @@
 /**
  * DOC: IPA Filter and Route Tables
  *
- * The IPA has tables defined in its local shared memory that define filter
- * and routing rules.  Each entry in these tables contains a 64-bit DMA
- * address that refers to DRAM (system memory) containing a rule definition.
+ * The IPA has tables defined in its local (IPA-resident) memory that define
+ * filter and routing rules.  An entry in either of these tables is a little
+ * endian 64-bit "slot" that holds the address of a rule definition.  (The
+ * size of these slots is 64 bits regardless of the host DMA address size.)
+ *
+ * Separate tables (both filter and route) used for IPv4 and IPv6.  There
+ * are normally another set of "hashed" filter and route tables, which are
+ * used with a hash of message metadata.  Hashed operation is not supported
+ * by all IPA hardware (IPA v4.2 doesn't support hashed tables).
+ *
+ * Rules can be in local memory or in DRAM (system memory).  The offset of
+ * an object (such as a route or filter table) in IPA-resident memory must
+ * 128-byte aligned.  An object in system memory (such as a route or filter
+ * rule) must be at an 8-byte aligned address.  We currently only place
+ * route or filter rules in system memory.
+ *
  * A rule consists of a contiguous block of 32-bit values terminated with
  * 32 zero bits.  A special "zero entry" rule consisting of 64 zero bits
  * represents "no filtering" or "no routing," and is the reset value for
- * filter or route table rules.  Separate tables (both filter and route)
- * used for IPv4 and IPv6.  Additionally, there can be hashed filter or
- * route tables, which are used when a hash of message metadata matches.
- * Hashed operation is not supported by all IPA hardware.
+ * filter or route table rules.
  *
  * Each filter rule is associated with an AP or modem TX endpoint, though
- * not all TX endpoints support filtering.  The first 64-bit entry in a
+ * not all TX endpoints support filtering.  The first 64-bit slot in a
  * filter table is a bitmap indicating which endpoints have entries in
  * the table.  The low-order bit (bit 0) in this bitmap represents a
  * special global filter, which applies to all traffic.  This is not
  * used in the current code.  Bit 1, if set, indicates that there is an
- * entry (i.e. a DMA address referring to a rule) for endpoint 0 in the
- * table.  Bit 2, if set, indicates there is an entry for endpoint 1,
- * and so on.  Space is set aside in IPA local memory to hold as many
- * filter table entries as might be required, but typically they are not
- * all used.
+ * entry (i.e. slot containing a system address referring to a rule) for
+ * endpoint 0 in the table.  Bit 3, if set, indicates there is an entry
+ * for endpoint 2, and so on.  Space is set aside in IPA local memory to
+ * hold as many filter table entries as might be required, but typically
+ * they are not all used.
  *
  * The AP initializes all entries in a filter table to refer to a "zero"
  * entry.  Once initialized the modem and AP update the entries for
@@ -122,8 +132,7 @@ static void ipa_table_validate_build(void)
 	 * code in ipa_table_init() uses a pointer to __le64 to
 	 * initialize tables.
 	 */
-	BUILD_BUG_ON(sizeof(dma_addr_t) > IPA_TABLE_ENTRY_SIZE);
-	BUILD_BUG_ON(sizeof(__le64) != IPA_TABLE_ENTRY_SIZE);
+	BUILD_BUG_ON(sizeof(dma_addr_t) > sizeof(__le64));
 
 	/* A "zero rule" is used to represent no filtering or no routing.
 	 * It is a 64-bit block of zeroed memory.  Code in ipa_table_init()
@@ -154,7 +163,7 @@ ipa_table_valid_one(struct ipa *ipa, bool route, bool ipv6, bool hashed)
 		else
 			mem = hashed ? &ipa->mem[IPA_MEM_V4_ROUTE_HASHED]
 				     : &ipa->mem[IPA_MEM_V4_ROUTE];
-		size = IPA_ROUTE_COUNT_MAX * IPA_TABLE_ENTRY_SIZE;
+		size = IPA_ROUTE_COUNT_MAX * sizeof(__le64);
 	} else {
 		if (ipv6)
 			mem = hashed ? &ipa->mem[IPA_MEM_V6_FILTER_HASHED]
@@ -162,7 +171,7 @@ ipa_table_valid_one(struct ipa *ipa, bool route, bool ipv6, bool hashed)
 		else
 			mem = hashed ? &ipa->mem[IPA_MEM_V4_FILTER_HASHED]
 				     : &ipa->mem[IPA_MEM_V4_FILTER];
-		size = (1 + IPA_FILTER_COUNT_MAX) * IPA_TABLE_ENTRY_SIZE;
+		size = (1 + IPA_FILTER_COUNT_MAX) * sizeof(__le64);
 	}
 
 	if (!ipa_cmd_table_valid(ipa, mem, route, ipv6, hashed))
@@ -261,8 +270,8 @@ static void ipa_table_reset_add(struct gsi_trans *trans, bool filter,
 	if (filter)
 		first++;	/* skip over bitmap */
 
-	offset = mem->offset + first * IPA_TABLE_ENTRY_SIZE;
-	size = count * IPA_TABLE_ENTRY_SIZE;
+	offset = mem->offset + first * sizeof(__le64);
+	size = count * sizeof(__le64);
 	addr = ipa_table_addr(ipa, false, count);
 
 	ipa_cmd_dma_shared_mem_add(trans, offset, size, addr, true);
@@ -446,11 +455,11 @@ static void ipa_table_init_add(struct gsi_trans *trans, bool filter,
 		count = 1 + hweight32(ipa->filter_map);
 		hash_count = hash_mem->size ? count : 0;
 	} else {
-		count = mem->size / IPA_TABLE_ENTRY_SIZE;
-		hash_count = hash_mem->size / IPA_TABLE_ENTRY_SIZE;
+		count = mem->size / sizeof(__le64);
+		hash_count = hash_mem->size / sizeof(__le64);
 	}
-	size = count * IPA_TABLE_ENTRY_SIZE;
-	hash_size = hash_count * IPA_TABLE_ENTRY_SIZE;
+	size = count * sizeof(__le64);
+	hash_size = hash_count * sizeof(__le64);
 
 	addr = ipa_table_addr(ipa, filter, count);
 	hash_addr = ipa_table_addr(ipa, filter, hash_count);
@@ -659,7 +668,7 @@ int ipa_table_init(struct ipa *ipa)
 	 * by dma_alloc_coherent() is guaranteed to be a power-of-2 number
 	 * of pages, which satisfies the rule alignment requirement.
 	 */
-	size = IPA_ZERO_RULE_SIZE + (1 + count) * IPA_TABLE_ENTRY_SIZE;
+	size = IPA_ZERO_RULE_SIZE + (1 + count) * sizeof(__le64);
 	virt = dma_alloc_coherent(dev, size, &addr, GFP_KERNEL);
 	if (!virt)
 		return -ENOMEM;
@@ -691,7 +700,7 @@ void ipa_table_exit(struct ipa *ipa)
 	struct device *dev = &ipa->pdev->dev;
 	size_t size;
 
-	size = IPA_ZERO_RULE_SIZE + (1 + count) * IPA_TABLE_ENTRY_SIZE;
+	size = IPA_ZERO_RULE_SIZE + (1 + count) * sizeof(__le64);
 
 	dma_free_coherent(dev, size, ipa->table_virt, ipa->table_addr);
 	ipa->table_addr = 0;
diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
index 78038d14fcea..dc9ff21dbdfb 100644
--- a/drivers/net/ipa/ipa_table.h
+++ b/drivers/net/ipa/ipa_table.h
@@ -10,9 +10,6 @@
 
 struct ipa;
 
-/* The size of a filter or route table entry */
-#define IPA_TABLE_ENTRY_SIZE	sizeof(__le64)	/* Holds a physical address */
-
 /* The maximum number of filter table entries (IPv4, IPv6; hashed or not) */
 #define IPA_FILTER_COUNT_MAX	14
 
-- 
2.35.1



