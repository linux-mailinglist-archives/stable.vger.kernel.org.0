Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664834BE24F
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351644AbiBUJuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:50:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352953AbiBUJsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:48:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2712121;
        Mon, 21 Feb 2022 01:21:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FD45608C4;
        Mon, 21 Feb 2022 09:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7534CC340E9;
        Mon, 21 Feb 2022 09:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435312;
        bh=RsCP4WFIqIduP2wma7cRCEq1uBfkFWhs7gWJGGRekYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R1icIj3eds628SL1jnd3NMWMuWZe7PGwYU3RGwj0lTjYsRcU+vfhm32vvh3Z4BIP7
         mimElq5rqsxpWj2ygM7/16BsJmMo6hMLRxsDR2R6GoBIID1q5IVVeY1NCcF0Cs/dTs
         JgXXzpPxzMGaOJ7JtnZyp8nRK2acL/ywMA/6UOMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 120/227] crypto: af_alg - get rid of alg_memory_allocated
Date:   Mon, 21 Feb 2022 09:48:59 +0100
Message-Id: <20220221084938.847859431@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 25206111512de994dfc914f5b2972a22aa904ef3 upstream.

alg_memory_allocated does not seem to be really used.

alg_proto does have a .memory_allocated field, but no
corresponding .sysctl_mem.

This means sk_has_account() returns true, but all sk_prot_mem_limits()
users will trigger a NULL dereference [1].

THis was not a problem until SO_RESERVE_MEM addition.

general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 1 PID: 3591 Comm: syz-executor153 Not tainted 5.17.0-rc3-syzkaller-00316-gb81b1829e7e3 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:sk_prot_mem_limits include/net/sock.h:1523 [inline]
RIP: 0010:sock_reserve_memory+0x1d7/0x330 net/core/sock.c:1000
Code: 08 00 74 08 48 89 ef e8 27 20 bb f9 4c 03 7c 24 10 48 8b 6d 00 48 83 c5 08 48 89 e8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 ef e8 fb 1f bb f9 48 8b 6d 00 4c 89 ff 48
RSP: 0018:ffffc90001f1fb68 EFLAGS: 00010202
RAX: 0000000000000001 RBX: ffff88814aabc000 RCX: dffffc0000000000
RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffffffff90e18120
RBP: 0000000000000008 R08: dffffc0000000000 R09: fffffbfff21c3025
R10: fffffbfff21c3025 R11: 0000000000000000 R12: ffffffff8d109840
R13: 0000000000001002 R14: 0000000000000001 R15: 0000000000000001
FS:  0000555556e08300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc74416f130 CR3: 0000000073d9e000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 sock_setsockopt+0x14a9/0x3a30 net/core/sock.c:1446
 __sys_setsockopt+0x5af/0x980 net/socket.c:2176
 __do_sys_setsockopt net/socket.c:2191 [inline]
 __se_sys_setsockopt net/socket.c:2188 [inline]
 __x64_sys_setsockopt+0xb1/0xc0 net/socket.c:2188
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fc7440fddc9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 51 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe98f07968 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fc7440fddc9
RDX: 0000000000000049 RSI: 0000000000000001 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000000000000004 R09: 00007ffe98f07990
R10: 0000000020000000 R11: 0000000000000246 R12: 00007ffe98f0798c
R13: 00007ffe98f079a0 R14: 00007ffe98f079e0 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:sk_prot_mem_limits include/net/sock.h:1523 [inline]
RIP: 0010:sock_reserve_memory+0x1d7/0x330 net/core/sock.c:1000
Code: 08 00 74 08 48 89 ef e8 27 20 bb f9 4c 03 7c 24 10 48 8b 6d 00 48 83 c5 08 48 89 e8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 ef e8 fb 1f bb f9 48 8b 6d 00 4c 89 ff 48
RSP: 0018:ffffc90001f1fb68 EFLAGS: 00010202
RAX: 0000000000000001 RBX: ffff88814aabc000 RCX: dffffc0000000000
RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffffffff90e18120
RBP: 0000000000000008 R08: dffffc0000000000 R09: fffffbfff21c3025
R10: fffffbfff21c3025 R11: 0000000000000000 R12: ffffffff8d109840
R13: 0000000000001002 R14: 0000000000000001 R15: 0000000000000001
FS:  0000555556e08300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc74416f130 CR3: 0000000073d9e000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000

Fixes: 2bb2f5fb21b0 ("net: add new socket option SO_RESERVE_MEM")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Wei Wang <weiwan@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/af_alg.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -25,12 +25,9 @@ struct alg_type_list {
 	struct list_head list;
 };
 
-static atomic_long_t alg_memory_allocated;
-
 static struct proto alg_proto = {
 	.name			= "ALG",
 	.owner			= THIS_MODULE,
-	.memory_allocated	= &alg_memory_allocated,
 	.obj_size		= sizeof(struct alg_sock),
 };
 


