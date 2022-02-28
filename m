Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F07224C76FA
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235045AbiB1SKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240687AbiB1SJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:09:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3E45EBF0;
        Mon, 28 Feb 2022 09:48:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48E20B815C8;
        Mon, 28 Feb 2022 17:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13E6C340E7;
        Mon, 28 Feb 2022 17:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070533;
        bh=qemwP1wcJjrddnQVCK5JyKnEA14bE0FgG6LNS9kGDWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oiDXQnCLC4A4bxFTHS35yrXKpfSTVBqeiWC/x727Ok950y1alKr4dT9F8HuRat7f/
         mzdqLuVVum0EbnmKOUE5w5loNS9weZl0BdhWGQey8fs3avnc+qnv7g3slRnG+U9DDu
         CoLGI2cS+NPIsfmFIsntf9s0iJ8tmESNbrX1gMpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?D=C4=81vis=20Mos=C4=81ns?= <davispuh@gmail.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 141/164] btrfs: prevent copying too big compressed lzo segment
Date:   Mon, 28 Feb 2022 18:25:03 +0100
Message-Id: <20220228172412.720363069@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dāvis Mosāns <davispuh@gmail.com>

commit 741b23a970a79d5d3a1db2d64fa2c7b375a4febb upstream.

Compressed length can be corrupted to be a lot larger than memory
we have allocated for buffer.
This will cause memcpy in copy_compressed_segment to write outside
of allocated memory.

This mostly results in stuck read syscall but sometimes when using
btrfs send can get #GP

  kernel: general protection fault, probably for non-canonical address 0x841551d5c1000: 0000 [#1] PREEMPT SMP NOPTI
  kernel: CPU: 17 PID: 264 Comm: kworker/u256:7 Tainted: P           OE     5.17.0-rc2-1 #12
  kernel: Workqueue: btrfs-endio btrfs_work_helper [btrfs]
  kernel: RIP: 0010:lzo_decompress_bio (./include/linux/fortify-string.h:225 fs/btrfs/lzo.c:322 fs/btrfs/lzo.c:394) btrfs
  Code starting with the faulting instruction
  ===========================================
     0:*  48 8b 06                mov    (%rsi),%rax              <-- trapping instruction
     3:   48 8d 79 08             lea    0x8(%rcx),%rdi
     7:   48 83 e7 f8             and    $0xfffffffffffffff8,%rdi
     b:   48 89 01                mov    %rax,(%rcx)
     e:   44 89 f0                mov    %r14d,%eax
    11:   48 8b 54 06 f8          mov    -0x8(%rsi,%rax,1),%rdx
  kernel: RSP: 0018:ffffb110812efd50 EFLAGS: 00010212
  kernel: RAX: 0000000000001000 RBX: 000000009ca264c8 RCX: ffff98996e6d8ff8
  kernel: RDX: 0000000000000064 RSI: 000841551d5c1000 RDI: ffffffff9500435d
  kernel: RBP: ffff989a3be856c0 R08: 0000000000000000 R09: 0000000000000000
  kernel: R10: 0000000000000000 R11: 0000000000001000 R12: ffff98996e6d8000
  kernel: R13: 0000000000000008 R14: 0000000000001000 R15: 000841551d5c1000
  kernel: FS:  0000000000000000(0000) GS:ffff98a09d640000(0000) knlGS:0000000000000000
  kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  kernel: CR2: 00001e9f984d9ea8 CR3: 000000014971a000 CR4: 00000000003506e0
  kernel: Call Trace:
  kernel:  <TASK>
  kernel: end_compressed_bio_read (fs/btrfs/compression.c:104 fs/btrfs/compression.c:1363 fs/btrfs/compression.c:323) btrfs
  kernel: end_workqueue_fn (fs/btrfs/disk-io.c:1923) btrfs
  kernel: btrfs_work_helper (fs/btrfs/async-thread.c:326) btrfs
  kernel: process_one_work (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:212 ./include/trace/events/workqueue.h:108 kernel/workqueue.c:2312)
  kernel: worker_thread (./include/linux/list.h:292 kernel/workqueue.c:2455)
  kernel: ? process_one_work (kernel/workqueue.c:2397)
  kernel: kthread (kernel/kthread.c:377)
  kernel: ? kthread_complete_and_exit (kernel/kthread.c:332)
  kernel: ret_from_fork (arch/x86/entry/entry_64.S:301)
  kernel:  </TASK>

CC: stable@vger.kernel.org # 4.9+
Signed-off-by: Dāvis Mosāns <davispuh@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/lzo.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -380,6 +380,17 @@ int lzo_decompress_bio(struct list_head
 		kunmap(cur_page);
 		cur_in += LZO_LEN;
 
+		if (seg_len > lzo1x_worst_compress(PAGE_SIZE)) {
+			/*
+			 * seg_len shouldn't be larger than we have allocated
+			 * for workspace->cbuf
+			 */
+			btrfs_err(fs_info, "unexpectedly large lzo segment len %u",
+					seg_len);
+			ret = -EIO;
+			goto out;
+		}
+
 		/* Copy the compressed segment payload into workspace */
 		copy_compressed_segment(cb, workspace->cbuf, seg_len, &cur_in);
 


