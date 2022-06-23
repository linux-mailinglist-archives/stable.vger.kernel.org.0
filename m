Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED7C55802C
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbiFWQpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbiFWQpt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:45:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF6D48899;
        Thu, 23 Jun 2022 09:45:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA1CDB82490;
        Thu, 23 Jun 2022 16:45:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4846CC3411B;
        Thu, 23 Jun 2022 16:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002745;
        bh=Sy6BBcIa5Pm2fc1tJBXYB8BDdCKNVJs0Kx10kTypQ/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xI7vijETeO0PixvpNBLlceLUWJD+iria+/ovLyWLNEwzhng6HseglObj9xt89Jcdd
         K7Lj92uUjF8hw0QXnEhiDDMJkZp3+KYsa1agaczpRdQDHg7EPSJcEEOmgvhMwakpfb
         hXqdic2kfkBLPLeqsp/1u6ca/h1cEOk/b8yqmvlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.9 012/264] random: warn when kernel uses unseeded randomness
Date:   Thu, 23 Jun 2022 18:40:05 +0200
Message-Id: <20220623164344.410859627@linuxfoundation.org>
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

commit d06bfd1989fe97623b32d6df4ffa6e4338c99dc8 upstream.

This enables an important dmesg notification about when drivers have
used the crng without it being seeded first. Prior, these errors would
occur silently, and so there hasn't been a great way of diagnosing these
types of bugs for obscure setups. By adding this as a config option, we
can leave it on by default, so that we learn where these issues happen,
in the field, will still allowing some people to turn it off, if they
really know what they're doing and do not want the log entries.

However, we don't leave it _completely_ by default. An earlier version
of this patch simply had `default y`. I'd really love that, but it turns
out, this problem with unseeded randomness being used is really quite
present and is going to take a long time to fix. Thus, as a compromise
between log-messages-for-all and nobody-knows, this is `default y`,
except it is also `depends on DEBUG_KERNEL`. This will ensure that the
curious see the messages while others don't have to.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   15 +++++++++++++--
 lib/Kconfig.debug     |   16 ++++++++++++++++
 2 files changed, 29 insertions(+), 2 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -289,7 +289,6 @@
 #define SEC_XFER_SIZE		512
 #define EXTRACT_SIZE		10
 
-#define DEBUG_RANDOM_BOOT 0
 
 #define LONGS(x) (((x) + sizeof(unsigned long) - 1)/sizeof(unsigned long))
 
@@ -1545,7 +1544,7 @@ void get_random_bytes(void *buf, int nby
 {
 	__u8 tmp[CHACHA20_BLOCK_SIZE];
 
-#if DEBUG_RANDOM_BOOT > 0
+#ifdef CONFIG_WARN_UNSEEDED_RANDOM
 	if (!crng_ready())
 		printk(KERN_NOTICE "random: %pF get_random_bytes called "
 		       "with crng_init = %d\n", (void *) _RET_IP_, crng_init);
@@ -2142,6 +2141,12 @@ u64 get_random_u64(void)
 	    return ret;
 #endif
 
+#ifdef CONFIG_WARN_UNSEEDED_RANDOM
+	if (!crng_ready())
+		printk(KERN_NOTICE "random: %pF get_random_u64 called "
+		       "with crng_init = %d\n", (void *) _RET_IP_, crng_init);
+#endif
+
 	batch = &get_cpu_var(batched_entropy_u64);
 	if (use_lock)
 		read_lock_irqsave(&batched_entropy_reset_lock, flags);
@@ -2168,6 +2173,12 @@ u32 get_random_u32(void)
 	if (arch_get_random_int(&ret))
 		return ret;
 
+#ifdef CONFIG_WARN_UNSEEDED_RANDOM
+	if (!crng_ready())
+		printk(KERN_NOTICE "random: %pF get_random_u32 called "
+		       "with crng_init = %d\n", (void *) _RET_IP_, crng_init);
+#endif
+
 	batch = &get_cpu_var(batched_entropy_u32);
 	if (use_lock)
 		read_lock_irqsave(&batched_entropy_reset_lock, flags);
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1177,6 +1177,22 @@ config STACKTRACE
 	  It is also used by various kernel debugging features that require
 	  stack trace generation.
 
+config WARN_UNSEEDED_RANDOM
+	bool "Warn when kernel uses unseeded randomness"
+	default y
+	depends on DEBUG_KERNEL
+	help
+	  Some parts of the kernel contain bugs relating to their use of
+	  cryptographically secure random numbers before it's actually possible
+	  to generate those numbers securely. This setting ensures that these
+	  flaws don't go unnoticed, by enabling a message, should this ever
+	  occur. This will allow people with obscure setups to know when things
+	  are going wrong, so that they might contact developers about fixing
+	  it.
+
+	  Say Y here, unless you simply do not care about using unseeded
+	  randomness and do not want a potential warning message in your logs.
+
 config DEBUG_KOBJECT
 	bool "kobject debugging"
 	depends on DEBUG_KERNEL


