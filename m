Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A41E34FB5D3
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 10:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343669AbiDKIWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 04:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244094AbiDKIWO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 04:22:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E44B3DDD5
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 01:19:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26E54B81126
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 08:19:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7067DC385A4;
        Mon, 11 Apr 2022 08:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649665196;
        bh=zyqn9kdG1GgacT74t94xUlQRuw84DGlx6CVd3Yeu8Oc=;
        h=Subject:To:Cc:From:Date:From;
        b=OLAMNP6I+v60ENLH9wjdD0czgFG2NqucDVNF17B2DAWzZWoY3lIVQQLocl3VMm6a+
         cCDlD//hLmADLHz2LtV7AEtAlbktAi2sRhp9Ch1le4Hp1NCZvrqgzOXuRjm8DpOuRT
         WufBFu1v0Nnq1zPgpSBnKaIcbjFxowcTHytOW/VE=
Subject: FAILED: patch "[PATCH] random: skip fast_init if hwrng provides large chunk of" failed to apply to 5.17-stable tree
To:     Jason@zx2c4.com, linux@dominikbrodowski.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Apr 2022 10:19:54 +0200
Message-ID: <164966519423686@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.17-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From af704c856e888fb044b058d731d61b46eeec499d Mon Sep 17 00:00:00 2001
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 21 Mar 2022 18:48:05 -0600
Subject: [PATCH] random: skip fast_init if hwrng provides large chunk of
 entropy

At boot time, EFI calls add_bootloader_randomness(), which in turn calls
add_hwgenerator_randomness(). Currently add_hwgenerator_randomness()
feeds the first 64 bytes of randomness to the "fast init"
non-crypto-grade phase. But if add_hwgenerator_randomness() gets called
with more than POOL_MIN_BITS of entropy, there's no point in passing it
off to the "fast init" stage, since that's enough entropy to bootstrap
the real RNG. The "fast init" stage is just there to provide _something_
in the case where we don't have enough entropy to properly bootstrap the
RNG. But if we do have enough entropy to bootstrap the RNG, the current
logic doesn't serve a purpose. So, in the case where we're passed
greater than or equal to POOL_MIN_BITS of entropy, this commit makes us
skip the "fast init" phase.

Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 66ce7c03a142..74e0b069972e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1128,7 +1128,7 @@ void rand_initialize_disk(struct gendisk *disk)
 void add_hwgenerator_randomness(const void *buffer, size_t count,
 				size_t entropy)
 {
-	if (unlikely(crng_init == 0)) {
+	if (unlikely(crng_init == 0 && entropy < POOL_MIN_BITS)) {
 		size_t ret = crng_pre_init_inject(buffer, count, true);
 		mix_pool_bytes(buffer, ret);
 		count -= ret;

