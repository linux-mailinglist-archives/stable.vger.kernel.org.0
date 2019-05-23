Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D374428884
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390226AbfEWT05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:26:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391050AbfEWT04 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:26:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2A4B2054F;
        Thu, 23 May 2019 19:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639616;
        bh=KqdD4SdZSFzorY+x2YgGvM/UH1GFWDLOzGdOxOUeuvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wqxYzJvJcfEeOQFDV0DQOKGDjUwmZ6r/6C2t34xHo0y3n3a2nWwd66JdPNjmbGYk7
         997cjoKI4Dh3KGpxjlXfETKlhY4p1QPu+4knLmCZesM8cRoAGb0XPTQmMyF9l5cTgO
         3hS6DOY3YDw7Gax9pszKfDTprsDQJV1Ab8iSXCUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 004/122] net: avoid weird emergency message
Date:   Thu, 23 May 2019 21:05:26 +0200
Message-Id: <20190523181705.579395112@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
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
@@ -8911,7 +8911,7 @@ static void netdev_wait_allrefs(struct n
 
 		refcnt = netdev_refcnt_read(dev);
 
-		if (time_after(jiffies, warning_time + 10 * HZ)) {
+		if (refcnt && time_after(jiffies, warning_time + 10 * HZ)) {
 			pr_emerg("unregister_netdevice: waiting for %s to become free. Usage count = %d\n",
 				 dev->name, refcnt);
 			warning_time = jiffies;


