Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02DC2A5848
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731447AbgKCVu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:50:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:41580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731698AbgKCUtF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:49:05 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CB2622409;
        Tue,  3 Nov 2020 20:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436544;
        bh=lRKm451vu1f1JKGLJl5/kCC2LtHcU9tMwssg2HTV1HQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bj36V8wwTHgl77+0HmCjBsUYgiztHLJHqrx8zZGf7efPq6WcFOYOSVPjwanYJJCgu
         JRYuyQi9jol6eiP8XnV7bsTYbQXG4EKZq6lhokZzKfMgR4yRqgUErAc+RZHlqAd86f
         GPQP3e+32ZM3OjZf1+DXRwCorwUCXBZB0BDawppw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 295/391] block: advance iov_iter on bio_add_hw_page failure
Date:   Tue,  3 Nov 2020 21:35:46 +0100
Message-Id: <20201103203406.980145598@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 4977d121bc9bc5138d4d48b85469123001859573 upstream.

When the bio's size reaches max_append_sectors, bio_add_hw_page returns
0 then __bio_iov_append_get_pages returns -EINVAL. This is an expected
result of building a small enough bio not to be split in the IO path.
However, iov_iter is not advanced in this case, causing the same pages
are filled for the bio again and again.

Fix the case by properly advancing the iov_iter for already processed
pages.

Fixes: 0512a75b98f8 ("block: Introduce REQ_OP_ZONE_APPEND")
Cc: stable@vger.kernel.org # 5.8+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/bio.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/block/bio.c
+++ b/block/bio.c
@@ -1046,6 +1046,7 @@ static int __bio_iov_append_get_pages(st
 	ssize_t size, left;
 	unsigned len, i;
 	size_t offset;
+	int ret = 0;
 
 	if (WARN_ON_ONCE(!max_append_sectors))
 		return 0;
@@ -1068,15 +1069,17 @@ static int __bio_iov_append_get_pages(st
 
 		len = min_t(size_t, PAGE_SIZE - offset, left);
 		if (bio_add_hw_page(q, bio, page, len, offset,
-				max_append_sectors, &same_page) != len)
-			return -EINVAL;
+				max_append_sectors, &same_page) != len) {
+			ret = -EINVAL;
+			break;
+		}
 		if (same_page)
 			put_page(page);
 		offset = 0;
 	}
 
-	iov_iter_advance(iter, size);
-	return 0;
+	iov_iter_advance(iter, size - left);
+	return ret;
 }
 
 /**


