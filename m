Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABBFF499AC2
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359800AbiAXVqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456647AbiAXVjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:39:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48113C06124E;
        Mon, 24 Jan 2022 12:25:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD2AB61382;
        Mon, 24 Jan 2022 20:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE12BC340E5;
        Mon, 24 Jan 2022 20:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055942;
        bh=3Ie9qEr5vFzrRtWIyCpzGwEkWAOWkxsiFMPjgFxG8B4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GuZU7qIIPxd1Ii6GzJUN8d3POqgU396Hp1la2i9NF2HHIZajVYy6e7xEnsvEwz1Ue
         c7QjxZMMJs5c+4x53lhGc3CxJqEVt+6ImCOldmbAjtxaSASWW0z6aZLsEm2NSp6Iak
         8qhbB0jXF1yCcKUd9V9mNqSLx0rbCrQQ+2kv8viM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>,
        Guillaume Nault <gnault@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 317/846] ppp: ensure minimum packet size in ppp_write()
Date:   Mon, 24 Jan 2022 19:37:14 +0100
Message-Id: <20220124184111.838647966@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 44073187990d5629804ce0627525f6ea5cfef171 ]

It seems pretty clear ppp layer assumed user space
would always be kind to provide enough data
in their write() to a ppp device.

This patch makes sure user provides at least
2 bytes.

It adds PPP_PROTO_LEN macro that could replace
in net-next many occurrences of hard-coded 2 value.

I replaced only one occurrence to ease backports
to stable kernels.

The bug manifests in the following report:

BUG: KMSAN: uninit-value in ppp_send_frame+0x28d/0x27c0 drivers/net/ppp/ppp_generic.c:1740
 ppp_send_frame+0x28d/0x27c0 drivers/net/ppp/ppp_generic.c:1740
 __ppp_xmit_process+0x23e/0x4b0 drivers/net/ppp/ppp_generic.c:1640
 ppp_xmit_process+0x1fe/0x480 drivers/net/ppp/ppp_generic.c:1661
 ppp_write+0x5cb/0x5e0 drivers/net/ppp/ppp_generic.c:513
 do_iter_write+0xb0c/0x1500 fs/read_write.c:853
 vfs_writev fs/read_write.c:924 [inline]
 do_writev+0x645/0xe00 fs/read_write.c:967
 __do_sys_writev fs/read_write.c:1040 [inline]
 __se_sys_writev fs/read_write.c:1037 [inline]
 __x64_sys_writev+0xe5/0x120 fs/read_write.c:1037
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:524 [inline]
 slab_alloc_node mm/slub.c:3251 [inline]
 __kmalloc_node_track_caller+0xe0c/0x1510 mm/slub.c:4974
 kmalloc_reserve net/core/skbuff.c:354 [inline]
 __alloc_skb+0x545/0xf90 net/core/skbuff.c:426
 alloc_skb include/linux/skbuff.h:1126 [inline]
 ppp_write+0x11d/0x5e0 drivers/net/ppp/ppp_generic.c:501
 do_iter_write+0xb0c/0x1500 fs/read_write.c:853
 vfs_writev fs/read_write.c:924 [inline]
 do_writev+0x645/0xe00 fs/read_write.c:967
 __do_sys_writev fs/read_write.c:1040 [inline]
 __se_sys_writev fs/read_write.c:1037 [inline]
 __x64_sys_writev+0xe5/0x120 fs/read_write.c:1037
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linux-ppp@vger.kernel.org
Reported-by: syzbot <syzkaller@googlegroups.com>
Acked-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_generic.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index fb52cd175b45d..829d6ada1704c 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -69,6 +69,8 @@
 #define MPHDRLEN	6	/* multilink protocol header length */
 #define MPHDRLEN_SSN	4	/* ditto with short sequence numbers */
 
+#define PPP_PROTO_LEN	2
+
 /*
  * An instance of /dev/ppp can be associated with either a ppp
  * interface unit or a ppp channel.  In both cases, file->private_data
@@ -497,6 +499,9 @@ static ssize_t ppp_write(struct file *file, const char __user *buf,
 
 	if (!pf)
 		return -ENXIO;
+	/* All PPP packets should start with the 2-byte protocol */
+	if (count < PPP_PROTO_LEN)
+		return -EINVAL;
 	ret = -ENOMEM;
 	skb = alloc_skb(count + pf->hdrlen, GFP_KERNEL);
 	if (!skb)
@@ -1764,7 +1769,7 @@ ppp_send_frame(struct ppp *ppp, struct sk_buff *skb)
 	}
 
 	++ppp->stats64.tx_packets;
-	ppp->stats64.tx_bytes += skb->len - 2;
+	ppp->stats64.tx_bytes += skb->len - PPP_PROTO_LEN;
 
 	switch (proto) {
 	case PPP_IP:
-- 
2.34.1



