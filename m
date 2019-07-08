Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 731246215A
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732376AbfGHPPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:15:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732370AbfGHPPh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:15:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADAC4216E3;
        Mon,  8 Jul 2019 15:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562598936;
        bh=gecknaLnpxJAkcz09//PUVx/i0m8/5EUXaITOfUOD1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nUbuHdEqul2Ayrn57K1uUUGbv8TftxwrD0w71YO1qNQg5vCyzPKvSIz1bxXHJDeVS
         gXlUimtWtWuD9NYjB4zkvApTDtFM/iVhNpPmCwVAqV8QmC2laSW1a9Ycfu/o0aiRQs
         BD4qlVPCxYfjSuB1KGbbEshIj4bJnZ09ZTXG4lnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+a90604060cb40f5bdd16@syzkaller.appspotmail.com,
        Willem de Bruijn <willemb@google.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.4 22/73] can: purge socket error queue on sock destruct
Date:   Mon,  8 Jul 2019 17:12:32 +0200
Message-Id: <20190708150521.526939612@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150513.136580595@linuxfoundation.org>
References: <20190708150513.136580595@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

commit fd704bd5ee749d560e86c4f1fd2ef486d8abf7cf upstream.

CAN supports software tx timestamps as of the below commit. Purge
any queued timestamp packets on socket destroy.

Fixes: 51f31cabe3ce ("ip: support for TX timestamps on UDP and RAW sockets")
Reported-by: syzbot+a90604060cb40f5bdd16@syzkaller.appspotmail.com
Signed-off-by: Willem de Bruijn <willemb@google.com>
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/can/af_can.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -113,6 +113,7 @@ EXPORT_SYMBOL(can_ioctl);
 static void can_sock_destruct(struct sock *sk)
 {
 	skb_queue_purge(&sk->sk_receive_queue);
+	skb_queue_purge(&sk->sk_error_queue);
 }
 
 static const struct can_proto *can_get_proto(int protocol)


