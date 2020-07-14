Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D02D21F9CB
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729554AbgGNSqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:46:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729551AbgGNSqi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:46:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7055B222E9;
        Tue, 14 Jul 2020 18:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752398;
        bh=AJh1bWO1xZ9Y0Ic/7ATl41MmP9Qjy8I3qx2CX1KBFxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gim549Fu3Af2vgwHmAIAotjo0ZaswhoDLQ58p33JLkLdM5TT66n9wXRXTY0Od05nb
         56RyiEVzjiXWflNzMaA1Di7qZkA0l9zKaUoNhwMjiyyvYx24wVp9eY7ZS5wUu5ronI
         nAgReVL9HfI7TTAAL7w5jKnU3JG8TrsqX2R4140k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Thoms Toerring <jt@toerring.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/58] regmap: fix alignment issue
Date:   Tue, 14 Jul 2020 20:43:39 +0200
Message-Id: <20200714184056.456365729@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184056.149119318@linuxfoundation.org>
References: <20200714184056.149119318@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b38b2d8c333d5..c7d946b745efe 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -21,6 +21,7 @@
 #include <linux/delay.h>
 #include <linux/log2.h>
 #include <linux/hwspinlock.h>
+#include <asm/unaligned.h>
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
@@ -232,22 +233,20 @@ static void regmap_format_8(void *buf, unsigned int val, unsigned int shift)
 
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
@@ -263,43 +262,39 @@ static void regmap_format_24(void *buf, unsigned int val, unsigned int shift)
 
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
 
@@ -316,35 +311,34 @@ static unsigned int regmap_parse_8(const void *buf)
 
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
@@ -359,69 +353,67 @@ static unsigned int regmap_parse_24(const void *buf)
 
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



