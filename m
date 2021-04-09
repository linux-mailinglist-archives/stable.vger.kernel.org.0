Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3496A35A7D2
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 22:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbhDIU1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 16:27:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233824AbhDIU1h (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 16:27:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F74F610A8;
        Fri,  9 Apr 2021 20:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618000043;
        bh=7ms6+3bG6fT5U/1g8c9M+XCu/LHEVKAEuADu6uC5ARo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iUw5+yGj1f7ug3pYSFPhv8eS7FK36brsNXkFGK2OQjt3CsyAvbVIMn0qG4lvowsHA
         ZZ2u6h9hMvoFXAw/uZ5M0DTxV1A3BVdojmRx6ldoG/kd9T7a4EHrP3RfctL/3obVMr
         dtZuNpWf/t/1nKHozxSmH717lKvAcXDHGH40NNdI=
Date:   Fri, 09 Apr 2021 13:27:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, deanbo422@gmail.com, green.hu@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        nickhu@andestech.com, rppt@linux.ibm.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org,
        ying.huang@intel.com
Subject:  [patch 08/16] nds32: flush_dcache_page: use
 page_mapping_file to avoid races with swapoff
Message-ID: <20210409202723.P4c1fnEGD%akpm@linux-foundation.org>
In-Reply-To: <20210409132633.6855fc8fea1b3905ea1bb4be@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: nds32: flush_dcache_page: use page_mapping_file to avoid races with swapoff

Commit cb9f753a3731 ("mm: fix races between swapoff and flush dcache")
updated flush_dcache_page implementations on several architectures to use
page_mapping_file() in order to avoid races between page_mapping() and
swapoff().

This update missed arch/nds32 and there is a possibility of a race there.

Replace page_mapping() with page_mapping_file() in nds32 implementation of
flush_dcache_page().

Link: https://lkml.kernel.org/r/20210330175126.26500-1-rppt@kernel.org
Fixes: cb9f753a3731 ("mm: fix races between swapoff and flush dcache")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Greentime Hu <green.hu@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nds32/mm/cacheflush.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/nds32/mm/cacheflush.c~nds32-flush_dcache_page-use-page_mapping_file-to-avoid-races-with-swapoff
+++ a/arch/nds32/mm/cacheflush.c
@@ -238,7 +238,7 @@ void flush_dcache_page(struct page *page
 {
 	struct address_space *mapping;
 
-	mapping = page_mapping(page);
+	mapping = page_mapping_file(page);
 	if (mapping && !mapping_mapped(mapping))
 		set_bit(PG_dcache_dirty, &page->flags);
 	else {
_
