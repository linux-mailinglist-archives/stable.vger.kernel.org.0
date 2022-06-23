Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0292D558043
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbiFWQtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232758AbiFWQsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:48:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD5C4BFE4;
        Thu, 23 Jun 2022 09:47:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8D9961FA4;
        Thu, 23 Jun 2022 16:47:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2BAC3411B;
        Thu, 23 Jun 2022 16:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002852;
        bh=GgW9rHCAKlZa1bYGLTKcS4p/eIUuL+qSoAlKD2rXBzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gDSQe5xh11HX0SwQa9xW2kce7T+BMdb6QzTc2C2UfS4DzGke8OJpe0moLB5DDVmMt
         35j/4Qd0B3M3YBjCVAaQoLfTlTwNe2sVFdYThyrl5Qj1KOPvGhP5zZZcP/ev1rxYYv
         dKiMKxDk+Dhyuwc4FQbL52+xAkbARdLgrZGsE5DI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 048/264] Revert "hwrng: core - Freeze khwrng thread during suspend"
Date:   Thu, 23 Jun 2022 18:40:41 +0200
Message-Id: <20220623164345.430102071@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
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

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 08e97aec700aeff54c4847f170e566cbd7e14e81 upstream.

This reverts commit 03a3bb7ae631 ("hwrng: core - Freeze khwrng
thread during suspend"), ff296293b353 ("random: Support freezable
kthreads in add_hwgenerator_randomness()") and 59b569480dc8 ("random:
Use wait_event_freezable() in add_hwgenerator_randomness()").

These patches introduced regressions and we need more time to
get them ready for mainline.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -327,7 +327,6 @@
 #include <linux/percpu.h>
 #include <linux/cryptohash.h>
 #include <linux/fips.h>
-#include <linux/freezer.h>
 #include <linux/ptrace.h>
 #include <linux/kmemcheck.h>
 #include <linux/workqueue.h>
@@ -2484,8 +2483,7 @@ void add_hwgenerator_randomness(const ch
 	 * We'll be woken up again once below random_write_wakeup_thresh,
 	 * or when the calling thread is about to terminate.
 	 */
-	wait_event_freezable(random_write_wait,
-			kthread_should_stop() ||
+	wait_event_interruptible(random_write_wait, kthread_should_stop() ||
 			ENTROPY_BITS(&input_pool) <= random_write_wakeup_bits);
 	mix_pool_bytes(poolp, buffer, count);
 	credit_entropy_bits(poolp, entropy);


