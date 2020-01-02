Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 614D812EFF7
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbgABWtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:49:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:53318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729076AbgABW0Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:26:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6590B21835;
        Thu,  2 Jan 2020 22:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003975;
        bh=NUPF5Gpjm26pdH3c01yife+I/Qz3oOyID/puu7PriXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CM9f43j6P4DlQbfnq/XgcOIy4X0qTl6b3CJbdctRQgfDC4lemiXOU5S2ePr31N5g/
         GDFWbLRINEkv4IuR5oRRrsxT29uOAQLzYNQBVw+8FtHum+OwFpTIGAQ3PLtYemylbq
         Z2bxfu6epzHQ0pwZe2NBRevtsnwKu6h7h8Iby9ow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antonio Messina <amessina@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 77/91] udp: fix integer overflow while computing available space in sk_rcvbuf
Date:   Thu,  2 Jan 2020 23:07:59 +0100
Message-Id: <20200102220448.435931821@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220356.856162165@linuxfoundation.org>
References: <20200102220356.856162165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antonio Messina <amessina@google.com>

[ Upstream commit feed8a4fc9d46c3126fb9fcae0e9248270c6321a ]

When the size of the receive buffer for a socket is close to 2^31 when
computing if we have enough space in the buffer to copy a packet from
the queue to the buffer we might hit an integer overflow.

When an user set net.core.rmem_default to a value close to 2^31 UDP
packets are dropped because of this overflow. This can be visible, for
instance, with failure to resolve hostnames.

This can be fixed by casting sk_rcvbuf (which is an int) to unsigned
int, similarly to how it is done in TCP.

Signed-off-by: Antonio Messina <amessina@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1338,7 +1338,7 @@ int __udp_enqueue_schedule_skb(struct so
 	 * queue contains some other skb
 	 */
 	rmem = atomic_add_return(size, &sk->sk_rmem_alloc);
-	if (rmem > (size + sk->sk_rcvbuf))
+	if (rmem > (size + (unsigned int)sk->sk_rcvbuf))
 		goto uncharge_drop;
 
 	spin_lock(&list->lock);


