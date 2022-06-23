Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F624558120
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbiFWQ4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbiFWQsm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:48:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D7A4D272;
        Thu, 23 Jun 2022 09:47:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF251B82491;
        Thu, 23 Jun 2022 16:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5042C3411B;
        Thu, 23 Jun 2022 16:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002855;
        bh=RvGAECfP5DT1J9G6PSsXIzvjAMCpYFRXMuHG4Pz6wWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dXwkhAkKaRgY5nT4f7tA1L151qk1iUzrW6+Z4MZlbskcMx+B42Zf3C/ouXwAZ/fNq
         7HF+qswPWA2WnDrmWcwmrwpl97QvjSZe0niRDEiRv9NEbSu0FH6iM+dw1KsE7Q45On
         DZ+Tld72VeDCKicC9vP3iyY55HQWNCuzOZdzLgLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 049/264] crypto: Deduplicate le32_to_cpu_array() and cpu_to_le32_array()
Date:   Thu, 23 Jun 2022 18:40:42 +0200
Message-Id: <20220623164345.458429843@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 9def051018c08e65c532822749e857eb4b2e12e7 upstream.

Deduplicate le32_to_cpu_array() and cpu_to_le32_array() by moving them
to the generic header.

No functional change implied.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/md4.c                      |   17 -----------------
 crypto/md5.c                      |   17 -----------------
 include/linux/byteorder/generic.h |   17 +++++++++++++++++
 3 files changed, 17 insertions(+), 34 deletions(-)

--- a/crypto/md4.c
+++ b/crypto/md4.c
@@ -64,23 +64,6 @@ static inline u32 H(u32 x, u32 y, u32 z)
 #define ROUND2(a,b,c,d,k,s) (a = lshift(a + G(b,c,d) + k + (u32)0x5A827999,s))
 #define ROUND3(a,b,c,d,k,s) (a = lshift(a + H(b,c,d) + k + (u32)0x6ED9EBA1,s))
 
-/* XXX: this stuff can be optimized */
-static inline void le32_to_cpu_array(u32 *buf, unsigned int words)
-{
-	while (words--) {
-		__le32_to_cpus(buf);
-		buf++;
-	}
-}
-
-static inline void cpu_to_le32_array(u32 *buf, unsigned int words)
-{
-	while (words--) {
-		__cpu_to_le32s(buf);
-		buf++;
-	}
-}
-
 static void md4_transform(u32 *hash, u32 const *in)
 {
 	u32 a, b, c, d;
--- a/crypto/md5.c
+++ b/crypto/md5.c
@@ -30,23 +30,6 @@ const u8 md5_zero_message_hash[MD5_DIGES
 };
 EXPORT_SYMBOL_GPL(md5_zero_message_hash);
 
-/* XXX: this stuff can be optimized */
-static inline void le32_to_cpu_array(u32 *buf, unsigned int words)
-{
-	while (words--) {
-		__le32_to_cpus(buf);
-		buf++;
-	}
-}
-
-static inline void cpu_to_le32_array(u32 *buf, unsigned int words)
-{
-	while (words--) {
-		__cpu_to_le32s(buf);
-		buf++;
-	}
-}
-
 static inline void md5_transform_helper(struct md5_state *ctx)
 {
 	le32_to_cpu_array(ctx->block, sizeof(ctx->block) / sizeof(u32));
--- a/include/linux/byteorder/generic.h
+++ b/include/linux/byteorder/generic.h
@@ -155,6 +155,23 @@ static inline void le64_add_cpu(__le64 *
 	*var = cpu_to_le64(le64_to_cpu(*var) + val);
 }
 
+/* XXX: this stuff can be optimized */
+static inline void le32_to_cpu_array(u32 *buf, unsigned int words)
+{
+	while (words--) {
+		__le32_to_cpus(buf);
+		buf++;
+	}
+}
+
+static inline void cpu_to_le32_array(u32 *buf, unsigned int words)
+{
+	while (words--) {
+		__cpu_to_le32s(buf);
+		buf++;
+	}
+}
+
 static inline void be16_add_cpu(__be16 *var, u16 val)
 {
 	*var = cpu_to_be16(be16_to_cpu(*var) + val);


