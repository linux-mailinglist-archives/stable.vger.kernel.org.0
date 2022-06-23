Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD5D558675
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236151AbiFWSNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236530AbiFWSMT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:12:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A759B575;
        Thu, 23 Jun 2022 10:20:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D888761E50;
        Thu, 23 Jun 2022 17:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6146C3411B;
        Thu, 23 Jun 2022 17:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004834;
        bh=FHmPyj2D2tGbC8s1f5us7ysnhTDu4Fn5V+6b2VESaaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iNmhleT2KUhfwmZsuqJSGyr3zOXxgmMuXk5wzqWpoXXvMl0KtgGzrAn6dxmaB4AAb
         X9XjKq6DVoyglrp+BW9vnq/YIbxVGPwGfS5tREoD4xAwd/LoDDTzitqUwKUlW9GBpl
         A1lOdWUMBAv8FudCApzJefQOM1nxqeW8aUM+Jfd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 163/234] random: remove extern from functions in header
Date:   Thu, 23 Jun 2022 18:43:50 +0200
Message-Id: <20220623164347.667353654@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
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

commit 7782cfeca7d420e8bb707613d4cfb0f7ff29bb3a upstream.

Accoriding to the kernel style guide, having `extern` on functions in
headers is old school and deprecated, and doesn't add anything. So remove
them from random.h, and tidy up the file a little bit too.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/random.h |   71 +++++++++++++++++++------------------------------
 1 file changed, 28 insertions(+), 43 deletions(-)

--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -12,13 +12,12 @@
 
 struct notifier_block;
 
-extern void add_device_randomness(const void *, size_t);
-extern void add_bootloader_randomness(const void *, size_t);
-extern void add_input_randomness(unsigned int type, unsigned int code,
-				 unsigned int value) __latent_entropy;
-extern void add_interrupt_randomness(int irq) __latent_entropy;
-extern void add_hwgenerator_randomness(const void *buffer, size_t count,
-				       size_t entropy);
+void add_device_randomness(const void *, size_t);
+void add_bootloader_randomness(const void *, size_t);
+void add_input_randomness(unsigned int type, unsigned int code,
+			  unsigned int value) __latent_entropy;
+void add_interrupt_randomness(int irq) __latent_entropy;
+void add_hwgenerator_randomness(const void *buffer, size_t count, size_t entropy);
 
 #if defined(LATENT_ENTROPY_PLUGIN) && !defined(__CHECKER__)
 static inline void add_latent_entropy(void)
@@ -26,21 +25,11 @@ static inline void add_latent_entropy(vo
 	add_device_randomness((const void *)&latent_entropy, sizeof(latent_entropy));
 }
 #else
-static inline void add_latent_entropy(void) {}
-#endif
-
-extern void get_random_bytes(void *buf, size_t nbytes);
-extern int wait_for_random_bytes(void);
-extern int __init random_init(const char *command_line);
-extern bool rng_is_initialized(void);
-extern int register_random_ready_notifier(struct notifier_block *nb);
-extern int unregister_random_ready_notifier(struct notifier_block *nb);
-extern size_t __must_check get_random_bytes_arch(void *buf, size_t nbytes);
-
-#ifndef MODULE
-extern const struct file_operations random_fops, urandom_fops;
+static inline void add_latent_entropy(void) { }
 #endif
 
+void get_random_bytes(void *buf, size_t nbytes);
+size_t __must_check get_random_bytes_arch(void *buf, size_t nbytes);
 u32 get_random_u32(void);
 u64 get_random_u64(void);
 static inline unsigned int get_random_int(void)
@@ -72,11 +61,17 @@ static inline unsigned long get_random_l
 
 static inline unsigned long get_random_canary(void)
 {
-	unsigned long val = get_random_long();
-
-	return val & CANARY_MASK;
+	return get_random_long() & CANARY_MASK;
 }
 
+unsigned long randomize_page(unsigned long start, unsigned long range);
+
+int __init random_init(const char *command_line);
+bool rng_is_initialized(void);
+int wait_for_random_bytes(void);
+int register_random_ready_notifier(struct notifier_block *nb);
+int unregister_random_ready_notifier(struct notifier_block *nb);
+
 /* Calls wait_for_random_bytes() and then calls get_random_bytes(buf, nbytes).
  * Returns the result of the call to wait_for_random_bytes. */
 static inline int get_random_bytes_wait(void *buf, size_t nbytes)
@@ -100,8 +95,6 @@ declare_get_random_var_wait(int)
 declare_get_random_var_wait(long)
 #undef declare_get_random_var
 
-unsigned long randomize_page(unsigned long start, unsigned long range);
-
 /*
  * This is designed to be standalone for just prandom
  * users, but for now we include it from <linux/random.h>
@@ -112,22 +105,10 @@ unsigned long randomize_page(unsigned lo
 #ifdef CONFIG_ARCH_RANDOM
 # include <asm/archrandom.h>
 #else
-static inline bool __must_check arch_get_random_long(unsigned long *v)
-{
-	return false;
-}
-static inline bool __must_check arch_get_random_int(unsigned int *v)
-{
-	return false;
-}
-static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
-{
-	return false;
-}
-static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
-{
-	return false;
-}
+static inline bool __must_check arch_get_random_long(unsigned long *v) { return false; }
+static inline bool __must_check arch_get_random_int(unsigned int *v) { return false; }
+static inline bool __must_check arch_get_random_seed_long(unsigned long *v) { return false; }
+static inline bool __must_check arch_get_random_seed_int(unsigned int *v) { return false; }
 #endif
 
 /*
@@ -151,8 +132,12 @@ static inline bool __init arch_get_rando
 #endif
 
 #ifdef CONFIG_SMP
-extern int random_prepare_cpu(unsigned int cpu);
-extern int random_online_cpu(unsigned int cpu);
+int random_prepare_cpu(unsigned int cpu);
+int random_online_cpu(unsigned int cpu);
+#endif
+
+#ifndef MODULE
+extern const struct file_operations random_fops, urandom_fops;
 #endif
 
 #endif /* _LINUX_RANDOM_H */


