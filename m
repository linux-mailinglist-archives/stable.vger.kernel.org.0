Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14A434C8F2
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbhC2IZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:25:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233131AbhC2IYC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:24:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA43E614A7;
        Mon, 29 Mar 2021 08:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006230;
        bh=maZLklevpeKGFhw+kRt1hXzJbYfrna0g4eQsOohi0eE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LySZCGbw7H+gMuNAeJ4FiP5JbwycYAThkBX6sDdtyiAPjWlXHnojOtFOZUuOPHxs/
         QYehEgyCM+MlpstPuyRA6/7UADvUaxsc2GTnw9ePFhXo5NFiPaj7nqvaHaKgAyPCE6
         Fd/L9cRYnR+b2galW0dn8qt4d19Z0pXrm7HpS1Dg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 165/221] can: isotp: tx-path: zero initialize outgoing CAN frames
Date:   Mon, 29 Mar 2021 09:58:16 +0200
Message-Id: <20210329075634.646178240@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

[ Upstream commit b5f020f82a8e41201c6ede20fa00389d6980b223 ]

Commit d4eb538e1f48 ("can: isotp: TX-path: ensure that CAN frame flags are
initialized") ensured the TX flags to be properly set for outgoing CAN
frames.

In fact the root cause of the issue results from a missing initialization
of outgoing CAN frames created by isotp. This is no problem on the CAN bus
as the CAN driver only picks the correctly defined content from the struct
can(fd)_frame. But when the outgoing frames are monitored (e.g. with
candump) we potentially leak some bytes in the unused content of
struct can(fd)_frame.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/r/20210319100619.10858-1-socketcan@hartkopp.net
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/isotp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index b01662d2f2cd..ea1e227b8e54 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -196,7 +196,7 @@ static int isotp_send_fc(struct sock *sk, int ae, u8 flowstatus)
 	nskb->dev = dev;
 	can_skb_set_owner(nskb, sk);
 	ncf = (struct canfd_frame *)nskb->data;
-	skb_put(nskb, so->ll.mtu);
+	skb_put_zero(nskb, so->ll.mtu);
 
 	/* create & send flow control reply */
 	ncf->can_id = so->txid;
@@ -779,7 +779,7 @@ isotp_tx_burst:
 		can_skb_prv(skb)->skbcnt = 0;
 
 		cf = (struct canfd_frame *)skb->data;
-		skb_put(skb, so->ll.mtu);
+		skb_put_zero(skb, so->ll.mtu);
 
 		/* create consecutive frame */
 		isotp_fill_dataframe(cf, so, ae, 0);
@@ -887,7 +887,7 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	so->tx.idx = 0;
 
 	cf = (struct canfd_frame *)skb->data;
-	skb_put(skb, so->ll.mtu);
+	skb_put_zero(skb, so->ll.mtu);
 
 	/* take care of a potential SF_DL ESC offset for TX_DL > 8 */
 	off = (so->tx.ll_dl > CAN_MAX_DLEN) ? 1 : 0;
-- 
2.30.1



