Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8CE2D0420
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbgLFLnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:43:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:42670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729127AbgLFLnV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:43:21 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ayush Ranjan <ayushranjan@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 07/39] sock: set sk_err to ee_errno on dequeue from errq
Date:   Sun,  6 Dec 2020 12:17:11 +0100
Message-Id: <20201206111555.025782473@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111554.677764505@linuxfoundation.org>
References: <20201206111554.677764505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 985f7337421a811cb354ca93882f943c8335a6f5 ]

When setting sk_err, set it to ee_errno, not ee_origin.

Commit f5f99309fa74 ("sock: do not set sk_err in
sock_dequeue_err_skb") disabled updating sk_err on errq dequeue,
which is correct for most error types (origins):

  -       sk->sk_err = err;

Commit 38b257938ac6 ("sock: reset sk_err when the error queue is
empty") reenabled the behavior for IMCP origins, which do require it:

  +       if (icmp_next)
  +               sk->sk_err = SKB_EXT_ERR(skb_next)->ee.ee_origin;

But read from ee_errno.

Fixes: 38b257938ac6 ("sock: reset sk_err when the error queue is empty")
Reported-by: Ayush Ranjan <ayushranjan@google.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Link: https://lore.kernel.org/r/20201126151220.2819322-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4452,7 +4452,7 @@ struct sk_buff *sock_dequeue_err_skb(str
 	if (skb && (skb_next = skb_peek(q))) {
 		icmp_next = is_icmp_err_skb(skb_next);
 		if (icmp_next)
-			sk->sk_err = SKB_EXT_ERR(skb_next)->ee.ee_origin;
+			sk->sk_err = SKB_EXT_ERR(skb_next)->ee.ee_errno;
 	}
 	spin_unlock_irqrestore(&q->lock, flags);
 


