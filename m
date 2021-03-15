Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797EF33B508
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhCONxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:53:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229925AbhCONw7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:52:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CE4364EEA;
        Mon, 15 Mar 2021 13:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816379;
        bh=jOpDPpgEsA13zoS/dxdsfNX/nyqPhE7M1ix198zZL+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQmme72zwq1yenh5NnW6DSpW1agOpQwn9rzME0daY/lC9LOa4ZZMCfga505i7xsgt
         lhkr9Xh/ZP7m4iTPUFKb5aaXd1QCz/2lsahycKEXldb1ECYEJJFQHRQJU/pcb8dh6B
         csibFGNuHdRPh78oJWvMviF4uXsOmslMBKbF3ESE=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        Andre Naujoks <nautsch2@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.9 06/78] can: skb: can_skb_set_owner(): fix ref counting if socket was closed before setting skb ownership
Date:   Mon, 15 Mar 2021 14:51:29 +0100
Message-Id: <20210315135212.274978979@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135212.060847074@linuxfoundation.org>
References: <20210315135212.060847074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit e940e0895a82c6fbaa259f2615eb52b57ee91a7e upstream.

There are two ref count variables controlling the free()ing of a socket:
- struct sock::sk_refcnt - which is changed by sock_hold()/sock_put()
- struct sock::sk_wmem_alloc - which accounts the memory allocated by
  the skbs in the send path.

In case there are still TX skbs on the fly and the socket() is closed,
the struct sock::sk_refcnt reaches 0. In the TX-path the CAN stack
clones an "echo" skb, calls sock_hold() on the original socket and
references it. This produces the following back trace:

| WARNING: CPU: 0 PID: 280 at lib/refcount.c:25 refcount_warn_saturate+0x114/0x134
| refcount_t: addition on 0; use-after-free.
| Modules linked in: coda_vpu(E) v4l2_jpeg(E) videobuf2_vmalloc(E) imx_vdoa(E)
| CPU: 0 PID: 280 Comm: test_can.sh Tainted: G            E     5.11.0-04577-gf8ff6603c617 #203
| Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
| Backtrace:
| [<80bafea4>] (dump_backtrace) from [<80bb0280>] (show_stack+0x20/0x24) r7:00000000 r6:600f0113 r5:00000000 r4:81441220
| [<80bb0260>] (show_stack) from [<80bb593c>] (dump_stack+0xa0/0xc8)
| [<80bb589c>] (dump_stack) from [<8012b268>] (__warn+0xd4/0x114) r9:00000019 r8:80f4a8c2 r7:83e4150c r6:00000000 r5:00000009 r4:80528f90
| [<8012b194>] (__warn) from [<80bb09c4>] (warn_slowpath_fmt+0x88/0xc8) r9:83f26400 r8:80f4a8d1 r7:00000009 r6:80528f90 r5:00000019 r4:80f4a8c2
| [<80bb0940>] (warn_slowpath_fmt) from [<80528f90>] (refcount_warn_saturate+0x114/0x134) r8:00000000 r7:00000000 r6:82b44000 r5:834e5600 r4:83f4d540
| [<80528e7c>] (refcount_warn_saturate) from [<8079a4c8>] (__refcount_add.constprop.0+0x4c/0x50)
| [<8079a47c>] (__refcount_add.constprop.0) from [<8079a57c>] (can_put_echo_skb+0xb0/0x13c)
| [<8079a4cc>] (can_put_echo_skb) from [<8079ba98>] (flexcan_start_xmit+0x1c4/0x230) r9:00000010 r8:83f48610 r7:0fdc0000 r6:0c080000 r5:82b44000 r4:834e5600
| [<8079b8d4>] (flexcan_start_xmit) from [<80969078>] (netdev_start_xmit+0x44/0x70) r9:814c0ba0 r8:80c8790c r7:00000000 r6:834e5600 r5:82b44000 r4:82ab1f00
| [<80969034>] (netdev_start_xmit) from [<809725a4>] (dev_hard_start_xmit+0x19c/0x318) r9:814c0ba0 r8:00000000 r7:82ab1f00 r6:82b44000 r5:00000000 r4:834e5600
| [<80972408>] (dev_hard_start_xmit) from [<809c6584>] (sch_direct_xmit+0xcc/0x264) r10:834e5600 r9:00000000 r8:00000000 r7:82b44000 r6:82ab1f00 r5:834e5600 r4:83f27400
| [<809c64b8>] (sch_direct_xmit) from [<809c6c0c>] (__qdisc_run+0x4f0/0x534)

To fix this problem, only set skb ownership to sockets which have still
a ref count > 0.

Fixes: 0ae89beb283a ("can: add destructor for self generated skbs")
Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Andre Naujoks <nautsch2@gmail.com>
Link: https://lore.kernel.org/r/20210226092456.27126-1-o.rempel@pengutronix.de
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/can/skb.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/include/linux/can/skb.h
+++ b/include/linux/can/skb.h
@@ -48,8 +48,12 @@ static inline void can_skb_reserve(struc
 
 static inline void can_skb_set_owner(struct sk_buff *skb, struct sock *sk)
 {
-	if (sk) {
-		sock_hold(sk);
+	/* If the socket has already been closed by user space, the
+	 * refcount may already be 0 (and the socket will be freed
+	 * after the last TX skb has been freed). So only increase
+	 * socket refcount if the refcount is > 0.
+	 */
+	if (sk && atomic_inc_not_zero(&sk->sk_refcnt)) {
 		skb->destructor = sock_efree;
 		skb->sk = sk;
 	}


