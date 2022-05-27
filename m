Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F41535C4E
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 11:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349184AbiE0JCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 05:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350660AbiE0JAP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 05:00:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638DF62129;
        Fri, 27 May 2022 01:56:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC2E361D92;
        Fri, 27 May 2022 08:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFF0C385B8;
        Fri, 27 May 2022 08:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641793;
        bh=o/vWndbOaURYXkT/zS2MSGUMqwWluO4wbWkZcZ5tb8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rq1kbe53k9UrtvSRg3c1WRMyg7KnYaZuR7lNUgHGJE2/vTbtyHwenLJUa/b/MYbaO
         UEPP4BlMsmxB7eiqP7ruZwnlutrHDiIdns0e+C3XGhHx/n7++tKieeP48ujwH1LfeR
         eOCS7xJQEa+X3lsZhIt0GiPFIfZ+yYLRjPf8an50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.17 036/111] random: group sysctl functions
Date:   Fri, 27 May 2022 10:49:08 +0200
Message-Id: <20220527084824.550347557@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084819.133490171@linuxfoundation.org>
References: <20220527084819.133490171@linuxfoundation.org>
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
 drivers/char/random.c |   37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

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
 
@@ -1761,14 +1786,14 @@ static struct ctl_table random_table[] =
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
@@ -1799,4 +1824,4 @@ static int __init random_sysctls_init(vo
 	return 0;
 }
 device_initcall(random_sysctls_init);
-#endif	/* CONFIG_SYSCTL */
+#endif


