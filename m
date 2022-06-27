Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF6E55C519
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbiF0LYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234681AbiF0LYD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:24:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50E0656C;
        Mon, 27 Jun 2022 04:24:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 690BFB8111E;
        Mon, 27 Jun 2022 11:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23D8C385A5;
        Mon, 27 Jun 2022 11:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329040;
        bh=Dofcmi+hdhw1/cNl7/QLeE8tyR3IXblze26vcC06QdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DG0/cst5MNEs9qnFwbhriLzxJL3TdSJKKF0OmVAlcW6HgFJ2cWtpek5XNyo4IAb/6
         7LLAKri/0/SMiuKYNzrcHJ0ycMBkKSJdsmmg0qterrkLhHSdq5sP4FWVjOyFNGMcT4
         9w32LLZyfujgTMu5yTDGs7Zh4viAYY2e/8z6EP6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Ron Economos <re@w6rz.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 003/102] random: quiet urandom warning ratelimit suppression message
Date:   Mon, 27 Jun 2022 13:20:14 +0200
Message-Id: <20220627111933.561143737@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit c01d4d0a82b71857be7449380338bc53dde2da92 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c           |    2 +-
 include/linux/ratelimit_types.h |   12 ++++++++----
 2 files changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -88,7 +88,7 @@ static RAW_NOTIFIER_HEAD(random_ready_ch
 
 /* Control how we warn userspace. */
 static struct ratelimit_state urandom_warning =
-	RATELIMIT_STATE_INIT("warn_urandom_randomness", HZ, 3);
+	RATELIMIT_STATE_INIT_FLAGS("urandom_warning", HZ, 3, RATELIMIT_MSG_ON_RELEASE);
 static int ratelimit_disable __read_mostly =
 	IS_ENABLED(CONFIG_WARN_ALL_UNSEEDED_RANDOM);
 module_param_named(ratelimit_disable, ratelimit_disable, int, 0644);
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
 


