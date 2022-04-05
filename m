Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D76A4F3060
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238786AbiDEJwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243782AbiDEJJQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:09:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4350BCB003;
        Tue,  5 Apr 2022 01:58:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC144B81A22;
        Tue,  5 Apr 2022 08:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0140EC385A0;
        Tue,  5 Apr 2022 08:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149111;
        bh=svLRQWbvKn7fTVcWgCPB7AJ8/y3hrUNuvu3IXuQAygw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mppxO7fte6N95emS8DHPnh1cEg4bAXkLfFHvgfJIWUhRJrVpId6fujwi7G3MwyBba
         +68XmYQ09Qj7YyqbgGgBK1/1BIJooQH1lWBtHcvXnuQZwFxZl+JZzo2TbFKhFVOBL3
         cJIEasYMmHm8EedFB2w1XOhq/e38J3OLBKZ0YSaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Yufen <wangyufen@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0599/1017] bpf, sockmap: Fix memleak in sk_psock_queue_msg
Date:   Tue,  5 Apr 2022 09:25:12 +0200
Message-Id: <20220405070412.058299189@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit 938d3480b92fa5e454b7734294f12a7b75126f09 ]

If tcp_bpf_sendmsg is running during a tear down operation we may enqueue
data on the ingress msg queue while tear down is trying to free it.

 sk1 (redirect sk2)                         sk2
 -------------------                      ---------------
tcp_bpf_sendmsg()
 tcp_bpf_send_verdict()
  tcp_bpf_sendmsg_redir()
   bpf_tcp_ingress()
                                          sock_map_close()
                                           lock_sock()
    lock_sock() ... blocking
                                           sk_psock_stop
                                            sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
                                           release_sock(sk);
    lock_sock()
    sk_mem_charge()
    get_page()
    sk_psock_queue_msg()
     sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED);
      drop_sk_msg()
    release_sock()

While drop_sk_msg(), the msg has charged memory form sk by sk_mem_charge
and has sg pages need to put. To fix we use sk_msg_free() and then kfee()
msg.

This issue can cause the following info:
WARNING: CPU: 0 PID: 9202 at net/core/stream.c:205 sk_stream_kill_queues+0xc8/0xe0
Call Trace:
 <IRQ>
 inet_csk_destroy_sock+0x55/0x110
 tcp_rcv_state_process+0xe5f/0xe90
 ? sk_filter_trim_cap+0x10d/0x230
 ? tcp_v4_do_rcv+0x161/0x250
 tcp_v4_do_rcv+0x161/0x250
 tcp_v4_rcv+0xc3a/0xce0
 ip_protocol_deliver_rcu+0x3d/0x230
 ip_local_deliver_finish+0x54/0x60
 ip_local_deliver+0xfd/0x110
 ? ip_protocol_deliver_rcu+0x230/0x230
 ip_rcv+0xd6/0x100
 ? ip_local_deliver+0x110/0x110
 __netif_receive_skb_one_core+0x85/0xa0
 process_backlog+0xa4/0x160
 __napi_poll+0x29/0x1b0
 net_rx_action+0x287/0x300
 __do_softirq+0xff/0x2fc
 do_softirq+0x79/0x90
 </IRQ>

WARNING: CPU: 0 PID: 531 at net/ipv4/af_inet.c:154 inet_sock_destruct+0x175/0x1b0
Call Trace:
 <TASK>
 __sk_destruct+0x24/0x1f0
 sk_psock_destroy+0x19b/0x1c0
 process_one_work+0x1b3/0x3c0
 ? process_one_work+0x3c0/0x3c0
 worker_thread+0x30/0x350
 ? process_one_work+0x3c0/0x3c0
 kthread+0xe6/0x110
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x22/0x30
 </TASK>

Fixes: 9635720b7c88 ("bpf, sockmap: Fix memleak on ingress msg enqueue")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20220304081145.2037182-2-wangyufen@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skmsg.h | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 18a717fe62eb..7f32dd59e751 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -310,21 +310,16 @@ static inline void sock_drop(struct sock *sk, struct sk_buff *skb)
 	kfree_skb(skb);
 }
 
-static inline void drop_sk_msg(struct sk_psock *psock, struct sk_msg *msg)
-{
-	if (msg->skb)
-		sock_drop(psock->sk, msg->skb);
-	kfree(msg);
-}
-
 static inline void sk_psock_queue_msg(struct sk_psock *psock,
 				      struct sk_msg *msg)
 {
 	spin_lock_bh(&psock->ingress_lock);
 	if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED))
 		list_add_tail(&msg->list, &psock->ingress_msg);
-	else
-		drop_sk_msg(psock, msg);
+	else {
+		sk_msg_free(psock->sk, msg);
+		kfree(msg);
+	}
 	spin_unlock_bh(&psock->ingress_lock);
 }
 
-- 
2.34.1



