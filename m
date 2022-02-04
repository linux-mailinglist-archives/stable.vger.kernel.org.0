Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC81C4A969E
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357931AbiBDJ1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:27:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53900 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358238AbiBDJ0K (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:26:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24376B836EB;
        Fri,  4 Feb 2022 09:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05E8C004E1;
        Fri,  4 Feb 2022 09:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966767;
        bh=LmrbcHvcX9oIGN9xKCE/bc6nuizkuV8gy2HnJpudulg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=un7xrTQIsoTTwbz29bbDHaVGSMvGPuTaLhPUhcOAAMD4y05/4QxFOFFuETLthf+Cb
         jQ99247yl3RpbIq27MYa4elVdKUy/A9SZKJUMO8I0Y5VNEYJILVPJLUkPSv1tPE/iY
         Q+wwbCw2tUq8KQovaOx8R53SdGkMLAlSyJIIzJNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Minchan Kim <minchan@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Will McVicker <willmcvicker@google.com>
Subject: [PATCH 5.16 07/43] Revert "mm/gup: small refactoring: simplify try_grab_page()"
Date:   Fri,  4 Feb 2022 10:22:14 +0100
Message-Id: <20220204091917.424405756@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
References: <20220204091917.166033635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

commit c36c04c2e132fc39f6b658bf607aed4425427fd7 upstream.

This reverts commit 54d516b1d62ff8f17cee2da06e5e4706a0d00b8a

That commit did a refactoring that effectively combined fast and slow
gup paths (again).  And that was again incorrect, for two reasons:

 a) Fast gup and slow gup get reference counts on pages in different
    ways and with different goals: see Linus' writeup in commit
    cd1adf1b63a1 ("Revert "mm/gup: remove try_get_page(), call
    try_get_compound_head() directly""), and

 b) try_grab_compound_head() also has a specific check for
    "FOLL_LONGTERM && !is_pinned(page)", that assumes that the caller
    can fall back to slow gup. This resulted in new failures, as
    recently report by Will McVicker [1].

But (a) has problems too, even though they may not have been reported
yet.  So just revert this.

Link: https://lore.kernel.org/r/20220131203504.3458775-1-willmcvicker@google.com [1]
Fixes: 54d516b1d62f ("mm/gup: small refactoring: simplify try_grab_page()")
Reported-and-tested-by: Will McVicker <willmcvicker@google.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Minchan Kim <minchan@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: stable@vger.kernel.org # 5.15
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/gup.c |   35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

--- a/mm/gup.c
+++ b/mm/gup.c
@@ -124,8 +124,8 @@ static inline struct page *try_get_compo
  * considered failure, and furthermore, a likely bug in the caller, so a warning
  * is also emitted.
  */
-struct page *try_grab_compound_head(struct page *page,
-				    int refs, unsigned int flags)
+__maybe_unused struct page *try_grab_compound_head(struct page *page,
+						   int refs, unsigned int flags)
 {
 	if (flags & FOLL_GET)
 		return try_get_compound_head(page, refs);
@@ -208,10 +208,35 @@ static void put_compound_head(struct pag
  */
 bool __must_check try_grab_page(struct page *page, unsigned int flags)
 {
-	if (!(flags & (FOLL_GET | FOLL_PIN)))
-		return true;
+	WARN_ON_ONCE((flags & (FOLL_GET | FOLL_PIN)) == (FOLL_GET | FOLL_PIN));
 
-	return try_grab_compound_head(page, 1, flags);
+	if (flags & FOLL_GET)
+		return try_get_page(page);
+	else if (flags & FOLL_PIN) {
+		int refs = 1;
+
+		page = compound_head(page);
+
+		if (WARN_ON_ONCE(page_ref_count(page) <= 0))
+			return false;
+
+		if (hpage_pincount_available(page))
+			hpage_pincount_add(page, 1);
+		else
+			refs = GUP_PIN_COUNTING_BIAS;
+
+		/*
+		 * Similar to try_grab_compound_head(): even if using the
+		 * hpage_pincount_add/_sub() routines, be sure to
+		 * *also* increment the normal page refcount field at least
+		 * once, so that the page really is pinned.
+		 */
+		page_ref_add(page, refs);
+
+		mod_node_page_state(page_pgdat(page), NR_FOLL_PIN_ACQUIRED, 1);
+	}
+
+	return true;
 }
 
 /**


