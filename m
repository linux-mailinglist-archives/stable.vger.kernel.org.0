Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C372C0895
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387899AbgKWMy5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:54:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:36852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387863AbgKWMxG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:53:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CB8121D7A;
        Mon, 23 Nov 2020 12:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135959;
        bh=8+/o72ugXJRo3qLpZVgZ+PPX9JIuk3UxkdFOcvmMnPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=18Cr4QavnbrKus5u5Qvg9WN7SixFdJR3/E+yD6qAhZ7tOfG8uGIwbLEDT7RY20Gof
         1pK9g11XVPLyUpEA62JKBBbCSd+ocwZTMxzXBW9A9mtqnkUM/qVZA/oDZdIfbEkg4D
         Dn4WtDnF0eXcoqKZqUckTDh3teyEohsgIEwr0jLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 249/252] mm: never attempt async page lock if weve transferred data already
Date:   Mon, 23 Nov 2020 13:23:19 +0100
Message-Id: <20201123121847.604526424@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 0abed7c69b956d135cb6d320c350b2adb213e7d8 upstream.

We catch the case where we enter generic_file_buffered_read() with data
already transferred, but we also need to be careful not to allow an async
page lock if we're looping transferring data. If not, we could be
returning -EIOCBQUEUED instead of the transferred amount, and it could
result in double waitqueue additions as well.

Cc: stable@vger.kernel.org # v5.9
Fixes: 1a0a7853b901 ("mm: support async buffered reads in generic_file_buffered_read()")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/filemap.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2327,10 +2327,15 @@ page_ok:
 
 page_not_up_to_date:
 		/* Get exclusive access to the page ... */
-		if (iocb->ki_flags & IOCB_WAITQ)
+		if (iocb->ki_flags & IOCB_WAITQ) {
+			if (written) {
+				put_page(page);
+				goto out;
+			}
 			error = lock_page_async(page, iocb->ki_waitq);
-		else
+		} else {
 			error = lock_page_killable(page);
+		}
 		if (unlikely(error))
 			goto readpage_error;
 
@@ -2373,10 +2378,15 @@ readpage:
 		}
 
 		if (!PageUptodate(page)) {
-			if (iocb->ki_flags & IOCB_WAITQ)
+			if (iocb->ki_flags & IOCB_WAITQ) {
+				if (written) {
+					put_page(page);
+					goto out;
+				}
 				error = lock_page_async(page, iocb->ki_waitq);
-			else
+			} else {
 				error = lock_page_killable(page);
+			}
 
 			if (unlikely(error))
 				goto readpage_error;


