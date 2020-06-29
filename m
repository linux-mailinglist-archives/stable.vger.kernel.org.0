Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9BB20E28E
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730963AbgF2VGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:06:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730874AbgF2TKS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:10:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDB2A254A8;
        Mon, 29 Jun 2020 15:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593446001;
        bh=JF4D4GxBKYc22QwJ+VHkcFbhksUi+zc6GFQewDK7e4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HQVwG67N/Ar8BfmZJYjtHQqYSvLgd4XAV9iR7dK6H0fg98ljJlsImxhUMUZeb4ZHF
         tUL+l8wEGLAOzDh6D0wlATEh6k8RBStgGajgndfR5FMSt82knNGtMxMh65KWyWk7w+
         F5gF7MZWYM0C5OOY3o0zpOP5TtWJYsI1egqdbiDI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Emmanuel Nicolet <emmanuel.nicolet@gmail.com>,
        Geoff Levand <geoff@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 009/135] ps3disk: use the default segment boundary
Date:   Mon, 29 Jun 2020 11:51:03 -0400
Message-Id: <20200629155309.2495516-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
References: <20200629155309.2495516-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:53+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emmanuel Nicolet <emmanuel.nicolet@gmail.com>

[ Upstream commit 720bc316690bd27dea9d71510b50f0cd698ffc32 ]

Since commit dcebd755926b ("block: use bio_for_each_bvec() to compute
multi-page bvec count"), the kernel will bug_on on the PS3 because
bio_split() is called with sectors == 0:

  kernel BUG at block/bio.c:1853!
  Oops: Exception in kernel mode, sig: 5 [#1]
  BE PAGE_SIZE=4K MMU=Hash PREEMPT SMP NR_CPUS=8 NUMA PS3
  Modules linked in: firewire_sbp2 rtc_ps3(+) soundcore ps3_gelic(+) \
  ps3rom(+) firewire_core ps3vram(+) usb_common crc_itu_t
  CPU: 0 PID: 97 Comm: blkid Not tainted 5.3.0-rc4 #1
  NIP:  c00000000027d0d0 LR: c00000000027d0b0 CTR: 0000000000000000
  REGS: c00000000135ae90 TRAP: 0700   Not tainted  (5.3.0-rc4)
  MSR:  8000000000028032 <SF,EE,IR,DR,RI>  CR: 44008240  XER: 20000000
  IRQMASK: 0
  GPR00: c000000000289368 c00000000135b120 c00000000084a500 c000000004ff8300
  GPR04: 0000000000000c00 c000000004c905e0 c000000004c905e0 000000000000ffff
  GPR08: 0000000000000000 0000000000000001 0000000000000000 000000000000ffff
  GPR12: 0000000000000000 c0000000008ef000 000000000000003e 0000000000080001
  GPR16: 0000000000000100 000000000000ffff 0000000000000000 0000000000000004
  GPR20: c00000000062fd7e 0000000000000001 000000000000ffff 0000000000000080
  GPR24: c000000000781788 c00000000135b350 0000000000000080 c000000004c905e0
  GPR28: c00000000135b348 c000000004ff8300 0000000000000000 c000000004c90000
  NIP [c00000000027d0d0] .bio_split+0x28/0xac
  LR [c00000000027d0b0] .bio_split+0x8/0xac
  Call Trace:
  [c00000000135b120] [c00000000027d130] .bio_split+0x88/0xac (unreliable)
  [c00000000135b1b0] [c000000000289368] .__blk_queue_split+0x11c/0x53c
  [c00000000135b2d0] [c00000000028f614] .blk_mq_make_request+0x80/0x7d4
  [c00000000135b3d0] [c000000000283a8c] .generic_make_request+0x118/0x294
  [c00000000135b4b0] [c000000000283d34] .submit_bio+0x12c/0x174
  [c00000000135b580] [c000000000205a44] .mpage_bio_submit+0x3c/0x4c
  [c00000000135b600] [c000000000206184] .mpage_readpages+0xa4/0x184
  [c00000000135b750] [c0000000001ff8fc] .blkdev_readpages+0x24/0x38
  [c00000000135b7c0] [c0000000001589f0] .read_pages+0x6c/0x1a8
  [c00000000135b8b0] [c000000000158c74] .__do_page_cache_readahead+0x118/0x184
  [c00000000135b9b0] [c0000000001591a8] .force_page_cache_readahead+0xe4/0xe8
  [c00000000135ba50] [c00000000014fc24] .generic_file_read_iter+0x1d8/0x830
  [c00000000135bb50] [c0000000001ffadc] .blkdev_read_iter+0x40/0x5c
  [c00000000135bbc0] [c0000000001b9e00] .new_sync_read+0x144/0x1a0
  [c00000000135bcd0] [c0000000001bc454] .vfs_read+0xa0/0x124
  [c00000000135bd70] [c0000000001bc7a4] .ksys_read+0x70/0xd8
  [c00000000135be20] [c00000000000a524] system_call+0x5c/0x70
  Instruction dump:
  7fe3fb78 482e30dc 7c0802a6 482e3085 7c9e2378 f821ff71 7ca42b78 7d3e00d0
  7c7d1b78 79290fe0 7cc53378 69290001 <0b090000> 81230028 7bca0020 7929ba62
  [ end trace 313fec760f30aa1f ]---

The problem originates from setting the segment boundary of the
request queue to -1UL. This makes get_max_segment_size() return zero
when offset is zero, whatever the max segment size. The test with
BLK_SEG_BOUNDARY_MASK fails and 'mask - (mask & offset) + 1' overflows
to zero in the return statement.

Not setting the segment boundary and using the default
value (BLK_SEG_BOUNDARY_MASK) fixes the problem.

Signed-off-by: Emmanuel Nicolet <emmanuel.nicolet@gmail.com>
Signed-off-by: Geoff Levand <geoff@infradead.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/060a416c43138f45105c0540eff1a45539f7e2fc.1589049250.git.geoff@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ps3disk.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index c120d70d3fb3b..fc7a20286090d 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -464,7 +464,6 @@ static int ps3disk_probe(struct ps3_system_bus_device *_dev)
 	blk_queue_bounce_limit(queue, BLK_BOUNCE_HIGH);
 
 	blk_queue_max_hw_sectors(queue, dev->bounce_size >> 9);
-	blk_queue_segment_boundary(queue, -1UL);
 	blk_queue_dma_alignment(queue, dev->blk_size-1);
 	blk_queue_logical_block_size(queue, dev->blk_size);
 
-- 
2.25.1

