Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4452350F3C1
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244968AbiDZI14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344708AbiDZI1g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:27:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFAF53AA5F;
        Tue, 26 Apr 2022 01:23:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48A6F617EA;
        Tue, 26 Apr 2022 08:23:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57982C385A4;
        Tue, 26 Apr 2022 08:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961419;
        bh=b28C6sxV5/ySAeFce2tzdxxxiRiKxVIZJhblxl+HbkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQ+IXZbFKJP4+XV9rGKSlDFrOI4gnHe1yD7EItJhE1NEDuGC82KnZXDSp7PKxeflm
         c3UNO60kaiQ6ypjqDtIGaZMn2waOUQMtEM1kknh25pw3ViO1QycWdCD1MuuSMqMiPD
         Q7BmkXoRak22xFz0MRma8hEqGI5cEQ9dSn9Mxpc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 07/24] netlink: reset network and mac headers in netlink_dump()
Date:   Tue, 26 Apr 2022 10:21:01 +0200
Message-Id: <20220426081731.588949864@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081731.370823950@linuxfoundation.org>
References: <20220426081731.370823950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 99c07327ae11e24886d552dddbe4537bfca2765d ]

netlink_dump() is allocating an skb, reserves space in it
but forgets to reset network header.

This allows a BPF program, invoked later from sk_filter()
to access uninitialized kernel memory from the reserved
space.

Theorically mac header reset could be omitted, because
it is set to a special initial value.
bpf_internal_load_pointer_neg_helper calls skb_mac_header()
without checking skb_mac_header_was_set().
Relying on skb->len not being too big seems fragile.
We also could add a sanity check in bpf_internal_load_pointer_neg_helper()
to avoid surprises in the future.

syzbot report was:

BUG: KMSAN: uninit-value in ___bpf_prog_run+0xa22b/0xb420 kernel/bpf/core.c:1637
 ___bpf_prog_run+0xa22b/0xb420 kernel/bpf/core.c:1637
 __bpf_prog_run32+0x121/0x180 kernel/bpf/core.c:1796
 bpf_dispatcher_nop_func include/linux/bpf.h:784 [inline]
 __bpf_prog_run include/linux/filter.h:626 [inline]
 bpf_prog_run include/linux/filter.h:633 [inline]
 __bpf_prog_run_save_cb+0x168/0x580 include/linux/filter.h:756
 bpf_prog_run_save_cb include/linux/filter.h:770 [inline]
 sk_filter_trim_cap+0x3bc/0x8c0 net/core/filter.c:150
 sk_filter include/linux/filter.h:905 [inline]
 netlink_dump+0xe0c/0x16c0 net/netlink/af_netlink.c:2276
 netlink_recvmsg+0x1129/0x1c80 net/netlink/af_netlink.c:2002
 sock_recvmsg_nosec net/socket.c:948 [inline]
 sock_recvmsg net/socket.c:966 [inline]
 sock_read_iter+0x5a9/0x630 net/socket.c:1039
 do_iter_readv_writev+0xa7f/0xc70
 do_iter_read+0x52c/0x14c0 fs/read_write.c:786
 vfs_readv fs/read_write.c:906 [inline]
 do_readv+0x432/0x800 fs/read_write.c:943
 __do_sys_readv fs/read_write.c:1034 [inline]
 __se_sys_readv fs/read_write.c:1031 [inline]
 __x64_sys_readv+0xe5/0x120 fs/read_write.c:1031
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:81
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was stored to memory at:
 ___bpf_prog_run+0x96c/0xb420 kernel/bpf/core.c:1558
 __bpf_prog_run32+0x121/0x180 kernel/bpf/core.c:1796
 bpf_dispatcher_nop_func include/linux/bpf.h:784 [inline]
 __bpf_prog_run include/linux/filter.h:626 [inline]
 bpf_prog_run include/linux/filter.h:633 [inline]
 __bpf_prog_run_save_cb+0x168/0x580 include/linux/filter.h:756
 bpf_prog_run_save_cb include/linux/filter.h:770 [inline]
 sk_filter_trim_cap+0x3bc/0x8c0 net/core/filter.c:150
 sk_filter include/linux/filter.h:905 [inline]
 netlink_dump+0xe0c/0x16c0 net/netlink/af_netlink.c:2276
 netlink_recvmsg+0x1129/0x1c80 net/netlink/af_netlink.c:2002
 sock_recvmsg_nosec net/socket.c:948 [inline]
 sock_recvmsg net/socket.c:966 [inline]
 sock_read_iter+0x5a9/0x630 net/socket.c:1039
 do_iter_readv_writev+0xa7f/0xc70
 do_iter_read+0x52c/0x14c0 fs/read_write.c:786
 vfs_readv fs/read_write.c:906 [inline]
 do_readv+0x432/0x800 fs/read_write.c:943
 __do_sys_readv fs/read_write.c:1034 [inline]
 __se_sys_readv fs/read_write.c:1031 [inline]
 __x64_sys_readv+0xe5/0x120 fs/read_write.c:1031
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:81
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:737 [inline]
 slab_alloc_node mm/slub.c:3244 [inline]
 __kmalloc_node_track_caller+0xde3/0x14f0 mm/slub.c:4972
 kmalloc_reserve net/core/skbuff.c:354 [inline]
 __alloc_skb+0x545/0xf90 net/core/skbuff.c:426
 alloc_skb include/linux/skbuff.h:1158 [inline]
 netlink_dump+0x30f/0x16c0 net/netlink/af_netlink.c:2242
 netlink_recvmsg+0x1129/0x1c80 net/netlink/af_netlink.c:2002
 sock_recvmsg_nosec net/socket.c:948 [inline]
 sock_recvmsg net/socket.c:966 [inline]
 sock_read_iter+0x5a9/0x630 net/socket.c:1039
 do_iter_readv_writev+0xa7f/0xc70
 do_iter_read+0x52c/0x14c0 fs/read_write.c:786
 vfs_readv fs/read_write.c:906 [inline]
 do_readv+0x432/0x800 fs/read_write.c:943
 __do_sys_readv fs/read_write.c:1034 [inline]
 __se_sys_readv fs/read_write.c:1031 [inline]
 __x64_sys_readv+0xe5/0x120 fs/read_write.c:1031
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:81
 entry_SYSCALL_64_after_hwframe+0x44/0xae

CPU: 0 PID: 3470 Comm: syz-executor751 Not tainted 5.17.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: db65a3aaf29e ("netlink: Trim skb to alloc size to avoid MSG_TRUNC")
Fixes: 9063e21fb026 ("netlink: autosize skb lengthes")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Link: https://lore.kernel.org/r/20220415181442.551228-1-eric.dumazet@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 8aef475fef31..a8674e9ff37b 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2194,6 +2194,13 @@ static int netlink_dump(struct sock *sk)
 	 * single netdev. The outcome is MSG_TRUNC error.
 	 */
 	skb_reserve(skb, skb_tailroom(skb) - alloc_size);
+
+	/* Make sure malicious BPF programs can not read unitialized memory
+	 * from skb->head -> skb->data
+	 */
+	skb_reset_network_header(skb);
+	skb_reset_mac_header(skb);
+
 	netlink_skb_set_owner_r(skb, sk);
 
 	if (nlk->dump_done_errno > 0)
-- 
2.35.1



