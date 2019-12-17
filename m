Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F51D1220E1
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfLQA6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:58:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34818 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726752AbfLQAvh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:37 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15I-0003L9-20; Tue, 17 Dec 2019 00:51:32 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15G-0005UZ-R0; Tue, 17 Dec 2019 00:51:30 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "syzbot" <syzkaller@googlegroups.com>
Date:   Tue, 17 Dec 2019 00:46:15 +0000
Message-ID: <lsq.1576543535.857630143@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 041/136] nfc: fix memory leak in llcp_sock_bind()
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit a0c2dc1fe63e2869b74c1c7f6a81d1745c8a695d upstream.

sysbot reported a memory leak after a bind() has failed.

While we are at it, abort the operation if kmemdup() has failed.

BUG: memory leak
unreferenced object 0xffff888105d83ec0 (size 32):
  comm "syz-executor067", pid 7207, jiffies 4294956228 (age 19.430s)
  hex dump (first 32 bytes):
    00 69 6c 65 20 72 65 61 64 00 6e 65 74 3a 5b 34  .ile read.net:[4
    30 32 36 35 33 33 30 39 37 5d 00 00 00 00 00 00  026533097]......
  backtrace:
    [<0000000036bac473>] kmemleak_alloc_recursive /./include/linux/kmemleak.h:43 [inline]
    [<0000000036bac473>] slab_post_alloc_hook /mm/slab.h:522 [inline]
    [<0000000036bac473>] slab_alloc /mm/slab.c:3319 [inline]
    [<0000000036bac473>] __do_kmalloc /mm/slab.c:3653 [inline]
    [<0000000036bac473>] __kmalloc_track_caller+0x169/0x2d0 /mm/slab.c:3670
    [<000000000cd39d07>] kmemdup+0x27/0x60 /mm/util.c:120
    [<000000008e57e5fc>] kmemdup /./include/linux/string.h:432 [inline]
    [<000000008e57e5fc>] llcp_sock_bind+0x1b3/0x230 /net/nfc/llcp_sock.c:107
    [<000000009cb0b5d3>] __sys_bind+0x11c/0x140 /net/socket.c:1647
    [<00000000492c3bbc>] __do_sys_bind /net/socket.c:1658 [inline]
    [<00000000492c3bbc>] __se_sys_bind /net/socket.c:1656 [inline]
    [<00000000492c3bbc>] __x64_sys_bind+0x1e/0x30 /net/socket.c:1656
    [<0000000008704b2a>] do_syscall_64+0x76/0x1a0 /arch/x86/entry/common.c:296
    [<000000009f4c57a4>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 30cc4587659e ("NFC: Move LLCP code to the NFC top level diirectory")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/nfc/llcp_sock.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -117,9 +117,14 @@ static int llcp_sock_bind(struct socket
 	llcp_sock->service_name = kmemdup(llcp_addr.service_name,
 					  llcp_sock->service_name_len,
 					  GFP_KERNEL);
-
+	if (!llcp_sock->service_name) {
+		ret = -ENOMEM;
+		goto put_dev;
+	}
 	llcp_sock->ssap = nfc_llcp_get_sdp_ssap(local, llcp_sock);
 	if (llcp_sock->ssap == LLCP_SAP_MAX) {
+		kfree(llcp_sock->service_name);
+		llcp_sock->service_name = NULL;
 		ret = -EADDRINUSE;
 		goto put_dev;
 	}

