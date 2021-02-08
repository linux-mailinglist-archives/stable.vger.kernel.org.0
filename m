Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62BC0313761
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbhBHPYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:24:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:60178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233393AbhBHPRa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:17:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3171464ED7;
        Mon,  8 Feb 2021 15:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797123;
        bh=l6kelLns2a54V95MdoGr4X0peT0OIHegaSq042hNbEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DhuoTZ0AEzHAhf9TmWOxI7fHo2CER8v2/rl7bBmUIeksy7znNONqWc9y898PSw6EZ
         djLh0TRSWvhwAsGDUPjJNW2Ip3WoA0XO6k6zmSPgxIq7PkYeyEGDwOfjxdJ2opmj2/
         uQ4aQq2aFiEeY2TfkTMcRtYkA6UaafQCMaLv7wRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Michal Hocko <mhocko@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>,
        Yang Shi <shy828301@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 51/65] mm: hugetlb: remove VM_BUG_ON_PAGE from page_huge_active
Date:   Mon,  8 Feb 2021 16:01:23 +0100
Message-Id: <20210208145812.195767206@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145810.230485165@linuxfoundation.org>
References: <20210208145810.230485165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

commit ecbf4724e6061b4b01be20f6d797d64d462b2bc8 upstream.

The page_huge_active() can be called from scan_movable_pages() which do
not hold a reference count to the HugeTLB page.  So when we call
page_huge_active() from scan_movable_pages(), the HugeTLB page can be
freed parallel.  Then we will trigger a BUG_ON which is in the
page_huge_active() when CONFIG_DEBUG_VM is enabled.  Just remove the
VM_BUG_ON_PAGE.

Link: https://lkml.kernel.org/r/20210115124942.46403-6-songmuchun@bytedance.com
Fixes: 7e1f049efb86 ("mm: hugetlb: cleanup using paeg_huge_active()")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1234,8 +1234,7 @@ struct hstate *size_to_hstate(unsigned l
  */
 bool page_huge_active(struct page *page)
 {
-	VM_BUG_ON_PAGE(!PageHuge(page), page);
-	return PageHead(page) && PagePrivate(&page[1]);
+	return PageHeadHuge(page) && PagePrivate(&page[1]);
 }
 
 /* never called for tail page */


