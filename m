Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEF535583E4
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbiFWRhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234418AbiFWRhC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:37:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2058EFB8;
        Thu, 23 Jun 2022 10:06:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB39BB82499;
        Thu, 23 Jun 2022 17:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB60C341C5;
        Thu, 23 Jun 2022 17:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003991;
        bh=kLu6oEFnz7kWzqySjKoPppP6306WDVKu2D0M9xJxpzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ACxnwXBnOwT8E46iPm7AWDNSvSEH+up2lyUonwiXR1AxzPek/hYu6gsGW12esKBii
         O6KNHGXN0xgs24IkvGritMqCstZ+FNSTp4y0OSZn6l8VyieGYJV6jgnFy8sSalH9n+
         DHgLoAtBqiBZyLpF25eaM4MLpnEiKiQAkHZsI6So=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 136/237] random: skip fast_init if hwrng provides large chunk of entropy
Date:   Thu, 23 Jun 2022 18:42:50 +0200
Message-Id: <20220623164347.066835144@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
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

commit af704c856e888fb044b058d731d61b46eeec499d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1120,7 +1120,7 @@ void rand_initialize_disk(struct gendisk
 void add_hwgenerator_randomness(const void *buffer, size_t count,
 				size_t entropy)
 {
-	if (unlikely(crng_init == 0)) {
+	if (unlikely(crng_init == 0 && entropy < POOL_MIN_BITS)) {
 		size_t ret = crng_pre_init_inject(buffer, count, true);
 		mix_pool_bytes(buffer, ret);
 		count -= ret;


