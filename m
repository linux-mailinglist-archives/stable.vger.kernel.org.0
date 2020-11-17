Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCE82B63AA
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732564AbgKQNkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:40:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:52414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732858AbgKQNkX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:40:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2914720870;
        Tue, 17 Nov 2020 13:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620422;
        bh=Y58FNH5AzrOBhm7QxjwM3cUvWGaPfXLXjWPNP/1QQcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2EkjSugUU/9gwCHhJqrP//m0pr0+Fu+6LIQHDfyJMcoVPcHAsDZMqrxgPbgcE6w9H
         MHZI6X2Uqyyf8ZdsBjeVKc2UPZ2UCqGCHpkm+3cCnu8fkZAVsB3gUS7kz14HWWkOhM
         +4PjMBKkZ3iwYmqVFzOnT9kPBNFcv4YI9Tm3+dDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.9 213/255] mm/gup: use unpin_user_pages() in __gup_longterm_locked()
Date:   Tue, 17 Nov 2020 14:05:53 +0100
Message-Id: <20201117122149.302832162@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

commit 96e1fac162cc0086c50b2b14062112adb2ba640e upstream.

When FOLL_PIN is passed to __get_user_pages() the page list must be put
back using unpin_user_pages() otherwise the page pin reference persists
in a corrupted state.

There are two places in the unwind of __gup_longterm_locked() that put
the pages back without checking.  Normally on error this function would
return the partial page list making this the caller's responsibility,
but in these two cases the caller is not allowed to see these pages at
all.

Fixes: 3faa52c03f44 ("mm/gup: track FOLL_PIN pages")
Reported-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/0-v2-3ae7d9d162e2+2a7-gup_cma_fix_jgg@nvidia.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/gup.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1637,8 +1637,11 @@ check_again:
 		/*
 		 * drop the above get_user_pages reference.
 		 */
-		for (i = 0; i < nr_pages; i++)
-			put_page(pages[i]);
+		if (gup_flags & FOLL_PIN)
+			unpin_user_pages(pages, nr_pages);
+		else
+			for (i = 0; i < nr_pages; i++)
+				put_page(pages[i]);
 
 		if (migrate_pages(&cma_page_list, alloc_migration_target, NULL,
 			(unsigned long)&mtc, MIGRATE_SYNC, MR_CONTIG_RANGE)) {
@@ -1718,8 +1721,11 @@ static long __gup_longterm_locked(struct
 			goto out;
 
 		if (check_dax_vmas(vmas_tmp, rc)) {
-			for (i = 0; i < rc; i++)
-				put_page(pages[i]);
+			if (gup_flags & FOLL_PIN)
+				unpin_user_pages(pages, rc);
+			else
+				for (i = 0; i < rc; i++)
+					put_page(pages[i]);
 			rc = -EOPNOTSUPP;
 			goto out;
 		}


