Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35B125A49FC
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbiH2Lbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbiH2LaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:30:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296E97B787;
        Mon, 29 Aug 2022 04:18:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3A32B80F1A;
        Mon, 29 Aug 2022 11:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D412C433C1;
        Mon, 29 Aug 2022 11:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771896;
        bh=mMH1hGcKpgwXBpSgbGBaRQI8Dz/52lPkbKB04R3cWOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nGzykrWL7TvRTYIjG8ONB+YazrUqlBuQMlcXTiuwM3oVjMVJlPXv7asr18LzQT7IC
         Z+4wehicc5/wkN6QfZM0iripm3yiv1WhKUx7BYlHUx+/ZF/cbGQ2MPTKftBDUVtGeG
         y7oOais/pH9ItR26KmxbO2dAjwMg/8IGT0DVa2VU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Shixin <liushixin2@huawei.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Matthew Wilcox <willy@infradead.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Oscar Salvador <osalvador@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.19 116/158] bootmem: remove the vmemmap pages from kmemleak in put_page_bootmem
Date:   Mon, 29 Aug 2022 12:59:26 +0200
Message-Id: <20220829105813.970168702@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Liu Shixin <liushixin2@huawei.com>

commit dd0ff4d12dd284c334f7e9b07f8f335af856ac78 upstream.

The vmemmap pages is marked by kmemleak when allocated from memblock.
Remove it from kmemleak when freeing the page.  Otherwise, when we reuse
the page, kmemleak may report such an error and then stop working.

 kmemleak: Cannot insert 0xffff98fb6eab3d40 into the object search tree (overlaps existing)
 kmemleak: Kernel memory leak detector disabled
 kmemleak: Object 0xffff98fb6be00000 (size 335544320):
 kmemleak:   comm "swapper", pid 0, jiffies 4294892296
 kmemleak:   min_count = 0
 kmemleak:   count = 0
 kmemleak:   flags = 0x1
 kmemleak:   checksum = 0
 kmemleak:   backtrace:

Link: https://lkml.kernel.org/r/20220819094005.2928241-1-liushixin2@huawei.com
Fixes: f41f2ed43ca5 (mm: hugetlb: free the vmemmap pages associated with each HugeTLB page)
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/bootmem_info.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/bootmem_info.c
+++ b/mm/bootmem_info.c
@@ -12,6 +12,7 @@
 #include <linux/memblock.h>
 #include <linux/bootmem_info.h>
 #include <linux/memory_hotplug.h>
+#include <linux/kmemleak.h>
 
 void get_page_bootmem(unsigned long info, struct page *page, unsigned long type)
 {
@@ -33,6 +34,7 @@ void put_page_bootmem(struct page *page)
 		ClearPagePrivate(page);
 		set_page_private(page, 0);
 		INIT_LIST_HEAD(&page->lru);
+		kmemleak_free_part(page_to_virt(page), PAGE_SIZE);
 		free_reserved_page(page);
 	}
 }


