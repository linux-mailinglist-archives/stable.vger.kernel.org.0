Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297EC43A136
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236162AbhJYThu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:37:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236573AbhJYTe5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:34:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43166610C8;
        Mon, 25 Oct 2021 19:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190287;
        bh=zdKgZyh2zyMlaaeqeVL+2k6iSsVp9MWQg7DLL/SSnOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pynn3FZhZLaAlyqLKPeI81J60Z+NcQuqrLWDlJWayxsnbxYwwhrG5+8MbZ2hXEi9S
         9kuA0CDDu2EEFu7x8GoqpH1lJvyvB+602BigNPtKhoLjHMfguw7EWRw0U/lpRHXup6
         g/YYDoctNUPsnWgdL0PszbyRCWqDIcfii7/0+7zE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+78bab6958a614b0c80b9@syzkaller.appspotmail.com,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 38/95] can: isotp: isotp_sendmsg(): add result check for wait_event_interruptible()
Date:   Mon, 25 Oct 2021 21:14:35 +0200
Message-Id: <20211025191002.297023883@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

commit 9acf636215a6ce9362fe618e7da4913b8bfe84c8 upstream.

Using wait_event_interruptible() to wait for complete transmission,
but do not check the result of wait_event_interruptible() which can be
interrupted. It will result in TX buffer has multiple accessors and
the later process interferes with the previous process.

Following is one of the problems reported by syzbot.

=============================================================
WARNING: CPU: 0 PID: 0 at net/can/isotp.c:840 isotp_tx_timer_handler+0x2e0/0x4c0
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.13.0-rc7+ #68
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
RIP: 0010:isotp_tx_timer_handler+0x2e0/0x4c0
Call Trace:
 <IRQ>
 ? isotp_setsockopt+0x390/0x390
 __hrtimer_run_queues+0xb8/0x610
 hrtimer_run_softirq+0x91/0xd0
 ? rcu_read_lock_sched_held+0x4d/0x80
 __do_softirq+0xe8/0x553
 irq_exit_rcu+0xf8/0x100
 sysvec_apic_timer_interrupt+0x9e/0xc0
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20

Add result check for wait_event_interruptible() in isotp_sendmsg()
to avoid multiple accessers for tx buffer.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Link: https://lore.kernel.org/all/10ca695732c9dd267c76a3c30f37aefe1ff7e32f.1633764159.git.william.xuanziyang@huawei.com
Cc: stable@vger.kernel.org
Reported-by: syzbot+78bab6958a614b0c80b9@syzkaller.appspotmail.com
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -863,7 +863,9 @@ static int isotp_sendmsg(struct socket *
 			return -EAGAIN;
 
 		/* wait for complete transmission of current pdu */
-		wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
+		err = wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
+		if (err)
+			return err;
 	}
 
 	if (!size || size > MAX_MSG_LENGTH)


