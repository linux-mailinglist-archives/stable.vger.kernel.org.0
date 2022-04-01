Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD9EF4EE517
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 02:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243267AbiDAAP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 20:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiDAAP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 20:15:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F0513CFB;
        Thu, 31 Mar 2022 17:13:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 217DCB82294;
        Fri,  1 Apr 2022 00:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE094C340EE;
        Fri,  1 Apr 2022 00:13:36 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="iTz8lzFT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1648772015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fxj+V0C98LxH/amAPZh8e04K1hwVl6DGYXcLOUCV95Y=;
        b=iTz8lzFTmOBq6cT1uGr+3NaK9r8yyhAL6mm7HQf/b5YOTNsSxQgrGjp6AM6mZfLoVOLECt
        bX8u+vmCuR6CcgbjrLDhizv96ep04iIDx4y7kLPKuuEsFFrOjC6CDud4j9F6r6n4cL5mW6
        BKGuaZuFB5U44zoeBtUwUq6GcqjQ/lo=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c9a5fcd6 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 1 Apr 2022 00:13:35 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     keescook@chromium.org, re.emese@gmail.com,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: [PATCH] gcc-plugins: latent_entropy: use /dev/urandom
Date:   Thu, 31 Mar 2022 20:13:25 -0400
Message-Id: <20220401001325.281220-1-Jason@zx2c4.com>
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

While the latent entropy plugin mostly doesn't derive entropy from
get_random_const() for measuring the call graph, when __latent_entropy is
applied to a constant, then it's initialized statically to output from
get_random_const(). In that case, this data is derived from a 64-bit
seed, which means a buffer of 512 bits doesn't really have that amount
of compile-time entropy.

This patch fixes that shortcoming by just buffering chunks of
/dev/urandom output and doling it out as requested.

Fixes: 38addce8b600 ("gcc-plugins: Add latent_entropy plugin")
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
I'm not super familiar with this plugin or its conventions, so pointers
would be most welcome if something here looks amiss. The decision to
buffer 2k at a time is pretty arbitrary too; I haven't measured usage.

 scripts/gcc-plugins/latent_entropy_plugin.c | 34 +++++++++------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/scripts/gcc-plugins/latent_entropy_plugin.c b/scripts/gcc-plugins/latent_entropy_plugin.c
index 589454bce930..f238ba6726b8 100644
--- a/scripts/gcc-plugins/latent_entropy_plugin.c
+++ b/scripts/gcc-plugins/latent_entropy_plugin.c
@@ -82,29 +82,27 @@ __visible int plugin_is_GPL_compatible;
 static GTY(()) tree latent_entropy_decl;
 
 static struct plugin_info latent_entropy_plugin_info = {
-	.version	= "201606141920vanilla",
+	.version	= "202203311920vanilla",
 	.help		= "disable\tturn off latent entropy instrumentation\n",
 };
 
-static unsigned HOST_WIDE_INT seed;
-/*
- * get_random_seed() (this is a GCC function) generates the seed.
- * This is a simple random generator without any cryptographic security because
- * the entropy doesn't come from here.
- */
+static unsigned HOST_WIDE_INT rnd_buf[256];
+static size_t rnd_idx = ARRAY_SIZE(rnd_buf);
+static int urandom_fd = -1;
+
 static unsigned HOST_WIDE_INT get_random_const(void)
 {
-	unsigned int i;
-	unsigned HOST_WIDE_INT ret = 0;
-
-	for (i = 0; i < 8 * sizeof(ret); i++) {
-		ret = (ret << 1) | (seed & 1);
-		seed >>= 1;
-		if (ret & 1)
-			seed ^= 0xD800000000000000ULL;
+	if (urandom_fd < 0) {
+		urandom_fd = open("/dev/urandom", O_RDONLY);
+		if (urandom_fd < 0)
+			abort();
 	}
-
-	return ret;
+	if (rnd_idx >= ARRAY_SIZE(rnd_buf)) {
+		if (read(urandom_fd, rnd_buf, sizeof(rnd_buf)) != sizeof(rnd_buf))
+			abort();
+		rnd_idx = 0;
+	}
+	return rnd_buf[rnd_idx++];
 }
 
 static tree tree_get_random_const(tree type)
@@ -537,8 +535,6 @@ static void latent_entropy_start_unit(void *gcc_data __unused,
 	tree type, id;
 	int quals;
 
-	seed = get_random_seed(false);
-
 	if (in_lto_p)
 		return;
 
-- 
2.35.1

