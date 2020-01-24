Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41A2E14820E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403820AbgAXLYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:24:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:38522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403813AbgAXLYu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:24:50 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4640C206D4;
        Fri, 24 Jan 2020 11:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865089;
        bh=gvluAuy/fgWBkNDVZ88bCgsL9atekzihsrJAl6zvCWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FcUDx82RHWE1mdRjYu59KsZ1EFlwRMA7fa2yByDcfpMMhGNKB2Llm2cI/JCQ7ZYRJ
         t2QmxFMNccRbdWc5Y+bDnSO5FCryepJfaB3KWkebLXUdLr9GeHiRcgekpk4j/uC02m
         jHhj64eOfBtoDKog8ETE/+7Z71QzEnRzoZNsn7Hc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 437/639] net/af_iucv: build proper skbs for HiperTransport
Date:   Fri, 24 Jan 2020 10:30:07 +0100
Message-Id: <20200124093141.764140433@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 238965b71b968dc5b3c0fe430e946f488322c4b5 ]

The HiperSockets-based transport path in af_iucv is still too closely
entangled with qeth.
With commit a647a02512ca ("s390/qeth: speed-up L3 IQD xmit"), the
relevant xmit code in qeth has begun to use skb_cow_head(). So to avoid
unnecessary skb head expansions, af_iucv must learn to
1) respect dev->needed_headroom when allocating skbs, and
2) drop the header reference before cloning the skb.

While at it, also stop hard-coding the LL-header creation stage and just
use the appropriate helper.

Fixes: a647a02512ca ("s390/qeth: speed-up L3 IQD xmit")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/iucv/af_iucv.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index f024914da1b2d..e07daee1227c3 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -13,6 +13,7 @@
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
 #include <linux/module.h>
+#include <linux/netdevice.h>
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/errno.h>
@@ -355,6 +356,9 @@ static int afiucv_hs_send(struct iucv_message *imsg, struct sock *sock,
 		err = -ENODEV;
 		goto err_free;
 	}
+
+	dev_hard_header(skb, skb->dev, ETH_P_AF_IUCV, NULL, NULL, skb->len);
+
 	if (!(skb->dev->flags & IFF_UP) || !netif_carrier_ok(skb->dev)) {
 		err = -ENETDOWN;
 		goto err_free;
@@ -367,6 +371,8 @@ static int afiucv_hs_send(struct iucv_message *imsg, struct sock *sock,
 		skb_trim(skb, skb->dev->mtu);
 	}
 	skb->protocol = cpu_to_be16(ETH_P_AF_IUCV);
+
+	__skb_header_release(skb);
 	nskb = skb_clone(skb, GFP_ATOMIC);
 	if (!nskb) {
 		err = -ENOMEM;
@@ -466,12 +472,14 @@ static void iucv_sever_path(struct sock *sk, int with_user_data)
 /* Send controlling flags through an IUCV socket for HIPER transport */
 static int iucv_send_ctrl(struct sock *sk, u8 flags)
 {
+	struct iucv_sock *iucv = iucv_sk(sk);
 	int err = 0;
 	int blen;
 	struct sk_buff *skb;
 	u8 shutdown = 0;
 
-	blen = sizeof(struct af_iucv_trans_hdr) + ETH_HLEN;
+	blen = sizeof(struct af_iucv_trans_hdr) +
+	       LL_RESERVED_SPACE(iucv->hs_dev);
 	if (sk->sk_shutdown & SEND_SHUTDOWN) {
 		/* controlling flags should be sent anyway */
 		shutdown = sk->sk_shutdown;
@@ -1131,7 +1139,8 @@ static int iucv_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 	 * segmented records using the MSG_EOR flag), but
 	 * for SOCK_STREAM we might want to improve it in future */
 	if (iucv->transport == AF_IUCV_TRANS_HIPER) {
-		headroom = sizeof(struct af_iucv_trans_hdr) + ETH_HLEN;
+		headroom = sizeof(struct af_iucv_trans_hdr) +
+			   LL_RESERVED_SPACE(iucv->hs_dev);
 		linear = len;
 	} else {
 		if (len < PAGE_SIZE) {
-- 
2.20.1



