Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E749453610F
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbiE0L5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352972AbiE0Lzs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:55:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7360215E48F;
        Fri, 27 May 2022 04:49:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B53B61D9B;
        Fri, 27 May 2022 11:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FBEC385A9;
        Fri, 27 May 2022 11:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652166;
        bh=bSVPVgeyCECwaJ5Y0bqjpISwHhKTwbz8Yl8nQDHYOKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vmsToVmncCbA/IL0jyERMdVwOBUEt5TvlbQK7jXf09lEEkM+xOwvYwzeZn7IimHgi
         09BNubS5gZjiLQ+K20mY8sY4W46G5zSElW87Q6UbjPR4s7utawOW9i77t7bQu/QzBb
         MG3kqccXgW6oMbAOkH0IGwH315nn9NCPtmq1FkiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 094/145] random: mix build-time latent entropy into pool at init
Date:   Fri, 27 May 2022 10:49:55 +0200
Message-Id: <20220527084902.023531532@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084850.364560116@linuxfoundation.org>
References: <20220527084850.364560116@linuxfoundation.org>
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
@@ -972,6 +972,11 @@ int __init rand_initialize(void)
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


