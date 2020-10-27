Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0EB29B92C
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802243AbgJ0PqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:46:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S368776AbgJ0P1m (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:27:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C61D0206E9;
        Tue, 27 Oct 2020 15:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812460;
        bh=fDvuzdHMi2m/Y1H9LP/iTIncn0If+v+pdo13ALMHRUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0LjoFyaGDI8RKtIdsnQraQFpbvDcTlShumow8i+vMytz8pED9FYUl82SxnabgZn9E
         1sfH/jCoQzoji3xp9vYBVy9voEht0qSKwJwkPa37Ht8Q7pFOm14NACHg/wLLjq+2VC
         ZPAd/I/UYe3GAlDo4ic3S55mr+SCzxHTc3Riv5do=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Josef Bacik <josef@toxicpanda.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 218/757] mm/error_inject: Fix allow_error_inject function signatures.
Date:   Tue, 27 Oct 2020 14:47:48 +0100
Message-Id: <20201027135500.838159404@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 76cd61739fd107a7f7ec4c24a045e98d8ee150f0 ]

'static' and 'static noinline' function attributes make no guarantees that
gcc/clang won't optimize them. The compiler may decide to inline 'static'
function and in such case ALLOW_ERROR_INJECT becomes meaningless. The compiler
could have inlined __add_to_page_cache_locked() in one callsite and didn't
inline in another. In such case injecting errors into it would cause
unpredictable behavior. It's worse with 'static noinline' which won't be
inlined, but it still can be optimized. Like the compiler may decide to remove
one argument or constant propagate the value depending on the callsite.

To avoid such issues make sure that these functions are global noinline.

Fixes: af3b854492f3 ("mm/page_alloc.c: allow error injection")
Fixes: cfcbfb1382db ("mm/filemap.c: enable error injection at add_to_page_cache()")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/bpf/20200827220114.69225-2-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/filemap.c    | 8 ++++----
 mm/page_alloc.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 99c49eeae71b8..f6d36ccc23515 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -827,10 +827,10 @@ int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask)
 }
 EXPORT_SYMBOL_GPL(replace_page_cache_page);
 
-static int __add_to_page_cache_locked(struct page *page,
-				      struct address_space *mapping,
-				      pgoff_t offset, gfp_t gfp_mask,
-				      void **shadowp)
+noinline int __add_to_page_cache_locked(struct page *page,
+					struct address_space *mapping,
+					pgoff_t offset, gfp_t gfp_mask,
+					void **shadowp)
 {
 	XA_STATE(xas, &mapping->i_pages, offset);
 	int huge = PageHuge(page);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 780c8f023b282..c449d74f55842 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3496,7 +3496,7 @@ static inline bool __should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
 
 #endif /* CONFIG_FAIL_PAGE_ALLOC */
 
-static noinline bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
+noinline bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
 {
 	return __should_fail_alloc_page(gfp_mask, order);
 }
-- 
2.25.1



