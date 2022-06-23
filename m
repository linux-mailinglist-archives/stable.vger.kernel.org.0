Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3215582EC
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbiFWRWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiFWRVj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:21:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2405DF0A;
        Thu, 23 Jun 2022 10:00:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 664B0B82493;
        Thu, 23 Jun 2022 17:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27EFC3411B;
        Thu, 23 Jun 2022 17:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003648;
        bh=h3VOGpWZPHzxekHerozc5L9whJEX8OLuqVwoF2QeCC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tt3yfuS14TqWtkUCN2VzvpbR5aKw8Sthv89a1p2T/3/sRetioBGcv6AzXLDHZGT6Y
         fqM/sU0Ww3euA6En6jPRqzg9ovoURQZ3a/dGrbkMnx0OAN7LVi6IAhOlHwxj936PSi
         pVt1VKDMIpZRL58Vmn4q0y/rSzbd7s7LlNv1dn/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 041/237] random: Add and use pr_fmt()
Date:   Thu, 23 Jun 2022 18:41:15 +0200
Message-Id: <20220623164344.336977670@linuxfoundation.org>
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

From: Yangtao Li <tiny.windzz@gmail.com>

commit 12cd53aff5ea0359b1dac91fcd9ddc7b9e646588 upstream.

Prefix all printk/pr_<level> messages with "random: " to make the
logging a bit more consistent.

Miscellanea:

o Convert a printks to pr_notice
o Whitespace to align to open parentheses
o Remove embedded "random: " from pr_* as pr_fmt adds it

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Link: https://lore.kernel.org/r/20190607182517.28266-3-tiny.windzz@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -307,6 +307,8 @@
  * Eastlake, Steve Crocker, and Jeff Schiller.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/utsname.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -739,7 +741,7 @@ retry:
 	}
 
 	if (WARN_ON(entropy_count < 0)) {
-		pr_warn("random: negative entropy/overflow: pool %s count %d\n",
+		pr_warn("negative entropy/overflow: pool %s count %d\n",
 			r->name, entropy_count);
 		entropy_count = 0;
 	} else if (entropy_count > pool_size)
@@ -832,7 +834,7 @@ static void crng_initialize(struct crng_
 	}
 	if (trust_cpu && arch_init) {
 		crng_init = 2;
-		pr_notice("random: crng done (trusting CPU's manufacturer)\n");
+		pr_notice("crng done (trusting CPU's manufacturer)\n");
 	}
 	crng->init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
 }
@@ -856,14 +858,12 @@ static void crng_finalize_init(struct cr
 	kill_fasync(&fasync, SIGIO, POLL_IN);
 	pr_notice("crng init done\n");
 	if (unseeded_warning.missed) {
-		pr_notice("random: %d get_random_xx warning(s) missed "
-			  "due to ratelimiting\n",
+		pr_notice("%d get_random_xx warning(s) missed due to ratelimiting\n",
 			  unseeded_warning.missed);
 		unseeded_warning.missed = 0;
 	}
 	if (urandom_warning.missed) {
-		pr_notice("random: %d urandom warning(s) missed "
-			  "due to ratelimiting\n",
+		pr_notice("%d urandom warning(s) missed due to ratelimiting\n",
 			  urandom_warning.missed);
 		urandom_warning.missed = 0;
 	}
@@ -944,7 +944,7 @@ static int crng_fast_load(const char *cp
 	if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
 		invalidate_batched_entropy();
 		crng_init = 1;
-		pr_notice("random: fast init done\n");
+		pr_notice("fast init done\n");
 	}
 	return 1;
 }
@@ -1380,7 +1380,7 @@ retry:
 		ibytes = 0;
 
 	if (WARN_ON(entropy_count < 0)) {
-		pr_warn("random: negative entropy count: pool %s count %d\n",
+		pr_warn("negative entropy count: pool %s count %d\n",
 			r->name, entropy_count);
 		entropy_count = 0;
 	}
@@ -1806,9 +1806,8 @@ urandom_read(struct file *file, char __u
 	if (!crng_ready() && maxwarn > 0) {
 		maxwarn--;
 		if (__ratelimit(&urandom_warning))
-			printk(KERN_NOTICE "random: %s: uninitialized "
-			       "urandom read (%zd bytes read)\n",
-			       current->comm, nbytes);
+			pr_notice("%s: uninitialized urandom read (%zd bytes read)\n",
+				  current->comm, nbytes);
 		spin_lock_irqsave(&primary_crng.lock, flags);
 		crng_init_cnt = 0;
 		spin_unlock_irqrestore(&primary_crng.lock, flags);


