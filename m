Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE51A37848B
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhEJKxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:53:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232769AbhEJKvK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:51:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BADFA61960;
        Mon, 10 May 2021 10:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643229;
        bh=bSLkO+VVhvv8H1V2LIVqicFAIdm0qHnN9TBYcyXa2QU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wT5/y6evRSdNWFbsmQUnVabncov2kt0d24Id8vuL4xIDQ8g4Kz17FuiE0ikJDSNYd
         /zRZji4gScbvtdmytpS29KjurlrTs0w1KZl00FP+6uVeDkCAZ233rnNm+AIe3vsyyh
         F4V3SlxuekYMhPRy8JhcQT3dnr+7YwooaKDqdN9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
Subject: [PATCH 5.10 229/299] f2fs: fix to avoid out-of-bounds memory access
Date:   Mon, 10 May 2021 12:20:26 +0200
Message-Id: <20210510102012.520767471@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

commit b862676e371715456c9dade7990c8004996d0d9e upstream.

butt3rflyh4ck <butterflyhuangxx@gmail.com> reported a bug found by
syzkaller fuzzer with custom modifications in 5.12.0-rc3+ [1]:

 dump_stack+0xfa/0x151 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x82/0x32c mm/kasan/report.c:232
 __kasan_report mm/kasan/report.c:399 [inline]
 kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
 f2fs_test_bit fs/f2fs/f2fs.h:2572 [inline]
 current_nat_addr fs/f2fs/node.h:213 [inline]
 get_next_nat_page fs/f2fs/node.c:123 [inline]
 __flush_nat_entry_set fs/f2fs/node.c:2888 [inline]
 f2fs_flush_nat_entries+0x258e/0x2960 fs/f2fs/node.c:2991
 f2fs_write_checkpoint+0x1372/0x6a70 fs/f2fs/checkpoint.c:1640
 f2fs_issue_checkpoint+0x149/0x410 fs/f2fs/checkpoint.c:1807
 f2fs_sync_fs+0x20f/0x420 fs/f2fs/super.c:1454
 __sync_filesystem fs/sync.c:39 [inline]
 sync_filesystem fs/sync.c:67 [inline]
 sync_filesystem+0x1b5/0x260 fs/sync.c:48
 generic_shutdown_super+0x70/0x370 fs/super.c:448
 kill_block_super+0x97/0xf0 fs/super.c:1394

The root cause is, if nat entry in checkpoint journal area is corrupted,
e.g. nid of journalled nat entry exceeds max nid value, during checkpoint,
once it tries to flush nat journal to NAT area, get_next_nat_page() may
access out-of-bounds memory on nat_bitmap due to it uses wrong nid value
as bitmap offset.

[1] https://lore.kernel.org/lkml/CAFcO6XOMWdr8pObek6eN6-fs58KG9doRFadgJj-FnF-1x43s2g@mail.gmail.com/T/#u

Reported-and-tested-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/node.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2781,6 +2781,9 @@ static void remove_nats_in_journal(struc
 		struct f2fs_nat_entry raw_ne;
 		nid_t nid = le32_to_cpu(nid_in_journal(journal, i));
 
+		if (f2fs_check_nid_range(sbi, nid))
+			continue;
+
 		raw_ne = nat_in_journal(journal, i);
 
 		ne = __lookup_nat_cache(nm_i, nid);


