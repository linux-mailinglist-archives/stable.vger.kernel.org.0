Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B872B6012
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbgKQNGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:06:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:60498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728453AbgKQNGO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:06:14 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08C732225E;
        Tue, 17 Nov 2020 13:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618373;
        bh=e/ZA+rSjyNAAwAafilfOd2JPZLcajknEqJZEOpFZyaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S3VzHqw8CbBN4PkF00gNaYRraS+vADvQtE+7dtj4qFMR2MngfhCiuzRmKbVKPrsrJ
         qvi0EEZT1uCRv1/Es4c9+ia+XYd77ictaYtZWiBTewv4wNX4Yxp+O0lnBT8rmbUsVT
         TnDJfmNL07BdVr8XyngUukckJb/9hDElVU4ug5I4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 11/64] can: can_create_echo_skb(): fix echo skb generation: always use skb_clone()
Date:   Tue, 17 Nov 2020 14:04:34 +0100
Message-Id: <20201117122106.687931012@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122106.144800239@linuxfoundation.org>
References: <20201117122106.144800239@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 286228d382ba6320f04fa2e7c6fc8d4d92e428f4 ]

All user space generated SKBs are owned by a socket (unless injected into the
key via AF_PACKET). If a socket is closed, all associated skbs will be cleaned
up.

This leads to a problem when a CAN driver calls can_put_echo_skb() on a
unshared SKB. If the socket is closed prior to the TX complete handler,
can_get_echo_skb() and the subsequent delivering of the echo SKB to all
registered callbacks, a SKB with a refcount of 0 is delivered.

To avoid the problem, in can_get_echo_skb() the original SKB is now always
cloned, regardless of shared SKB or not. If the process exists it can now
safely discard its SKBs, without disturbing the delivery of the echo SKB.

The problem shows up in the j1939 stack, when it clones the incoming skb, which
detects the already 0 refcount.

We can easily reproduce this with following example:

testj1939 -B -r can0: &
cansend can0 1823ff40#0123

WARNING: CPU: 0 PID: 293 at lib/refcount.c:25 refcount_warn_saturate+0x108/0x174
refcount_t: addition on 0; use-after-free.
Modules linked in: coda_vpu imx_vdoa videobuf2_vmalloc dw_hdmi_ahb_audio vcan
CPU: 0 PID: 293 Comm: cansend Not tainted 5.5.0-rc6-00376-g9e20dcb7040d #1
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
Backtrace:
[<c010f570>] (dump_backtrace) from [<c010f90c>] (show_stack+0x20/0x24)
[<c010f8ec>] (show_stack) from [<c0c3e1a4>] (dump_stack+0x8c/0xa0)
[<c0c3e118>] (dump_stack) from [<c0127fec>] (__warn+0xe0/0x108)
[<c0127f0c>] (__warn) from [<c01283c8>] (warn_slowpath_fmt+0xa8/0xcc)
[<c0128324>] (warn_slowpath_fmt) from [<c0539c0c>] (refcount_warn_saturate+0x108/0x174)
[<c0539b04>] (refcount_warn_saturate) from [<c0ad2cac>] (j1939_can_recv+0x20c/0x210)
[<c0ad2aa0>] (j1939_can_recv) from [<c0ac9dc8>] (can_rcv_filter+0xb4/0x268)
[<c0ac9d14>] (can_rcv_filter) from [<c0aca2cc>] (can_receive+0xb0/0xe4)
[<c0aca21c>] (can_receive) from [<c0aca348>] (can_rcv+0x48/0x98)
[<c0aca300>] (can_rcv) from [<c09b1fdc>] (__netif_receive_skb_one_core+0x64/0x88)
[<c09b1f78>] (__netif_receive_skb_one_core) from [<c09b2070>] (__netif_receive_skb+0x38/0x94)
[<c09b2038>] (__netif_receive_skb) from [<c09b2130>] (netif_receive_skb_internal+0x64/0xf8)
[<c09b20cc>] (netif_receive_skb_internal) from [<c09b21f8>] (netif_receive_skb+0x34/0x19c)
[<c09b21c4>] (netif_receive_skb) from [<c0791278>] (can_rx_offload_napi_poll+0x58/0xb4)

Fixes: 0ae89beb283a ("can: add destructor for self generated skbs")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: http://lore.kernel.org/r/20200124132656.22156-1-o.rempel@pengutronix.de
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/can/skb.h | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
index 51bb6532785c3..1a2111c775ae1 100644
--- a/include/linux/can/skb.h
+++ b/include/linux/can/skb.h
@@ -60,21 +60,17 @@ static inline void can_skb_set_owner(struct sk_buff *skb, struct sock *sk)
  */
 static inline struct sk_buff *can_create_echo_skb(struct sk_buff *skb)
 {
-	if (skb_shared(skb)) {
-		struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
+	struct sk_buff *nskb;
 
-		if (likely(nskb)) {
-			can_skb_set_owner(nskb, skb->sk);
-			consume_skb(skb);
-			return nskb;
-		} else {
-			kfree_skb(skb);
-			return NULL;
-		}
+	nskb = skb_clone(skb, GFP_ATOMIC);
+	if (unlikely(!nskb)) {
+		kfree_skb(skb);
+		return NULL;
 	}
 
-	/* we can assume to have an unshared skb with proper owner */
-	return skb;
+	can_skb_set_owner(nskb, skb->sk);
+	consume_skb(skb);
+	return nskb;
 }
 
 #endif /* !_CAN_SKB_H */
-- 
2.27.0



