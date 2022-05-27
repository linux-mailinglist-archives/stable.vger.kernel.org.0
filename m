Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6CA3535FAF
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240079AbiE0LlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351574AbiE0Lkr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:40:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F55913C1F4;
        Fri, 27 May 2022 04:39:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9DB461CC4;
        Fri, 27 May 2022 11:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3772C385A9;
        Fri, 27 May 2022 11:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651569;
        bh=hnMVFKzJakkFudy48mRUI+VFFoGuT+sdo+aAIP6T100=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jsfso5SSCF12QNUW1Sa2P1qYKa3xf/FKQEUq81nEkiuWkHnoRTUr5pqIHvpmywwwI
         a+SN+ta2zydQv0ROSbcvPcUoSjEvIh9vVn8D+63BX9nb4Rd8qxogDJaD288BfFJk4o
         i+9taOR7I4gW55rQb/BhNJUGrXfSvGMrxhhx6CSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.17 059/111] random: mix build-time latent entropy into pool at init
Date:   Fri, 27 May 2022 10:49:31 +0200
Message-Id: <20220527084827.872544791@linuxfoundation.org>
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

commit 1754abb3e7583c570666fa1e1ee5b317e88c89a0 upstream.

Prior, the "input_pool_data" array needed no real initialization, and so
it was easy to mark it with __latent_entropy to populate it during
compile-time. In switching to using a hash function, this required us to
specifically initialize it to some specific state, which means we
dropped the __latent_entropy attribute. An unfortunate side effect was
this meant the pool was no longer seeded using compile-time random data.
In order to bring this back, we declare an array in rand_initialize()
with __latent_entropy and call mix_pool_bytes() on that at init, which
accomplishes the same thing as before. We make this __initconst, so that
it doesn't take up space at runtime after init.

Fixes: 6e8ec2552c7d ("random: use computational hash for entropy extraction")
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -970,6 +970,11 @@ int __init rand_initialize(void)
 	bool arch_init = true;
 	unsigned long rv;
 
+#if defined(LATENT_ENTROPY_PLUGIN)
+	static const u8 compiletime_seed[BLAKE2S_BLOCK_SIZE] __initconst __latent_entropy;
+	_mix_pool_bytes(compiletime_seed, sizeof(compiletime_seed));
+#endif
+
 	for (i = 0; i < BLAKE2S_BLOCK_SIZE; i += sizeof(rv)) {
 		if (!arch_get_random_seed_long_early(&rv) &&
 		    !arch_get_random_long_early(&rv)) {


