Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E076234C89E
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233530AbhC2IXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:23:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233630AbhC2IWA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:22:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B805161932;
        Mon, 29 Mar 2021 08:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006120;
        bh=EWkXCU+CZWZS7C5hQ0Vo7n218JpcAreF2chuIbKaGDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x892f5UGEQiU1UF/dbKmesks+ci2Jv/Ri4gJrotlB/nMiEqLVayrIGkFkEtl9A6L2
         b2maH5md2YMasLUzukSHmHKRvNA21U10EkxrSOU1qHdjvDxzCdRhpu/8GCtye/G/ni
         3yO8fNt9eb11QsLWEAC6lcR5hPcPJuuCx/6Yi8a0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 125/221] can: isotp: TX-path: ensure that CAN frame flags are initialized
Date:   Mon, 29 Mar 2021 09:57:36 +0200
Message-Id: <20210329075633.377932596@linuxfoundation.org>
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

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit d4eb538e1f48b3cf7bb6cb9eb39fe3e9e8a701f7 ]

The previous patch ensures that the TX flags (struct
can_isotp_ll_options::tx_flags) are 0 for classic CAN frames or a user
configured value for CAN-FD frames.

This patch sets the CAN frames flags unconditionally to the ISO-TP TX
flags, so that they are initialized to a proper value. Otherwise when
running "candump -x" on a classical CAN ISO-TP stream shows wrongly
set "B" and "E" flags.

| $ candump any,0:0,#FFFFFFFF -extA
| [...]
| can0  TX B E  713   [8]  2B 0A 0B 0C 0D 0E 0F 00
| can0  TX B E  713   [8]  2C 01 02 03 04 05 06 07
| can0  TX B E  713   [8]  2D 08 09 0A 0B 0C 0D 0E
| can0  TX B E  713   [8]  2E 0F 00 01 02 03 04 05

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Link: https://lore.kernel.org/r/20210218215434.1708249-2-mkl@pengutronix.de
Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/isotp.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index a9b96a6e6317..b01662d2f2cd 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -215,8 +215,7 @@ static int isotp_send_fc(struct sock *sk, int ae, u8 flowstatus)
 	if (ae)
 		ncf->data[0] = so->opt.ext_address;
 
-	if (so->ll.mtu == CANFD_MTU)
-		ncf->flags = so->ll.tx_flags;
+	ncf->flags = so->ll.tx_flags;
 
 	can_send_ret = can_send(nskb, 1);
 	if (can_send_ret)
@@ -790,8 +789,7 @@ isotp_tx_burst:
 		so->tx.sn %= 16;
 		so->tx.bs++;
 
-		if (so->ll.mtu == CANFD_MTU)
-			cf->flags = so->ll.tx_flags;
+		cf->flags = so->ll.tx_flags;
 
 		skb->dev = dev;
 		can_skb_set_owner(skb, sk);
@@ -934,8 +932,7 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	}
 
 	/* send the first or only CAN frame */
-	if (so->ll.mtu == CANFD_MTU)
-		cf->flags = so->ll.tx_flags;
+	cf->flags = so->ll.tx_flags;
 
 	skb->dev = dev;
 	skb->sk = sk;
-- 
2.30.1



