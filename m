Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE1E551D23
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348581AbiFTNqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348768AbiFTNqH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:46:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146172DD51;
        Mon, 20 Jun 2022 06:17:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12456B811A6;
        Mon, 20 Jun 2022 13:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580E2C3411B;
        Mon, 20 Jun 2022 13:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730949;
        bh=16LFNup+v25/VvNo3CxgLkxi4CTpG2cxX/qybxkt+Iw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQcO4f2uhvvJVDe7JiEtosGXtOEsFQWsgS+b3jktlLFQETbxh+iP9psgzWP8sn51+
         WzmzZAVqYaFAw+Ug7K/NxOW9txSRMbqm2gQqDsJsPPuEd+zKpMgMJxyvx3+OSqQa1M
         dqe4iPjFK+n9RFpgT2eNl7KqpYiqtLsa9Di2d5yg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Theodore Tso <tytso@mit.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 104/240] random: pull add_hwgenerator_randomness() declaration into random.h
Date:   Mon, 20 Jun 2022 14:50:05 +0200
Message-Id: <20220620124742.030172183@linuxfoundation.org>
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

commit b777c38239fec5a528e59f55b379e31b1a187524 upstream.

add_hwgenerator_randomness() is a function implemented and documented
inside of random.c. It is the way that hardware RNGs push data into it.
Therefore, it should be declared in random.h. Otherwise sparse complains
with:

random.c:1137:6: warning: symbol 'add_hwgenerator_randomness' was not declared. Should it be static?

The alternative would be to include hw_random.h into random.c, but that
wouldn't really be good for anything except slowing down compile time.

Cc: Matt Mackall <mpm@selenic.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/hw_random/core.c |    1 +
 include/linux/hw_random.h     |    2 --
 include/linux/random.h        |    2 ++
 3 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -15,6 +15,7 @@
 #include <linux/err.h>
 #include <linux/fs.h>
 #include <linux/hw_random.h>
+#include <linux/random.h>
 #include <linux/kernel.h>
 #include <linux/kthread.h>
 #include <linux/sched/signal.h>
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -60,7 +60,5 @@ extern int devm_hwrng_register(struct de
 /** Unregister a Hardware Random Number Generator driver. */
 extern void hwrng_unregister(struct hwrng *rng);
 extern void devm_hwrng_unregister(struct device *dve, struct hwrng *rng);
-/** Feed random bits into the pool. */
-extern void add_hwgenerator_randomness(const void *buffer, size_t count, size_t entropy);
 
 #endif /* LINUX_HWRANDOM_H_ */
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -32,6 +32,8 @@ static inline void add_latent_entropy(vo
 extern void add_input_randomness(unsigned int type, unsigned int code,
 				 unsigned int value) __latent_entropy;
 extern void add_interrupt_randomness(int irq) __latent_entropy;
+extern void add_hwgenerator_randomness(const void *buffer, size_t count,
+				       size_t entropy);
 
 extern void get_random_bytes(void *buf, size_t nbytes);
 extern int wait_for_random_bytes(void);


