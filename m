Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07F521333C6
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgAGVV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:21:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:44802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728178AbgAGVDQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:03:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D2822087F;
        Tue,  7 Jan 2020 21:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430996;
        bh=BwMZc9l3rW61PTP7woOXDslCuxBTnDgf4z7yxxprXNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+vHFUmbWPEHMrMGcuq9csmlEZjQPg05Qf4UcnJHGd2NrIYjzPp/07rYOyJVNs2hm
         d/gsm3W9kfQ10lb8K+/y3AbxPa3AXpS29HDb5fo7HY26JjTzlRkxdmI9hAKI+0YL7X
         r2HPCBYuhr28b0nkS30BB0z98hV0Q9axIqfAzZco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Oscar Salvador <OSalvador@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 182/191] mm/sparse.c: mark populate_section_memmap as __meminit
Date:   Tue,  7 Jan 2020 21:55:02 +0100
Message-Id: <20200107205342.733693882@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 030eab4f9ffb469344c10a46bc02c5149db0a2a9 ]

Building the kernel on s390 with -Og produces the following warning:

  WARNING: vmlinux.o(.text+0x28dabe): Section mismatch in reference from the function populate_section_memmap() to the function .meminit.text:__populate_section_memmap()
  The function populate_section_memmap() references
  the function __meminit __populate_section_memmap().
  This is often because populate_section_memmap lacks a __meminit
  annotation or the annotation of __populate_section_memmap is wrong.

While -Og is not supported, in theory this might still happen with
another compiler or on another architecture.  So fix this by using the
correct section annotations.

[iii@linux.ibm.com: v2]
  Link: http://lkml.kernel.org/r/20191030151639.41486-1-iii@linux.ibm.com
Link: http://lkml.kernel.org/r/20191028165549.14478-1-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Oscar Salvador <OSalvador@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/sparse.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index f6891c1992b1..c2c01b6330af 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -647,7 +647,7 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 #endif
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-static struct page *populate_section_memmap(unsigned long pfn,
+static struct page * __meminit populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
 {
 	return __populate_section_memmap(pfn, nr_pages, nid, altmap);
@@ -669,7 +669,7 @@ static void free_map_bootmem(struct page *memmap)
 	vmemmap_free(start, end, NULL);
 }
 #else
-struct page *populate_section_memmap(unsigned long pfn,
+struct page * __meminit populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
 {
 	struct page *page, *ret;
-- 
2.20.1



