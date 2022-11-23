Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4716E63593A
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236414AbiKWKIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:08:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236022AbiKWKHV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:07:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E773252B2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:57:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19B67B81EE5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B239C433C1;
        Wed, 23 Nov 2022 09:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197464;
        bh=wt3XbCM6A1KA2PCRzQwfOqepKwTedlpJnOEaesghM9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=05FpdQKew9FKUkVe8Wa/QyXWunYq1wkN80tNvIo8CRV8s/dRXvnyaypmKVzmm1GW/
         5PSgB3RoCW4Ci7jG6/yvBpLMWrvThLbLRp9JcVz469xa6aECk05KFoL+qb7bTOUyOc
         lgrUupn3gIeW5urXfM5aljSI+eGk+nwKupSxsiEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        Tom Herbert <tom@herbertland.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.0 300/314] kcm: avoid potential race in kcm_tx_work
Date:   Wed, 23 Nov 2022 09:52:25 +0100
Message-Id: <20221123084639.144930835@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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
@@ -1799,10 +1799,10 @@ static int kcm_release(struct socket *so
 	kcm = kcm_sk(sk);
 	mux = kcm->mux;
 
+	lock_sock(sk);
 	sock_orphan(sk);
 	kfree_skb(kcm->seq_skb);
 
-	lock_sock(sk);
 	/* Purge queue under lock to avoid race condition with tx_work trying
 	 * to act when queue is nonempty. If tx_work runs after this point
 	 * it will just return.


