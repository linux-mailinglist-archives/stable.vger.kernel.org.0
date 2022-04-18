Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDF8505457
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237761AbiDRNFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241166AbiDRNEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:04:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77CD13CDE;
        Mon, 18 Apr 2022 05:45:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0691B80E4B;
        Mon, 18 Apr 2022 12:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CBFFC385A1;
        Mon, 18 Apr 2022 12:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285923;
        bh=aB2grxo82eSSMEAM6CaepTwOHhA0YDudYnxtqcMn5/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gsEOMWmbSZZmysQ60GqXDqXlAFXbvon9Kxb1wPoey8/fGofqrmm8qNPj1ElwqVm1i
         0qyN4zx+PMOEvQnAjKefgeav00ub8V/780Qc4Z7HVFS8NmSusnCTZ4oUfqJpuHPHYx
         oJD9QC9Pxgev4LRACTaJxz/4g8/qP7aIqxTCzH/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Duoming Zhou <duoming@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 62/63] ax25: Fix NULL pointer dereferences in ax25 timers
Date:   Mon, 18 Apr 2022 14:13:59 +0200
Message-Id: <20220418121138.296778536@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121134.149115109@linuxfoundation.org>
References: <20220418121134.149115109@linuxfoundation.org>
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

From: Duoming Zhou <duoming@zju.edu.cn>

commit fc6d01ff9ef03b66d4a3a23b46fc3c3d8cf92009 upstream.

The previous commit 7ec02f5ac8a5 ("ax25: fix NPD bug in ax25_disconnect")
move ax25_disconnect into lock_sock() in order to prevent NPD bugs. But
there are race conditions that may lead to null pointer dereferences in
ax25_heartbeat_expiry(), ax25_t1timer_expiry(), ax25_t2timer_expiry(),
ax25_t3timer_expiry() and ax25_idletimer_expiry(), when we use
ax25_kill_by_device() to detach the ax25 device.

One of the race conditions that cause null pointer dereferences can be
shown as below:

      (Thread 1)                    |      (Thread 2)
ax25_connect()                      |
 ax25_std_establish_data_link()     |
  ax25_start_t1timer()              |
   mod_timer(&ax25->t1timer,..)     |
                                    | ax25_kill_by_device()
   (wait a time)                    |  ...
                                    |  s->ax25_dev = NULL; //(1)
   ax25_t1timer_expiry()            |
    ax25->ax25_dev->values[..] //(2)|  ...
     ...                            |

We set null to ax25_cb->ax25_dev in position (1) and dereference
the null pointer in position (2).

The corresponding fail log is shown below:
===============================================================
BUG: kernel NULL pointer dereference, address: 0000000000000050
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.17.0-rc6-00794-g45690b7d0
RIP: 0010:ax25_t1timer_expiry+0x12/0x40
...
Call Trace:
 call_timer_fn+0x21/0x120
 __run_timers.part.0+0x1ca/0x250
 run_timer_softirq+0x2c/0x60
 __do_softirq+0xef/0x2f3
 irq_exit_rcu+0xb6/0x100
 sysvec_apic_timer_interrupt+0xa2/0xd0
...

This patch moves ax25_disconnect() before s->ax25_dev = NULL
and uses del_timer_sync() to delete timers in ax25_disconnect().
If ax25_disconnect() is called by ax25_kill_by_device() or
ax25->ax25_dev is NULL, the reason in ax25_disconnect() will be
equal to ENETUNREACH, it will wait all timers to stop before we
set null to s->ax25_dev in ax25_kill_by_device().

Fixes: 7ec02f5ac8a5 ("ax25: fix NPD bug in ax25_disconnect")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
[OP: backport to 5.4: adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ax25/af_ax25.c   |    4 ++--
 net/ax25/ax25_subr.c |   20 ++++++++++++++------
 2 files changed, 16 insertions(+), 8 deletions(-)

--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -89,20 +89,20 @@ again:
 			sk = s->sk;
 			if (!sk) {
 				spin_unlock_bh(&ax25_list_lock);
-				s->ax25_dev = NULL;
 				ax25_disconnect(s, ENETUNREACH);
+				s->ax25_dev = NULL;
 				spin_lock_bh(&ax25_list_lock);
 				goto again;
 			}
 			sock_hold(sk);
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
+			ax25_disconnect(s, ENETUNREACH);
 			s->ax25_dev = NULL;
 			if (sk->sk_socket) {
 				dev_put(ax25_dev->dev);
 				ax25_dev_put(ax25_dev);
 			}
-			ax25_disconnect(s, ENETUNREACH);
 			release_sock(sk);
 			spin_lock_bh(&ax25_list_lock);
 			sock_put(sk);
--- a/net/ax25/ax25_subr.c
+++ b/net/ax25/ax25_subr.c
@@ -261,12 +261,20 @@ void ax25_disconnect(ax25_cb *ax25, int
 {
 	ax25_clear_queues(ax25);
 
-	if (!ax25->sk || !sock_flag(ax25->sk, SOCK_DESTROY))
-		ax25_stop_heartbeat(ax25);
-	ax25_stop_t1timer(ax25);
-	ax25_stop_t2timer(ax25);
-	ax25_stop_t3timer(ax25);
-	ax25_stop_idletimer(ax25);
+	if (reason == ENETUNREACH) {
+		del_timer_sync(&ax25->timer);
+		del_timer_sync(&ax25->t1timer);
+		del_timer_sync(&ax25->t2timer);
+		del_timer_sync(&ax25->t3timer);
+		del_timer_sync(&ax25->idletimer);
+	} else {
+		if (!ax25->sk || !sock_flag(ax25->sk, SOCK_DESTROY))
+			ax25_stop_heartbeat(ax25);
+		ax25_stop_t1timer(ax25);
+		ax25_stop_t2timer(ax25);
+		ax25_stop_t3timer(ax25);
+		ax25_stop_idletimer(ax25);
+	}
 
 	ax25->state = AX25_STATE_0;
 


