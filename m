Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B52DE536142
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245119AbiE0L6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352994AbiE0Lzx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:55:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8085B15E4B7;
        Fri, 27 May 2022 04:49:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13C9861D9F;
        Fri, 27 May 2022 11:49:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C403C3411B;
        Fri, 27 May 2022 11:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652172;
        bh=KTs+xomYX51L3KBxgiY1mlchgYaaGZ2z5mj5sA2Wqxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v+3+zOKe5uRFSHrX/g0IYAJDtbrxP0RrGmGwZQT3buyn0nWYuyGUD1KNT/SaQq2KA
         f1EQaKMHV9oZJKsZbaMb+77YOfRJZj52IfgEdcnkvcgnVgHuzGlsdj8JoqH8ia2AS0
         7+vBaWBu3/G1LlilTV5NuOalpDd2MkhJjVlYz1CY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 108/163] random: check for signal and try earlier when generating entropy
Date:   Fri, 27 May 2022 10:49:48 +0200
Message-Id: <20220527084843.144719116@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
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

commit 3e504d2026eb6c8762cd6040ae57db166516824a upstream.

Rather than waiting a full second in an interruptable waiter before
trying to generate entropy, try to generate entropy first and wait
second. While waiting one second might give an extra second for getting
entropy from elsewhere, we're already pretty late in the init process
here, and whatever else is generating entropy will still continue to
contribute. This has implications on signal handling: we call
try_to_generate_entropy() from wait_for_random_bytes(), and
wait_for_random_bytes() always uses wait_event_interruptible_timeout()
when waiting, since it's called by userspace code in restartable
contexts, where signals can pend. Since try_to_generate_entropy() now
runs first, if a signal is pending, it's necessary for
try_to_generate_entropy() to check for signals, since it won't hit the
wait until after try_to_generate_entropy() has returned. And even before
this change, when entering a busy loop in try_to_generate_entropy(), we
should have been checking to see if any signals are pending, so that a
process doesn't get stuck in that loop longer than expected.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -127,10 +127,11 @@ int wait_for_random_bytes(void)
 {
 	while (!crng_ready()) {
 		int ret;
+
+		try_to_generate_entropy();
 		ret = wait_event_interruptible_timeout(crng_init_wait, crng_ready(), HZ);
 		if (ret)
 			return ret > 0 ? 0 : ret;
-		try_to_generate_entropy();
 	}
 	return 0;
 }
@@ -1371,7 +1372,7 @@ static void try_to_generate_entropy(void
 		return;
 
 	timer_setup_on_stack(&stack.timer, entropy_timer, 0);
-	while (!crng_ready()) {
+	while (!crng_ready() && !signal_pending(current)) {
 		if (!timer_pending(&stack.timer))
 			mod_timer(&stack.timer, jiffies + 1);
 		mix_pool_bytes(&stack.cycles, sizeof(stack.cycles));


