Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0202354E1BF
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 15:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbiFPNUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 09:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbiFPNUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 09:20:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF1C42EF8;
        Thu, 16 Jun 2022 06:20:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31E8DB82411;
        Thu, 16 Jun 2022 13:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2826FC34114;
        Thu, 16 Jun 2022 13:20:48 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="LGQ/8lxd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1655385646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mpx3Cbe6UECgdt/hmJPPtsrz3KuyrD1FOkyrZL0lfSs=;
        b=LGQ/8lxdXrWCwzOeeWThI7CwOHak7ywC7OSt5GOdA6UgdLHRo90ECFJ1b0EzwH9KHiV/4X
        dMqm78XZNtF3y2LLeAlJEpipAkrhboNsC1y07os0sqeKhhiUQOZWNAwz/HpBb3yuNsr0H2
        ZhDAql1Gvap44OwY16pAxPJmZEZU93U=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 59d13479 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 16 Jun 2022 13:20:45 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org,
        Jon Hunter <jonathanh@nvidia.com>, Ron Economos <re@w6rz.net>
Subject: [PATCH] random: quiet urandom warning ratelimit suppression message
Date:   Thu, 16 Jun 2022 15:20:29 +0200
Message-Id: <20220616132029.443033-1-Jason@zx2c4.com>
In-Reply-To: <81bda7cc-fd95-8f54-4ad7-3fad9a81b831@nvidia.com>
References: <81bda7cc-fd95-8f54-4ad7-3fad9a81b831@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

random.c ratelimits how much it warns about uninitialized urandom reads
using __ratelimit. When the RNG is finally initialized, it prints the
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
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/char/random.c           |  2 +-
 include/linux/ratelimit_types.h | 12 ++++++++----
 2 files changed, 9 insertions(+), 5 deletions(-)

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
 
-- 
2.35.1

