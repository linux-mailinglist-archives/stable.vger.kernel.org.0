Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96AA86158B3
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbiKBC4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbiKBC4y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:56:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0657722516
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:56:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92CB2617CF
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3446DC433D6;
        Wed,  2 Nov 2022 02:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357813;
        bh=oH/Y4gBbmiV0RQAS2mRbM3vrp7iXh/245JVg5AbGjOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z527Hu8iMGukeZdMXBtoe9DSLGItPXslUgTB187wmi2xjEHClUpcq4h5eDDlM3t+c
         3+N3WspFNUjrqUB2SW8sYv1CCT3iS3PmUW4/AZUbsdU0gipp9rKHC4qKTQ9uvIT1aX
         /g5hImWSZXNrS2UZjDNtD9Bib88K6So/ArPB55/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 233/240] net: do not sense pfmemalloc status in skb_append_pagefrags()
Date:   Wed,  2 Nov 2022 03:33:28 +0100
Message-Id: <20221102022116.672519320@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 228ebc41dfab5b5d34cd76835ddb0ca8ee12f513 ]

skb_append_pagefrags() is used by af_unix and udp sendpage()
implementation so far.

In commit 326140063946 ("tcp: TX zerocopy should not sense
pfmemalloc status") we explained why we should not sense
pfmemalloc status for pages owned by user space.

We should also use skb_fill_page_desc_noacc()
in skb_append_pagefrags() to avoid following KCSAN report:

BUG: KCSAN: data-race in lru_add_fn / skb_append_pagefrags

write to 0xffffea00058fc1c8 of 8 bytes by task 17319 on cpu 0:
__list_add include/linux/list.h:73 [inline]
list_add include/linux/list.h:88 [inline]
lruvec_add_folio include/linux/mm_inline.h:323 [inline]
lru_add_fn+0x327/0x410 mm/swap.c:228
folio_batch_move_lru+0x1e1/0x2a0 mm/swap.c:246
lru_add_drain_cpu+0x73/0x250 mm/swap.c:669
lru_add_drain+0x21/0x60 mm/swap.c:773
free_pages_and_swap_cache+0x16/0x70 mm/swap_state.c:311
tlb_batch_pages_flush mm/mmu_gather.c:59 [inline]
tlb_flush_mmu_free mm/mmu_gather.c:256 [inline]
tlb_flush_mmu+0x5b2/0x640 mm/mmu_gather.c:263
tlb_finish_mmu+0x86/0x100 mm/mmu_gather.c:363
exit_mmap+0x190/0x4d0 mm/mmap.c:3098
__mmput+0x27/0x1b0 kernel/fork.c:1185
mmput+0x3d/0x50 kernel/fork.c:1207
copy_process+0x19fc/0x2100 kernel/fork.c:2518
kernel_clone+0x166/0x550 kernel/fork.c:2671
__do_sys_clone kernel/fork.c:2812 [inline]
__se_sys_clone kernel/fork.c:2796 [inline]
__x64_sys_clone+0xc3/0xf0 kernel/fork.c:2796
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

read to 0xffffea00058fc1c8 of 8 bytes by task 17325 on cpu 1:
page_is_pfmemalloc include/linux/mm.h:1817 [inline]
__skb_fill_page_desc include/linux/skbuff.h:2432 [inline]
skb_fill_page_desc include/linux/skbuff.h:2453 [inline]
skb_append_pagefrags+0x210/0x600 net/core/skbuff.c:3974
unix_stream_sendpage+0x45e/0x990 net/unix/af_unix.c:2338
kernel_sendpage+0x184/0x300 net/socket.c:3561
sock_sendpage+0x5a/0x70 net/socket.c:1054
pipe_to_sendpage+0x128/0x160 fs/splice.c:361
splice_from_pipe_feed fs/splice.c:415 [inline]
__splice_from_pipe+0x222/0x4d0 fs/splice.c:559
splice_from_pipe fs/splice.c:594 [inline]
generic_splice_sendpage+0x89/0xc0 fs/splice.c:743
do_splice_from fs/splice.c:764 [inline]
direct_splice_actor+0x80/0xa0 fs/splice.c:931
splice_direct_to_actor+0x305/0x620 fs/splice.c:886
do_splice_direct+0xfb/0x180 fs/splice.c:974
do_sendfile+0x3bf/0x910 fs/read_write.c:1255
__do_sys_sendfile64 fs/read_write.c:1323 [inline]
__se_sys_sendfile64 fs/read_write.c:1309 [inline]
__x64_sys_sendfile64+0x10c/0x150 fs/read_write.c:1309
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

value changed: 0x0000000000000000 -> 0xffffea00058fc188

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 17325 Comm: syz-executor.0 Not tainted 6.1.0-rc1-syzkaller-00158-g440b7895c990-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/11/2022

Fixes: 326140063946 ("tcp: TX zerocopy should not sense pfmemalloc status")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20221027040346.1104204-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 417463da4fac..5e1a8eeb5e32 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3868,7 +3868,7 @@ int skb_append_pagefrags(struct sk_buff *skb, struct page *page,
 	} else if (i < MAX_SKB_FRAGS) {
 		skb_zcopy_downgrade_managed(skb);
 		get_page(page);
-		skb_fill_page_desc(skb, i, page, offset, size);
+		skb_fill_page_desc_noacc(skb, i, page, offset, size);
 	} else {
 		return -EMSGSIZE;
 	}
-- 
2.35.1



