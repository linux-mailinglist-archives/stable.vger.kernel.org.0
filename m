Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 724D5CD867
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbfJFRYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:24:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727944AbfJFRYj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:24:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFBFF20867;
        Sun,  6 Oct 2019 17:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382678;
        bh=H1UlWTytnQ7kqdRX4mbQdL7bveS9FBSgwFgIlp3T5Ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u+UezLYaGMCVhHGlXayGlmpN52qIQMNmddik+bqkRu+bT2JLZVf8gHhvK1StAlctt
         3ehzJWq3DeZdfBHRrlHKgwX1bsIAgj1VLpUDifCUvtkaDlAaKsYAFBUEcNu/CMPTLZ
         xhX2CtA7gxK/bODhmJPukntekwUfX2TmKWlNIBfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 38/47] nfc: fix memory leak in llcp_sock_bind()
Date:   Sun,  6 Oct 2019 19:21:25 +0200
Message-Id: <20191006172018.897792221@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006172016.873463083@linuxfoundation.org>
References: <20191006172016.873463083@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a0c2dc1fe63e2869b74c1c7f6a81d1745c8a695d ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/llcp_sock.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -118,9 +118,14 @@ static int llcp_sock_bind(struct socket
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


