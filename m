Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349802C0AE8
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730872AbgKWMbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:31:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:42666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730194AbgKWMbe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:31:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5A2721D7E;
        Mon, 23 Nov 2020 12:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134693;
        bh=tfAf0+7EwoYlWdov5kICKScbg39EvHobteHX7ndjaZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2d69OnQFHU0t7mg8A8mlpkNiIPlkf8xU2+QL7JLkCoohjKZTuUy2VlFymQGba3tII
         28dtq/anG6r4977YnE+rsXU6ipsGqP2Jt/IAefUoGB1QBbneGlzKo9dKz9ZznEnMat
         WbSmnBaB4FGON8VjRsy6KvmklMPIYQD3rw4j35dQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+9bcb0c9409066696d3aa@syzkaller.appspotmail.com,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 49/91] can: af_can: prevent potential access of uninitialized member in canfd_rcv()
Date:   Mon, 23 Nov 2020 13:22:09 +0100
Message-Id: <20201123121811.703579099@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anant Thazhemadam <anant.thazhemadam@gmail.com>

[ Upstream commit 9aa9379d8f868e91719333a7f063ccccc0579acc ]

In canfd_rcv(), cfd->len is uninitialized when skb->len = 0, and this
uninitialized cfd->len is accessed nonetheless by pr_warn_once().

Fix this uninitialized variable access by checking cfd->len's validity
condition (cfd->len > CANFD_MAX_DLEN) separately after the skb->len's
condition is checked, and appropriately modify the log messages that
are generated as well.
In case either of the required conditions fail, the skb is freed and
NET_RX_DROP is returned, same as before.

Fixes: d4689846881d ("can: af_can: canfd_rcv(): replace WARN_ONCE by pr_warn_once")
Reported-by: syzbot+9bcb0c9409066696d3aa@syzkaller.appspotmail.com
Tested-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Link: https://lore.kernel.org/r/20201103213906.24219-3-anant.thazhemadam@gmail.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/af_can.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index 1201846dc07e3..b3edb80921248 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -748,16 +748,25 @@ static int canfd_rcv(struct sk_buff *skb, struct net_device *dev,
 {
 	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 
-	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CANFD_MTU ||
-		     cfd->len > CANFD_MAX_DLEN)) {
-		pr_warn_once("PF_CAN: dropped non conform CAN FD skbuf: dev type %d, len %d, datalen %d\n",
+	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CANFD_MTU)) {
+		pr_warn_once("PF_CAN: dropped non conform CAN FD skbuff: dev type %d, len %d\n",
+			     dev->type, skb->len);
+		goto free_skb;
+	}
+
+	/* This check is made separately since cfd->len would be uninitialized if skb->len = 0. */
+	if (unlikely(cfd->len > CANFD_MAX_DLEN)) {
+		pr_warn_once("PF_CAN: dropped non conform CAN FD skbuff: dev type %d, len %d, datalen %d\n",
 			     dev->type, skb->len, cfd->len);
-		kfree_skb(skb);
-		return NET_RX_DROP;
+		goto free_skb;
 	}
 
 	can_receive(skb, dev);
 	return NET_RX_SUCCESS;
+
+free_skb:
+	kfree_skb(skb);
+	return NET_RX_DROP;
 }
 
 /*
-- 
2.27.0



