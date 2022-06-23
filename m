Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E2955804F
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbiFWQrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbiFWQrQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:47:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246F449B5E;
        Thu, 23 Jun 2022 09:47:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A82E561F91;
        Thu, 23 Jun 2022 16:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F04C341C4;
        Thu, 23 Jun 2022 16:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002833;
        bh=JGZcpj+IYPHOuDGpesA9sgFvi7K45kzC1jyunNeIqVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xHC/jaPeAdNQFo1WGpmpuokJIu1TTOVTbknwi5W7yxZ+c+gx07/9QcAIaxxtEFJKX
         Kbc8achk0km4/KXpyGbaeo5LHx51F/3l1fdNFGS54HwkCDBTcmtEUEEqFfb6lCeA+K
         1ycJxfMJsPKV/rLhrbOd+lVV2QkgLuKy67uK4e0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.9 006/264] random: convert get_random_int/long into get_random_u32/u64
Date:   Thu, 23 Jun 2022 18:39:59 +0200
Message-Id: <20220623164344.239578504@linuxfoundation.org>
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

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit c440408cf6901eeb2c09563397e24a9097907078 upstream.

Many times, when a user wants a random number, he wants a random number
of a guaranteed size. So, thinking of get_random_int and get_random_long
in terms of get_random_u32 and get_random_u64 makes it much easier to
achieve this. It also makes the code simpler.

On 32-bit platforms, get_random_int and get_random_long are both aliased
to get_random_u32. On 64-bit platforms, int->u32 and long->u64.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c  |   63 ++++++++++++++++++++++++++-----------------------
 include/linux/random.h |   17 +++++++++++--
 2 files changed, 49 insertions(+), 31 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2089,57 +2089,62 @@ struct ctl_table random_table[] = {
 
 struct batched_entropy {
 	union {
-		unsigned long entropy_long[CHACHA20_BLOCK_SIZE / sizeof(unsigned long)];
-		unsigned int entropy_int[CHACHA20_BLOCK_SIZE / sizeof(unsigned int)];
+		u64 entropy_u64[CHACHA20_BLOCK_SIZE / sizeof(u64)];
+		u32 entropy_u32[CHACHA20_BLOCK_SIZE / sizeof(u32)];
 	};
 	unsigned int position;
 };
 
 /*
  * Get a random word for internal kernel use only. The quality of the random
- * number is good as /dev/urandom, but there is no backtrack protection, with
- * the goal of being quite fast and not depleting entropy.
+ * number is either as good as RDRAND or as good as /dev/urandom, with the
+ * goal of being quite fast and not depleting entropy.
  */
-static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_long);
-unsigned long get_random_long(void)
+static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u64);
+u64 get_random_u64(void)
 {
-	unsigned long ret;
+	u64 ret;
 	struct batched_entropy *batch;
 
-	batch = &get_cpu_var(batched_entropy_long);
-	if (batch->position % ARRAY_SIZE(batch->entropy_long) == 0) {
-		extract_crng((u8 *)batch->entropy_long);
+#if BITS_PER_LONG == 64
+	if (arch_get_random_long((unsigned long *)&ret))
+		return ret;
+#else
+	if (arch_get_random_long((unsigned long *)&ret) &&
+	    arch_get_random_long((unsigned long *)&ret + 1))
+	    return ret;
+#endif
+
+	batch = &get_cpu_var(batched_entropy_u64);
+	if (batch->position % ARRAY_SIZE(batch->entropy_u64) == 0) {
+		extract_crng((u8 *)batch->entropy_u64);
 		batch->position = 0;
 	}
-	ret = batch->entropy_long[batch->position++];
-	put_cpu_var(batched_entropy_long);
+	ret = batch->entropy_u64[batch->position++];
+	put_cpu_var(batched_entropy_u64);
 	return ret;
 }
-EXPORT_SYMBOL(get_random_long);
+EXPORT_SYMBOL(get_random_u64);
 
-#if BITS_PER_LONG == 32
-unsigned int get_random_int(void)
-{
-	return get_random_long();
-}
-#else
-static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_int);
-unsigned int get_random_int(void)
+static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u32);
+u32 get_random_u32(void)
 {
-	unsigned int ret;
+	u32 ret;
 	struct batched_entropy *batch;
 
-	batch = &get_cpu_var(batched_entropy_int);
-	if (batch->position % ARRAY_SIZE(batch->entropy_int) == 0) {
-		extract_crng((u8 *)batch->entropy_int);
+	if (arch_get_random_int(&ret))
+		return ret;
+
+	batch = &get_cpu_var(batched_entropy_u32);
+	if (batch->position % ARRAY_SIZE(batch->entropy_u32) == 0) {
+		extract_crng((u8 *)batch->entropy_u32);
 		batch->position = 0;
 	}
-	ret = batch->entropy_int[batch->position++];
-	put_cpu_var(batched_entropy_int);
+	ret = batch->entropy_u32[batch->position++];
+	put_cpu_var(batched_entropy_u32);
 	return ret;
 }
-#endif
-EXPORT_SYMBOL(get_random_int);
+EXPORT_SYMBOL(get_random_u32);
 
 /**
  * randomize_page - Generate a random, page aligned address
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -42,8 +42,21 @@ extern void get_random_bytes_arch(void *
 extern const struct file_operations random_fops, urandom_fops;
 #endif
 
-unsigned int get_random_int(void);
-unsigned long get_random_long(void);
+u32 get_random_u32(void);
+u64 get_random_u64(void);
+static inline unsigned int get_random_int(void)
+{
+	return get_random_u32();
+}
+static inline unsigned long get_random_long(void)
+{
+#if BITS_PER_LONG == 64
+	return get_random_u64();
+#else
+	return get_random_u32();
+#endif
+}
+
 unsigned long randomize_page(unsigned long start, unsigned long range);
 
 /*


