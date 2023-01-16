Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4865066C729
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbjAPQ2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233161AbjAPQ2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:28:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C412D2D148
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:16:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 616F361041
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:16:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7246DC433EF;
        Mon, 16 Jan 2023 16:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885784;
        bh=Bk17wbfieS+IATCK1z+OCL7gxgWLt1xr1VuQzhqPW2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ya6lWaJhweAPWBjEF6NYTy5aUKq05VG4AAorNZTwjKcy2YzRPytUim7d5pUtvJrmB
         mPHwE45fwEiK3I7Gp2XmEfbyhO+m3l+mVCZkxFQfmzU4xvC85Msy2wWFYOeoMCtQNV
         ql8QGIdvP7TNEMSdSxeh+vLA615bO/d0vMSa3Bns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 182/658] bpf, sockmap: fix race in sock_map_free()
Date:   Mon, 16 Jan 2023 16:44:30 +0100
Message-Id: <20230116154917.764334302@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0a182f8d607464911756b4dbef5d6cad8de22469 ]

sock_map_free() calls release_sock(sk) without owning a reference
on the socket. This can cause use-after-free as syzbot found [1]

Jakub Sitnicki already took care of a similar issue
in sock_hash_free() in commit 75e68e5bf2c7 ("bpf, sockhash:
Synchronize delete from bucket list on map free")

[1]
refcount_t: decrement hit 0; leaking memory.
WARNING: CPU: 0 PID: 3785 at lib/refcount.c:31 refcount_warn_saturate+0x17c/0x1a0 lib/refcount.c:31
Modules linked in:
CPU: 0 PID: 3785 Comm: kworker/u4:6 Not tainted 6.1.0-rc7-syzkaller-00103-gef4d3ea40565 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound bpf_map_free_deferred
RIP: 0010:refcount_warn_saturate+0x17c/0x1a0 lib/refcount.c:31
Code: 68 8b 31 c0 e8 75 71 15 fd 0f 0b e9 64 ff ff ff e8 d9 6e 4e fd c6 05 62 9c 3d 0a 01 48 c7 c7 80 bb 68 8b 31 c0 e8 54 71 15 fd <0f> 0b e9 43 ff ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c a2 fe ff
RSP: 0018:ffffc9000456fb60 EFLAGS: 00010246
RAX: eae59bab72dcd700 RBX: 0000000000000004 RCX: ffff8880207057c0
RDX: 0000000000000000 RSI: 0000000000000201 RDI: 0000000000000000
RBP: 0000000000000004 R08: ffffffff816fdabd R09: fffff520008adee5
R10: fffff520008adee5 R11: 1ffff920008adee4 R12: 0000000000000004
R13: dffffc0000000000 R14: ffff88807b1c6c00 R15: 1ffff1100f638dcf
FS: 0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30c30000 CR3: 000000000d08e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
__refcount_dec include/linux/refcount.h:344 [inline]
refcount_dec include/linux/refcount.h:359 [inline]
__sock_put include/net/sock.h:779 [inline]
tcp_release_cb+0x2d0/0x360 net/ipv4/tcp_output.c:1092
release_sock+0xaf/0x1c0 net/core/sock.c:3468
sock_map_free+0x219/0x2c0 net/core/sock_map.c:356
process_one_work+0x81c/0xd10 kernel/workqueue.c:2289
worker_thread+0xb14/0x1330 kernel/workqueue.c:2436
kthread+0x266/0x300 kernel/kthread.c:376
ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
</TASK>

Fixes: 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear down")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Song Liu <songliubraving@fb.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/r/20221202111640.2745533-1-edumazet@google.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 2646e8f98f67..5bce6d4d2057 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -279,11 +279,13 @@ static void sock_map_free(struct bpf_map *map)
 
 		sk = xchg(psk, NULL);
 		if (sk) {
+			sock_hold(sk);
 			lock_sock(sk);
 			rcu_read_lock();
 			sock_map_unref(sk, psk);
 			rcu_read_unlock();
 			release_sock(sk);
+			sock_put(sk);
 		}
 	}
 
-- 
2.35.1



