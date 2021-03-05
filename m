Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713C732E7E2
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhCEMXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:23:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:58272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229669AbhCEMXb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:23:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68AA964FED;
        Fri,  5 Mar 2021 12:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947011;
        bh=zAWYyGYJNc3+5PGuzBJamF3D3UHWFg4X/HGAlrziTdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0fXJ5bV4B77SaB0V0QBfEgjbHMhckdr1P7YXb2NxtYp8XIJwqo99Bn6koEkOcW+aE
         s4ruHHsHQG1PtJCDedGShfBDPuppUL52CLhrmjLrx6pVXG6m+Zv57gb2S1bvthRbK5
         nu5HjIIl9KFVtojZlGvdflBKzmChVuvI5zN32h88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Paasch <cpaasch@apple.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 016/104] mptcp: fix spurious retransmissions
Date:   Fri,  5 Mar 2021 13:20:21 +0100
Message-Id: <20210305120903.977847571@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

commit 64b9cea7a0afe579dd2682f1f1c04f2e4e72fd25 upstream.

Syzkaller was able to trigger the following splat again:

WARNING: CPU: 1 PID: 12512 at net/mptcp/protocol.c:761 mptcp_reset_timer+0x12a/0x160 net/mptcp/protocol.c:761
Modules linked in:
CPU: 1 PID: 12512 Comm: kworker/1:6 Not tainted 5.10.0-rc6 #52
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
Workqueue: events mptcp_worker
RIP: 0010:mptcp_reset_timer+0x12a/0x160 net/mptcp/protocol.c:761
Code: e8 4b 0c ad ff e8 56 21 88 fe 48 b8 00 00 00 00 00 fc ff df 48 c7 04 03 00 00 00 00 48 83 c4 40 5b 5d 41 5c c3 e8 36 21 88 fe <0f> 0b 41 bc c8 00 00 00 eb 98 e8 e7 b1 af fe e9 30 ff ff ff 48 c7
RSP: 0018:ffffc900018c7c68 EFLAGS: 00010293
RAX: ffff888108cb1c80 RBX: 1ffff92000318f8d RCX: ffffffff82ad0307
RDX: 0000000000000000 RSI: ffffffff82ad036a RDI: 0000000000000007
RBP: ffff888113e2d000 R08: ffff888108cb1c80 R09: ffffed10227c5ab7
R10: ffff888113e2d5b7 R11: ffffed10227c5ab6 R12: 0000000000000000
R13: ffff88801f100000 R14: ffff888113e2d5b0 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff88811b500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd76a874ef8 CR3: 000000001689c005 CR4: 0000000000170ee0
Call Trace:
 mptcp_worker+0xaa4/0x1560 net/mptcp/protocol.c:2334
 process_one_work+0x8d3/0x1200 kernel/workqueue.c:2272
 worker_thread+0x9c/0x1090 kernel/workqueue.c:2418
 kthread+0x303/0x410 kernel/kthread.c:292
 ret_from_fork+0x22/0x30 arch/x86/entry/entry_64.S:296

The mptcp_worker tries to update the MPTCP retransmission timer
even if such timer is not currently scheduled.

The mptcp_rtx_head() return value is bogus: we can have enqueued
data not yet transmitted. The above may additionally cause spurious,
unneeded MPTCP-level retransmissions.

Fix the issue adding an explicit clearing of the rtx queue before
trying to retransmit and checking for unacked data.
Additionally drop an unneeded timer stop call and the unused
mptcp_rtx_tail() helper.

Reported-by: Christoph Paasch <cpaasch@apple.com>
Fixes: 6e628cd3a8f7 ("mptcp: use mptcp release_cb for delayed tasks")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    3 +--
 net/mptcp/protocol.h |   11 ++---------
 2 files changed, 3 insertions(+), 11 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -364,8 +364,6 @@ static void mptcp_check_data_fin_ack(str
 
 	/* Look for an acknowledged DATA_FIN */
 	if (mptcp_pending_data_fin_ack(sk)) {
-		mptcp_stop_timer(sk);
-
 		WRITE_ONCE(msk->snd_data_fin_enable, 0);
 
 		switch (sk->sk_state) {
@@ -2299,6 +2297,7 @@ static void mptcp_worker(struct work_str
 	if (!test_and_clear_bit(MPTCP_WORK_RTX, &msk->flags))
 		goto unlock;
 
+	__mptcp_clean_una(sk);
 	dfrag = mptcp_rtx_head(sk);
 	if (!dfrag)
 		goto unlock;
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -325,20 +325,13 @@ static inline struct mptcp_data_frag *mp
 	return list_last_entry(&msk->rtx_queue, struct mptcp_data_frag, list);
 }
 
-static inline struct mptcp_data_frag *mptcp_rtx_tail(const struct sock *sk)
+static inline struct mptcp_data_frag *mptcp_rtx_head(const struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	if (!before64(msk->snd_nxt, READ_ONCE(msk->snd_una)))
+	if (msk->snd_una == READ_ONCE(msk->snd_nxt))
 		return NULL;
 
-	return list_last_entry(&msk->rtx_queue, struct mptcp_data_frag, list);
-}
-
-static inline struct mptcp_data_frag *mptcp_rtx_head(const struct sock *sk)
-{
-	struct mptcp_sock *msk = mptcp_sk(sk);
-
 	return list_first_entry_or_null(&msk->rtx_queue, struct mptcp_data_frag, list);
 }
 


