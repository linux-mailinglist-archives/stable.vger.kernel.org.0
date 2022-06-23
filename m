Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D7A5582AF
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiFWRSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233588AbiFWRRx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:17:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E320B885A3;
        Thu, 23 Jun 2022 09:59:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C454B8248A;
        Thu, 23 Jun 2022 16:59:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E9BC3411B;
        Thu, 23 Jun 2022 16:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003596;
        bh=AsZmhEC9vfB6DX0K6zIPKTKXQnbgvJ5AfNP0h5XiAWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o842dnH/ZNlVr3cHLIbvk7tK4/SLVs5sKtU6xHHp/TVJMQiJrG3TVf1nzbmfrpH8Y
         J+//M9hWu6iffy9iaR8kcTCRt4abrW4qYcjMR2vnGtbb/MayJyBpSWUrYMqmkBwk8q
         OGU30ogpcjoyM6woKUeISz7z3tSsnMaUC4m8yEcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 025/237] crypto: Deduplicate le32_to_cpu_array() and cpu_to_le32_array()
Date:   Thu, 23 Jun 2022 18:40:59 +0200
Message-Id: <20220623164343.879325145@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
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
@@ -32,23 +32,6 @@ const u8 md5_zero_message_hash[MD5_DIGES
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
 #define F1(x, y, z)	(z ^ (x & (y ^ z)))
 #define F2(x, y, z)	F1(z, x, y)
 #define F3(x, y, z)	(x ^ y ^ z)
--- a/include/linux/byteorder/generic.h
+++ b/include/linux/byteorder/generic.h
@@ -156,6 +156,23 @@ static inline void le64_add_cpu(__le64 *
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


