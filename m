Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE92561C95
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236085AbiF3OAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236016AbiF3N5I (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:57:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2993BA5A;
        Thu, 30 Jun 2022 06:51:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA34462009;
        Thu, 30 Jun 2022 13:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B01C34115;
        Thu, 30 Jun 2022 13:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597067;
        bh=r/AUmqVNZ/rqk8TyaWRYjSqZNwcpqBfVSV8e106GGsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JnNNdf4nPiV2cRo/T2ZJpsFLciygewS4D2Ywml/8EVlepVPRk/+YgBhF0ewBuxvbS
         S86V2bC507DtjzDphudwO024sBZMEDNbPkXXHpop4BMwNqqHc6ikyFaf88L+IXBnDs
         VabrB9GvXi232XMXsQ7BoLPB1D2V3FjIGIiwx2qw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Ron Economos <re@w6rz.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 08/49] random: quiet urandom warning ratelimit suppression message
Date:   Thu, 30 Jun 2022 15:46:21 +0200
Message-Id: <20220630133234.153473945@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133233.910803744@linuxfoundation.org>
References: <20220630133233.910803744@linuxfoundation.org>
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
 drivers/char/random.c     |    2 +-
 include/linux/ratelimit.h |   12 ++++++++----
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
--- a/include/linux/ratelimit.h
+++ b/include/linux/ratelimit.h
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
 


