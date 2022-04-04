Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 614214F2016
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 01:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239850AbiDDXRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 19:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243800AbiDDXQs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 19:16:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694FABE9;
        Mon,  4 Apr 2022 16:07:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F151861711;
        Mon,  4 Apr 2022 23:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63E4C34110;
        Mon,  4 Apr 2022 23:07:14 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="KFvhKuZ7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1649113633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vGTaurbGxnmX61uTtsDVA0m4CB9YGZAV9yFAwsrZgZM=;
        b=KFvhKuZ78B+r+N8t4RyLL1HurxD33oMWR69ujLyRkOx4tws71XRwtLP6Dlrv71L1P1yVv8
        Hmh3CbbjuThGe+bNk9gCwR/l8+ZEWrZhX8EXaESZJyltxf9Hn0SSmSLYfmrfhv9/Qrn9Gv
        DVVxoBlvg2OuTxxwf3HstTQ93iWdXoA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9db78fce (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 4 Apr 2022 23:07:12 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org,
        PaX Team <pageexec@freemail.hu>
Subject: [PATCH v3] gcc-plugins: latent_entropy: use /dev/urandom
Date:   Tue,  5 Apr 2022 01:07:09 +0200
Message-Id: <20220404230709.124508-1-Jason@zx2c4.com>
In-Reply-To: <Ykt1cj0wPKEsHL2q@zx2c4.com>
References: <Ykt1cj0wPKEsHL2q@zx2c4.com>
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

At the same time, it's important that we don't break the use of
-frandom-seed, for people who want the runtime benefits of the latent
entropy plugin, while still having compile-time determinism. In that
case, we detect whether a seed is in use via the local_ticks variable,
which the documentation explains is, "-1u, if the user has specified a
particular random seed."

Fixes: 38addce8b600 ("gcc-plugins: Add latent_entropy plugin")
Cc: stable@vger.kernel.org
Cc: PaX Team <pageexec@freemail.hu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
Changes v2->v3:
- Drop change to xorshift for deterministic thing. This can be done
  later if anybody actually finds a good reason for it.
- Drop change of plugin version. Since Kees is proposing a change in
  the versioning scheme, that can also be a separate patch.
- At Pipacs' suggestion, use local_ticks for determining if
  -frandom-seed is being used, since that's what gcc says to do.

 scripts/gcc-plugins/latent_entropy_plugin.c | 44 ++++++++++++++-------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/scripts/gcc-plugins/latent_entropy_plugin.c b/scripts/gcc-plugins/latent_entropy_plugin.c
index 589454bce930..435b956ac1bd 100644
--- a/scripts/gcc-plugins/latent_entropy_plugin.c
+++ b/scripts/gcc-plugins/latent_entropy_plugin.c
@@ -87,24 +87,40 @@ static struct plugin_info latent_entropy_plugin_info = {
 };
 
 static unsigned HOST_WIDE_INT seed;
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
+	/*
+	 * When local_tick==-1, the user has specified a seed using
+	 * -frandom-seed, which means we should do something deterministic.
+	 */
+	if (local_tick == -1U) {
+		unsigned HOST_WIDE_INT ret = 0;
+		size_t i;
+
+		for (i = 0; i < 8 * sizeof(ret); i++) {
+			ret = (ret << 1) | (seed & 1);
+			seed >>= 1;
+			if (ret & 1)
+				seed ^= 0xD800000000000000ULL;
+		}
+		return ret;
 	}
 
-	return ret;
+	if (urandom_fd < 0) {
+		urandom_fd = open("/dev/urandom", O_RDONLY);
+		if (urandom_fd < 0)
+			abort();
+	}
+	if (rnd_idx >= ARRAY_SIZE(rnd_buf)) {
+		if (read(urandom_fd, rnd_buf, sizeof(rnd_buf)) != sizeof(rnd_buf))
+			abort();
+		rnd_idx = 0;
+	}
+	return rnd_buf[rnd_idx++];
 }
 
 static tree tree_get_random_const(tree type)
-- 
2.35.1

