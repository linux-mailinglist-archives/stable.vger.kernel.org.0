Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D721CAFEE
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbgEHNVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:21:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728587AbgEHMj7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:39:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E0C621835;
        Fri,  8 May 2020 12:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941598;
        bh=VuhCrMo/JOkpOOBjMSFM8yGGqQSUKOJBNsbjYOWJP1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z67kIpBlziZdKbH72wwK0v4vKujWRgHom/CNAIKn4GiikxQAzpDAcxw6Ln/2OrJIG
         yJfTEN3m7y1edVDQ7r4qu9pI/ttrLgJ8VZtWgPN3qUZ+XRiucF91kK9QrCyXgqq+wP
         HohpC5/LKPoqyvGVmp70AGJP+feSX+sFzvv/V138=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Turnbull <phil.turnbull@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 095/312] irda: Free skb on irda_accept error path.
Date:   Fri,  8 May 2020 14:31:26 +0200
Message-Id: <20200508123131.217130888@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: phil.turnbull@oracle.com <phil.turnbull@oracle.com>

commit 8ab86c00e349cef9fb14719093a7f198bcc72629 upstream.

skb is not freed if newsk is NULL. Rework the error path so free_skb is
unconditionally called on function exit.

Fixes: c3ea9fa27413 ("[IrDA] af_irda: IRDA_ASSERT cleanups")
Signed-off-by: Phil Turnbull <phil.turnbull@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/irda/af_irda.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/irda/af_irda.c
+++ b/net/irda/af_irda.c
@@ -839,7 +839,7 @@ static int irda_accept(struct socket *so
 	struct sock *sk = sock->sk;
 	struct irda_sock *new, *self = irda_sk(sk);
 	struct sock *newsk;
-	struct sk_buff *skb;
+	struct sk_buff *skb = NULL;
 	int err;
 
 	err = irda_create(sock_net(sk), newsock, sk->sk_protocol, 0);
@@ -907,7 +907,6 @@ static int irda_accept(struct socket *so
 	err = -EPERM; /* value does not seem to make sense. -arnd */
 	if (!new->tsap) {
 		pr_debug("%s(), dup failed!\n", __func__);
-		kfree_skb(skb);
 		goto out;
 	}
 
@@ -926,7 +925,6 @@ static int irda_accept(struct socket *so
 	/* Clean up the original one to keep it in listen state */
 	irttp_listen(self->tsap);
 
-	kfree_skb(skb);
 	sk->sk_ack_backlog--;
 
 	newsock->state = SS_CONNECTED;
@@ -934,6 +932,7 @@ static int irda_accept(struct socket *so
 	irda_connect_response(new);
 	err = 0;
 out:
+	kfree_skb(skb);
 	release_sock(sk);
 	return err;
 }


