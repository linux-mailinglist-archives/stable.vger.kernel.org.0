Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27CF855AAAE
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 15:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbiFYNyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 09:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232971AbiFYNyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 09:54:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320F512AF7
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 06:54:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDB95B80B4C
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 13:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B667C3411C;
        Sat, 25 Jun 2022 13:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656165242;
        bh=NFUslPu4PQp09EDyLLB3+OOsInryl8koXy34UO5Cw1E=;
        h=Subject:To:Cc:From:Date:From;
        b=rXJvoszbaHSgm/aD7DZm63X5LbVWk6h2QPD8Wqs1W/DKp+XGAo8fYCKoefzH6pXwa
         nSW6kS1lS7IbXzhQvoCD5PYC5n/XjtXOnsEuqAgPgB7WLUljslpSQxquVkPYDbukvD
         KHspQTYqBqt+9FNlsvOmdRheDpH0PW80AfzOLsjI=
Subject: FAILED: patch "[PATCH] random: quiet urandom warning ratelimit suppression message" failed to apply to 4.19-stable tree
To:     Jason@zx2c4.com, jonathanh@nvidia.com, re@w6rz.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 25 Jun 2022 15:53:46 +0200
Message-ID: <1656165226153151@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c01d4d0a82b71857be7449380338bc53dde2da92 Mon Sep 17 00:00:00 2001
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 16 Jun 2022 15:00:51 +0200
Subject: [PATCH] random: quiet urandom warning ratelimit suppression message

random.c ratelimits how much it warns about uninitialized urandom reads
using __ratelimit(). When the RNG is finally initialized, it prints the
number of missed messages due to ratelimiting.

It has been this way since that functionality was introduced back in
2018. Recently, cc1e127bfa95 ("random: remove ratelimiting for in-kernel
unseeded randomness") put a bit more stress on the urandom ratelimiting,
which teased out a bug in the implementation.

Specifically, when under pressure, __ratelimit() will print its own
message and reset the count back to 0, making the final message at the
end less useful. Secondly, it does so as a pr_warn(), which apparently
is undesirable for people's CI.

Fortunately, __ratelimit() has the RATELIMIT_MSG_ON_RELEASE flag exactly
for this purpose, so we set the flag.

Fixes: 4e00b339e264 ("random: rate limit unseeded randomness warnings")
Cc: stable@vger.kernel.org
Reported-by: Jon Hunter <jonathanh@nvidia.com>
Reported-by: Ron Economos <re@w6rz.net>
Tested-by: Ron Economos <re@w6rz.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

diff --git a/drivers/char/random.c b/drivers/char/random.c
index d0e4c89c4fcb..07a022e24057 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -87,7 +87,7 @@ static struct fasync_struct *fasync;
 
 /* Control how we warn userspace. */
 static struct ratelimit_state urandom_warning =
-	RATELIMIT_STATE_INIT("warn_urandom_randomness", HZ, 3);
+	RATELIMIT_STATE_INIT_FLAGS("urandom_warning", HZ, 3, RATELIMIT_MSG_ON_RELEASE);
 static int ratelimit_disable __read_mostly =
 	IS_ENABLED(CONFIG_WARN_ALL_UNSEEDED_RANDOM);
 module_param_named(ratelimit_disable, ratelimit_disable, int, 0644);
diff --git a/include/linux/ratelimit_types.h b/include/linux/ratelimit_types.h
index c21c7f8103e2..002266693e50 100644
--- a/include/linux/ratelimit_types.h
+++ b/include/linux/ratelimit_types.h
@@ -23,12 +23,16 @@ struct ratelimit_state {
 	unsigned long	flags;
 };
 
-#define RATELIMIT_STATE_INIT(name, interval_init, burst_init) {		\
-		.lock		= __RAW_SPIN_LOCK_UNLOCKED(name.lock),	\
-		.interval	= interval_init,			\
-		.burst		= burst_init,				\
+#define RATELIMIT_STATE_INIT_FLAGS(name, interval_init, burst_init, flags_init) { \
+		.lock		= __RAW_SPIN_LOCK_UNLOCKED(name.lock),		  \
+		.interval	= interval_init,				  \
+		.burst		= burst_init,					  \
+		.flags		= flags_init,					  \
 	}
 
+#define RATELIMIT_STATE_INIT(name, interval_init, burst_init) \
+	RATELIMIT_STATE_INIT_FLAGS(name, interval_init, burst_init, 0)
+
 #define RATELIMIT_STATE_INIT_DISABLED					\
 	RATELIMIT_STATE_INIT(ratelimit_state, 0, DEFAULT_RATELIMIT_BURST)
 

