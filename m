Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDD14798E1
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730477AbfG2ULQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 16:11:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387748AbfG2Tdj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:33:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73F3721773;
        Mon, 29 Jul 2019 19:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428819;
        bh=QEj/HLs4qgcfXS9pAfCuX2BkTk9HK4xqAbKdsVSyGCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AzdpvB4uVkbv2Spv2xRwuZhESchNV/XgF5OvsS/KtQ6ZNta0XjvyQUHukRII+8+S1
         PxzOvWyTbh/x0NVdu9FFOlCa+rf1t3weL6dVeCpbz+HfV9Y7iwNEjCl97+tHZRgC4n
         zZZrNfRHw1DH5QLMXsRIZv8/PKyO6OeOo9Vzum4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+622bdabb128acc33427d@syzkaller.appspotmail.com,
        syzbot+6eaef7158b19e3fec3a0@syzkaller.appspotmail.com,
        syzbot+9399c158fcc09b21d0d2@syzkaller.appspotmail.com,
        syzbot+a34e5f3d0300163f0c87@syzkaller.appspotmail.com
Subject: [PATCH 4.14 197/293] netrom: hold sock when setting skb->destructor
Date:   Mon, 29 Jul 2019 21:21:28 +0200
Message-Id: <20190729190839.561909247@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 4638faac032756f7eab5524be7be56bee77e426b ]

sock_efree() releases the sock refcnt, if we don't hold this refcnt
when setting skb->destructor to it, the refcnt would not be balanced.
This leads to several bug reports from syzbot.

I have checked other users of sock_efree(), all of them hold the
sock refcnt.

Fixes: c8c8218ec5af ("netrom: fix a memory leak in nr_rx_frame()")
Reported-and-tested-by: <syzbot+622bdabb128acc33427d@syzkaller.appspotmail.com>
Reported-and-tested-by: <syzbot+6eaef7158b19e3fec3a0@syzkaller.appspotmail.com>
Reported-and-tested-by: <syzbot+9399c158fcc09b21d0d2@syzkaller.appspotmail.com>
Reported-and-tested-by: <syzbot+a34e5f3d0300163f0c87@syzkaller.appspotmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netrom/af_netrom.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -969,6 +969,7 @@ int nr_rx_frame(struct sk_buff *skb, str
 
 	window = skb->data[20];
 
+	sock_hold(make);
 	skb->sk             = make;
 	skb->destructor     = sock_efree;
 	make->sk_state	    = TCP_ESTABLISHED;


