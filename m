Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4572C0893
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387896AbgKWMy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:54:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:36854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387862AbgKWMxH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:53:07 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9540D21741;
        Mon, 23 Nov 2020 12:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135962;
        bh=s0Fh4Hf7a5gtGIEOSPGia7j2A7/d/r+6KYlTN8YjYfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tHdPjZpudDxFXedhMdrTSjoYRG9cN14A1mYJbU3RBrm8bAFiswFOfxRxJXIfJw8+J
         D67lhWr11oEB4pgX++IXLkIczgwU9VzVbLr3QS0jWxAZLTfTOEQxb+Rk2greAg3RNj
         uKxZZWSeOcwZz+GqiN8O9LJHJfhBNQDy13W5aOI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Wonhyuk Yang <vvghjk1234@gmail.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.9 250/252] mm: fix readahead_page_batch for retry entries
Date:   Mon, 23 Nov 2020 13:23:20 +0100
Message-Id: <20201123121847.653594830@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 4349a83a3190c1d4414371161b0f4a4c3ccd3f9d upstream.

Both btrfs and fuse have reported faults caused by seeing a retry entry
instead of the page they were looking for.  This was caused by a missing
check in the iterator.

As can be seen in the below panic log, the accessing 0x402 causes a
panic.  In the xarray.h, 0x402 means RETRY_ENTRY.

  BUG: kernel NULL pointer dereference, address: 0000000000000402
  CPU: 14 PID: 306003 Comm: as Not tainted 5.9.0-1-amd64 #1 Debian 5.9.1-1
  Hardware name: Lenovo ThinkSystem SR665/7D2VCTO1WW, BIOS D8E106Q-1.01 05/30/2020
  RIP: 0010:fuse_readahead+0x152/0x470 [fuse]
  Code: 41 8b 57 18 4c 8d 54 10 ff 4c 89 d6 48 8d 7c 24 10 e8 d2 e3 28 f9 48 85 c0 0f 84 fe 00 00 00 44 89 f2 49 89 04 d4 44 8d 72 01 <48> 8b 10 41 8b 4f 1c 48 c1 ea 10 83 e2 01 80 fa 01 19 d2 81 e2 01
  RSP: 0018:ffffad99ceaebc50 EFLAGS: 00010246
  RAX: 0000000000000402 RBX: 0000000000000001 RCX: 0000000000000002
  RDX: 0000000000000000 RSI: ffff94c5af90bd98 RDI: ffffad99ceaebc60
  RBP: ffff94ddc1749a00 R08: 0000000000000402 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000100 R12: ffff94de6c429ce0
  R13: ffff94de6c4d3700 R14: 0000000000000001 R15: ffffad99ceaebd68
  FS:  00007f228c5c7040(0000) GS:ffff94de8ed80000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000402 CR3: 0000001dbd9b4000 CR4: 0000000000350ee0
  Call Trace:
    read_pages+0x83/0x270
    page_cache_readahead_unbounded+0x197/0x230
    generic_file_buffered_read+0x57a/0xa20
    new_sync_read+0x112/0x1a0
    vfs_read+0xf8/0x180
    ksys_read+0x5f/0xe0
    do_syscall_64+0x33/0x80
    entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 042124cc64c3 ("mm: add new readahead_control API")
Reported-by: David Sterba <dsterba@suse.com>
Reported-by: Wonhyuk Yang <vvghjk1234@gmail.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20201103142852.8543-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20201103124349.16722-1-vvghjk1234@gmail.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/pagemap.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -794,6 +794,8 @@ static inline unsigned int __readahead_b
 	xas_set(&xas, rac->_index);
 	rcu_read_lock();
 	xas_for_each(&xas, page, rac->_index + rac->_nr_pages - 1) {
+		if (xas_retry(&xas, page))
+			continue;
 		VM_BUG_ON_PAGE(!PageLocked(page), page);
 		VM_BUG_ON_PAGE(PageTail(page), page);
 		array[i++] = page;


