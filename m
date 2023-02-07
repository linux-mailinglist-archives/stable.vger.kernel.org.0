Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69E068D823
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbjBGNGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbjBGNGX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:06:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36823BD85
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:05:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D04AF61408
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:05:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBD1C433EF;
        Tue,  7 Feb 2023 13:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775137;
        bh=35uBNXtQPsapA7GZ9vvjWjNs3pb20izQAzpUwZI5WjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z6m/ocPIgUP109rJzWmR5D5JZVI57ASSJrCDWfyrXol5Ki/nQPUjXfdws8JylHFuZ
         I7hmEFgeXh1DxQ9KuH5UQVaF82b4YgH7Z+uAJX0MuEPrjwcBT5RYgKo7T1MMU5BmqR
         7gDuuxmC1XADRlPZwoR0WPN/LwNt4XBovOu2zlMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+5aed6c3aaba661f5b917@syzkaller.appspotmail.com,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 120/208] can: isotp: split tx timer into transmission and timeout
Date:   Tue,  7 Feb 2023 13:56:14 +0100
Message-Id: <20230207125639.837825335@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 4f027cba8216f42a18b544842efab134f8b1f9f4 upstream.

The timer for the transmission of isotp PDUs formerly had two functions:
1. send two consecutive frames with a given time gap
2. monitor the timeouts for flow control frames and the echo frames

This led to larger txstate checks and potentially to a problem discovered
by syzbot which enabled the panic_on_warn feature while testing.

The former 'txtimer' function is split into 'txfrtimer' and 'txtimer'
to handle the two above functionalities with separate timer callbacks.

The two simplified timers now run in one-shot mode and make the state
transitions (especially with isotp_rcv_echo) better understandable.

Fixes: 866337865f37 ("can: isotp: fix tx state handling for echo tx processing")
Reported-by: syzbot+5aed6c3aaba661f5b917@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org # >= v6.0
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20230104145701.2422-1-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |   65 ++++++++++++++++++++++++--------------------------------
 1 file changed, 29 insertions(+), 36 deletions(-)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -140,7 +140,7 @@ struct isotp_sock {
 	canid_t rxid;
 	ktime_t tx_gap;
 	ktime_t lastrxcf_tstamp;
-	struct hrtimer rxtimer, txtimer;
+	struct hrtimer rxtimer, txtimer, txfrtimer;
 	struct can_isotp_options opt;
 	struct can_isotp_fc_options rxfc, txfc;
 	struct can_isotp_ll_options ll;
@@ -871,7 +871,7 @@ static void isotp_rcv_echo(struct sk_buf
 	}
 
 	/* start timer to send next consecutive frame with correct delay */
-	hrtimer_start(&so->txtimer, so->tx_gap, HRTIMER_MODE_REL_SOFT);
+	hrtimer_start(&so->txfrtimer, so->tx_gap, HRTIMER_MODE_REL_SOFT);
 }
 
 static enum hrtimer_restart isotp_tx_timer_handler(struct hrtimer *hrtimer)
@@ -879,49 +879,39 @@ static enum hrtimer_restart isotp_tx_tim
 	struct isotp_sock *so = container_of(hrtimer, struct isotp_sock,
 					     txtimer);
 	struct sock *sk = &so->sk;
-	enum hrtimer_restart restart = HRTIMER_NORESTART;
 
-	switch (so->tx.state) {
-	case ISOTP_SENDING:
+	/* don't handle timeouts in IDLE state */
+	if (so->tx.state == ISOTP_IDLE)
+		return HRTIMER_NORESTART;
 
-		/* cfecho should be consumed by isotp_rcv_echo() here */
-		if (!so->cfecho) {
-			/* start timeout for unlikely lost echo skb */
-			hrtimer_set_expires(&so->txtimer,
-					    ktime_add(ktime_get(),
-						      ktime_set(ISOTP_ECHO_TIMEOUT, 0)));
-			restart = HRTIMER_RESTART;
+	/* we did not get any flow control or echo frame in time */
 
-			/* push out the next consecutive frame */
-			isotp_send_cframe(so);
-			break;
-		}
-
-		/* cfecho has not been cleared in isotp_rcv_echo() */
-		pr_notice_once("can-isotp: cfecho %08X timeout\n", so->cfecho);
-		fallthrough;
+	/* report 'communication error on send' */
+	sk->sk_err = ECOMM;
+	if (!sock_flag(sk, SOCK_DEAD))
+		sk_error_report(sk);
 
-	case ISOTP_WAIT_FC:
-	case ISOTP_WAIT_FIRST_FC:
+	/* reset tx state */
+	so->tx.state = ISOTP_IDLE;
+	wake_up_interruptible(&so->wait);
 
-		/* we did not get any flow control frame in time */
+	return HRTIMER_NORESTART;
+}
 
-		/* report 'communication error on send' */
-		sk->sk_err = ECOMM;
-		if (!sock_flag(sk, SOCK_DEAD))
-			sk_error_report(sk);
+static enum hrtimer_restart isotp_txfr_timer_handler(struct hrtimer *hrtimer)
+{
+	struct isotp_sock *so = container_of(hrtimer, struct isotp_sock,
+					     txfrtimer);
 
-		/* reset tx state */
-		so->tx.state = ISOTP_IDLE;
-		wake_up_interruptible(&so->wait);
-		break;
+	/* start echo timeout handling and cover below protocol error */
+	hrtimer_start(&so->txtimer, ktime_set(ISOTP_ECHO_TIMEOUT, 0),
+		      HRTIMER_MODE_REL_SOFT);
 
-	default:
-		WARN_ONCE(1, "can-isotp: tx timer state %08X cfecho %08X\n",
-			  so->tx.state, so->cfecho);
-	}
+	/* cfecho should be consumed by isotp_rcv_echo() here */
+	if (so->tx.state == ISOTP_SENDING && !so->cfecho)
+		isotp_send_cframe(so);
 
-	return restart;
+	return HRTIMER_NORESTART;
 }
 
 static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
@@ -1194,6 +1184,7 @@ static int isotp_release(struct socket *
 		}
 	}
 
+	hrtimer_cancel(&so->txfrtimer);
 	hrtimer_cancel(&so->txtimer);
 	hrtimer_cancel(&so->rxtimer);
 
@@ -1597,6 +1588,8 @@ static int isotp_init(struct sock *sk)
 	so->rxtimer.function = isotp_rx_timer_handler;
 	hrtimer_init(&so->txtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_SOFT);
 	so->txtimer.function = isotp_tx_timer_handler;
+	hrtimer_init(&so->txfrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_SOFT);
+	so->txfrtimer.function = isotp_txfr_timer_handler;
 
 	init_waitqueue_head(&so->wait);
 	spin_lock_init(&so->rx_lock);


