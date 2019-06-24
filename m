Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68F4F50869
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730872AbfFXKRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:17:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730840AbfFXKQ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:16:57 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A4E120645;
        Mon, 24 Jun 2019 10:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371416;
        bh=sLCeOjCrzZWFX3mgX9qYm4q7YOx5AuqolYxd8ZsyC4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jtKCFtaqhzMWShFyMYmC8lodbPYW3S4qKPJ0IxLyzyKlnZo8Jye7If0E5q/gRHjLs
         U9dsLE8yFERA3XOaaBaCTuld6ZeBHlglveTD6rXTO+7IEVVS+mXcjvKae00zIqnzMy
         EvJTWdK6MyZYo2BoZOZrRLspuTr8CAxTi8sdHyf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+a90604060cb40f5bdd16@syzkaller.appspotmail.com,
        Willem de Bruijn <willemb@google.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.1 095/121] can: purge socket error queue on sock destruct
Date:   Mon, 24 Jun 2019 17:57:07 +0800
Message-Id: <20190624092325.617532146@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
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
@@ -105,6 +105,7 @@ EXPORT_SYMBOL(can_ioctl);
 static void can_sock_destruct(struct sock *sk)
 {
 	skb_queue_purge(&sk->sk_receive_queue);
+	skb_queue_purge(&sk->sk_error_queue);
 }
 
 static const struct can_proto *can_get_proto(int protocol)


