Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529EE35BD51
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237591AbhDLIvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:51:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238047AbhDLIrY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:47:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 074206124C;
        Mon, 12 Apr 2021 08:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217226;
        bh=2iUfIGXM5vEfOxaYAahgYQr4W9HehDTzGP/q1Qt8J7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SEO9LMC07FfGaTVQBo26f6zIAT/+99eYViXS7U0Y+1fE8s6rnJR0dntjx5R8wVsCy
         qcKxwJZrZ042kvnn9a+iZURiRoOwD/lZZyYuzryYWlpdD1Q/Q+6Rzidunik+XKBAMI
         sr9M6IkZ082nuWvZaa3iKvcR4mX6iYBA/niTBFLY=
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
Subject: [PATCH 5.4 015/111] nds32: flush_dcache_page: use page_mapping_file to avoid races with swapoff
Date:   Mon, 12 Apr 2021 10:39:53 +0200
Message-Id: <20210412084004.733578027@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
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
@@ -239,7 +239,7 @@ void flush_dcache_page(struct page *page
 {
 	struct address_space *mapping;
 
-	mapping = page_mapping(page);
+	mapping = page_mapping_file(page);
 	if (mapping && !mapping_mapped(mapping))
 		set_bit(PG_dcache_dirty, &page->flags);
 	else {


