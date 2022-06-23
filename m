Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59589558523
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235438AbiFWRyM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235526AbiFWRws (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:52:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749D26E7AD;
        Thu, 23 Jun 2022 10:13:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F18BDB82497;
        Thu, 23 Jun 2022 17:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4719DC385A9;
        Thu, 23 Jun 2022 17:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004417;
        bh=UZ4rOZnXD0B2s7otWoi4i5a8pXEpQZBcHueYldFP76Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qi+ngaIfXLmCcOeuk+UA0j/w74WUs1/PjdegzSUAy3D9AM+h8GpGckHnnQfr56Cki
         9vWDcS/pWU6b5THxWLjSuVj7DGYFkf7sgVPg/3t/Tf07XaVZonQREJyjpEFL44yJ6U
         W8b6xA9O3rVvjeEmnbUMPiOQJqBT+PeRfZueaOfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 030/234] random: Add and use pr_fmt()
Date:   Thu, 23 Jun 2022 18:41:37 +0200
Message-Id: <20220623164343.917723742@linuxfoundation.org>
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
@@ -835,7 +837,7 @@ static void crng_initialize(struct crng_
 		invalidate_batched_entropy();
 		numa_crng_init();
 		crng_init = 2;
-		pr_notice("random: crng done (trusting CPU's manufacturer)\n");
+		pr_notice("crng done (trusting CPU's manufacturer)\n");
 	}
 	crng->init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
 }
@@ -859,14 +861,12 @@ static void crng_finalize_init(struct cr
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
@@ -947,7 +947,7 @@ static int crng_fast_load(const char *cp
 	if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
 		invalidate_batched_entropy();
 		crng_init = 1;
-		pr_notice("random: fast init done\n");
+		pr_notice("fast init done\n");
 	}
 	return 1;
 }
@@ -1383,7 +1383,7 @@ retry:
 		ibytes = 0;
 
 	if (WARN_ON(entropy_count < 0)) {
-		pr_warn("random: negative entropy count: pool %s count %d\n",
+		pr_warn("negative entropy count: pool %s count %d\n",
 			r->name, entropy_count);
 		entropy_count = 0;
 	}
@@ -1869,9 +1869,8 @@ urandom_read(struct file *file, char __u
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


