Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326273C4B2B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240133AbhGLGzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:55:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240990AbhGLGyZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:54:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 729AE60FD8;
        Mon, 12 Jul 2021 06:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072697;
        bh=VlX7Iqr2YAqQBDc+i+FUT5d7YmQ3Lx0WLXTqyk7gdro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QFKlHzULmFd6HDjANJF98WRralvWrMUbAPnhbkOiHJryjQRX2cDZgD9ROJz10vNNa
         F4rGuFWIEhhD19pCt3NtFifPGj2iPCr3pQS1bJAU9yNxG35ruU8OKdJx739T1hvJ3C
         9Vzr82sXIQKOOYdV+F9iKgvxO/wQxceAGJ+qS2jE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yanfei Xu <yanfei.xu@windriver.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 567/593] mm/hugetlb: remove redundant check in preparing and destroying gigantic page
Date:   Mon, 12 Jul 2021 08:12:07 +0200
Message-Id: <20210712060957.183774562@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yanfei Xu <yanfei.xu@windriver.com>

[ Upstream commit 5291c09b3edb657f23c1939750c702ba2d74932f ]

Gigantic page is a compound page and its order is more than 1.  Thus it
must be available for hpage_pincount.  Let's remove the redundant check
for gigantic page.

Link: https://lkml.kernel.org/r/20210202112002.73170-1-yanfei.xu@windriver.com
Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 991b5cd40267..f90dd909d017 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1252,8 +1252,7 @@ static void destroy_compound_gigantic_page(struct page *page,
 	struct page *p = page + 1;
 
 	atomic_set(compound_mapcount_ptr(page), 0);
-	if (hpage_pincount_available(page))
-		atomic_set(compound_pincount_ptr(page), 0);
+	atomic_set(compound_pincount_ptr(page), 0);
 
 	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
 		clear_compound_head(p);
@@ -1583,9 +1582,7 @@ static void prep_compound_gigantic_page(struct page *page, unsigned int order)
 		set_compound_head(p, page);
 	}
 	atomic_set(compound_mapcount_ptr(page), -1);
-
-	if (hpage_pincount_available(page))
-		atomic_set(compound_pincount_ptr(page), 0);
+	atomic_set(compound_pincount_ptr(page), 0);
 }
 
 /*
-- 
2.30.2



