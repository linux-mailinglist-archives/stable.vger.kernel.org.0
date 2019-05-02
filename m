Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6679F11F65
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfEBPYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:24:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727259AbfEBPYU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:24:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ECBE2081C;
        Thu,  2 May 2019 15:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810659;
        bh=43Wx7ufeKBgKvgVXesu2MuU8wP1RhKxMfcNoIfIQnIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OJaiQwx1vIAiug0MheTdIj4wLfzVl4fQ5FBBx66BNwATEJ+Eb7aqgeV7wxb946hwp
         NeVuYY93m7HzGJ7Pzn3mAASf50ncdMCMGSvylyWVCCSLx65oTqmZXmEiWYo0+iK26g
         Fe/y3oImJxZ3MRBFn9ixgaBV7SctXzBbOYdVFzpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Jann Horn <jannh@google.com>, stable@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 05/49] mm: add try_get_page() helper function
Date:   Thu,  2 May 2019 17:20:42 +0200
Message-Id: <20190502143324.714897978@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143323.397051088@linuxfoundation.org>
References: <20190502143323.397051088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 88b1a17dfc3ed7728316478fae0f5ad508f50397 upstream.

This is the same as the traditional 'get_page()' function, but instead
of unconditionally incrementing the reference count of the page, it only
does so if the count was "safe".  It returns whether the reference count
was incremented (and is marked __must_check, since the caller obviously
has to be aware of it).

Also like 'get_page()', you can't use this function unless you already
had a reference to the page.  The intent is that you can use this
exactly like get_page(), but in situations where you want to limit the
maximum reference count.

The code currently does an unconditional WARN_ON_ONCE() if we ever hit
the reference count issues (either zero or negative), as a notification
that the conditional non-increment actually happened.

NOTE! The count access for the "safety" check is inherently racy, but
that doesn't matter since the buffer we use is basically half the range
of the reference count (ie we look at the sign of the count).

Acked-by: Matthew Wilcox <willy@infradead.org>
Cc: Jann Horn <jannh@google.com>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/mm.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -839,6 +839,15 @@ static inline void get_page(struct page
 	page_ref_inc(page);
 }
 
+static inline __must_check bool try_get_page(struct page *page)
+{
+	page = compound_head(page);
+	if (WARN_ON_ONCE(page_ref_count(page) <= 0))
+		return false;
+	page_ref_inc(page);
+	return true;
+}
+
 static inline void put_page(struct page *page)
 {
 	page = compound_head(page);


