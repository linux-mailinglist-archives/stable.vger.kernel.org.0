Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6A8261B96
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731731AbgIHTE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:04:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:52116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731261AbgIHQHV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:07:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BBE023E22;
        Tue,  8 Sep 2020 15:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580019;
        bh=6W5PImKoQy+Nd3zNLvrudh8+VVaCoLUFwkeOePG+JDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MhwsyZBbEtFzyajjNq8cgdX6RTNA9umV2RytS2qJLy5b8MYPNkJB0XzlZj2mVinda
         nCVrd3SCIwcjqc85OX+HaN4+860f+Oj8U8OHp8mwqql/bV4B5vrx4JIyevf+Z2U3np
         lUyPeswG54whwdFRtgQ4IijJbIihlh908hg50qt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Song Liu <songliubraving@fb.com>,
        Yang Shi <shy828301@gmail.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Eric Biggers <ebiggers@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 127/129] mm/khugepaged.c: fix khugepageds request size in collapse_file
Date:   Tue,  8 Sep 2020 17:26:08 +0200
Message-Id: <20200908152236.212996375@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit e5a59d308f52bb0052af5790c22173651b187465 upstream.

collapse_file() in khugepaged passes PAGE_SIZE as the number of pages to
be read to page_cache_sync_readahead().  The intent was probably to read
a single page.  Fix it to use the number of pages to the end of the
window instead.

Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Yang Shi <shy828301@gmail.com>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Eric Biggers <ebiggers@google.com>
Link: https://lkml.kernel.org/r/20200903140844.14194-2-willy@infradead.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1592,7 +1592,7 @@ static void collapse_file(struct mm_stru
 				xas_unlock_irq(&xas);
 				page_cache_sync_readahead(mapping, &file->f_ra,
 							  file, index,
-							  PAGE_SIZE);
+							  end - index);
 				/* drain pagevecs to help isolate_lru_page() */
 				lru_add_drain();
 				page = find_lock_page(mapping, index);


