Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAD6F558045
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbiFWQrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbiFWQqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:46:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C168A49B75;
        Thu, 23 Jun 2022 09:46:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22ED561F85;
        Thu, 23 Jun 2022 16:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A30AC3411B;
        Thu, 23 Jun 2022 16:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002795;
        bh=Yv8CjKqydAz/Fpz5QLw4VQmmWsQMsONZHOvoeqnMo4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K5l73IYFCRb09bdatV14rHGYNzG6TB4mAMpCsUuAin5U+GcrbT0zIIWRVQ+shuc4W
         QQXrwwp4K7LBWP3VNFKlmunuqw8aVa5vtCPZSkgpj8xItIXHFILoIci1uPX8fu0gyD
         y0CMt2Tp66NVSlT3mXpXtySXg5+9V59N6jBc7RXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 028/264] random: optimize add_interrupt_randomness
Date:   Thu, 23 Jun 2022 18:40:21 +0200
Message-Id: <20220623164344.866224048@linuxfoundation.org>
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

From: Andi Kleen <ak@linux.intel.com>

commit e8e8a2e47db6bb85bb0cb21e77b5c6aaedf864b4 upstream.

add_interrupt_randomess always wakes up
code blocking on /dev/random. This wake up is done
unconditionally. Unfortunately this means all interrupts
take the wait queue spinlock, which can be rather expensive
on large systems processing lots of interrupts.

We saw 1% cpu time spinning on this on a large macro workload
running on a large system.

I believe it's a recent regression (?)

Always check if there is a waiter on the wait queue
before waking up. This check can be done without
taking a spinlock.

1.06%         10460  [kernel.vmlinux] [k] native_queued_spin_lock_slowpath
         |
         ---native_queued_spin_lock_slowpath
            |
             --0.57%--_raw_spin_lock_irqsave
                       |
                        --0.56%--__wake_up_common_lock
                                  credit_entropy_bits
                                  add_interrupt_randomness
                                  handle_irq_event_percpu
                                  handle_irq_event
                                  handle_edge_irq
                                  handle_irq
                                  do_IRQ
                                  common_interrupt

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -722,7 +722,8 @@ retry:
 		}
 
 		/* should we wake readers? */
-		if (entropy_bits >= random_read_wakeup_bits) {
+		if (entropy_bits >= random_read_wakeup_bits &&
+		    wq_has_sleeper(&random_read_wait)) {
 			wake_up_interruptible(&random_read_wait);
 			kill_fasync(&fasync, SIGIO, POLL_IN);
 		}


