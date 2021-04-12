Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A06D35BE07
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238595AbhDLI4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:56:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238741AbhDLIyc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:54:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A09BF6135F;
        Mon, 12 Apr 2021 08:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217563;
        bh=a/QfLz8Zf/XTYH97kvbgOCj/oUJzKi39vkv7KSE0Sss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ntMSBJq8qrEWi4pg+9YQbiaJWxB2nQXOuiqcpCNMTf2LiRrHBeiIcAyizxZwbN2wX
         eh49UejY/8nlbodzFiC5Qd14snU4NeO2RulcHWN8KO/OQzppriWIIhcy1pelHT8+ry
         kn+x/IV0YYO5oXfx/rIkZrLpq80TqB4TYUZ5nuW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Greentime Hu <green.hu@gmail.com>,
        Huang Ying <ying.huang@intel.com>,
        Nick Hu <nickhu@andestech.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 024/188] nds32: flush_dcache_page: use page_mapping_file to avoid races with swapoff
Date:   Mon, 12 Apr 2021 10:38:58 +0200
Message-Id: <20210412084014.457353921@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

commit a3a8833dffb7e7329c2586b8bfc531adb503f123 upstream.

Commit cb9f753a3731 ("mm: fix races between swapoff and flush dcache")
updated flush_dcache_page implementations on several architectures to
use page_mapping_file() in order to avoid races between page_mapping()
and swapoff().

This update missed arch/nds32 and there is a possibility of a race
there.

Replace page_mapping() with page_mapping_file() in nds32 implementation
of flush_dcache_page().

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/nds32/mm/cacheflush.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/nds32/mm/cacheflush.c
+++ b/arch/nds32/mm/cacheflush.c
@@ -238,7 +238,7 @@ void flush_dcache_page(struct page *page
 {
 	struct address_space *mapping;
 
-	mapping = page_mapping(page);
+	mapping = page_mapping_file(page);
 	if (mapping && !mapping_mapped(mapping))
 		set_bit(PG_dcache_dirty, &page->flags);
 	else {


