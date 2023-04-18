Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74396E6427
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbjDRMqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbjDRMqf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:46:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C00614F41
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:46:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AA75633A6
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C1BC433EF;
        Tue, 18 Apr 2023 12:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821993;
        bh=S25VDnCp8RQihbAz8ao1fgLNYX9CuiTx8r5yEZM5z60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P4o+BsRtQ61QXuBDdcOYf0XLU9oDkRR01S48DDS6dG/CgNgZDPv+fZ0l+ZMW8LWkV
         nTP8ruzoE/orCUE+DhcJ98tSbQYpk2Ov4HFE3vA2QmS/ZTijih7GIalYAN8UmGYqZi
         1saa1xv4MhkRhDN8u0oXktzSBHikZ/9cfKPlJAwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Paasch <cpaasch@apple.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 117/134] mptcp: stricter state check in mptcp_worker
Date:   Tue, 18 Apr 2023 14:22:53 +0200
Message-Id: <20230418120317.261282619@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

commit d6a0443733434408f2cbd4c53fea6910599bab9e upstream.

As reported by Christoph, the mptcp protocol can run the
worker when the relevant msk socket is in an unexpected state:

connect()
// incoming reset + fastclose
// the mptcp worker is scheduled
mptcp_disconnect()
// msk is now CLOSED
listen()
mptcp_worker()

Leading to the following splat:

divide error: 0000 [#1] PREEMPT SMP
CPU: 1 PID: 21 Comm: kworker/1:0 Not tainted 6.3.0-rc1-gde5e8fd0123c #11
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
Workqueue: events mptcp_worker
RIP: 0010:__tcp_select_window+0x22c/0x4b0 net/ipv4/tcp_output.c:3018
RSP: 0018:ffffc900000b3c98 EFLAGS: 00010293
RAX: 000000000000ffd7 RBX: 000000000000ffd7 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff8214ce97 RDI: 0000000000000004
RBP: 000000000000ffd7 R08: 0000000000000004 R09: 0000000000010000
R10: 000000000000ffd7 R11: ffff888005afa148 R12: 000000000000ffd7
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88803ed00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000405270 CR3: 000000003011e006 CR4: 0000000000370ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 tcp_select_window net/ipv4/tcp_output.c:262 [inline]
 __tcp_transmit_skb+0x356/0x1280 net/ipv4/tcp_output.c:1345
 tcp_transmit_skb net/ipv4/tcp_output.c:1417 [inline]
 tcp_send_active_reset+0x13e/0x320 net/ipv4/tcp_output.c:3459
 mptcp_check_fastclose net/mptcp/protocol.c:2530 [inline]
 mptcp_worker+0x6c7/0x800 net/mptcp/protocol.c:2705
 process_one_work+0x3bd/0x950 kernel/workqueue.c:2390
 worker_thread+0x5b/0x610 kernel/workqueue.c:2537
 kthread+0x138/0x170 kernel/kthread.c:376
 ret_from_fork+0x2c/0x50 arch/x86/entry/entry_64.S:308
 </TASK>

This change addresses the issue explicitly checking for bad states
before running the mptcp worker.

Fixes: e16163b6e2b7 ("mptcp: refactor shutdown and close")
Cc: stable@vger.kernel.org
Reported-by: Christoph Paasch <cpaasch@apple.com>
Link: https://github.com/multipath-tcp/mptcp_net-next/issues/374
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Tested-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2638,7 +2638,7 @@ static void mptcp_worker(struct work_str
 
 	lock_sock(sk);
 	state = sk->sk_state;
-	if (unlikely(state == TCP_CLOSE))
+	if (unlikely((1 << state) & (TCPF_CLOSE | TCPF_LISTEN)))
 		goto unlock;
 
 	mptcp_check_data_fin_ack(sk);


