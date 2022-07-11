Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1331256FC0A
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbiGKJiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233037AbiGKJh2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:37:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE36583F01;
        Mon, 11 Jul 2022 02:19:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E822B80E74;
        Mon, 11 Jul 2022 09:19:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEE7C34115;
        Mon, 11 Jul 2022 09:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531172;
        bh=iQ84uY8s4fGiSftDNeEMZ8xdGgAqkR5pl9zjUgtGbxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUqu6EdBDLjbTxIWGJgfJPCpfGMvgHhP58nTeruP9JfrMiUo8EB8xjATKOgCxQlur
         AbdKFQ6kTJnPlW5dhQxd68y0VBKWpp1LkoSCDxVYasf+pe+vIQj4s/5QoMwngveA/T
         e2qz0O3xbC9N3b1WYbwI2xoWR+l0dfPkIvfBHAyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Shixin <liushixin2@huawei.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 5.15 002/230] mm/filemap: fix UAF in find_lock_entries
Date:   Mon, 11 Jul 2022 11:04:18 +0200
Message-Id: <20220711090604.132579878@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Shixin <liushixin2@huawei.com>

Release refcount after xas_set to fix UAF which may cause panic like this:

 page:ffffea000491fa40 refcount:1 mapcount:0 mapping:0000000000000000 index:0x1 pfn:0x1247e9
 head:ffffea000491fa00 order:3 compound_mapcount:0 compound_pincount:0
 memcg:ffff888104f91091
 flags: 0x2fffff80010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
...
page dumped because: VM_BUG_ON_PAGE(PageTail(page))
 ------------[ cut here ]------------
 kernel BUG at include/linux/page-flags.h:632!
 invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN
 CPU: 1 PID: 7642 Comm: sh Not tainted 5.15.51-dirty #26
...
 Call Trace:
  <TASK>
  __invalidate_mapping_pages+0xe7/0x540
  drop_pagecache_sb+0x159/0x320
  iterate_supers+0x120/0x240
  drop_caches_sysctl_handler+0xaa/0xe0
  proc_sys_call_handler+0x2b4/0x480
  new_sync_write+0x3d6/0x5c0
  vfs_write+0x446/0x7a0
  ksys_write+0x105/0x210
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7f52b5733130
...

This problem has been fixed on mainline by patch 6b24ca4a1a8d ("mm: Use
multi-index entries in the page cache") since it deletes the related code.

Fixes: 5c211ba29deb ("mm: add and use find_lock_entries")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Acked-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2090,7 +2090,11 @@ unsigned find_lock_entries(struct addres
 
 	rcu_read_lock();
 	while ((page = find_get_entry(&xas, end, XA_PRESENT))) {
+		unsigned long next_idx = xas.xa_index + 1;
+
 		if (!xa_is_value(page)) {
+			if (PageTransHuge(page))
+				next_idx = page->index + thp_nr_pages(page);
 			if (page->index < start)
 				goto put;
 			if (page->index + thp_nr_pages(page) - 1 > end)
@@ -2111,13 +2115,11 @@ unlock:
 put:
 		put_page(page);
 next:
-		if (!xa_is_value(page) && PageTransHuge(page)) {
-			unsigned int nr_pages = thp_nr_pages(page);
-
+		if (next_idx != xas.xa_index + 1) {
 			/* Final THP may cross MAX_LFS_FILESIZE on 32-bit */
-			xas_set(&xas, page->index + nr_pages);
-			if (xas.xa_index < nr_pages)
+			if (next_idx < xas.xa_index)
 				break;
+			xas_set(&xas, next_idx);
 		}
 	}
 	rcu_read_unlock();


