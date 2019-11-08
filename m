Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E814DF5683
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391265AbfKHTJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:09:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:40876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387556AbfKHTJR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:09:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A38920673;
        Fri,  8 Nov 2019 19:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240157;
        bh=tpuQoNJVpjn0kU/NMgrkC7yxYZd56hAMheU7OpqGfzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A296bmKCNz3iok/HFy2UaJPYYx7kiG6K3IUWRcgKiMIdhnzC/FS5u/Ywmp8r64W/A
         I43bGycwq+6t2EO9C7sS2ebER7+IJ/EZFJSimpLn1W0X8qPpi6qaAPPF44d2Ih/ARg
         Ow1hIx88cWdqCItl6WbdkMk9TKMNTtCTDJvBb/yw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takeshi Misawa <jeliantsurux@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+3b3296d032353c33184b@syzkaller.appspotmail.com
Subject: [PATCH 5.3 107/140] keys: Fix memory leak in copy_net_ns
Date:   Fri,  8 Nov 2019 19:50:35 +0100
Message-Id: <20191108174911.646944128@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takeshi Misawa <jeliantsurux@gmail.com>

[ Upstream commit 82ecff655e7968151b0047f1b5de03b249e5c1c4 ]

If copy_net_ns() failed after net_alloc(), net->key_domain is leaked.
Fix this, by freeing key_domain in error path.

syzbot report:
BUG: memory leak
unreferenced object 0xffff8881175007e0 (size 32):
  comm "syz-executor902", pid 7069, jiffies 4294944350 (age 28.400s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000a83ed741>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
    [<00000000a83ed741>] slab_post_alloc_hook mm/slab.h:439 [inline]
    [<00000000a83ed741>] slab_alloc mm/slab.c:3326 [inline]
    [<00000000a83ed741>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
    [<0000000059fc92b9>] kmalloc include/linux/slab.h:547 [inline]
    [<0000000059fc92b9>] kzalloc include/linux/slab.h:742 [inline]
    [<0000000059fc92b9>] net_alloc net/core/net_namespace.c:398 [inline]
    [<0000000059fc92b9>] copy_net_ns+0xb2/0x220 net/core/net_namespace.c:445
    [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0 kernel/nsproxy.c:103
    [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100 kernel/nsproxy.c:202
    [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
    [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
    [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
    [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740
    [<00000000f4c5f2c8>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:296
    [<0000000038550184>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

syzbot also reported other leak in copy_net_ns -> setup_net.
This problem is already fixed by cf47a0b882a4e5f6b34c7949d7b293e9287f1972.

Fixes: 9b242610514f ("keys: Network namespace domain tag")
Reported-and-tested-by: syzbot+3b3296d032353c33184b@syzkaller.appspotmail.com
Signed-off-by: Takeshi Misawa <jeliantsurux@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/net_namespace.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -478,6 +478,7 @@ struct net *copy_net_ns(unsigned long fl
 
 	if (rv < 0) {
 put_userns:
+		key_remove_domain(net->key_domain);
 		put_user_ns(user_ns);
 		net_drop_ns(net);
 dec_ucounts:


