Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9E4551AE9
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347844AbiFTNpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349572AbiFTNoc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:44:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9092CDD2;
        Mon, 20 Jun 2022 06:16:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 345E4B811E1;
        Mon, 20 Jun 2022 13:16:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F479C3411B;
        Mon, 20 Jun 2022 13:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730982;
        bh=B1KcBXihG84hUbxR5ankUmNavS3EMHs70nPIAU0OEnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GCyD76Z6n/CNUBmBEtYHQ/uWIP+eQTb2kGE5AhlZHwHNI/nq13N/NL7+V0/nffIl7
         slX9BlrzpITInIn4yRxKx6zzdLsH3riwqXWjnIqBZTt6fQ9aecVZ2uiJ38SBA0/agT
         Er+pc3Eq+tQhVnUipvyZR1JsdKXhBkoBS/n75XdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 117/240] random: check for signal and try earlier when generating entropy
Date:   Mon, 20 Jun 2022 14:50:18 +0200
Message-Id: <20220620124742.404159356@linuxfoundation.org>
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
@@ -1366,7 +1367,7 @@ static void try_to_generate_entropy(void
 		return;
 
 	timer_setup_on_stack(&stack.timer, entropy_timer, 0);
-	while (!crng_ready()) {
+	while (!crng_ready() && !signal_pending(current)) {
 		if (!timer_pending(&stack.timer))
 			mod_timer(&stack.timer, jiffies + 1);
 		mix_pool_bytes(&stack.cycles, sizeof(stack.cycles));


