Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEDB712C5ED
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730262AbfL2RmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:42:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:48244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730255AbfL2RmL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:42:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1EC521744;
        Sun, 29 Dec 2019 17:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641331;
        bh=zHIFrSwZR8EIE5Mo20V+kC+daYYYejuSBO4JhINZu0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gAFd3/fi8bsmWeN6KFZBZVthnV2xikukrdlKwxrfxXqa/ayZa2mad63wAnzqwnS+f
         2GvU4AYOuSmOBzwtUuILVbokLFs72Eg7vNcZ9zSYB42hgSv8WsQgFYRu3pI2EZi02w
         krgBU9GEdPSF7sDbBqbc4S/LxxUMBLkmhRJnKUxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 007/434] net: nfc: nci: fix a possible sleep-in-atomic-context bug in nci_uart_tty_receive()
Date:   Sun, 29 Dec 2019 18:21:00 +0100
Message-Id: <20191229172702.803074969@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit b7ac893652cafadcf669f78452329727e4e255cc ]

The kernel may sleep while holding a spinlock.
The function call path (from bottom to top) in Linux 4.19 is:

net/nfc/nci/uart.c, 349:
	nci_skb_alloc in nci_uart_default_recv_buf
net/nfc/nci/uart.c, 255:
	(FUNC_PTR)nci_uart_default_recv_buf in nci_uart_tty_receive
net/nfc/nci/uart.c, 254:
	spin_lock in nci_uart_tty_receive

nci_skb_alloc(GFP_KERNEL) can sleep at runtime.
(FUNC_PTR) means a function pointer is called.

To fix this bug, GFP_KERNEL is replaced with GFP_ATOMIC for
nci_skb_alloc().

This bug is found by a static analysis tool STCheck written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/nci/uart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/nfc/nci/uart.c
+++ b/net/nfc/nci/uart.c
@@ -346,7 +346,7 @@ static int nci_uart_default_recv_buf(str
 			nu->rx_packet_len = -1;
 			nu->rx_skb = nci_skb_alloc(nu->ndev,
 						   NCI_MAX_PACKET_SIZE,
-						   GFP_KERNEL);
+						   GFP_ATOMIC);
 			if (!nu->rx_skb)
 				return -ENOMEM;
 		}


