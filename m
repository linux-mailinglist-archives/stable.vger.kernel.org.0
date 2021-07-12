Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66B33C50E1
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237223AbhGLHfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:35:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241000AbhGLHcq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:32:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96D5760FF3;
        Mon, 12 Jul 2021 07:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074978;
        bh=/rBBF4qMlCt4NrqwlKdNtuol+V1/VqI44xAxJt0pufk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=liPEssjt5mvq2/lzouX85dmGlK11rp0sMi2drsfd6kNXt+OI6vTcsXfIvMhZ9ibKt
         f5Lh6MShEO1fwn7zyU7HqbjOlFVs1gke21hYfKuaHVrDPAJCZzl2G/xbOf9YNlYll6
         yWnIEMXm1tbQoMn7eXujBRlYHFFjSpLIgEI9C1gQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.13 062/800] can: isotp: isotp_release(): omit unintended hrtimer restart on socket release
Date:   Mon, 12 Jul 2021 08:01:25 +0200
Message-Id: <20210712060922.070459204@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 14a4696bc3118ba49da28f79280e1d55603aa737 upstream.

When closing the isotp socket, the potentially running hrtimers are
canceled before removing the subscription for CAN identifiers via
can_rx_unregister().

This may lead to an unintended (re)start of a hrtimer in
isotp_rcv_cf() and isotp_rcv_fc() in the case that a CAN frame is
received by isotp_rcv() while the subscription removal is processed.

However, isotp_rcv() is called under RCU protection, so after calling
can_rx_unregister, we may call synchronize_rcu in order to wait for
any RCU read-side critical sections to finish. This prevents the
reception of CAN frames after hrtimer_cancel() and therefore the
unintended (re)start of the hrtimers.

Link: https://lore.kernel.org/r/20210618173713.2296-1-socketcan@hartkopp.net
Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/can/isotp.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1028,9 +1028,6 @@ static int isotp_release(struct socket *
 
 	lock_sock(sk);
 
-	hrtimer_cancel(&so->txtimer);
-	hrtimer_cancel(&so->rxtimer);
-
 	/* remove current filters & unregister */
 	if (so->bound && (!(so->opt.flags & CAN_ISOTP_SF_BROADCAST))) {
 		if (so->ifindex) {
@@ -1042,10 +1039,14 @@ static int isotp_release(struct socket *
 						  SINGLE_MASK(so->rxid),
 						  isotp_rcv, sk);
 				dev_put(dev);
+				synchronize_rcu();
 			}
 		}
 	}
 
+	hrtimer_cancel(&so->txtimer);
+	hrtimer_cancel(&so->rxtimer);
+
 	so->ifindex = 0;
 	so->bound = 0;
 


