Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B766C5582F9
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbiFWRXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233769AbiFWRWb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:22:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAFB826A9;
        Thu, 23 Jun 2022 10:01:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3243261408;
        Thu, 23 Jun 2022 17:01:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FC2C3411B;
        Thu, 23 Jun 2022 17:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003673;
        bh=IuH4ic1YsBToeSvLd3jNZS1lfWQ/zJnN8Ztg8qqvwV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgpC6F6qDet1kdPkIZzth5BiIltb+CWco9wLcOu5LsMEBK3sPpYG5uooT/bJkqn8T
         b2q4VPOL9Hmk0UaiRnLWDFi2hLhy9dhmanhJYBjwxU8Z51z0jZImz/KuLDewiSFdFD
         CUGl9PEwUd0m9zCoxUb1SIVzhnn/mSDfQcN2kUKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Theodore Tso" <tytso@mit.edu>,
        Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 009/237] random: remove preempt disabled region
Date:   Thu, 23 Jun 2022 18:40:43 +0200
Message-Id: <20220623164343.416061929@linuxfoundation.org>
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

From: Ingo Molnar <mingo@elte.hu>

commit b34fbaa9289328c7aec67d2b8b8b7d02bc61c67d upstream.

No need to keep preemption disabled across the whole function.

mix_pool_bytes() uses a spin_lock() to protect the pool and there are
other places like write_pool() whhich invoke mix_pool_bytes() without
disabling preemption.
credit_entropy_bits() is invoked from other places like
add_hwgenerator_randomness() without disabling preemption.

Before commit 95b709b6be49 ("random: drop trickle mode") the function
used __this_cpu_inc_return() which would require disabled preemption.
The preempt_disable() section was added in commit 43d5d3018c37 ("[PATCH]
random driver preempt robustness", history tree).  It was claimed that
the code relied on "vt_ioctl() being called under BKL".

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bigeasy: enhance the commit message]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1136,8 +1136,6 @@ static void add_timer_randomness(struct
 	} sample;
 	long delta, delta2, delta3;
 
-	preempt_disable();
-
 	sample.jiffies = jiffies;
 	sample.cycles = random_get_entropy();
 	sample.num = num;
@@ -1175,8 +1173,6 @@ static void add_timer_randomness(struct
 	 * and limit entropy entimate to 12 bits.
 	 */
 	credit_entropy_bits(r, min_t(int, fls(delta>>1), 11));
-
-	preempt_enable();
 }
 
 void add_input_randomness(unsigned int type, unsigned int code,


