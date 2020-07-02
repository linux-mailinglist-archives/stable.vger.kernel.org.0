Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7A72117A5
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgGBBWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:22:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbgGBBWG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:22:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1C8B2083E;
        Thu,  2 Jul 2020 01:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593652925;
        bh=eEmDcz5D+lQVVqHTUN/23pAD+joc3MzUTOTrSXN4g1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gMwCgoLEWIWyF+1+TyEfspnnmEWgazQ/Fyd3JHhiiRv6opB8FEKKYT1QS1h1cOWiW
         MwUH482fMsQx6JZ+JdZrWic6fj0PkkUgW1+P2e09HEHbcK69386MzI1twm4yBBM/UB
         cDnp/QH4ZbWURYi4bp+uVCt4+PXfruYPn67bjdyg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Thoms Toerring <jt@toerring.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.7 02/53] regmap: fix alignment issue
Date:   Wed,  1 Jul 2020 21:21:11 -0400
Message-Id: <20200702012202.2700645-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012202.2700645-1-sashal@kernel.org>
References: <20200702012202.2700645-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Thoms Toerring <jt@toerring.de>

[ Upstream commit 53d860952c8215cf9ae1ea33409c8cb71ad6ad3d ]

The assembly and disassembly of data to be sent to or received from
a device invoke functions regmap_format_XX() and regmap_parse_XX()
that extract or insert data items from or into a buffer, using
assignments. In some cases the functions are called with a buffer
pointer with an odd address. On architectures with strict alignment
requirements this can result in a kernel crash. The assignments
have been replaced by functions that take alignment into account.

Signed-off-by: Jens Thoms Toerring <jt@toerring.de>
Link: https://lore.kernel.org/r/20200531095300.GA27570@toerring.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap.c | 100 ++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 54 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 59f911e577192..d3112665c7d08 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -17,6 +17,7 @@
 #include <linux/delay.h>
 #include <linux/log2.h>
 #include <linux/hwspinlock.h>
+#include <asm/unaligned.h>
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
@@ -249,22 +250,20 @@ static void regmap_format_8(void *buf, unsigned int val, unsigned int shift)
 
 static void regmap_format_16_be(void *buf, unsigned int val, unsigned int shift)
 {
-	__be16 *b = buf;
-
-	b[0] = cpu_to_be16(val << shift);
+	put_unaligned_be16(val << shift, buf);
 }
 
 static void regmap_format_16_le(void *buf, unsigned int val, unsigned int shift)
 {
-	__le16 *b = buf;
-
-	b[0] = cpu_to_le16(val << shift);
+	put_unaligned_le16(val << shift, buf);
 }
 
 static void regmap_format_16_native(void *buf, unsigned int val,
 				    unsigned int shift)
 {
-	*(u16 *)buf = val << shift;
+	u16 v = val << shift;
+
+	memcpy(buf, &v, sizeof(v));
 }
 
 static void regmap_format_24(void *buf, unsigned int val, unsigned int shift)
@@ -280,43 +279,39 @@ static void regmap_format_24(void *buf, unsigned int val, unsigned int shift)
 
 static void regmap_format_32_be(void *buf, unsigned int val, unsigned int shift)
 {
-	__be32 *b = buf;
-
-	b[0] = cpu_to_be32(val << shift);
+	put_unaligned_be32(val << shift, buf);
 }
 
 static void regmap_format_32_le(void *buf, unsigned int val, unsigned int shift)
 {
-	__le32 *b = buf;
-
-	b[0] = cpu_to_le32(val << shift);
+	put_unaligned_le32(val << shift, buf);
 }
 
 static void regmap_format_32_native(void *buf, unsigned int val,
 				    unsigned int shift)
 {
-	*(u32 *)buf = val << shift;
+	u32 v = val << shift;
+
+	memcpy(buf, &v, sizeof(v));
 }
 
 #ifdef CONFIG_64BIT
 static void regmap_format_64_be(void *buf, unsigned int val, unsigned int shift)
 {
-	__be64 *b = buf;
-
-	b[0] = cpu_to_be64((u64)val << shift);
+	put_unaligned_be64((u64) val << shift, buf);
 }
 
 static void regmap_format_64_le(void *buf, unsigned int val, unsigned int shift)
 {
-	__le64 *b = buf;
-
-	b[0] = cpu_to_le64((u64)val << shift);
+	put_unaligned_le64((u64) val << shift, buf);
 }
 
 static void regmap_format_64_native(void *buf, unsigned int val,
 				    unsigned int shift)
 {
-	*(u64 *)buf = (u64)val << shift;
+	u64 v = (u64) val << shift;
+
+	memcpy(buf, &v, sizeof(v));
 }
 #endif
 
@@ -333,35 +328,34 @@ static unsigned int regmap_parse_8(const void *buf)
 
 static unsigned int regmap_parse_16_be(const void *buf)
 {
-	const __be16 *b = buf;
-
-	return be16_to_cpu(b[0]);
+	return get_unaligned_be16(buf);
 }
 
 static unsigned int regmap_parse_16_le(const void *buf)
 {
-	const __le16 *b = buf;
-
-	return le16_to_cpu(b[0]);
+	return get_unaligned_le16(buf);
 }
 
 static void regmap_parse_16_be_inplace(void *buf)
 {
-	__be16 *b = buf;
+	u16 v = get_unaligned_be16(buf);
 
-	b[0] = be16_to_cpu(b[0]);
+	memcpy(buf, &v, sizeof(v));
 }
 
 static void regmap_parse_16_le_inplace(void *buf)
 {
-	__le16 *b = buf;
+	u16 v = get_unaligned_le16(buf);
 
-	b[0] = le16_to_cpu(b[0]);
+	memcpy(buf, &v, sizeof(v));
 }
 
 static unsigned int regmap_parse_16_native(const void *buf)
 {
-	return *(u16 *)buf;
+	u16 v;
+
+	memcpy(&v, buf, sizeof(v));
+	return v;
 }
 
 static unsigned int regmap_parse_24(const void *buf)
@@ -376,69 +370,67 @@ static unsigned int regmap_parse_24(const void *buf)
 
 static unsigned int regmap_parse_32_be(const void *buf)
 {
-	const __be32 *b = buf;
-
-	return be32_to_cpu(b[0]);
+	return get_unaligned_be32(buf);
 }
 
 static unsigned int regmap_parse_32_le(const void *buf)
 {
-	const __le32 *b = buf;
-
-	return le32_to_cpu(b[0]);
+	return get_unaligned_le32(buf);
 }
 
 static void regmap_parse_32_be_inplace(void *buf)
 {
-	__be32 *b = buf;
+	u32 v = get_unaligned_be32(buf);
 
-	b[0] = be32_to_cpu(b[0]);
+	memcpy(buf, &v, sizeof(v));
 }
 
 static void regmap_parse_32_le_inplace(void *buf)
 {
-	__le32 *b = buf;
+	u32 v = get_unaligned_le32(buf);
 
-	b[0] = le32_to_cpu(b[0]);
+	memcpy(buf, &v, sizeof(v));
 }
 
 static unsigned int regmap_parse_32_native(const void *buf)
 {
-	return *(u32 *)buf;
+	u32 v;
+
+	memcpy(&v, buf, sizeof(v));
+	return v;
 }
 
 #ifdef CONFIG_64BIT
 static unsigned int regmap_parse_64_be(const void *buf)
 {
-	const __be64 *b = buf;
-
-	return be64_to_cpu(b[0]);
+	return get_unaligned_be64(buf);
 }
 
 static unsigned int regmap_parse_64_le(const void *buf)
 {
-	const __le64 *b = buf;
-
-	return le64_to_cpu(b[0]);
+	return get_unaligned_le64(buf);
 }
 
 static void regmap_parse_64_be_inplace(void *buf)
 {
-	__be64 *b = buf;
+	u64 v =  get_unaligned_be64(buf);
 
-	b[0] = be64_to_cpu(b[0]);
+	memcpy(buf, &v, sizeof(v));
 }
 
 static void regmap_parse_64_le_inplace(void *buf)
 {
-	__le64 *b = buf;
+	u64 v = get_unaligned_le64(buf);
 
-	b[0] = le64_to_cpu(b[0]);
+	memcpy(buf, &v, sizeof(v));
 }
 
 static unsigned int regmap_parse_64_native(const void *buf)
 {
-	return *(u64 *)buf;
+	u64 v;
+
+	memcpy(&v, buf, sizeof(v));
+	return v;
 }
 #endif
 
-- 
2.25.1

