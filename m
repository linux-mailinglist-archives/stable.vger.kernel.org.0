Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD20289B6
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389507AbfEWTUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:20:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389310AbfEWTT7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:19:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF7012133D;
        Thu, 23 May 2019 19:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639199;
        bh=xybzybaBrRBY0rwIS01IM151RQKj+ojYIRqCBC0xclI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sBTCqHYmwBerCh8Q/wYVYDn2hI9Gp2ntDe1TB1FgeDuejqiUt9sLpl3g/VhKe9T2m
         KlMwf+DC1nAb+sEGelt0finJM/Ez1iDYmu4VN1HP4qDKkQCbafJyo4i3rdEYiKW+/8
         f10rN6xM2FPBfRXyDK4oymizd8nhIJbSaaipeSg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 004/139] net: avoid weird emergency message
Date:   Thu, 23 May 2019 21:04:52 +0200
Message-Id: <20190523181720.815152467@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d7c04b05c9ca14c55309eb139430283a45c4c25f ]

When host is under high stress, it is very possible thread
running netdev_wait_allrefs() returns from msleep(250)
10 seconds late.

This leads to these messages in the syslog :

[...] unregister_netdevice: waiting for syz_tun to become free. Usage count = 0

If the device refcount is zero, the wait is over.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8829,7 +8829,7 @@ static void netdev_wait_allrefs(struct n
 
 		refcnt = netdev_refcnt_read(dev);
 
-		if (time_after(jiffies, warning_time + 10 * HZ)) {
+		if (refcnt && time_after(jiffies, warning_time + 10 * HZ)) {
 			pr_emerg("unregister_netdevice: waiting for %s to become free. Usage count = %d\n",
 				 dev->name, refcnt);
 			warning_time = jiffies;


