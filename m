Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF70504E71
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 11:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbiDRJps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 05:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233208AbiDRJps (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 05:45:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5543A1658F
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 02:43:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3F58611A4
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 09:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7304C385A1;
        Mon, 18 Apr 2022 09:43:07 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="csSK4Tjp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1650274986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ad7+LLiFapkfOJZyymcGxnzr5/oGz+J7Od3iIxVy8hQ=;
        b=csSK4TjptdRnaAQZafyBaxVsJ8ZVxNgfo+hrUlOBgBm3AwQrQsiTHXddFxVujD/ln4O1Ya
        BxGnxRoRJypqy/RWUPrWGCW5NtArphjG6lJNqrPUMdKM1Y7JbfoK9FBktSZPHTea9mPgUZ
        SFjmvfMGD3EwVmccOqWb+FTvNN6uhU8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 836d5bd3 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 18 Apr 2022 09:43:06 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        PaX Team <pageexec@freemail.hu>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH stable v4.9.y] gcc-plugins: latent_entropy: use /dev/urandom
Date:   Mon, 18 Apr 2022 11:42:41 +0200
Message-Id: <20220418094241.1484705-1-Jason@zx2c4.com>
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

commit c40160f2998c897231f8454bf797558d30a20375 upstream.

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
case, we detect whether gcc's set_random_seed() has been called by
making a call to get_random_seed(noinit=true) in the plugin init
function, which is called after set_random_seed() is called but before
anything that calls get_random_seed(noinit=false), and seeing if it's
zero or not. If it's not zero, we're in deterministic mode, and so we
just generate numbers with a basic xorshift prng.

Note that we don't detect if -frandom-seed is being used using the
documented local_tick variable, because it's assigned via:
   local_tick = (unsigned) tv.tv_sec * 1000 + tv.tv_usec / 1000;
which may well overflow and become -1 on its own, and so isn't
reliable: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105171

[kees: The 256 byte rnd_buf size was chosen based on average (250),
 median (64), and std deviation (575) bytes of used entropy for a
 defconfig x86_64 build]

Fixes: 38addce8b600 ("gcc-plugins: Add latent_entropy plugin")
Cc: stable@vger.kernel.org
Cc: PaX Team <pageexec@freemail.hu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220405222815.21155-1-Jason@zx2c4.com
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 scripts/gcc-plugins/latent_entropy_plugin.c | 44 +++++++++++++--------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/scripts/gcc-plugins/latent_entropy_plugin.c b/scripts/gcc-plugins/latent_entropy_plugin.c
index dff390f692a2..4435263766ac 100644
--- a/scripts/gcc-plugins/latent_entropy_plugin.c
+++ b/scripts/gcc-plugins/latent_entropy_plugin.c
@@ -86,25 +86,31 @@ static struct plugin_info latent_entropy_plugin_info = {
 	.help		= "disable\tturn off latent entropy instrumentation\n",
 };
 
-static unsigned HOST_WIDE_INT seed;
-/*
- * get_random_seed() (this is a GCC function) generates the seed.
- * This is a simple random generator without any cryptographic security because
- * the entropy doesn't come from here.
- */
+static unsigned HOST_WIDE_INT deterministic_seed;
+static unsigned HOST_WIDE_INT rnd_buf[32];
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
+	if (deterministic_seed) {
+		unsigned HOST_WIDE_INT w = deterministic_seed;
+		w ^= w << 13;
+		w ^= w >> 7;
+		w ^= w << 17;
+		deterministic_seed = w;
+		return deterministic_seed;
 	}
 
-	return ret;
+	if (urandom_fd < 0) {
+		urandom_fd = open("/dev/urandom", O_RDONLY);
+		gcc_assert(urandom_fd >= 0);
+	}
+	if (rnd_idx >= ARRAY_SIZE(rnd_buf)) {
+		gcc_assert(read(urandom_fd, rnd_buf, sizeof(rnd_buf)) == sizeof(rnd_buf));
+		rnd_idx = 0;
+	}
+	return rnd_buf[rnd_idx++];
 }
 
 static tree tree_get_random_const(tree type)
@@ -556,8 +562,6 @@ static void latent_entropy_start_unit(void *gcc_data __unused,
 	tree type, id;
 	int quals;
 
-	seed = get_random_seed(false);
-
 	if (in_lto_p)
 		return;
 
@@ -594,6 +598,12 @@ __visible int plugin_init(struct plugin_name_args *plugin_info,
 
 	struct register_pass_info latent_entropy_pass_info;
 
+	/*
+	 * Call get_random_seed() with noinit=true, so that this returns
+	 * 0 in the case where no seed has been passed via -frandom-seed.
+	 */
+	deterministic_seed = get_random_seed(true);
+
 	latent_entropy_pass_info.pass		= make_latent_entropy_pass();
 	latent_entropy_pass_info.reference_pass_name		= "optimized";
 	latent_entropy_pass_info.ref_pass_instance_number	= 1;
-- 
2.35.1

