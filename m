Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D46434436B
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbhCVMuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:50:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232854AbhCVMsU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:48:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80FC9619E9;
        Mon, 22 Mar 2021 12:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417078;
        bh=KEmkC7eCaSy2d/QMMOfqdMMOi3iq+/+h8z527AfaTAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o7xNGJA7LRwTjl1jGms9Z8jjkI60IRdCGEjJTbxahdNehoKbWgYhS3ic184jPrvVr
         dhZKfJikg178k1s+4WuCPVgftYiPELvtnohFX12mbfmOty2a4VBYLcLoldHJTM2wLK
         OMmTwYUMMMKpP10hFarUxTD1fQHvsgpBsbyFEirE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+80dccaee7c6630fa9dcf@syzkaller.appspotmail.com,
        Pavel Skripkin <paskripkin@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 18/43] net/qrtr: fix __netdev_alloc_skb call
Date:   Mon, 22 Mar 2021 13:28:32 +0100
Message-Id: <20210322121920.518842646@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121919.936671417@linuxfoundation.org>
References: <20210322121919.936671417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit 093b036aa94e01a0bea31a38d7f0ee28a2749023 upstream.

syzbot found WARNING in __alloc_pages_nodemask()[1] when order >= MAX_ORDER.
It was caused by a huge length value passed from userspace to qrtr_tun_write_iter(),
which tries to allocate skb. Since the value comes from the untrusted source
there is no need to raise a warning in __alloc_pages_nodemask().

[1] WARNING in __alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:5014
Call Trace:
 __alloc_pages include/linux/gfp.h:511 [inline]
 __alloc_pages_node include/linux/gfp.h:524 [inline]
 alloc_pages_node include/linux/gfp.h:538 [inline]
 kmalloc_large_node+0x60/0x110 mm/slub.c:3999
 __kmalloc_node_track_caller+0x319/0x3f0 mm/slub.c:4496
 __kmalloc_reserve net/core/skbuff.c:150 [inline]
 __alloc_skb+0x4e4/0x5a0 net/core/skbuff.c:210
 __netdev_alloc_skb+0x70/0x400 net/core/skbuff.c:446
 netdev_alloc_skb include/linux/skbuff.h:2832 [inline]
 qrtr_endpoint_post+0x84/0x11b0 net/qrtr/qrtr.c:442
 qrtr_tun_write_iter+0x11f/0x1a0 net/qrtr/tun.c:98
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write+0x426/0x650 fs/read_write.c:518
 vfs_write+0x791/0xa30 fs/read_write.c:605
 ksys_write+0x12d/0x250 fs/read_write.c:658
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported-by: syzbot+80dccaee7c6630fa9dcf@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Acked-by: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/qrtr/qrtr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -271,7 +271,7 @@ int qrtr_endpoint_post(struct qrtr_endpo
 	if (len == 0 || len & 3)
 		return -EINVAL;
 
-	skb = netdev_alloc_skb(NULL, len);
+	skb = __netdev_alloc_skb(NULL, len, GFP_ATOMIC | __GFP_NOWARN);
 	if (!skb)
 		return -ENOMEM;
 


