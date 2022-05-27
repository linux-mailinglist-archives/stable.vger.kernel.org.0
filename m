Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF70B535FA5
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348920AbiE0Lkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351778AbiE0LkF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:40:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745C5111BA6;
        Fri, 27 May 2022 04:39:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D82D961CB7;
        Fri, 27 May 2022 11:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75EFC385A9;
        Fri, 27 May 2022 11:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651557;
        bh=zeCNXD/6mPqe80gmC393S7dCSxWXSaOLreAdBp1vAWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w3hyO/5s3HTX2+ezbV1IxPIfyaIvgQh0jWUkx6xnbj3mv0vwBPMQX6iA4sxzrx+Hl
         hee6BzldFU8/rKFmOEG9OzeYormZu9C8NwuAQMti0JfHGvd3to4YjgvYFFvy1hYHAf
         +qV5J3OehherNOeq7JTmCGFboBszrNZIWJe2wfZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 016/145] random: mix bootloader randomness into pool
Date:   Fri, 27 May 2022 10:48:37 +0200
Message-Id: <20220527084852.955822975@linuxfoundation.org>
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

commit 57826feeedb63b091f807ba8325d736775d39afd upstream.

If we're trusting bootloader randomness, crng_fast_load() is called by
add_hwgenerator_randomness(), which sets us to crng_init==1. However,
usually it is only called once for an initial 64-byte push, so bootloader
entropy will not mix any bytes into the input pool. So it's conceivable
that crng_init==1 when crng_initialize_primary() is called later, but
then the input pool is empty. When that happens, the crng state key will
be overwritten with extracted output from the empty input pool. That's
bad.

In contrast, if we're not trusting bootloader randomness, we call
crng_slow_load() *and* we call mix_pool_bytes(), so that later
crng_initialize_primary() isn't drawing on nothing.

In order to prevent crng_initialize_primary() from extracting an empty
pool, have the trusted bootloader case mirror that of the untrusted
bootloader case, mixing the input into the pool.

[linux@dominikbrodowski.net: rewrite commit message]
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2301,6 +2301,7 @@ void add_hwgenerator_randomness(const ch
 
 	if (unlikely(crng_init == 0)) {
 		size_t ret = crng_fast_load(buffer, count);
+		mix_pool_bytes(poolp, buffer, ret);
 		count -= ret;
 		buffer += ret;
 		if (!count || crng_init == 0)


