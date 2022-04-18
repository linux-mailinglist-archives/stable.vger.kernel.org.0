Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D80C85054FB
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241525AbiDRNMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240912AbiDRNGH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:06:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDE52A244;
        Mon, 18 Apr 2022 05:46:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C77660FB6;
        Mon, 18 Apr 2022 12:46:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF99C385A7;
        Mon, 18 Apr 2022 12:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286009;
        bh=dJzCn9cIQspghMBiSeA+o7H9D+g3/toGnQtHulXDBOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a269XnCEG8+AfGXXqi+3wHkyY2hUsb7hlUxHN5RD6dSp8KoCQ53l2houBKq7SUyUp
         C9egdPvUP96a6cr6hMxf7HYjFbWYXWcNvAt8YxiVnSvlYg5p3R1HCcjFiXICHvELCI
         HhFI3LV8k97gGkWrt/HLS6iPexfKpNEWgqxYMxUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, PaX Team <pageexec@freemail.hu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 4.19 26/32] gcc-plugins: latent_entropy: use /dev/urandom
Date:   Mon, 18 Apr 2022 14:14:06 +0200
Message-Id: <20220418121127.888590983@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121127.127656835@linuxfoundation.org>
References: <20220418121127.127656835@linuxfoundation.org>
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

From: Jason A. Donenfeld <Jason@zx2c4.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gcc-plugins/latent_entropy_plugin.c |   44 +++++++++++++++++-----------
 1 file changed, 27 insertions(+), 17 deletions(-)

--- a/scripts/gcc-plugins/latent_entropy_plugin.c
+++ b/scripts/gcc-plugins/latent_entropy_plugin.c
@@ -86,25 +86,31 @@ static struct plugin_info latent_entropy
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
@@ -549,8 +555,6 @@ static void latent_entropy_start_unit(vo
 	tree type, id;
 	int quals;
 
-	seed = get_random_seed(false);
-
 	if (in_lto_p)
 		return;
 
@@ -585,6 +589,12 @@ __visible int plugin_init(struct plugin_
 	const struct plugin_argument * const argv = plugin_info->argv;
 	int i;
 
+	/*
+	 * Call get_random_seed() with noinit=true, so that this returns
+	 * 0 in the case where no seed has been passed via -frandom-seed.
+	 */
+	deterministic_seed = get_random_seed(true);
+
 	static const struct ggc_root_tab gt_ggc_r_gt_latent_entropy[] = {
 		{
 			.base = &latent_entropy_decl,


