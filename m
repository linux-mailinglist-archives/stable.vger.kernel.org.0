Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA4035BC5E
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236883AbhDLImf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:42:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236802AbhDLImf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:42:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CABA161243;
        Mon, 12 Apr 2021 08:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618216937;
        bh=2iUfIGXM5vEfOxaYAahgYQr4W9HehDTzGP/q1Qt8J7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rtol0QzQb1M8tJiDYWmDTAPF5AETnjR+rK7GzzaHh4nuVaf9lyPzb3ljK83yzCBWS
         yJOHD3aAVSaNT+1iEM0xPzdczBJz1VKD7r0J4670mSG7lMuNi0sWTofBHRr6DDS2bY
         IBSBzJwf5IX4YcobX90lHOn1N1ZC7N8TdsuMCAtg=
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
Subject: [PATCH 4.19 10/66] nds32: flush_dcache_page: use page_mapping_file to avoid races with swapoff
Date:   Mon, 12 Apr 2021 10:40:16 +0200
Message-Id: <20210412083958.469573373@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412083958.129944265@linuxfoundation.org>
References: <20210412083958.129944265@linuxfoundation.org>
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


