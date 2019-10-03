Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA924CACF3
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731608AbfJCRcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:32:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729041AbfJCQJJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:09:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22ACC207FF;
        Thu,  3 Oct 2019 16:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118948;
        bh=Nv9twrohaHZFYlosBKimIU3ZsQQJywuxTEEXDKqmwPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bf7iHA+7Ii77ipkXl71zIhImXJywu1t7/ini5qAlEWzAnr3CZcJ3xkOnrQPK39ihT
         12YAZZ8XV8kAoeU0f+4xEacwnCuw8aMd3IExs9tps942NXceskXFbCzWOzQwTkcMRl
         95jOTnLqkFzZY8UjlSrZ0KO1GH28b99xW6M3B4FA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takeshi Misawa <jeliantsurux@gmail.com>,
        Guillaume Nault <gnault@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+d9c8bf24e56416d7ce2c@syzkaller.appspotmail.com
Subject: [PATCH 4.14 042/185] ppp: Fix memory leak in ppp_write
Date:   Thu,  3 Oct 2019 17:52:00 +0200
Message-Id: <20191003154447.350820927@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takeshi Misawa <jeliantsurux@gmail.com>

[ Upstream commit 4c247de564f1ff614d11b3bb5313fb70d7b9598b ]

When ppp is closing, __ppp_xmit_process() failed to enqueue skb
and skb allocated in ppp_write() is leaked.

syzbot reported :
BUG: memory leak
unreferenced object 0xffff88812a17bc00 (size 224):
  comm "syz-executor673", pid 6952, jiffies 4294942888 (age 13.040s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000d110fff9>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
    [<00000000d110fff9>] slab_post_alloc_hook mm/slab.h:522 [inline]
    [<00000000d110fff9>] slab_alloc_node mm/slab.c:3262 [inline]
    [<00000000d110fff9>] kmem_cache_alloc_node+0x163/0x2f0 mm/slab.c:3574
    [<000000002d616113>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:197
    [<000000000167fc45>] alloc_skb include/linux/skbuff.h:1055 [inline]
    [<000000000167fc45>] ppp_write+0x48/0x120 drivers/net/ppp/ppp_generic.c:502
    [<000000009ab42c0b>] __vfs_write+0x43/0xa0 fs/read_write.c:494
    [<00000000086b2e22>] vfs_write fs/read_write.c:558 [inline]
    [<00000000086b2e22>] vfs_write+0xee/0x210 fs/read_write.c:542
    [<00000000a2b70ef9>] ksys_write+0x7c/0x130 fs/read_write.c:611
    [<00000000ce5e0fdd>] __do_sys_write fs/read_write.c:623 [inline]
    [<00000000ce5e0fdd>] __se_sys_write fs/read_write.c:620 [inline]
    [<00000000ce5e0fdd>] __x64_sys_write+0x1e/0x30 fs/read_write.c:620
    [<00000000d9d7b370>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:296
    [<0000000006e6d506>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fix this by freeing skb, if ppp is closing.

Fixes: 6d066734e9f0 ("ppp: avoid loop in xmit recursion detection code")
Reported-and-tested-by: syzbot+d9c8bf24e56416d7ce2c@syzkaller.appspotmail.com
Signed-off-by: Takeshi Misawa <jeliantsurux@gmail.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Tested-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ppp/ppp_generic.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1433,6 +1433,8 @@ static void __ppp_xmit_process(struct pp
 			netif_wake_queue(ppp->dev);
 		else
 			netif_stop_queue(ppp->dev);
+	} else {
+		kfree_skb(skb);
 	}
 	ppp_xmit_unlock(ppp);
 }


