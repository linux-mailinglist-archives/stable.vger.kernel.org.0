Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D82551E0F
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350390AbiFTOCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352057AbiFTNzw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:55:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CD134BB8;
        Mon, 20 Jun 2022 06:21:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95ADFB811D7;
        Mon, 20 Jun 2022 13:11:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E543FC3411B;
        Mon, 20 Jun 2022 13:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730667;
        bh=Se/8P/jaRDfY+UTXLxqdL6SgFPgJump3fH5kjWf95ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v4ou0V6Nq9Nv5/etmTHn0JyZTCpZ2r4qk8wYi6ZfexqkIMdpJlWsHR2j6MmDfcM6L
         T1a52CTtsb3npUP0bpQPRDfu8/h8+zabFHZ7RGHMdiDBGVlqWJccGUPN8rNC9qaGkf
         Du5dSe80DDi7mpopIorLhlCYUaKniO7UgPT5nRdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 019/240] random: Add and use pr_fmt()
Date:   Mon, 20 Jun 2022 14:48:40 +0200
Message-Id: <20220620124738.367436228@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
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
@@ -738,7 +740,7 @@ retry:
 	}
 
 	if (WARN_ON(entropy_count < 0)) {
-		pr_warn("random: negative entropy/overflow: pool %s count %d\n",
+		pr_warn("negative entropy/overflow: pool %s count %d\n",
 			r->name, entropy_count);
 		entropy_count = 0;
 	} else if (entropy_count > pool_size)
@@ -834,7 +836,7 @@ static void crng_initialize(struct crng_
 		invalidate_batched_entropy();
 		numa_crng_init();
 		crng_init = 2;
-		pr_notice("random: crng done (trusting CPU's manufacturer)\n");
+		pr_notice("crng done (trusting CPU's manufacturer)\n");
 	}
 	crng->init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
 }
@@ -858,14 +860,12 @@ static void crng_finalize_init(struct cr
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
@@ -948,7 +948,7 @@ static size_t crng_fast_load(const char
 	if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
 		invalidate_batched_entropy();
 		crng_init = 1;
-		pr_notice("random: fast init done\n");
+		pr_notice("fast init done\n");
 	}
 	return ret;
 }
@@ -1384,7 +1384,7 @@ retry:
 		ibytes = 0;
 
 	if (WARN_ON(entropy_count < 0)) {
-		pr_warn("random: negative entropy count: pool %s count %d\n",
+		pr_warn("negative entropy count: pool %s count %d\n",
 			r->name, entropy_count);
 		entropy_count = 0;
 	}
@@ -1870,9 +1870,8 @@ urandom_read(struct file *file, char __u
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


