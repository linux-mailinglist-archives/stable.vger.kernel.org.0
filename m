Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077513CA77A
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240845AbhGOSyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:54:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240196AbhGOSxT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:53:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C616613CF;
        Thu, 15 Jul 2021 18:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375025;
        bh=DtX/bfoIb8yS1vHs2Tw3r89uJfmPjrYLb1lWwESbjZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UgSnp477CBdzmqNVVH9erTJfyel0UEtqm/J4Nb1GCYUoFTdAFc4gyITt6aMAa1fV7
         FLcMZlsW8VMg9wtihZ0D8omb8ReZnciwzVmSnmfAizW7n3hqjz08+gJmG+fCR4TAlS
         TPhbDQT10gt1BtD2kkFG56o8GNVAToxnEFwrO2AM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+5d895828587f49e7fe9b@syzkaller.appspotmail.com,
        Rustam Kovhaev <rkovhaev@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 127/215] bpf: Fix false positive kmemleak report in bpf_ringbuf_area_alloc()
Date:   Thu, 15 Jul 2021 20:38:19 +0200
Message-Id: <20210715182621.923134617@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rustam Kovhaev <rkovhaev@gmail.com>

[ Upstream commit ccff81e1d028bbbf8573d3364a87542386c707bf ]

kmemleak scans struct page, but it does not scan the page content. If we
allocate some memory with kmalloc(), then allocate page with alloc_page(),
and if we put kmalloc pointer somewhere inside that page, kmemleak will
report kmalloc pointer as a false positive.

We can instruct kmemleak to scan the memory area by calling kmemleak_alloc()
and kmemleak_free(), but part of struct bpf_ringbuf is mmaped to user space,
and if struct bpf_ringbuf changes we would have to revisit and review size
argument in kmemleak_alloc(), because we do not want kmemleak to scan the
user space memory. Let's simplify things and use kmemleak_not_leak() here.

For posterity, also adding additional prior analysis from Andrii:

  I think either kmemleak or syzbot are misreporting this. I've added a
  bunch of printks around all allocations performed by BPF ringbuf. [...]
  On repro side I get these two warnings:

  [vmuser@archvm bpf]$ sudo ./repro
  BUG: memory leak
  unreferenced object 0xffff88810d538c00 (size 64):
    comm "repro", pid 2140, jiffies 4294692933 (age 14.540s)
    hex dump (first 32 bytes):
      00 af 19 04 00 ea ff ff c0 ae 19 04 00 ea ff ff  ................
      80 ae 19 04 00 ea ff ff c0 29 2e 04 00 ea ff ff  .........)......
    backtrace:
      [<0000000077bfbfbd>] __bpf_map_area_alloc+0x31/0xc0
      [<00000000587fa522>] ringbuf_map_alloc.cold.4+0x48/0x218
      [<0000000044d49e96>] __do_sys_bpf+0x359/0x1d90
      [<00000000f601d565>] do_syscall_64+0x2d/0x40
      [<0000000043d3112a>] entry_SYSCALL_64_after_hwframe+0x44/0xae

  BUG: memory leak
  unreferenced object 0xffff88810d538c80 (size 64):
    comm "repro", pid 2143, jiffies 4294699025 (age 8.448s)
    hex dump (first 32 bytes):
      80 aa 19 04 00 ea ff ff 00 ab 19 04 00 ea ff ff  ................
      c0 ab 19 04 00 ea ff ff 80 44 28 04 00 ea ff ff  .........D(.....
    backtrace:
      [<0000000077bfbfbd>] __bpf_map_area_alloc+0x31/0xc0
      [<00000000587fa522>] ringbuf_map_alloc.cold.4+0x48/0x218
      [<0000000044d49e96>] __do_sys_bpf+0x359/0x1d90
      [<00000000f601d565>] do_syscall_64+0x2d/0x40
      [<0000000043d3112a>] entry_SYSCALL_64_after_hwframe+0x44/0xae

  Note that both reported leaks (ffff88810d538c80 and ffff88810d538c00)
  correspond to pages array bpf_ringbuf is allocating and tracking properly
  internally. Note also that syzbot repro doesn't close FD of created BPF
  ringbufs, and even when ./repro itself exits with error, there are still
  two forked processes hanging around in my system. So clearly ringbuf maps
  are alive at that point. So reporting any memory leak looks weird at that
  point, because that memory is being used by active referenced BPF ringbuf.

  It's also a question why repro doesn't clean up its forks. But if I do a
  `pkill repro`, I do see that all the allocated memory is /properly/ cleaned
  up [and the] "leaks" are deallocated properly.

  BTW, if I add close() right after bpf() syscall in syzbot repro, I see that
  everything is immediately deallocated, like designed. And no memory leak
  is reported. So I don't think the problem is anywhere in bpf_ringbuf code,
  rather in the leak detection and/or repro itself.

Reported-by: syzbot+5d895828587f49e7fe9b@syzkaller.appspotmail.com
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
[ Daniel: also included analysis from Andrii to the commit log ]
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: syzbot+5d895828587f49e7fe9b@syzkaller.appspotmail.com
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/CAEf4BzYk+dqs+jwu6VKXP-RttcTEGFe+ySTGWT9CRNkagDiJVA@mail.gmail.com
Link: https://lore.kernel.org/lkml/YNTAqiE7CWJhOK2M@nuc10
Link: https://lore.kernel.org/lkml/20210615101515.GC26027@arm.com
Link: https://syzkaller.appspot.com/bug?extid=5d895828587f49e7fe9b
Link: https://lore.kernel.org/bpf/20210626181156.1873604-1-rkovhaev@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/ringbuf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index add0b34f2b34..f9913bc65ef8 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -8,6 +8,7 @@
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
 #include <linux/poll.h>
+#include <linux/kmemleak.h>
 #include <uapi/linux/btf.h>
 
 #define RINGBUF_CREATE_FLAG_MASK (BPF_F_NUMA_NODE)
@@ -109,6 +110,7 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node)
 	rb = vmap(pages, nr_meta_pages + 2 * nr_data_pages,
 		  VM_ALLOC | VM_USERMAP, PAGE_KERNEL);
 	if (rb) {
+		kmemleak_not_leak(pages);
 		rb->pages = pages;
 		rb->nr_pages = nr_pages;
 		return rb;
-- 
2.30.2



