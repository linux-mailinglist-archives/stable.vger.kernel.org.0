Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4D9451E74
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348553AbhKPAgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:36:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:45406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344978AbhKOTZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 387CA6349A;
        Mon, 15 Nov 2021 19:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003281;
        bh=usSEATAGWECWxlihXrfv1S9zeODMpf5CqCqlU4RWMu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k7G0I1TNNz7aZn16d8F0XYJEH/narVeqwsdapQi8Np5Xpyj106rHAtxwdWAeigmyz
         aBaG0IUdHpcfqS/Dtw6PtQVvYG6wEbbCptMNZgotyYOKms8P6Bh8zpHvqSBP2x/UfI
         tga2VYP+APBmJ1yQITPdd+L7QXEanzhzacs1GWsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        syzbot+c87be4f669d920c76330@syzkaller.appspotmail.com,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 876/917] mm/filemap.c: remove bogus VM_BUG_ON
Date:   Mon, 15 Nov 2021 18:06:11 +0100
Message-Id: <20211115165458.753378986@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit d417b49fff3e2f21043c834841e8623a6098741d upstream.

It is not safe to check page->index without holding the page lock.  It
can be changed if the page is moved between the swap cache and the page
cache for a shmem file, for example.  There is a VM_BUG_ON below which
checks page->index is correct after taking the page lock.

Link: https://lkml.kernel.org/r/20210818144932.940640-1-willy@infradead.org
Fixes: 5c211ba29deb ("mm: add and use find_lock_entries")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: <syzbot+c87be4f669d920c76330@syzkaller.appspotmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2093,7 +2093,6 @@ unsigned find_lock_entries(struct addres
 		if (!xa_is_value(page)) {
 			if (page->index < start)
 				goto put;
-			VM_BUG_ON_PAGE(page->index != xas.xa_index, page);
 			if (page->index + thp_nr_pages(page) - 1 > end)
 				goto put;
 			if (!trylock_page(page))


