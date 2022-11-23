Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6A86353E6
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236931AbiKWJCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236972AbiKWJCK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:02:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C102FFAB7
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:02:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF6B961B43
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:02:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9838C433D6;
        Wed, 23 Nov 2022 09:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194128;
        bh=ozvKxBch8i4IK4aMjrMX0xPTwZ1icZ+HFk7kcr4vvhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sivYdCDkx5lY3rEeUrN7HEd5AC0CTqKcsTtZcqe6VRQ/AUnJjWBIu5N58/LC7EBzk
         Uu7DOOJ7qXl3i4RiEv+0jtLK5FAUX94LS2i9RXsYaBg4hmN303eTT9JIhuymqs8pfP
         6aGSG/MzZv5dley2OLGIjPQyP/HEGVeSktEqmGZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        Tom Herbert <tom@herbertland.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 78/88] kcm: avoid potential race in kcm_tx_work
Date:   Wed, 23 Nov 2022 09:51:15 +0100
Message-Id: <20221123084551.382939122@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
References: <20221123084548.535439312@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit ec7eede369fe5b0d085ac51fdbb95184f87bfc6c upstream.

syzbot found that kcm_tx_work() could crash [1] in:

	/* Primarily for SOCK_SEQPACKET sockets */
	if (likely(sk->sk_socket) &&
	    test_bit(SOCK_NOSPACE, &sk->sk_socket->flags)) {
<<*>>	clear_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
		sk->sk_write_space(sk);
	}

I think the reason is that another thread might concurrently
run in kcm_release() and call sock_orphan(sk) while sk is not
locked. kcm_tx_work() find sk->sk_socket being NULL.

[1]
BUG: KASAN: null-ptr-deref in instrument_atomic_write include/linux/instrumented.h:86 [inline]
BUG: KASAN: null-ptr-deref in clear_bit include/asm-generic/bitops/instrumented-atomic.h:41 [inline]
BUG: KASAN: null-ptr-deref in kcm_tx_work+0xff/0x160 net/kcm/kcmsock.c:742
Write of size 8 at addr 0000000000000008 by task kworker/u4:3/53

CPU: 0 PID: 53 Comm: kworker/u4:3 Not tainted 5.19.0-rc3-next-20220621-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: kkcmd kcm_tx_work
Call Trace:
<TASK>
__dump_stack lib/dump_stack.c:88 [inline]
dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
kasan_report+0xbe/0x1f0 mm/kasan/report.c:495
check_region_inline mm/kasan/generic.c:183 [inline]
kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
instrument_atomic_write include/linux/instrumented.h:86 [inline]
clear_bit include/asm-generic/bitops/instrumented-atomic.h:41 [inline]
kcm_tx_work+0xff/0x160 net/kcm/kcmsock.c:742
process_one_work+0x996/0x1610 kernel/workqueue.c:2289
worker_thread+0x665/0x1080 kernel/workqueue.c:2436
kthread+0x2e9/0x3a0 kernel/kthread.c:376
ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
</TASK>

Fixes: ab7ac4eb9832 ("kcm: Kernel Connection Multiplexor module")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Tom Herbert <tom@herbertland.com>
Link: https://lore.kernel.org/r/20221012133412.519394-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/kcm/kcmsock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -1850,10 +1850,10 @@ static int kcm_release(struct socket *so
 	kcm = kcm_sk(sk);
 	mux = kcm->mux;
 
+	lock_sock(sk);
 	sock_orphan(sk);
 	kfree_skb(kcm->seq_skb);
 
-	lock_sock(sk);
 	/* Purge queue under lock to avoid race condition with tx_work trying
 	 * to act when queue is nonempty. If tx_work runs after this point
 	 * it will just return.


