Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD4A551B04
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346667AbiFTNgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345799AbiFTNee (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:34:34 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC1E27CC4;
        Mon, 20 Jun 2022 06:13:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6628ACE139A;
        Mon, 20 Jun 2022 13:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F1CC3411C;
        Mon, 20 Jun 2022 13:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730743;
        bh=YTcOURT67RliY+onoFdF4rJ3Bag8bxdtEdjdRn02ukk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=URGAAWdsTKak3JcTGTXOQm/t3ZNP3Thv+kP6UHnn6FIIPG9Pb9ErXJYGWvZJh/RtQ
         YNnasu/rG3uOvhndqTRsdXNR8VAVCJd0rhKirpCHtNWKJz1H323cFz9Yl6CyJ2rEmB
         2LcWTsmMVnlvmBk3USNLCRhT81WVb8GeIwke0VnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 042/240] random: mix bootloader randomness into pool
Date:   Mon, 20 Jun 2022 14:49:03 +0200
Message-Id: <20220620124739.210208937@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
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
@@ -2299,6 +2299,7 @@ void add_hwgenerator_randomness(const ch
 
 	if (unlikely(crng_init == 0)) {
 		size_t ret = crng_fast_load(buffer, count);
+		mix_pool_bytes(poolp, buffer, ret);
 		count -= ret;
 		buffer += ret;
 		if (!count || crng_init == 0)


