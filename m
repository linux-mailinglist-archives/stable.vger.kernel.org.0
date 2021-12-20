Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACED647ABF3
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234562AbhLTOkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234839AbhLTOjW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:39:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47895C061785;
        Mon, 20 Dec 2021 06:39:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4F83B80EEF;
        Mon, 20 Dec 2021 14:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281ECC36AE8;
        Mon, 20 Dec 2021 14:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011159;
        bh=sNNu4jVaU97YaSVIlyxjn7c0DfeFD9w8simXp1ehp9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2bv6hQzfTgVviSvEzkqTC15KwYHh/1N9+jPkOZOMYLbsdYRuZYCPfw3XJA5MN1i9j
         LpdqbLHBNpcOcggEKRG+t96YFfu4F3jwL/DUMTeq5D6fh1AsefD3aNSE0l8HOV0t8b
         nuka98XBzy3hGamUgYn/3TWR5kZ03g3/zi6f+k3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 24/45] sit: do not call ipip6_dev_free() from sit_init_net()
Date:   Mon, 20 Dec 2021 15:34:19 +0100
Message-Id: <20211220143023.078823955@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143022.266532675@linuxfoundation.org>
References: <20211220143022.266532675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e28587cc491ef0f3c51258fdc87fbc386b1d4c59 ]

ipip6_dev_free is sit dev->priv_destructor, already called
by register_netdevice() if something goes wrong.

Alternative would be to make ipip6_dev_free() robust against
multiple invocations, but other drivers do not implement this
strategy.

syzbot reported:

dst_release underflow
WARNING: CPU: 0 PID: 5059 at net/core/dst.c:173 dst_release+0xd8/0xe0 net/core/dst.c:173
Modules linked in:
CPU: 1 PID: 5059 Comm: syz-executor.4 Not tainted 5.16.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:dst_release+0xd8/0xe0 net/core/dst.c:173
Code: 4c 89 f2 89 d9 31 c0 5b 41 5e 5d e9 da d5 44 f9 e8 1d 90 5f f9 c6 05 87 48 c6 05 01 48 c7 c7 80 44 99 8b 31 c0 e8 e8 67 29 f9 <0f> 0b eb 85 0f 1f 40 00 53 48 89 fb e8 f7 8f 5f f9 48 83 c3 a8 48
RSP: 0018:ffffc9000aa5faa0 EFLAGS: 00010246
RAX: d6894a925dd15a00 RBX: 00000000ffffffff RCX: 0000000000040000
RDX: ffffc90005e19000 RSI: 000000000003ffff RDI: 0000000000040000
RBP: 0000000000000000 R08: ffffffff816a1f42 R09: ffffed1017344f2c
R10: ffffed1017344f2c R11: 0000000000000000 R12: 0000607f462b1358
R13: 1ffffffff1bfd305 R14: ffffe8ffffcb1358 R15: dffffc0000000000
FS:  00007f66c71a2700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f88aaed5058 CR3: 0000000023e0f000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 dst_cache_destroy+0x107/0x1e0 net/core/dst_cache.c:160
 ipip6_dev_free net/ipv6/sit.c:1414 [inline]
 sit_init_net+0x229/0x550 net/ipv6/sit.c:1936
 ops_init+0x313/0x430 net/core/net_namespace.c:140
 setup_net+0x35b/0x9d0 net/core/net_namespace.c:326
 copy_net_ns+0x359/0x5c0 net/core/net_namespace.c:470
 create_new_namespaces+0x4ce/0xa00 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0x11e/0x180 kernel/nsproxy.c:226
 ksys_unshare+0x57d/0xb50 kernel/fork.c:3075
 __do_sys_unshare kernel/fork.c:3146 [inline]
 __se_sys_unshare kernel/fork.c:3144 [inline]
 __x64_sys_unshare+0x34/0x40 kernel/fork.c:3144
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f66c882ce99
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f66c71a2168 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 00007f66c893ff60 RCX: 00007f66c882ce99
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000048040200
RBP: 00007f66c8886ff1 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff6634832f R14: 00007f66c71a2300 R15: 0000000000022000
 </TASK>

Fixes: cf124db566e6 ("net: Fix inconsistent teardown and release of private netdev state.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Link: https://lore.kernel.org/r/20211216111741.1387540-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/sit.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 0c71137c5d41b..43fd9cfa7b115 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1858,7 +1858,6 @@ static int __net_init sit_init_net(struct net *net)
 	return 0;
 
 err_reg_dev:
-	ipip6_dev_free(sitn->fb_tunnel_dev);
 	free_netdev(sitn->fb_tunnel_dev);
 err_alloc_dev:
 	return err;
-- 
2.33.0



