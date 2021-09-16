Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2086340E70F
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243154AbhIPR2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:28:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348334AbhIPRZz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:25:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF48661BF3;
        Thu, 16 Sep 2021 16:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810666;
        bh=2JntmivuHJPxvvoKc91C/1ZAcnZue6O8y+RHCQyB10Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W/4i8MWrEtLt40C04DsyssclXyaYPcZ2bn1fF5uL3YXEmMxfZkmL37Ezsu/VWEghd
         4nR/1h3d1tjN9mqZRRzPRkYm4w+gJ8S8APsftc0ehbqYDqqRMlNY0CKfM2wazG6qOs
         PgGz1IWoyYoso9Jpsc0zy6c9MA9/mPFERULCzkHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 224/432] net: ipa: always validate filter and route tables
Date:   Thu, 16 Sep 2021 17:59:33 +0200
Message-Id: <20210916155818.439019907@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 546948bf362541857d4f500705efe08a2fe0bb95 ]

All checks in ipa_table_validate_build() are computed at build time,
so build that unconditionally.

In ipa_table_valid() calls to ipa_table_valid_one() are missing the
IPA pointer parameter is missing in (a bug that shows up only when
IPA_VALIDATE is defined).  Don't bother checking whether hashed
table memory regions are valid if hashed tables are not supported.

With those things fixed, have these table validation functions built
unconditionally (not dependent on IPA_VALIDATE).

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_table.c | 36 +++++++++++++++++-------------------
 drivers/net/ipa/ipa_table.h | 16 ----------------
 2 files changed, 17 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 4f5b6749f6aa..c607ebec7456 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -120,8 +120,6 @@
  */
 #define IPA_ZERO_RULE_SIZE		(2 * sizeof(__le32))
 
-#ifdef IPA_VALIDATE
-
 /* Check things that can be validated at build time. */
 static void ipa_table_validate_build(void)
 {
@@ -169,7 +167,7 @@ ipa_table_valid_one(struct ipa *ipa, enum ipa_mem_id mem_id, bool route)
 		return true;
 
 	/* Hashed table regions can be zero size if hashing is not supported */
-	if (hashed && !mem->size)
+	if (ipa_table_hash_support(ipa) && !mem->size)
 		return true;
 
 	dev_err(dev, "%s table region %u size 0x%02x, expected 0x%02x\n",
@@ -183,14 +181,22 @@ bool ipa_table_valid(struct ipa *ipa)
 {
 	bool valid;
 
-	valid = ipa_table_valid_one(IPA_MEM_V4_FILTER, false);
-	valid = valid && ipa_table_valid_one(IPA_MEM_V4_FILTER_HASHED, false);
-	valid = valid && ipa_table_valid_one(IPA_MEM_V6_FILTER, false);
-	valid = valid && ipa_table_valid_one(IPA_MEM_V6_FILTER_HASHED, false);
-	valid = valid && ipa_table_valid_one(IPA_MEM_V4_ROUTE, true);
-	valid = valid && ipa_table_valid_one(IPA_MEM_V4_ROUTE_HASHED, true);
-	valid = valid && ipa_table_valid_one(IPA_MEM_V6_ROUTE, true);
-	valid = valid && ipa_table_valid_one(IPA_MEM_V6_ROUTE_HASHED, true);
+	valid = ipa_table_valid_one(ipa, IPA_MEM_V4_FILTER, false);
+	valid = valid && ipa_table_valid_one(ipa, IPA_MEM_V6_FILTER, false);
+	valid = valid && ipa_table_valid_one(ipa, IPA_MEM_V4_ROUTE, true);
+	valid = valid && ipa_table_valid_one(ipa, IPA_MEM_V6_ROUTE, true);
+
+	if (!ipa_table_hash_support(ipa))
+		return valid;
+
+	valid = valid && ipa_table_valid_one(ipa, IPA_MEM_V4_FILTER_HASHED,
+					     false);
+	valid = valid && ipa_table_valid_one(ipa, IPA_MEM_V6_FILTER_HASHED,
+					     false);
+	valid = valid && ipa_table_valid_one(ipa, IPA_MEM_V4_ROUTE_HASHED,
+					     true);
+	valid = valid && ipa_table_valid_one(ipa, IPA_MEM_V6_ROUTE_HASHED,
+					     true);
 
 	return valid;
 }
@@ -217,14 +223,6 @@ bool ipa_filter_map_valid(struct ipa *ipa, u32 filter_map)
 	return true;
 }
 
-#else /* !IPA_VALIDATE */
-static void ipa_table_validate_build(void)
-
-{
-}
-
-#endif /* !IPA_VALIDATE */
-
 /* Zero entry count means no table, so just return a 0 address */
 static dma_addr_t ipa_table_addr(struct ipa *ipa, bool filter_mask, u16 count)
 {
diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
index 1e2be9fce2f8..b6a9a0d79d68 100644
--- a/drivers/net/ipa/ipa_table.h
+++ b/drivers/net/ipa/ipa_table.h
@@ -16,8 +16,6 @@ struct ipa;
 /* The maximum number of route table entries (IPv4, IPv6; hashed or not) */
 #define IPA_ROUTE_COUNT_MAX	15
 
-#ifdef IPA_VALIDATE
-
 /**
  * ipa_table_valid() - Validate route and filter table memory regions
  * @ipa:	IPA pointer
@@ -35,20 +33,6 @@ bool ipa_table_valid(struct ipa *ipa);
  */
 bool ipa_filter_map_valid(struct ipa *ipa, u32 filter_mask);
 
-#else /* !IPA_VALIDATE */
-
-static inline bool ipa_table_valid(struct ipa *ipa)
-{
-	return true;
-}
-
-static inline bool ipa_filter_map_valid(struct ipa *ipa, u32 filter_mask)
-{
-	return true;
-}
-
-#endif /* !IPA_VALIDATE */
-
 /**
  * ipa_table_hash_support() - Return true if hashed tables are supported
  * @ipa:	IPA pointer
-- 
2.30.2



