Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653565360C7
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352161AbiE0Lwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239451AbiE0Lve (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:51:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFC7149A92;
        Fri, 27 May 2022 04:47:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B546061D9B;
        Fri, 27 May 2022 11:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F92C385A9;
        Fri, 27 May 2022 11:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652038;
        bh=0m6IMPAF3aFYuYZnc9e3p4j0SYuukOg9VWQ2U6J8brs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0jZRPsfkJSCyAsKKs5VW5Hygi0vrJl4QjeJT566Jl/J0oTulyFW6vFGg7kLXiq01k
         dhMusA7JvAA1ef5BeGnKY8KwkkbarLtWCHweNi2rr/x6a/qZwpxNozTFmjG8mIwt/j
         wYvtSTwoxMPNVS8jY82OoYg6BrcD9Ps3iSHDo9Nw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 071/145] random: group sysctl functions
Date:   Fri, 27 May 2022 10:49:32 +0200
Message-Id: <20220527084859.082173070@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084850.364560116@linuxfoundation.org>
References: <20220527084850.364560116@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 0deff3c43206c24e746b1410f11125707ad3040e upstream.

This pulls all of the sysctl-focused functions into the sixth labeled
section.

No functional changes.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1693,9 +1693,34 @@ const struct file_operations urandom_fop
 	.llseek = noop_llseek,
 };
 
+
 /********************************************************************
  *
- * Sysctl interface
+ * Sysctl interface.
+ *
+ * These are partly unused legacy knobs with dummy values to not break
+ * userspace and partly still useful things. They are usually accessible
+ * in /proc/sys/kernel/random/ and are as follows:
+ *
+ * - boot_id - a UUID representing the current boot.
+ *
+ * - uuid - a random UUID, different each time the file is read.
+ *
+ * - poolsize - the number of bits of entropy that the input pool can
+ *   hold, tied to the POOL_BITS constant.
+ *
+ * - entropy_avail - the number of bits of entropy currently in the
+ *   input pool. Always <= poolsize.
+ *
+ * - write_wakeup_threshold - the amount of entropy in the input pool
+ *   below which write polls to /dev/random will unblock, requesting
+ *   more entropy, tied to the POOL_MIN_BITS constant. It is writable
+ *   to avoid breaking old userspaces, but writing to it does not
+ *   change any behavior of the RNG.
+ *
+ * - urandom_min_reseed_secs - fixed to the meaningless value "60".
+ *   It is writable to avoid breaking old userspaces, but writing
+ *   to it does not change any behavior of the RNG.
  *
  ********************************************************************/
 
@@ -1703,8 +1728,8 @@ const struct file_operations urandom_fop
 
 #include <linux/sysctl.h>
 
-static int random_min_urandom_seed = 60;
-static int random_write_wakeup_bits = POOL_MIN_BITS;
+static int sysctl_random_min_urandom_seed = 60;
+static int sysctl_random_write_wakeup_bits = POOL_MIN_BITS;
 static int sysctl_poolsize = POOL_BITS;
 static char sysctl_bootid[16];
 
@@ -1762,14 +1787,14 @@ struct ctl_table random_table[] = {
 	},
 	{
 		.procname	= "write_wakeup_threshold",
-		.data		= &random_write_wakeup_bits,
+		.data		= &sysctl_random_write_wakeup_bits,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "urandom_min_reseed_secs",
-		.data		= &random_min_urandom_seed,
+		.data		= &sysctl_random_min_urandom_seed,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,


