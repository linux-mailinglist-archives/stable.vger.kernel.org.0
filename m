Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E4E3C50E5
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242063AbhGLHff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:35:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240902AbhGLHct (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:32:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87E2C61008;
        Mon, 12 Jul 2021 07:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074984;
        bh=j/hfKJTTAEp2JofBV0iu1l3g7CIKwhamTP8twTxnDQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CMZYNkY7Ybj528mMAV2zJZ40bcyzL5zdNLYX0JAio+Mpqrkmy4/XelCMmMRss8XW3
         DmU6/ANEtBAeD34DNg/PsvshQUAVegpDxI9DMO7McvoeEkeb0lbuEteNbsceGQXODt
         rEP9iRFTk68Weu6mXblB59TXbS0syxp+zAhCB3j0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.13 037/800] teach copy_page_to_iter() to handle compound pages
Date:   Mon, 12 Jul 2021 08:01:00 +0200
Message-Id: <20210712060918.498753221@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 08aa64796016cb47b2ef3d0924653b4d944b0d65 upstream.

	In situation when copy_page_to_iter() got a compound page the current
code would only work on systems with no CONFIG_HIGHMEM.  It *is* the majority
of real-world setups, or we would've drown in bug reports by now.  Still needs
fixing.

	Current variant works for solitary page; rename that to
__copy_page_to_iter() and turn the handling of compound pages into a loop over
subpages.

Cc: stable@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/iov_iter.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -957,11 +957,9 @@ static inline bool page_copy_sane(struct
 	return false;
 }
 
-size_t copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
+static size_t __copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
 			 struct iov_iter *i)
 {
-	if (unlikely(!page_copy_sane(page, offset, bytes)))
-		return 0;
 	if (i->type & (ITER_BVEC | ITER_KVEC | ITER_XARRAY)) {
 		void *kaddr = kmap_atomic(page);
 		size_t wanted = copy_to_iter(kaddr + offset, bytes, i);
@@ -977,6 +975,30 @@ size_t copy_page_to_iter(struct page *pa
 	else
 		return copy_page_to_iter_pipe(page, offset, bytes, i);
 }
+
+size_t copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
+			 struct iov_iter *i)
+{
+	size_t res = 0;
+	if (unlikely(!page_copy_sane(page, offset, bytes)))
+		return 0;
+	page += offset / PAGE_SIZE; // first subpage
+	offset %= PAGE_SIZE;
+	while (1) {
+		size_t n = __copy_page_to_iter(page, offset,
+				min(bytes, (size_t)PAGE_SIZE - offset), i);
+		res += n;
+		bytes -= n;
+		if (!bytes || !n)
+			break;
+		offset += n;
+		if (offset == PAGE_SIZE) {
+			page++;
+			offset = 0;
+		}
+	}
+	return res;
+}
 EXPORT_SYMBOL(copy_page_to_iter);
 
 size_t copy_page_from_iter(struct page *page, size_t offset, size_t bytes,


